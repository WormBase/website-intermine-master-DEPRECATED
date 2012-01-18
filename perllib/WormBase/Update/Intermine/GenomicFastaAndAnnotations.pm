package WormBase::Update::Intermine::GenomicFasta;

use Moose;
use Bio::SeqIO;

extends qw/WormBase::Update/;

# The symbolic name of this step
has 'step' => (
    is => 'ro',
    default => 'fetch genomic fasta sequence',
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
	
	my $taxon_id    = $species->taxon_id;
	my $name        = $species->symbolic_name;
	
	# GFF3
	$self->_make_dir("$datadir/genomic_annotations");
	my $gff_dir = "$datadir/genomic_annotations/$name";
	$self->_make_dir($gff_dir);
	chdir $gff_dir or $self->log->logdie("cannot chdir to local data directory: $gff_dir");

	my $gff3 = "ftp://$ftp_host/pub/wormbase/releases/$release/species/$name/$name.$release.annotations.gff3.gz";
	my $gff3_mirrored = "$name.current.annorations.gff3.gz";
	$self->mirror_uri({ uri    => $gff3,
			    output => $gff3_mirrored,
			    msg    => "mirroring genomic annotations for $name" });
	
	$self->process_gff($gff3_mirrored);
	
	# if ($name =~ /elegans/) {
	#    $gff3_file = $self->process_elegans("$name.current.annotations.gff3.gz");
	#}

        # FASTA
	$self->_make_dir("$datadir/genomic_fasta");
	my $fasta_dir = "$datadir/genomic_fasta/$name";
	$self->_make_dir($fasta_dir);
	chdir $fasta_dir or $self->log->logdie("cannot chdir to local data directory: $fasta_dir");
	my $fasta = "ftp://$ftp_host/pub/wormbase/releases/$release/species/$name/$name.$release.genomic.fa.gz";
	$self->mirror_uri({ uri    => $fasta,
			    output => "$name.current.genomic.fa.gz",
			    msg    => "mirroring genomic fasta for $name" });
	
	$self->split_fasta("$name.current.genomic.fa.gz");
	
    }

    # Update the datadir current symlink
    $self->update_staging_dir_symlink();
}


sub process_gff {
    my ($self,$file) = @_;

    open IN,"/bin/gunzip -c $file |" or $self->log->logdie("Couldn't open $file for processing: $!");
    my %data;

    while (<IN>) {
	next if /^#/;      # ignore comments
	s/^CHROMOSOME_//i; 
	s/^chr//i;         # remove chromosome identifiers
	my $type = $self->get_type($_);
	
	$data{$type} = () unless( exists $data{$type} );
	push(@{$data{$type}}, $_);
    }
    close IN;
    system("mv $file $file.original.gz");
    
    open OUT,"| /bin/gzip -c > $file";
#    my @order = qw(gene mRNA exon CDS); 
    my @order = qw(gene rRNA_primary_transcript nc_primary_transcript miRNA_primary_transcript tRNA pseudogenic_transcript snoRNA snRNA miRNA mRNA exon CDS);
    my @types = keys %data;
    
    foreach my $desired_order (@order) {
	foreach my $line (@{$data{$desired_order}}) {
	    chomp $line;
	    my ($ref,$source,$type,$start,$stop,$score,$strand,$phase,$attributes) = split("\t",$line);
	    
	    # Let's only keep WormBase features for now.
	    next unless $source eq 'WormBase';
	    
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
