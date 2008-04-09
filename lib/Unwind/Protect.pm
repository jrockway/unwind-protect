package Unwind::Protect;
use strict;
use warnings;
use Context::Preserve qw(preserve_context);
use base 'Exporter';

our @EXPORT = our @EXPORT_OK = qw(unwind_protect);

sub unwind_protect(&&){
    my ($action, $protection) = @_;
    return preserve_context {
        return eval {
            $action->();
        };
    } after => sub {
        my $saved_error = $@;
        $protection->();
        die $saved_error if $saved_error;
    };
}

1;
