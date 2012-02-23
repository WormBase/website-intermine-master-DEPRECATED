#!/usr/bin/perl
use strict;

my $file = shift;
my $output_file = 'c_elegans.6239.current.annotations.gff3';

open IN,"/bin/gunzip -c $file |";
my %data;

while (<IN>) {
    next if /^#/;      # ignore comments
    s/^CHROMOSOME_//i; # remove chromosome identifiers
    s/^chr//i;         # 
    my $type = get_type($_);
    my $source = get_source($_);
    next if $source eq 'history';
    $data{$type} = () unless( exists $data{$type} );
    push(@{$data{$type}}, $_);
}
close IN;
system("mv $file $file.original.gz");

#    my @order = qw(gene mRNA exon CDS); 
my @order = qw(gene rRNA_primary_transcript nc_primary_transcript miRNA_primary_transcript primary_transcript transposable_element_insertion_site transposable_element tRNA pseudogenic_transcript snoRNA snRNA miRNA mRNA exon CDS three_prime_UTR five_prime_UTR complex_substitution substitution SNP deletion insertion_site operon);
my @types = keys %data;

foreach my $desired_order (@order) {
    foreach my $line (@{$data{$desired_order}}) {
	chomp $line;
	my ($ref,$source,$type,$start,$stop,$score,$strand,$phase,$attributes) = split("\t",$line);
	
	# Let's only keep WormBase features for now.
	# Kev's prototypical GFF3 has source of Wormbase.
	# but my GFF2->GFF3 does not.
	# next unless $source eq 'WormBase';
	
	# Mangle our attributes, removing the prefixes that will break integration.
	$attributes =~ s/Name=Gene:/Name=/g;
#		$attributes =~ s/ID=RGD/ID=/g;
#		$attributes =~ s/Parent=RGD/Parent=/g;
	$attributes =~ s/=\s+/=/g;
	$attributes =~ s/,\t/,/g;
	$attributes =~ s/\s+?;/;/g;
#		$attributes =~ s/associatedGene[\d\D]+?ID/ID/g;
#		$attributes =~ s/\t//g;
#		$attributes =~ s/\w+=;//g;
#		$attributes =~ s/,\s+/,/g;
	
	print join("\t",$ref,$source,$type,$start,$stop,$score,$strand,$phase,$attributes),"\n";
    }
}
#    system("sort -k1,1 -k3,3n -k4,4n -T /tmp tmp.gff > c_elegans.current.annotations.sorted.gff3");
#    system("gzip c_elegans.current.annotations.sorted.gff3");
#    unlink "tmp.gff";


sub get_type {
    my $line = shift;
    my @data = split(/\t/,$line);
    return $data[2];
}


sub get_source {
    my $line = shift;
    my @data = split(/\t/,$line);
    return $data[1];
}



=pod


Not yet handled

BLAT_RST_BEST	expressed_sequence_match
RNAi_primary	RNAi_reagent
binding_site_region	binding_site
BLAT_EST_BEST	EST_match
SAGE_tag_most_three_prime	SAGE_tag
Oligo_set	reagent
DNAseI_hypersensitive_site	DNAseI_hypersensitive_site
SAGE_tag	SAGE_tag
Vancouver_fosmid	nucleotide_match
TEC_RED	nucleotide_match
RepeatMasker	repeat_region
RNASeq	TSS
SAGE_tag_genomic_unique	SAGE_tag
dust	low_complexity_region
binding_site	binding_site
Expr_pattern	reagent
BLAT_OST_BEST	expressed_sequence_match
inverted	inverted_repeat
wublastx	protein_match
GenePair_STS	PCR_product
SAGE_tag_unambiguously_mapped	SAGE_tag
polyA_signal_sequence	polyA_signal_sequence
BLAT_RST_OTHER	expressed_sequence_match
BLAT_mRNA_BEST	cDNA_match
BLAT_ncRNA_BEST	nucleotide_match
Chronogram	reagent
tandem	tandem_repeat
SL1	SL1_acceptor_site
BLAT_mRNA_OTHER	cDNA_match
Link	assembly_component
deprecated_operon	operon
Orfeome	PCR_product
oligo	oligo
BLAT_OST_OTHER	expressed_sequence_match
cDNA_for_RNAi	experimental_result_region

SL2	SL2_acceptor_site
BLAT_EST_OTHER	EST_match
RNASeq	base_call_error_correction
Expr_profile	experimental_result_region
polyA_site	polyA_site

RNASeq	transcription_end_site
BLAT_ncRNA_OTHER	nucleotide_match

pmid18538569	G_quartet

RNAi_secondary	RNAi_reagent
operon	operon

BLAT_Caen_mRNA_BEST	translated_nucleotide_match
BLAT_Caen_mRNA_OTHER	translated_nucleotide_match
BLAT_NEMBASE	translated_nucleotide_match
BLAT_NEMATODE	translated_nucleotide_match
BLAT_Caen_EST_BEST	translated_nucleotide_match
mass_spec_genome	translated_nucleotide_match
BLAT_WASHU	translated_nucleotide_match
BLAT_Caen_EST_OTHER	translated_nucleotide_match

BLAT_TC1_BEST	nucleotide_match
regulatory_region	regulatory_region
jigsaw	CDS
BLAT_TC1_OTHER	nucleotide_match
Promoterome	PCR_product
segmental_duplication	duplication
history	primary_transcript
promoter	promoter


=cut
