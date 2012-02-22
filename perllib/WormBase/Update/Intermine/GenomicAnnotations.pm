package WormBase::Update::Intermine::GenomicAnnotations;

use Moose;
use Bio::SeqIO;

extends qw/WormBase::Update/;

# The symbolic name of this step
has 'step' => (
    is => 'ro',
    default => 'fetch genomic annotations in gff3',
    );

has 'datadir' => (
    is => 'ro',
    lazy_build => 1);

sub _build_datadir {
    my $self = shift;
    my $release = $self->release;
    my $datadir   = join("/",$self->intermine_staging,$release);
    $self->_make_dir($datadir);
    return "$datadir";
}

sub run {
    my $self = shift;    
    my $datadir = $self->datadir;
    chdir $datadir or $self->log->logdie("cannot chdir to local data directory: $datadir");

    my $release     = $self->release;
    my $all_species = $self->species;
    my $ftp_host    = $self->production_ftp_host;
    
    foreach my $species (@$all_species) {	
	my $taxonid = $species->taxon_id;
	my $name    = $species->symbolic_name
	next unless $name =~ /elegans/;

	$self->_make_dir("$datadir/genomic_annotations");
	my $gff_dir = "$datadir/genomic_annotations/$name";
	$self->_make_dir($gff_dir);
	chdir $gff_dir or $self->log->logdie("cannot chdir to local data directory: $gff_dir");

	my $gff3 = "ftp://$ftp_host/pub/wormbase/releases/$release/species/$name/$name.$release.annotations.gff3.gz";
	my $gff3_mirrored = "$name.$release.annotations.gff3.gz";
	my $gff3_output   = "$name.$taxonid.current.annotations.gff3";
	$self->mirror_uri({ uri    => $gff3,
			    output => $gff3_mirrored,
			    msg    => "mirroring genomic annotations for $name" });
	
	$self->process_gff($gff3_mirrored,$gff3_output);
    }

    # Update the datadir current symlink
    $self->update_staging_dir_symlink();
}


sub process_gff {
    my ($self,$file,$output_file) = @_;

    open IN,"/bin/gunzip -c $file |" or $self->log->logdie("Couldn't open $file for processing: $!");
    my %data;

    while (<IN>) {
	next if /^#/;      # ignore comments
	s/^CHROMOSOME_//i; # remove chromosome identifiers
	s/^chr//i;         # 
	my $type = $self->get_type($_);
	
	$data{$type} = () unless( exists $data{$type} );
	push(@{$data{$type}}, $_);
    }
    close IN;
    system("mv $file $file.original.gz");
    
    open OUT,"| /bin/gzip -c > $output_file";
#    my @order = qw(gene mRNA exon CDS); 
    my @order = qw(gene rRNA_primary_transcript nc_primary_transcript miRNA_primary_transcript tRNA pseudogenic_transcript snoRNA snRNA miRNA mRNA exon CDS);
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
	    
	    print OUT join("\t",$ref,$source,$type,$start,$stop,$score,$strand,$phase,$attributes),"\n";
	}
    }
    close OUT;
#    system("sort -k1,1 -k3,3n -k4,4n -T /tmp tmp.gff > c_elegans.current.annotations.sorted.gff3");
#    system("gzip c_elegans.current.annotations.sorted.gff3");
#    unlink "tmp.gff";

}

sub get_type {
    my ($self,$line) = @_;
    my @data = split(/\t/,$line);
    return $data[2];
}



1;
