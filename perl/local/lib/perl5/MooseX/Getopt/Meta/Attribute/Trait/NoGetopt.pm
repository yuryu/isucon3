package MooseX::Getopt::Meta::Attribute::Trait::NoGetopt;
BEGIN {
  $MooseX::Getopt::Meta::Attribute::Trait::NoGetopt::AUTHORITY = 'cpan:STEVAN';
}
{
  $MooseX::Getopt::Meta::Attribute::Trait::NoGetopt::VERSION = '0.58';
}
# ABSTRACT: Optional meta attribute trait for ignoring params

use Moose::Role;
no Moose::Role;

# register this as a metaclass alias ...
package # stop confusing PAUSE
    Moose::Meta::Attribute::Custom::Trait::NoGetopt;
sub register_implementation { 'MooseX::Getopt::Meta::Attribute::Trait::NoGetopt' }

1;

__END__

=pod

=encoding utf-8

=for :stopwords Stevan Little Infinity Interactive, Inc

=head1 NAME

MooseX::Getopt::Meta::Attribute::Trait::NoGetopt - Optional meta attribute trait for ignoring params

=head1 VERSION

version 0.58

=head1 SYNOPSIS

  package App;
  use Moose;

  with 'MooseX::Getopt';

  has 'data' => (
      traits  => [ 'NoGetopt' ],  # do not attempt to capture this param
      is      => 'ro',
      isa     => 'Str',
      default => 'file.dat',
  );

=head1 DESCRIPTION

This is a custom attribute metaclass trait which can be used to
specify that a specific attribute should B<not> be processed by
C<MooseX::Getopt>. All you need to do is specify the C<NoGetopt>
metaclass trait.

  has 'foo' => (traits => [ 'NoGetopt', ... ], ... );

=head1 AUTHOR

Stevan Little <stevan@iinteractive.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2013 by Infinity Interactive, Inc.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
