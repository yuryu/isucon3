package Isucon3::Util;

use Mouse;
use Text::Xslate;
use IPC::Open2;
use IO::Handle;
use Encode;
use Time::Piece;
use Cache::Memcached::Fast;
use HTML::FillInForm::Lite;
use Carp;
use File::Temp qw/ tempfile /;
use Data::Dumper;
use Isucon3::Markdown;

has memcached => (
    is => 'ro',
    isa => 'Cache::Memcached::Fast',
    default => sub {
        Cache::Memcached::Fast->new({
            servers => [ "localhost:11211" ],
        });
    },
    lazy => 1,
);

sub markdown {
    my ($self, $id, $content) = @_;

    my $memd = $self->memcached;
    my $html = $memd->get("markdown_" . $id);
    return $html if $html;

    $html = Isucon3::Markdown::Markdown(encode_utf8($content));
    $memd->set("markdown_" . $id, $html);
    return $html;
}

no Mouse;

1;

