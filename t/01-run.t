#!usr/bin/perl

BEGIN {
	my $dir = -d 't' ? './lib' : '../lib';
	unshift @INC, $dir;
	require Tie::Wx::Widget;
}


package TestApp;
use base qw(Wx::App);
use Wx;
use Test::More tests=> 8;
use Test::Exception;

sub OnInit {
	my $app = shift;
	my ($old_txt, $new_txt, $module) = qw/fabulous frequency Tie::Wx::Widget/;
	my $frame = Wx::Frame->new( undef, wxDEFAULT, "testing $module");
	my $b = Wx::Button->new( $frame, -1, 'reach me',[10,10],[75,-1]);
	my $t = Wx::TextCtrl->new( $frame, -1, $old_txt,[10,50], [75,30]);

	throws_ok { tie my $tb, Tie::Wx::Widget, '' } qr/is no Wx object/, 'dies when tying empty values';
	throws_ok { tie my $tb, Tie::Wx::Widget, $b } qr/has no method:/, 'dies when tying widgets without getter or setter';
	my ($tt, $tieref);
	is (ref tie($tt, Tie::Wx::Widget, $t), $module, 'tie works');
	is (ref tied $tt, $module, 'tied works');

	is ($tt, $old_txt, 'FETCH works');
	$tt = $new_txt; 
	is ($tt, $new_txt, 'STORE works');

	is (untie $tt, 1, 'untie works');
	is (tied $tt, undef, 'really untied');

	# shut the app down after 10 millseconds
	Wx::Timer->new( $frame, 1000 )->Start( '10', 1 );
	Wx::Event::EVT_TIMER( $frame, 1000 , sub { $app->ExitMainLoop } );

	1;
}

package main;
TestApp->new->MainLoop;

