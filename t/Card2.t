#!/usr/local/bin/perl -w

# $Id: Card2.t,v 1.1 2003/07/27 20:00:41 jonasbn Exp $

use strict;
use Data::Dumper;
use lib qw(../lib lib);

use Test::More tests => 3;

my $dump = 0;

#Test 1-2
BEGIN { use_ok( 'Games::Bingo::Print::Card'); }
require_ok( 'Games::Bingo::Print::Card' );

#Testing the constructor and the constructed object

#Test 3
my $p = Games::Bingo::Print::Card->new();
ok($p->populate(), 'Populating the test card');

print STDERR Dumper $p if $dump;
