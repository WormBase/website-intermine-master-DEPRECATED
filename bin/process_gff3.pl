#!/usr/bin/perl -w

# WormBase GFF3 pre-processor

use strict;

my $species = shift;



	gunzip -c ${SPECIES}.current.annotations.original.gff3.gz | perl -p -i -e 's/CHROMOSOME_//g' | gzip -c > ${SPECIES}.current.annotations.gff3.gz
