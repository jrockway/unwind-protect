use strict;
use warnings;
use Test::More tests => 11;
use Test::Exception;
use Unwind::Protect;

sub try_it($$);

my $unwound_ok = 0;
my $ret;
throws_ok {
    try_it 1, 0;
} qr/FORM DEATH/;
is $unwound_ok, 1;

throws_ok {
    try_it 0, 1;
} qr/UNWIND DEATH/;
is $unwound_ok, 1;

throws_ok {
    try_it 1, 1;
} qr/UNWIND DEATH/; # FORM DEATH lost

my ($result, @result);
lives_ok {
    $result = try_it 0, 0;
};
is $result, 1;
is $unwound_ok, 1;

lives_ok {
    @result = try_it 0, 0;
};
is_deeply \@result, [1,2,3];
is $unwound_ok, 1;
  

sub try_it($$) {
    my ($form_death, $unwind_death) = @_;
    $unwound_ok = 0;
    return unwind_protect {
        die "FORM DEATH" if $form_death;
        if(wantarray){
            return (1, 2, 3);
        }
        else {
            return 1;
        }
    } sub {
        $unwound_ok = 1;
        die "UNWIND DEATH" if $unwind_death;
    };
}
