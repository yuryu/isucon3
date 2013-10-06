package MooseX::Getopt::Strict;
BEGIN {
  $MooseX::Getopt::Strict::AUTHORITY = 'cpan:STEVAN';
}
{
  $MooseX::Getopt::Strict::VERSION = '0.58';
}
# ABSTRACT: only make options for attrs with the Getopt metaclass

use Moose::Role;

with 'MooseX::Getopt';

around '_compute_getopt_attrs' => sub {
    my $next = shift;
    my ( $class, @args ) = @_;
    grep {
        $_->does("MooseX::Getopt::Meta::Attribute::Trait")
    } $class->$next(@args);
};

no Moose::Role;

1;

__END__

=pod

=encoding utf-8

=for :stopwords Stevan Little Infinity Interactive, Inc Brandon Devin Austin Drew Taylor
Florian Ragwitz Gordon Irving Hans Dieter L Pearcey Hinrik Örn Sigurðsson
Jesse Luehrs John Goulah Jonathan Swartz Black Justin Hunter Karen
Etheridge Nelo Onyiah Ricardo SIGNES Ryan D Chris Johnson Shlomi Fish Todd
Hepler Tomas Doran Yuval Prather Kogman t0m Ævar Arnfjörð Bjarmason Dagfinn
Ilmari Mannsåker Damien Krotkine

=head1 NAME

MooseX::Getopt::Strict - only make options for attrs with the Getopt metaclass

=head1 VERSION

version 0.58

=head1 DESCRIPTION

This is an stricter version of C<MooseX::Getopt> which only processes the
attributes if they explicitly set as C<Getopt> attributes. All other attributes
are ignored by the command line handler.

=head1 AUTHOR

Stevan Little <stevan@iinteractive.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2013 by Infinity Interactive, Inc.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
