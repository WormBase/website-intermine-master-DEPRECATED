
# see http://intermine.org/wiki/RunningABuild
# ../bio/scripts/project_build [ -b build-db  | -l restore from latest dump ] -v  
# ../bio/scripts/project_build -b localhost wormmine_2012_02_xx.test 
#

ANT_OPTS="-Xmx1024m -Xms512m" 

# ROOT defines where wormmine directory is
ROOT=/usr/local/wormbase/intermine/current/wormmine


######################################################




######################################################
# integrate
# 	loading data 
cd ${ROOT}/integrate

#########################
# Load up some sources - See project.xml for sources that have "passed"
#########################
# wormbase ids 
ant -Dsource=wormbase-ids -v

# Uniprot
ant -Dsource=uniprot -v
ant -Dsource=uniprot-fasta -v

# Interpro
ant -Dsource=interpro -v

# Gene ontology
ant -Dsource=gene-ontology -v
ant -Dsource=gene-ontology-annotation -v

# Genomic fasta
ant -Dsource=celegans-genome-fasta -v

# Genomic annotation
ant -Dsource=celegans-gff3 -v

# Reactome
ant -Dsource=reactome -v
ant -Dsource=reactome-curated -v

# Entrez 
ant -Dsource=entrez-organism -v 





######################################################

cd ${ROOT}/webapp
# build-db-user-profile
# 	created adminstrator or superuser and templates 
# 	need to do this once 
#ant build-db-user-profile

# default
#	re-compiling of war file 
# remove-webapp
#	remove current webapp
# release-webapp
#	release webapp
ant default remove-webapp release-webapp



