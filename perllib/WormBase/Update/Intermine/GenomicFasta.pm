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
	$self->mirror_uri({ uri    => $gff3,
			    output => "$name.current.annotations.gff3.gz",
			    msg    => "mirroring genomic annotations for $name" });

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

1;
