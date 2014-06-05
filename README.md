# Crypt::Bcrypt #

This is a basic, stop-gap implementation of bcrypt for Perl 6

## Example ##

	use Crypt::Bcrypt;
	my $salt = Crypt::Bcrypt.gensalt(10);
	my $hash = Crypt::Bcrypt.hash("My password", $salt);
	
	my $password_attempt = Crypt::Bcrypt.hash("My password", $hash);

	if ($password_attempt ~~ $hash) {
		say "access granted";
	}

## Methods ##

 - `gensalt(Int $rounds = 12)`

	Generates a salt
	The generated salt includes a prefix specifying the number of rounds
	that the password will be hashed with when the returned salt is 
	passed to `hash`

 - `hash(Str $password, Str $salt)`

	Generates a hash of the password, using the settings from the salt
	The salt should be generated using gensalt but can be passed manually

	The salt can also be a fully qualified bcrypt hash, this is useful
	when you want to compare a string against a known hash

	Example:

		.hash("MyAttemptedPassword", $known_hash);

	In this example, if the result of hash is equal to $known_hash
	the passwords match

## Requirements ##

Your system must be capable of compiling the provided libraries

This should work on most Unix variants, however Windows is not currently
supported as the library depends on the existance of /dev/urandom

Confirmed working on rakudo running on the MoarVM

## How to ##

First get your system ready for compiling
If you installed a perl6 implementation from source you probably already
meet this requirement

On Debian-based systems this can be achieved like this:
	apt-get install build-essential

On openSUSE you can do:
	zypper in --type pattern devel_basis

Then enter the ext/ directory and run `make`, this should compile the
library and create the crypt_blowfish.so shared library

You can then run the tests like this (assuming you are in the base directory):
	PERL6LIB=lib LD_LIBRARY_PATH=ext perl6 t/01-basic.t

## Contact ##

carlin in #perl6 on Freenode

## Credit ##

This module uses the Openwall crypt_blowfish library by Solar Designer
See http://www.openwall.com/crypt/ and the header of
<ext/crypt_blowfish-1.2/crypt_blowfish.c> for details