package Tie::Wx::Widget;

use v5.6;
use strict;
use warnings;
use base 'Tie::Scalar';

=head1 NAME

Tie::Wx::Widget - get and set the main Value of a Widget with less syntax

=head1 VERSION

Version 0.5

=cut

our $VERSION = '0.5';


=head1 SYNOPSIS

	use Tie::Wx::Widget;

	tie $tiedwidget, Tie::Wx::Widget, $widgetref;
    
	# instead of say $widgetref->GetValue;
	say $tiedwidget;

	# instead of $widgetref->SetValue('7');
	$tiedwidget = 7;

	# not required:
	untie $tiedwidget;
	# now $tiedwidget is just a normal scalar

=cut

sub TIESCALAR {
	my $self = shift;
	my $wx = shift;
	die "$wx is no Wx object"         unless substr(ref $wx, 0, 4) eq 'Wx::';
	die "$wx is no Wx Widget"         unless $wx->isa('Wx::Control');
	die "$wx has no method: GetValue" unless $wx->can('GetValue');
	die "$wx has no method: SetValue" unless $wx->can('SetValue');
	return bless { 'widget' => $wx }, $self;
}

sub FETCH { $_[0]->{'widget'}->GetValue }
sub STORE { $_[0]->{'widget'}->SetValue($_[1]) }

=head1 ATTENTION

Your Program will die, if you don't provide a proper reference to a Wx
widget, that has a GetValue and SetValue method.

=head1 INTERNALS

	# how to get a reference to the Tie::Wx::Widget object?
	$tieobjectref = tie $tiedwidget, Tie::Wx::Widget, $widgetref;
	$tieobjectref = tied $tiedwidget;

	# now you even can:
	$tieobjectref->FETCH()
	# aka:
	$tieobjectref->{'widget'}->GetValue;
	# or do any other method on the wx object reference

	$tieobjectref->DESTROY()

=head1 AUTHOR

Herbert Breunung, C<< <lichtkind at cpan.org> >>

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

=head1 LICENSE AND COPYRIGHT

Copyright 2011 Herbert Breunung.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.

=cut

1; # End of Tie::Wx::Widget
