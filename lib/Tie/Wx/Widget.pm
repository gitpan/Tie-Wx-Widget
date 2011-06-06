use v5.6;
use strict;
use warnings;
use Tie::Scalar;

package Tie::Wx::Widget;
our $VERSION = '0.91';
our @ISA = 'Tie::Scalar';
our $complainmethod = 'die';

sub import   { $complainmethod = 'warn_mode' if defined $_[1] and $_[1] eq 'warn'}
sub die_mode { $complainmethod = 'die'}
sub warn_mode{ $complainmethod = 'warn'}
sub complain { $complainmethod eq 'die' ? die $_[0] : warn $_[0] }

sub TIESCALAR {
	my $self = shift;
	my $widget = shift;
	if (substr(ref $widget, 0, 4) ne 'Wx::'){complain("$widget is no Wx object")}
	elsif(not $widget->isa('Wx::Control'))  {complain("$widget is no Wx widget")}
	elsif(not $widget->can('GetValue'))     {complain("$widget has no method: GetValue")}
	elsif(not$widget->can('SetValue'))      {complain("$widget has no method: SetValue")}
	else {
		return bless { 'w' => $widget, 'widget' => $widget }, $self;
	}
	return 0;
}

sub FETCH { $_[0]->{'w'}->GetValue }
sub STORE { $_[0]->{'w'}->SetValue($_[1]) unless ref $_[1] }
sub DESTROY {} # to prevent crashes if called

'one';

__END__

=head1 NAME

Tie::Wx::Widget - get and set the main value of a Wx widget with less syntax

=head1 SYNOPSIS

	use Tie::Wx::Widget;

	tie $tiedwidget, Tie::Wx::Widget, $widget;

	say $tiedwidget;       # instead of say $widgetref->GetValue;

	$tiedwidget = 7;       # instead of $widgetref->SetValue(7);

	untie $tiedwidget;     # now $tiedwidget is a normal scalar again (not required)

=head1 ATTENTION

Your program will die, if you don't provide a proper reference
to a Wx widget, that has a GetValue and SetValue method.
Unless you init with

	use Tie::Wx::Widget 'warn_mode';

	or do later:

	Tie::Wx::Widget::warn_mode();

Then will be called C<warn> instead of C<die>. 
But you can switch anytime back with:

	Tie::Wx::Widget::die_mode();

Wich has only effect for all variables afterwards.
Because if the Wx ref is not good there will be no tying anyway.

=head1 INTERNALS

	# how to get a reference to the Tie::Wx::Widget object ?
	$tieobject = tie $tiedwidget, Tie::Wx::Widget, $widget;
	$tieobject = tied $tiedwidget;

	# now you even can:
	$tieobject->FETCH()
	# aka:
	$tieobject->{'widget'}->GetValue;
	# or do any other method on the wx object
	$tieobject->{'w'}->Show(0);
	# works too (hides the widget)
	$tieobject->STORE(7);

	# doesn't do anything
	$tieobject->DESTROY()

=head1 BUGS

Please report any bugs or feature requests to C<bug-tie-wx-widget at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Tie-Wx-Widget>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Tie::Wx::Widget


You can also look for information at:

=over 4

=item * RT: CPAN's request tracker (report bugs here)

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=Tie-Wx-Widget>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/Tie-Wx-Widget>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/Tie-Wx-Widget>

=item * Search CPAN

L<http://search.cpan.org/dist/Tie-Wx-Widget/>

=item * Source Repository: (in case you fant to fork :))

L<http://bitbucket.org/lichtkind/tie-wx-widget>

=back


=head1 ACKNOWLEDGEMENTS

This was solely my idea. 

=head1 AUTHOR

Herbert Breunung, C<< <lichtkind at cpan.org> >>

=head1 LICENSE AND COPYRIGHT

Copyright 2011 Herbert Breunung.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.

