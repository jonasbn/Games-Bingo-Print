package Games::Bingo::Print;

# $Id: Print.pm,v 1.10 2004/01/07 19:32:41 jonasbn Exp $

use strict;
use integer;
use Carp;
use PDFLib;
use vars qw($VERSION);

use lib qw(lib ../lib);
use Games::Bingo::Card;

$VERSION = '0.02';

sub new {
	my ($class, %opts) = @_;
	
	my $self = bless{
		text    => $opts{text}?$opts{text}:'by jonasbn <jonasbn@cpan.org>',
		heading => $opts{heading}?$opts{heading}:'Games::Bingo',
	}, $class || ref $class;

	eval {
		$self->{pdf} = PDFLib->new(
	    	filename  => $opts{filename}?$opts{filename}:'bingo.pdf',
   	    	papersize => 'a4',
   	    	creator   => 'Games::Bingo::Print',
    	    author    => 'Jonas B. Nielsen',
    	    title     => 'Bingo!',
	    );
	    $self->{pdf}->start_page;
	};    	
    
    if ($@) {
		warn $@;
		return undef;
	} else {
		return $self;	
	}
}

sub print_pages {
	my ($self, $pages, $cards) = @_;
		
	eval {
		foreach my $i (1..$pages) {
			
			if ($cards) {
				if ($cards > 3) {
					$cards = 3;
				}
			} else {
				$cards = 3;
			}
			
    		$self->{pdf}->set_font(
    			face => 'Helvetica',
    			size => 40,
    			bold => 1
    		);
    		$self->{pdf}->print_boxed(
    			$self->{heading},
    			mode => 'center',
    			'x' => 0,
    			'y' => 740,
    			'w' => 595,
    			'h' => 50
    		);
    		$self->{pdf}->set_font(
    			face => 'Helvetica',
    			size => 12,
    			bold => 1
    		);
    		$self->{pdf}->print_boxed(
				$self->{text},
    			'mode' => 'center',
    			'x' => 0,
    			'y' => 685,
    			'w' => 595,
    			'h' => 50
    		);
			
			my $y_start_cordinate = 685; 
			my $x_start_cordinate = 30;
			my $size = 60;
			my $yec;
			my $ysc;
			my $cardsize = $size * 3;
			
			for (my $card = 1; $card <= $cards; $card++) {
				
				$ysc = $y_start_cordinate - $cardsize;
				$yec = $ysc + $cardsize;
				
				$self->_print_card(
					size              => $size,
					x_start_cordinate => $x_start_cordinate,
					y_start_cordinate => $ysc,
					y_end_cordinate   => $yec,
				);
				$y_start_cordinate = $ysc - 50;
    		}
		}
		$self->{pdf}->stroke;
		$self->{pdf}->finish;
	};

	if ($@) {
		carp $@;
		return 0;
	} else {
		return 1;	
	}
}

sub _print_card {
	my $self = shift;
	my %args = @_;

	my $p = Games::Bingo::Card->new();
	$p = $p->populate();
		
	my $ysc  = $args{'y_start_cordinate'};
	my $yec  = $args{'y_end_cordinate'};
	my $xsc  = $args{'x_start_cordinate'};
	my $size = $args{'size'};
	
	my $y = 3;
	for (my $ry = $ysc; $ry < $yec; $ry += $size) {
		my @numbers;
		for (my $x = 0; $x <= 9; $x++) {
			push(@numbers, $p->[$x-1]->[$y-1]);
		}	
		$self->_print_row(
				  size 			    => $size,
			      x_start_cordinate => $xsc,
			      y_start_cordinate => $ry,
			      x_end_cordinate   => 540,
			      numbers 		    => \@numbers,
		);
		$y--;
	}
	return 1;
}

sub _print_row {
	my $self = shift;
	my %args = @_;
	
	my $ysc     = $args{'y_start_cordinate'};
	my $xsc     = $args{'x_start_cordinate'};
	my $xec     = $args{'x_end_cordinate'};
	my $size    = $args{'size'};
	my $numbers = $args{'numbers'};
	
	my $x;
	for (my $rx = $xsc; $rx <= $xec; $rx += $size) {
		++$x;
		my $label = $numbers->[$x]?$numbers->[$x]:'';
		
		$self->{pdf}->rect(
		    'x' => $rx,
		    'y' => $ysc,
		    'w' => $size,
		    'h' => $size
		);
		$self->{pdf}->stroke;
		$self->{pdf}->set_font(
		    face => 'Helvetica',
		    size => 40,
		    bold => 1
		);
 	   	$self->{pdf}->print_at(
 	   	    $label, 
 	   	    'mode' => "right",
 	   	    'w'    => $size,
 	   	    'h'    => $size,
 	   	    'x'    => $rx+8,
 	   	    'y'    => $ysc+13
 	   	);

	}
	return 1;
}

1;

__END__

=head1 NAME

Games::Bingo::Print - a PDF Generation Class for Games::Bingo

=cut

=head1 SYNOPSIS

C<< use Games::Bingo::Print; >>

C<< my $bp = Games::Bingo::Print-E<gt>new(); >>

C<< $bp-E<gt>print_pages(2); >>

C<< my $bp = Games::Bingo::Print-E<gt>new( >>

C<<		heading   =E<gt> 'Jimmys bingohalle', >>

C<<		text =E<gt> 'its all in the game!' >>

C<<		filename =E<gt> 'jimmys.pdf >>

C<< ); >>

=cut

=head1 DESCRIPTION

This is that actual printing class. It generates a PDF file with pages
containing bingo cards.

The page contains space for 3 bingo cards, each consisting of 3 rows
and 10 columns like this:

=begin text

+--+--+--+--+--+--+--+--+--+
|  |  |  |  |  |  |  |  |  |
+--+--+--+--+--+--+--+--+--+
|  |  |  |  |  |  |  |  |  |
+--+--+--+--+--+--+--+--+--+
|  |  |  |  |  |  |  |  |  |
+--+--+--+--+--+--+--+--+--+

=end text

=begin html

E<lt>preE<gt>
+--+--+--+--+--+--+--+--+--+
|  |  |  |  |  |  |  |  |  |
+--+--+--+--+--+--+--+--+--+
|  |  |  |  |  |  |  |  |  |
+--+--+--+--+--+--+--+--+--+
|  |  |  |  |  |  |  |  |  |
+--+--+--+--+--+--+--+--+--+
E<lt>/preE<gt>

=end html

So a filled out example card could look like this:

=begin text

+--+--+--+--+--+--+--+--+--+
| 4|13|  |30|  |  |62|  |  |
+--+--+--+--+--+--+--+--+--+
|  |  |22|  |41|53|  |78|  |
+--+--+--+--+--+--+--+--+--+
|  |14|27|  |  |  |65|  |80|
+--+--+--+--+--+--+--+--+--+

=end text

=begin html

<pre>

+--+--+--+--+--+--+--+--+--+
| 4|13|  |30|  |  |62|  |  |
+--+--+--+--+--+--+--+--+--+
|  |  |22|  |41|53|  |78|  |
+--+--+--+--+--+--+--+--+--+
|  |14|27|  |  |  |65|  |80|
+--+--+--+--+--+--+--+--+--+

</pre>

=end html

=cut

=head1 METHODS

=head2 new

The constructor

The constructor can take several options, all these are optional.

=over 4

=item * heading

The heading on the generated bingo card PDF.

=item * text 

The smaller text on the generated bingo card PDF, the default is the
authors name (SEE AUTHOR section below).

=item * filename

The name of the file containing the generated bingo card PDF, the
default is bingo.pdf

=back

=head2 print_pages

The B<print_pages> is the main method it takes two arguments, the
number of pages you want to print and optionally the number of cards
you want to print on a page. 

The default is 3 cards on a page which also is the maximum.

The B<print_pages> returns 1 on success and 0 on failure, failure issues a 
warning.

B<print_pages> calls B<_print_card>.

=head2 _print_card

This is the method used to print the actual card, it calls B<_print_row> 3
times.

=over 4

=item * y_start_cordinate

The B<Y> start cordinate (we print botton up for now, please see the TODO file).

=item * y_end_cordinate

The B<Y> end cordinate (we print botton up for now, please see the TODO file).

=item * x_start_cordinate

The B<X> start cordinate (we print botton up for now, please see the TODO file).

=item * size

The pixel size of the box containg the number,

=back

=head2 _print_row

This method prints a single row.

=over 4
	
=item * y_start_cordinate

The B<Y> start cordinate (we print botton up for now, please see the TODO file).

=item * x_start_cordinate

The B<X> start cordinate (we print botton up for now, please see the TODO file).

=item * x_end_cordinate

The B<X> end cordinate (we print botton up for now, please see the TODO file),

=item * size

The pixel size of the box containg the number.

=item * numbers

The numbers to be inserted into the row as an reference to an array.

=back

=cut

=head1 SEE ALSO

=over 4

=item Games::Bingo

=item Games::Bingo::Card

=item PDFLib

=item bin/bingo_print.pl

=back

=head1 TODO

The TODO file contains a complete list for the Games::Bingo::Print
class.

=cut

=head1 AUTHOR

jonasbn E<lt>jonasbn@cpan.orgE<gt>

=cut

=head1 ACKNOWLEDGEMENTS

Thanks to Matt Sergeant for suggesting using PDFLib. 

=cut

=head1 COPYRIGHT

Games::Bingo::Print and related modules are free software and is
released under the Artistic License. See
E<lt>http://www.perl.com/language/misc/Artistic.htmlE<gt> for details.

Games::Bingo::Print is (C) 2003 Jonas B. Nielsen (jonasbn)
E<lt>jonasbn@cpan.orgE<gt>

=cut