use v6;
use Crypt::Bcrypt;
use Test;

BEGIN {
	%*ENV<MVM_SPESH_DISABLE> = 1;
}


plan *;

my Crypt::Bcrypt $bc .= new();

# moar sometimes dies with spesh errors running this
if (%*ENV<MVM_SPESH_DISABLE>:exists && %*ENV<MVM_SPESH_DISABLE>) 	{
	loop (my Int $round = 4; $round <= 31; $round++) {
		my $gen = Crypt::Bcrypt.gensalt($round);
		 # 7 prefix + 22 encoded salt
		is $gen.chars, 29, 'count for ' ~ $round;
		is $gen.substr(0, 7), '$2a$'
			~ $round.Str.fmt('%02d') ~ '$',
			'prefix for ' ~ $round ~ ' rounds';
	}
}
else {
	my $gen = $bc.gensalt(31);
	is $gen.chars, 29, 'count';
	is $gen.substr(0, 7), '$2a$' ~ '31' ~ '$', 'prefix';
}

dies_ok { $bc.gensalt(-20) }, 'dies with negative rounds';
dies_ok { $bc.gensalt(-1) }, 'dies with negative rounds';
dies_ok { $bc.gensalt(0) }, 'dies with 0 rounds';
dies_ok { $bc.gensalt(1) }, 'dies with 1 round';
dies_ok { $bc.gensalt(2) }, 'dies with 2 rounds';
dies_ok { $bc.gensalt(3) }, 'dies with 3 rounds';
lives_ok { $bc.gensalt(4) }, 'lives with 4 rounds';
lives_ok { $bc.gensalt(31) }, 'lives with 31 rounds';
dies_ok { $bc.gensalt(32) }, 'dies with 32 rounds';

done();

# vim: ft=perl6
