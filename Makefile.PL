use ExtUtils::MakeMaker;

# $Id: Makefile.PL,v 1.4 2004/01/07 19:32:41 jonasbn Exp $

WriteMakefile(
    'NAME'	        => 'Games::Bingo::Print',
    'VERSION_FROM'  => 'lib/Games/Bingo/Print.pm', # finds $VERSION
	'PREREQ_PM' => {
		'POSIX'         => 0,
		'Test::Harness' => 0,
		'Test::More'    => 0,
		'Test::Pod'     => '0.95',
		'Data::Dumper'  => 0,
		'PDFLib'		=> '0.12',
		'Games::Bingo'  => '0.09', #actually G::B::Card 0.02
		'Getopt::Long'  => 0,
	}
);
