use strict;
use warnings;
package App::Cmd::Tester::CaptureExternal;
{
  $App::Cmd::Tester::CaptureExternal::VERSION = '0.320';
}

use parent 'App::Cmd::Tester';
use Capture::Tiny 0.13 qw/capture/;

# ABSTRACT: Extends App::Cmd::Tester to capture from external subprograms


sub _run_with_capture {
  my ($class, $app, $argv) = @_;

  my $run_rv;

  my ($stdout, $stderr, $ok) = capture {
    eval {
      local $App::Cmd::Tester::TEST_IN_PROGRESS = 1;
      local @ARGV = @$argv;
      $run_rv = $app->run;
      1;
    };
  };

  my $error = $ok ? undef : $@;

  return {
    stdout => $stdout,
    stderr => $stderr,
    output => $stdout . $stderr,
    error  => $error,
    run_rv => $run_rv,
  };
}

1;

__END__

=pod

=head1 NAME

App::Cmd::Tester::CaptureExternal - Extends App::Cmd::Tester to capture from external subprograms

=head1 VERSION

version 0.320

=head1 SYNOPSIS

  use Test::More tests => 4;
  use App::Cmd::Tester::CaptureExternal;

  use YourApp;

  my $result = test_app(YourApp => [ qw(command --opt value) ]);

  like($result->stdout, qr/expected output/, 'printed what we expected');

  is($result->stderr, '', 'nothing sent to sderr');

  ok($result->output, "STDOUT concatenated with STDERR");

=head1 DESCRIPTION

L<App::Cmd::Tester> provides a useful scaffold for testing applications, but it
is unable to capture output generated from any external subprograms that are
invoked from the application.

This subclass uses an alternate mechanism for capturing output
(L<Capture::Tiny>) that does capture from external programs, with one
major limitation.

It is not possible to capture externally from both STDOUT and STDERR while
also having appropriately interleaved combined output.  Therefore, the
C<output> from this subclass simply concatenates the two.

You can still use C<output> for testing if there is any output at all or for
testing if something appeared in either output stream, but you can't rely on
the ordering being correct between lines to STDOUT and lines to STDERR.

=head1 AUTHOR

Ricardo Signes <rjbs@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2013 by Ricardo Signes.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
