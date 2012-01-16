package WormBase::Update::Intermine::GeneOntology;

use Moose;

extends qw/WormBase::Update/;

# The symbolic name of this step
has 'step' => (
    is => 'ro',
    default => 'fetch gene ontology .obo and .association files',
    );

has 'datadir' => (
    is => 'ro',
    lazy_build => 1);

sub _build_datadir {
    my $self = shift;
    my $release = $self->release;
    my $datadir   = join("/",$self->intermine_staging,$release);
    $self->_make_dir($datadir);
    return $datadir;
}

sub run {
    my $self = shift;    
    my $datadir = $self->datadir;
    chdir $datadir or $self->log->logdie("cannot chdir to local data directory: $datadir");

    my $release = $self->release;
    
    $self->_make_dir("$datadir/ontology_gene");
    chdir "$datadir/ontology_gene" or $self->log->logdie("cannot chdir to local data directory: $datadir/ontology_gene");

    my $ftp_host    = $self->production_ftp_host;
   
    $self->mirror_uri({ uri    => "ftp://$ftp_host/pub/wormbase/releases/$release/ONTOLOGY/gene_ontology.$release.obo",
			output => "gene_ontology.current.obo",
			msg    => "mirroring gene ontology .obo file" });
    
    $self->mirror_uri({ uri    => "ftp://$ftp_host/pub/wormbase/releases/$release/ONTOLOGY/gene_association.$release.wb",
			output => "gene_association.current.unsorted",
			msg    => "mirroring gene ontology associations file" });
    
    # Sort the gene associations file
    system("sort -k2,2 gene_association.current.unsorted > gene_association.current");

    # Update the datadir current symlink
    $self->update_staging_dir_symlink();
}

1;
