#!/usr/bin/perl -w

use FindBin qw/$Bin/;
use lib "$Bin/../perllib";
use strict;
use WormBase::Update::Intermine::GenomicFasta;
use Getopt::Long;

my ($release,$help);
GetOptions('release=s' => \$release,
	   'help=s'    => \$help);

if ($help || (!$release)) {
    die <<END;
    
Usage: $0 --release WSXXX

Fetch the genomic fasta sequence for all species available at WormBase.

END
;
}

my $agent = WormBase::Update::Intermine::GenomicFasta->new({release => $release});
$agent->execute();
