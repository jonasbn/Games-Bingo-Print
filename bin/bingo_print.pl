#!/usr/local/bin/perl -w

# $Id: bingo_print.pl,v 1.3 2003/07/29 20:25:19 jonasbn Exp $

use strict;
use PDFLib;
use Getopt::Long;
use Data::Dumper;
use lib qw(lib ../lib);
use Games::Bingo::Print;

my ($cards, $help, $heading, $text, $filename);

GetOptions (
	'help'       => \$help,
	'heading=s'  => \$heading,
	'text=s'     => \$text,
	'filename=s' => \$filename,
	'cards=i'    => \$cards,
);

my $pages = shift @ARGV || usage();

my $bp = Games::Bingo::Print->new(
	'heading'  => $heading,
	'text'     => $text,
	'filename' => $filename,
);

$bp->print_pages($pages, $cards);

exit(0);

sub usage {
	print "Usage: bingo_print.pl [options] <number of pages>\n\n";
	print "Options:\n";
	print "\t--help\t(this message)\n";
	print "\t--heading\ta string which will be inserted as a header\n";
	print "\t--text\ta string to be inserted underneath the header\n";
	print "\t--filename\ta filename for the PDF target file\n";
	print "\t--cards\tthe number of cards per page (1-3, 3 is default)\n";
	
	exit(0);
}

__END__

=head1 NAME

bingo_plates.pl

=cut

=head1 SYNOPSIS

% bingo_print.pl 3

% bingo_print.pl 10

% bingo_print.pl --help

% bingo_print.pl --cards=1 3

% bingo_print.pl --filename=mybingo.pdf --cards=1 10

% bingo_print.pl --heading="My Bingo" --cards=1 10

% bingo_print.pl --heading="My Bingo" --text="Phantastic Prizes!" --cards=1 10

=cut

=head1 DESCRIPTION

This is a console based PDF bingo plates.pl generator. Together with
bingo.pl you have everything you need to play bingo.

=cut

=head1 SEE ALSO

=over 4

=item Games::Bingo

=item bin/bingo.pl

=back

=cut

=head1 TODO

The TODO file contains a complete list for the whole Games::Bingo
project.

=cut

=head1 AUTHOR

jonasbn E<gt>jonasbn@io.dkE<lt>

=cut

=head1 COPYRIGHT

Games::Bingo and related modules are free software and is released under
the Artistic License. See
E<lt>http://www.perl.com/language/misc/Artistic.htmlE<gt> for details.

Games::Bingo is (C) 2003 Jonas B. Nielsen (jonasbn)
E<gt>jonasbn@io.dkE<lt>

=cut