
ANT_OPTS="-Xmx1024m -Xms512m" 
export ANT_OPTS

cd dbmodel
ant clean  build-db

cd ../integrate 
#ant -v -Dsource=qtsample 1> out.sample 2> err.sample
#ant -v -Dsource=qtsnp 1> out.qtsnp 2> err.qtsnp
#ant -v -Dsource=entrez-organism
#ant -v -Dsource=malaria-chromosome-fasta 1> out 2> err
ant -v -Dsource=all 1> out 2> err

cd ../postprocess
ant -v  

cd ../webapp
ant build-db-userprofile
ant -v default remove-webapp release-webapp


