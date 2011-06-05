#!usr/bin/perl
use strict;
use warnings;
BEGIN { unshift @INC, -d 't' ? 'lib' : '../lib' } # making local lib favoured

package TestApp;
our @ISA = 'Wx::App';
use Wx;
use Tie::Wx::Widget;

use Test::More tests => 10;
use Test::Exception;

sub OnInit {
	my $app = shift;
	my ($module, $old_txt, $new_txt) = qw/Tie::Wx::Widget fabulous frequency/;
	my $frame = Wx::Frame->new( undef, &Wx::wxDEFAULT, "$module testing app" );
	my $b = Wx::Button->new( $frame, -1, 'reach me',[10,10],[75,-1] );
	my $t = Wx::TextCtrl->new( $frame, -1, $old_txt,[10,50], [75,30] );
	my $s = Wx::BoxSizer->new( &Wx::wxVERTICAL );

	throws_ok { tie my $tb, $module, '' } qr/is no Wx object/, 'dies when tying an empty value';
	throws_ok { tie my $tb, $module,  1 } qr/is no Wx object/, 'dies when tying a none ref';
	throws_ok { tie my $tb, $module, $s } qr/is no Wx widget/, 'dies when tying a wx object thats not a widget';
	throws_ok { tie my $tb, $module, $b } qr/has no method:/, 'dies when tying widgets without getter or setter';

	my $tt;
	is (ref tie( $tt, $module, $t), $module, 'tie works');
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

exit(0);