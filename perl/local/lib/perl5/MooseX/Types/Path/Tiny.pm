use strict;
use warnings;

package MooseX::Types::Path::Tiny;
{
  $MooseX::Types::Path::Tiny::VERSION = '0.006';
}
# git description: v0.005-3-g8aa0bc8

BEGIN {
  $MooseX::Types::Path::Tiny::AUTHORITY = 'cpan:ETHER';
}
# ABSTRACT: Path::Tiny types and coercions for Moose
# VERSION

use Moose 2;
use MooseX::Types::Stringlike qw/Stringable/;
use MooseX::Types::Moose qw/Str ArrayRef/;
use MooseX::Types -declare => [qw( Path AbsPath File AbsFile Dir AbsDir )];
use Path::Tiny ();

#<<<
subtype Path,    as 'Path::Tiny';
subtype AbsPath, as Path, where { $_->is_absolute };

subtype File,    as Path, where { $_->is_file }, message { "File '$_' does not exist" };
subtype Dir,     as Path, where { $_->is_dir },  message { "Directory '$_' does not exist" };

subtype AbsFile, as AbsPath, where { $_->is_file }, message { "File '$_' does not exist" };
subtype AbsDir,  as AbsPath, where { $_->is_dir },  message { "Directory '$_' does not exist" };
#>>>

for my $type ( 'Path::Tiny', Path, File, Dir ) {
    coerce(
        $type,
        from Str()        => via { Path::Tiny::path($_) },
        from Stringable() => via { Path::Tiny::path($_) },
        from ArrayRef()   => via { Path::Tiny::path(@$_) },
    );
}

for my $type ( AbsPath, AbsFile, AbsDir ) {
    coerce(
        $type,
        from 'Path::Tiny' => via { $_->absolute },
        from Str()        => via { Path::Tiny::path($_)->absolute },
        from Stringable() => via { Path::Tiny::path($_)->absolute },
        from ArrayRef()   => via { Path::Tiny::path(@$_)->absolute },
    );
}

### optionally add Getopt option type (adapted from MooseX::Types:Path::Class
##eval { require MooseX::Getopt; };
##if ( !$@ ) {
##    MooseX::Getopt::OptionTypeMap->add_option_type_to_map( $_, '=s', )
##      for ( 'Path::Tiny', Path );
##}

1;


# vim: ts=4 sts=4 sw=4 et:

__END__

=pod

=encoding utf-8

=for :stopwords David Golden coercions SUBTYPES subtype subtypes AbsPath AbsFile AbsDir

=head1 NAME

MooseX::Types::Path::Tiny - Path::Tiny types and coercions for Moose

=head1 VERSION

version 0.006

=head1 SYNOPSIS

  ### specification of type constraint with coercion

  package Foo;

  use Moose;
  use MooseX::Types::Path::Tiny qw/Path AbsPath/;

  has filename => (
    is => 'ro',
    isa => Path,
    coerce => 1,
  );

  has directory => (
    is => 'ro',
    isa => AbsPath,
    coerce => 1,
  );

  ### usage in code

  Foo->new( filename => 'foo.txt' ); # coerced to Path::Tiny
  Foo->new( directory => '.' ); # coerced to path('.')->absolute

=head1 DESCRIPTION

This module provides L<Path::Tiny> types for Moose.  It handles
two important types of coercion:

=over 4

=item *

coercing objects with overloaded stringification

=item *

coercing to absolute paths

=back

It also can check to ensure that files or directories exist.

=for Pod::Coverage method_names_here

=head1 SUBTYPES

This module uses L<MooseX::Types> to define the following subtypes.

=head2 Path

C<Path> ensures an attribute is a L<Path::Tiny> object.  Strings and
objects with overloaded stringification may be coerced.

=head2 AbsPath

C<AbsPath> is a subtype of C<Path> (above), but coerces to an absolute path.

=head2 File, AbsFile

These are just like C<Path> and C<AbsPath>, except they check C<-f> to ensure
the file actually exists on the filesystem.

=head2 Dir, AbsDir

These are just like C<Path> and C<AbsPath>, except they check C<-d> to ensure
the directory actually exists on the filesystem.

=head1 CAVEATS

=head2 Path vs File vs Dir

C<Path> just ensures you have a L<Path::Tiny> object.

C<File> and C<Dir> check the filesystem.  Don't use them unless that's really
what you want.

=head2 Usage with File::Temp

Be careful if you pass in a File::Temp object. Because the argument is
stringified during coercion into a Path::Tiny object, no reference to the
original File::Temp argument is held.  Be sure to hold an external reference to
it to avoid immediate cleanup of the temporary file or directory at the end of
the enclosing scope.

A better approach is to use Path::Tiny's own C<tempfile> or C<tempdir>
constructors, which hold the reference for you.

    Foo->new( filename => Path::Tiny->tempfile );

=head1 SEE ALSO

=over 4

=item *

L<Path::Tiny>

=item *

L<Moose::Manual::Types>

=item *

L<Types::Path::Tiny>

=back

=head1 AUTHOR

David Golden <dagolden@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is Copyright (c) 2013 by David Golden.

This is free software, licensed under:

  The Apache License, Version 2.0, January 2004

=cut
