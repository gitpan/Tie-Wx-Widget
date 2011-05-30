package Tie::Wx::Widget;

use 5.006;
use strict;
use warnings;

require Tie::Scalar;
our @ISA = qw(Tie::Scalar);

=head1 NAME

Tie::Wx::Widget - a simpler way to get and set the main Value of a Widget

=head1 VERSION

Version 0.2

=cut

our $VERSION = '0.2';


=head1 SYNOPSIS

	use Tie::Wx::Widget;

	tie $tiedwidget, Tie::Wx::Widget, $widgetref;
    
	# instead of say $widgetref->GetValue;
	say  $tiedwidget;

	# instead of $widgetref->SetValue('7');
	$tiedwidget = 7;

	untie $tiedwidget;

=cut

sub TIESCALAR {
	my $class = shift;
	my $wx = shift;
	die "$wx is no Wx widget"
		   unless substr(ref $wx, 0, 4) eq 'Wx::';
	die "$wx has no set method" unless $wx->can('SetValue');
	die "$wx has no get method" unless $wx->can('GetValue');
	return bless { 'w' => $wx, }, $class;
}

sub FETCH { $_[0]->{'w'}->GetValue }
sub STORE { $_[0]->{'w'}->SetValue($_[1]) }

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
