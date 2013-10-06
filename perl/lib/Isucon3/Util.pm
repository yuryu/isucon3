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

    my ($fh, $filename) = tempfile();
    $fh->print(encode_utf8($content));
    $fh->close;
    $html = qx{ ../bin/markdown $filename };
    unlink $filename;
    $memd->set("markdown_" . $id, $html);
    return $html;

    my ($fin, $fout);
    my $pid = open2($fin, $fout, "../bin/markdown") or croak;
    print $fout, $content;
    close($fout);
    waitpid($pid, 0);
    local $/;
    $html = <$fin>;
    close($fin);

    
}

no Mouse;

1;

