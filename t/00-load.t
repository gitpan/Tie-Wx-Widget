#!perl -T

use Test::More tests => 1;

BEGIN {
	my $dir = -d 't' ? './lib' : '../lib';
	unshift @INC, $dir;
    use_ok( 'Tie::Wx::Widget' ) || print "Bail out!\n";
}

diag( "Testing Tie::Wx::Widget $Tie::Wx::Widget::VERSION, Perl $], $^X" );
