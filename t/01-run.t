#!usr/bin/perl
use strict;
use warnings;
BEGIN { unshift @INC, -d 't' ? 'lib' : '../lib' } # making local lib favoured

package TestApp;
our @ISA = 'Wx::App';

use Wx;
use Tie::Wx::Widget 'die';

use Test::More tests => 22;
use Test::Exception;
use Test::Warn;

sub OnInit {
	my $app = shift;
	my ($module, $old_txt, $new_txt) = qw/Tie::Wx::Widget fabulous frequency/;
	my $cmsg = 'with the right error message';
	my $frame = Wx::Frame->new( undef, &Wx::wxDEFAULT, "$module testing app" );
	my $b = Wx::Button->new( $frame, -1, 'reach me',[10,10],[75,-1] );
	my $t = Wx::TextCtrl->new( $frame, -1, $old_txt,[10,50], [75,30] );
	my $s = Wx::BoxSizer->new( &Wx::wxVERTICAL );
	my $tt;

	# die when input is not correct
	dies_ok   { tie my $tb, $module, '' } 'dies when tying an empty value';
	throws_ok { tie my $tb, $module, '' } qr/is no Wx object/, $cmsg;
	dies_ok   { tie my $tb, $module,  1 } 'dies when tying a none ref';
	throws_ok { tie my $tb, $module,  1 } qr/is no Wx object/, $cmsg;
	dies_ok   { tie my $tb, $module, $s } 'dies when tying a wx object thats not a widget';
	throws_ok { tie my $tb, $module, $s } qr/is no Wx widget/, $cmsg;
	dies_ok   { tie my $tb, $module, $b } 'dies when tying widgets without getter or setter';
	throws_ok { tie my $tb, $module, $b } qr/has no method:/,  $cmsg;
	Tie::Wx::Widget::warn();
	my $tbb;
	warning_like {tie my $tbb, $module, ''} qr/is no Wx object/, 'warn mode works correctly';
	is (tied $tbb, undef, 'really didn\'t tie in warn mode with bad input');
	Tie::Wx::Widget::die();
	dies_ok   { tie my $tb, $module, '' } 'die mode works too';

	# test external API
	is (ref tie( $tt, $module, $t), $module, 'tie works');
	is (ref tied $tt, $module, 'tied works');
	is ($tt, $old_txt, 'FETCH works');
	$tt = $new_txt;
	is ($tt, $new_txt, 'STORE works');
	is (untie $tt, 1, 'untie works');
	is (tied $tt, undef, 'really untied');

	# test internal API
	my $tref = tie( $tt, $module, $t);
	is ($tref->FETCH, $new_txt, 'FETCH as a method works');
	$tref->STORE($old_txt);
	is ($tt, $old_txt, 'STORE as a method works');
	is ($tref->{'widget'}, $t, 'get the internal Wx widget object');
	is ($tref->{'w'}, $t, 'alternative shortcut key works too');
	lives_ok { $tref->DESTROY } 'DESTROY can be called'; # but has no effect

	# shut the app down after 10 millseconds
	Wx::Timer->new( $frame, 1000 )->Start( '10', 1 );
	Wx::Event::EVT_TIMER( $frame, 1000 , sub { $app->ExitMainLoop } );

	1;
}

package main;
TestApp->new->MainLoop;

exit(0);