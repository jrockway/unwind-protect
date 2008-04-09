package Unwind::Protect;
use strict;
use warnings;
use Context::Preserve qw(preserve_context);
use base 'Exporter';

our $VERSION = '0.01';
our @EXPORT = our @EXPORT_OK = qw(unwind_protect);

sub unwind_protect(&&){
    my ($bodyform, $unwindform) = @_;
    return preserve_context {
        return eval {
            $bodyform->();
        };
    } after => sub {
        my $saved_error = $@;
        $unwindform->();
        die $saved_error if $saved_error;
    };
}

1;

__END__

=head1 NAME

Unwind::Protect - protect stack unwinds with cleanup code

=head1 SYNOPSIS

  use Unwind::Protect;

  my $tmpfile;
  my $file = unwind_protect {
      $tmpfile = get_a_temp_file;
      write stuff to the tmpfile;        # this could die
      move tmpfile to final destination  # this could die
      return $final_destination;
  } sub {
      unlink $tmpfile;
  };

=head1 DESCRIPTION

This module exports a single function C<unwind_protect> that accepts
exactly two code blocks, C<bodyform> and C<unwindform>.  (See the
SYNOPSIS for the syntax; it's prototyped C<(&&)> which may catch you
off guard.)

When run, C<unwind_protect> evaluates C<bodyform>, then C<unwindform>,
and returns the result of C<bodyform> (preserving context).  If
C<bodyform> unwinds, C<unwindform> executes anyway and then rethrows
the exception that C<bodyform> threw.

=head1 EXPORT

This module exports C<unwind_protect> by default.

=head1 BUGS

If you unwind via C<goto> or C<last> (etc.), the protection block will not run.

=head1 SEE ALSO

L<Scope::Guard>

=head1 AUTHOR

Jonathan Rockway C<< jrockway AT cpan.org >>

=head1 COPYRIGHT

C<Unwind::Protect> is Free software.  You may redistribute it under
the same terms as Perl itself.
