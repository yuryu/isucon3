package Isucon3::Worker;

use strict;
use warnings;
use utf8;

use Mouse;
use JSON qw/ decode_json /;
use Digest::SHA qw/ sha256_hex /;
use DBIx::Sunny;
use File::Temp qw/ tempfile /;
use IO::Handle;
use Encode;
use Time::Piece;
use Cache::Memcached::Fast;
use Net::RabbitFoot;
use Coro;

has queue => (
    is => "ro",
    isa => "Str",
    default => "isucon_newmemo",
);

has mq => (
    is => "ro",
    isa => "Net::RabbitMQ",
    default => sub {
        my $self = shift;
        my @MQ_CONNECT_ARGS = ( 
            host  => '10.0.0.10',
            port  => 5672,
            user  => 'guest',
            pass  => 'guest',
            vhost => '/',
        );
        my $mq = Net::RabbitFoot->new()->load_xml_spec()->connect(
            @MQ_CONNECT_ARGS,
        );
        return $mq;
    },
    lazy => 1,
);

has dbh => (
    is => "ro",
    isa => "DBIx::Sunny::db",
    default => sub {
        my $self = shift;
        my $dbconf = $self->config->{database};
        DBIx::Sunny->connect(
            "dbi:mysql:database=${$dbconf}{dbname};host=${$dbconf}{host};port=${$dbconf}{port}", $dbconf->{username}, $dbconf->{password}, {
                RaiseError => 1,
                PrintError => 0,
                AutoInactiveDestroy => 1,
                mysql_enable_utf8   => 1,
                mysql_auto_reconnect => 1,
            },
        );
    },
    lazy => 1,
);

has config => (
    is => 'ro',
    isa => 'HashRef',
    default => sub {
        my $self = shift;
        my $env = $ENV{ISUCON_ENV} || 'local';
        open(my $fh, '<', $FindBin::Bin . "/../config/${env}.json") or die $!;
        my $json = do { local $/; <$fh> };
        close($fh);
        decode_json($json);
    },
    lazy => 1,
);

has json => (
    is => 'ro',
    isa => 'JSON::XS',
    default => sub { JSON::XS->new()->utf8(); },
    lazy => 1,
);

sub dequeue
{
    my ($self) = @_;

    my $m = $self->mq->get(1, $self->queue);
    return undef unless defined $m;
}



sub run
{
    my ($self) = @_;
    my $mq = $self->mq;
    my $ch = $mq->open_channel();
    $ch->declare_queue($self->queue);
    $ch->consume(
        queue => $self->queue,
        no_ack => 1,
        on_consume => unblock_sub {
            my $req = shift;
            my $m = $self->json->decode($req->{body}->payload);
            $self->dbh->query(
                'INSERT INTO memos (id, user, content, is_private, created_at) VALUES (?, ?, ?, ?, now())',
                $m->{id},
                $m->{user},
                scalar $m->{content},
                scalar($m->{is_private}) ? 1 : 0,
            );
        },
    );

    schedule;
    $mq->close;
}

no Mouse;

1;

