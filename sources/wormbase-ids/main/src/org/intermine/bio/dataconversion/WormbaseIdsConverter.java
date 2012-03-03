package org.intermine.bio.dataconversion;

/*
 * Copyright (C) 2002-2011 FlyMine
 *
 * This code may be freely distributed and modified under the
 * terms of the GNU Lesser General Public Licence.  This should
 * be distributed with the code.  See the LICENSE file for more
 * information or http://www.gnu.org/copyleft/lesser.html.
 *
 */

import java.io.Reader;
import java.util.Iterator;

import org.intermine.dataconversion.ItemWriter;
import org.intermine.metadata.Model;
import org.intermine.xml.full.Item;

import org.apache.commons.lang.StringUtils;
import org.intermine.util.FormattedTextParser;
import java.io.File;
import java.util.ArrayList;
import java.util.List;

import org.apache.tools.ant.DirectoryScanner;
import org.apache.tools.ant.types.FileSet;
import java.io.IOException;

import org.apache.log4j.Logger;

/**
 * 
 * @author
 */
public class WormbaseIdsConverter extends BioFileConverter
{
    private static final Logger LOG = Logger.getLogger(WormbaseIdsConverter.class);
    //
    private static final String DATASET_TITLE = "WormBase Identifiers";
    private static final String DATA_SOURCE_NAME = "WormBase";

    /**
     * Constructor
     * @param writer the ItemWriter used to handle the resultant items
     * @param model the Model
     */
    public WormbaseIdsConverter(ItemWriter writer, Model model) {
        super(writer, model, DATA_SOURCE_NAME, DATASET_TITLE);
    }

    /**
     * 
     *
     * {@inheritDoc}
     */
    public void process(Reader reader) throws Exception {
       Iterator<?> lineIter = FormattedTextParser.parseTabDelimitedReader(reader);

        // data is in format:
        // primaryIdentifier | identifier | symbol

        while (lineIter.hasNext()) {
            String[] line = (String[]) lineIter.next();

	    //System.out.println ("\nAAAAAA length " + line.length + " " + line[0]);
	    if ( line[0].startsWith("#") )
		continue;
	    if ( line[0].equals("")) {
		LOG.warn("missing organism ID , failed to load Gene!");
		continue;
	    }

            String organismID = line[0];
            String organismName = line[1];
            String primaryIdentifier = line[2];
            String symbol =  "";
            String secondIdentifier = "";
	    if (line.length > 3 )
            	symbol = line[3];
	    if (line.length > 4 )
            	secondIdentifier = line[4];

            Item gene = createItem("Gene");
            if (primaryIdentifier != null && !"".equals(primaryIdentifier )) { 
                gene.setAttribute("primaryIdentifier", primaryIdentifier);
            }
            if (symbol != null && !"".equals(symbol)) { 
                gene.setAttribute("symbol", symbol);
            }
            if (secondIdentifier != null && !"".equals(secondIdentifier )) { 
                gene.setAttribute("secondaryIdentifier", secondIdentifier);
            }
                                  
            gene.setReference("organism", getOrganism(organismID));
            store(gene); 	
    }
}
}
