#!/usr/local/bin/perl -w

# $Id: Card.t,v 1.2 2003/07/29 20:25:19 jonasbn Exp $

use strict;
use Data::Dumper;
use lib qw(../lib lib);
use Games::Bingo;
use Test::More tests => 104;

#test 1-2
BEGIN { use_ok( 'Games::Bingo::Print::Card'); }
require_ok( 'Games::Bingo::Print::Card' );

my $dump = 0;

#test 3-4 - Testing the constructor and the constructed object
my $p = Games::Bingo::Print::Card->new();

is(ref $p, 'Games::Bingo::Print::Card', 'Testing the constructed object');

is((scalar @{$p}), 9, 'Testing the number of columns');

#test 5-15
for(my $i = 0; $i < 9; $i++) {
	is(scalar @{$p->[$i]}, 3, "Testing the column: $i");
}

#Testing the resolution of numbers resolv column
my $bingo = Games::Bingo->new();
my @game_numbers;
$bingo->init(\@game_numbers, 90);

my $match = 0;
for(my $i = 0; $i < (scalar @game_numbers); $i++) {
	if ($game_numbers[$i] == 90) {
		#nop;
	} elsif ($game_numbers[$i] > 9) {
		$match++ if (($game_numbers[$i] % 10) == 0);
	} 
	is($p->_resolve_column($game_numbers[$i]), $match, "Testing number: $game_numbers[$i] against: $match");
}

#Testing the population of the card
my @numbers = qw(2 10 21 71 14 34 56 74 4 42 66 90);

my $counter;
for (my $row = 0; $row < 3; $row++) {
	
	for (my $number = 0; $number < 4; $number++) {
		my $n = shift(@numbers);
		$counter++;
		print STDERR "[$counter] We are trying to insert $n in our card at row $row\n" if $dump;
		$p->_populate($row, $n);
	}
}
is($counter, 12, 'Testing our card generation');

print STDERR Dumper $p if $dump;

#Printing a test card
for (my $row = 0; $row < 3; $row++) {
	for (my $column = 0; $column < 9; $column++) {
		print "[";
		if ($p->[$column]->[$row] =~ m/^\d+$/) {
			printf("%02d", $p->[$column]->[$row]);
		} else {
			print $p->[$column]->[$row];
		}
		print "] ";
	}
	print "\n";
}
