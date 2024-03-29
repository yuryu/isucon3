package MooseX::Getopt::Meta::Attribute::Trait;
BEGIN {
  $MooseX::Getopt::Meta::Attribute::Trait::AUTHORITY = 'cpan:STEVAN';
}
{
  $MooseX::Getopt::Meta::Attribute::Trait::VERSION = '0.58';
}
# ABSTRACT: Optional meta attribute trait for custom option names

use Moose::Role;
use Moose::Util::TypeConstraints;

has 'cmd_flag' => (
    is        => 'rw',
    isa       => 'Str',
    predicate => 'has_cmd_flag',
);

# This subtype is to support scalar -> arrayref coercion
#  without polluting the built-in types
subtype '_MooseX_Getopt_CmdAliases' => as 'ArrayRef';

coerce '_MooseX_Getopt_CmdAliases'
    => from 'Str'
        => via { [$_] };

has 'cmd_aliases' => (
    is        => 'rw',
    isa       => '_MooseX_Getopt_CmdAliases',
    predicate => 'has_cmd_aliases',
    coerce    => 1,
);

no Moose::Util::TypeConstraints;
no Moose::Role;

# register this as a metaclass alias ...
package # stop confusing PAUSE
    Moose::Meta::Attribute::Custom::Trait::Getopt;
sub register_implementation { 'MooseX::Getopt::Meta::Attribute::Trait' }

1;

__END__

=pod

=encoding utf-8

=for :stopwords Stevan Little Infinity Interactive, Inc

=head1 NAME

MooseX::Getopt::Meta::Attribute::Trait - Optional meta attribute trait for custom option names

=head1 VERSION

version 0.58

=head1 SYNOPSIS

  package App;
  use Moose;

  with 'MooseX::Getopt';

  has 'data' => (
      traits    => [ 'Getopt' ],
      is        => 'ro',
      isa       => 'Str',
      default   => 'file.dat',

      # tells MooseX::Getopt to use --somedata as the
      # command line flag instead of the normal
      # autogenerated one (--data)
      cmd_flag  => 'somedata',

      # tells MooseX::Getopt to also allow --moosedata,
      # -m, and -d as aliases for this same option on
      # the commandline.
      cmd_aliases => [qw/ moosedata m d /],

      # Or, you can use a plain scalar for a single alias:
      cmd_aliases => 'm',
  );

=head1 DESCRIPTION

This is a custom attribute metaclass trait which can be used to
specify a the specific command line flag to use instead of the
default one which L<MooseX::Getopt> will create for you.

=head1 METHODS

=head2 B<cmd_flag>

Changes the commandline flag to be this value, instead of the default,
which is the same as the attribute name.

=head2 B<cmd_aliases>

Adds more aliases for this commandline flag, useful for short options
and such.

=head2 B<has_cmd_flag>

=head2 B<has_cmd_aliases>

=head1 AUTHOR

Stevan Little <stevan@iinteractive.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2013 by Infinity Interactive, Inc.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
