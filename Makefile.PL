use ExtUtils::MakeMaker;

# $Id: Makefile.PL,v 1.2 2003/07/27 20:00:38 jonasbn Exp $

WriteMakefile(
    'NAME'	        => 'Games::Bingo::Print',
    'VERSION_FROM'  => 'lib/Games/Bingo/Print.pm', # finds $VERSION
	'PREREQ_PM' => {
		'POSIX'         => 0,
		'Test::Harness' => 0,
		'Test::More'    => 0,
		'Data::Dumper'  => 0,
		'PDFLib'		=> '0.12',
		'Games::Bingo'  => '0.05',
		'Getopt::Long'   => 0,
	}
);
