#!perl -T

use Test::More tests => 3;

BEGIN {
	my $dir = -d 't' ? './lib' : '../lib';
	unshift @INC, $dir;
	use_ok( 'Wx' );
	use_ok( 'Tie::Scalar' );
    use_ok( 'Tie::Wx::Widget' ) || print "Bail out!\n";
}

diag( "Testing Tie::Wx::Widget $Tie::Wx::Widget::VERSION, Perl $], $^X" );
