#!/usr/local/bin/perl -w

# $Id: integrity_check.t,v 1.1 2003/07/29 20:11:54 jonasbn Exp $

use strict;
use lib qw(../lib lib);
use Games::Bingo::Print::Card;
use Test::More tests => 2;

#test 1
{
	my @numbers = qw(2 10 21 71 14 34 56 74 4 42 66 90);

	my $c = Games::Bingo::Print::Card->new();

	for (my $row = 0; $row < 3; $row++) {
	
		for (my $number = 0; $number < 4; $number++) {
			my $n = shift(@numbers);
			$c->_populate($row, $n);
		}
	}
	is($c->_integrity_check(), 1, 'Testing our card integrity');
}

#test 2
{
	my @numbers = qw(2 4 6 8 14 34 56 74 24 42 66 90);

	my $c = Games::Bingo::Print::Card->new();

	for (my $row = 0; $row < 3; $row++) {
	
		for (my $number = 0; $number < 4; $number++) {
			my $n = shift(@numbers);
			$c->_populate($row, $n);
		}
	}
	is($c->_integrity_check(), 0, 'Testing our card integrity');
}
