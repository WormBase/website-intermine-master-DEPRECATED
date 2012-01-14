#!/bin/bash

# Quick data staging script for building a new intermine release.

WSVERSION=$1

if [ ! ${WSVERSION} ]; then
  echo "Usage: $0 [WSVERSION]"
  exit
fi

DATAROOT=/usr/local/wormbase/intermine/data/${WSVERSION}/
#        VERSION    /  SOURCE / SPECIES  / TYPE
mkdir -p ${DATAROOT}/wormbase/c_elegans/gff3
mkdir -p ${DATAROOT}/wormbase/c_elegans/fasta

ALL_SPECIES=(c_elegans);

for SPECIES in ${ALL_SPECIES}; do

    # genomic annotations
    cd ${DATAROOT}/wormbase/${SPECIES}/gff3
    curl -O ftp://ftp.wormbase.org/pub/wormbase/releases/${WSVERSION}/species/${SPECIES}/${SPECIES}.${WSVERSION}.annotations.gff3.gz
    mv ${SPECIES}.${WSVERSION}.annotations.gff3.gz ${SPECIES}.current.annotations.gff3.gz
    # cp /usr/local/ftp/pub/wormbase/releases/${WSVERSION}/species/c_elegans/c_elegans.${WSVERSION}.annotations.gff3.gz c_elegans.current.annotations.gff3.gz

    # FASTA sequence
    cd ${DATAROOT}/wormbase/${SPECIES}/fasta
    curl -O ftp://ftp.wormbase.org/pub/wormbase/releases/${WSVERSION}/species/${SPECIES}/${SPECIES}.${WSVERSION}.genomic.fa.gz 
    mv ${SPECIES}.${WSVERSION}.genomic.fa.gz ${SPECIES}.current.genomic.fa.gz
    #cp /usr/local/ftp/pub/wormbase/releases/${WSVERSION}/species/c_elegans/c_elegans.${WSVERSION}.annotations.gff3.gz c_elegans.current.genomic.fa.gz
    gunzip ${SPECIES}.current.genomic.fa.gz

    # Update the root-level symlink
    cd ${DATAROOT}
    rm -rf current
    ln -s ${VERSION} current
   
    # Intermine can't load a concatenated fasta via src.data.file
    csplit ${SPECIES}.current.genomic.fa '/^>/' '{*}' -z -s --suffix-format="%02d.fasta" --prefix=split-

    if [ ${SPECIES} == 'c_elegans' ]; then
	perl -p -i -e 's/CHROMOSOME_//g' *.fasta
    fi
done   