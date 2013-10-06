package Isucon3::Util;

use Text::Xslate;
use Encode;
use Cache::Memcached::Fast;
use Carp;
use File::Temp qw/ tempfile /;
use Isucon3::Markdown;

sub new {
    my $self = shift;
    bless {},$self;
}

sub memcached {
    my ($self) = @_;
    $self->{_memcached} ||= do {
        Cache::Memcached::Fast->new({
            servers => [ "localhost:11211" ],
        });
    }
}

sub markdown {
    my ($self, $id, $content) = @_;

    my $html = $self->memcached->get("markdown_" . $id);
    return $html if $html;

    $html = Isucon3::Markdown::Markdown(encode_utf8($content));
    $self->memcached->set("markdown_" . $id, $html);
    return $html;
}

1;

