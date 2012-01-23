package org.intermine.bio.dataconversion;

/*
 * Copyright (C) 2012 The WormBase Consortium
 * 
 * California Institute of Technology
 * Ontario Institute for Cancer Research 
 * Burroughs Wellcome Trust Sanger Institute
 * Washington University St. Louis
 *
 * This code may be freely distributed and modified under the
 * terms of the GNU Lesser General Public Licence.  This should
 * be distributed with the code.  See the LICENSE file for more
 * information or http://www.gnu.org/copyleft/lesser.html.
 *
 */

import java.util.Collection;
import java.util.HashMap;
import java.util.Map;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Set;
import org.intermine.xml.full.ReferenceList;

/* import org.intermine.bio.io.gff3.GFF3Record; GFF3RecordHandler imports this. Not sure what it provides. */
import org.intermine.metadata.Model;
import org.intermine.xml.full.Item;

/**
 * A generic munger of WormBase GFF2 files
 *
 * @author Todd Harris (todd@wormbase.org)
 */

public class WormBaseGFF2RecordHandler
{
    protected Map<String, Item> items = new LinkedHashMap<String, Item>();
    protected List<Item> earlyItems = new ArrayList<Item>();
    protected List<String> parents = new ArrayList<String>();
    protected Map<String, String> refsAndCollections = new HashMap<String, String>();
    private Item sequence;
    private Model tgtModel;
    protected GFF3Converter converter;
    private Item organism;
    private ReferenceList dataSetReferenceList = new ReferenceList("dataSets");
    private ReferenceList publicationReferenceList = new ReferenceList("publications");
    private Item tgtOrganism;
    protected Item tgtSequence;

    /**
     * Construct with the model to create items in (for type checking).
     * @param tgtModel the model for which items will be created
     */
    public WormbaseGFF2RecordHandler(Model tgtModel) {
        this.tgtModel = tgtModel;
    }

    /**
     * Method to perform additional operations for a GFF3Record.  Access to core items
     * is possible via getters() (sequence and computational analysis items cannot be
     * altered but are available read-only).  Additional items to store can be placed
     * in the items map, keys can be anything except a string starting with '_'.
     * @param record the GFF line being processed
     */
    public void process(GFF3Record record) {
        // empty
    }

    /**
     * Set the Map of GFF identifiers to Item identifier.  The Map should be used to get/add any
     * item identifiers for features used so that multiple Items aren't created for the same
     * feature.
     * @param identifierMap map from GFF ID to item identifier for all features
     */
    public void setIdentifierMap(Map<?, ?> identifierMap) {
        // empty
    }

    /**
     * Return the Model that was passed to the constructor.
     * @return the Model
     */
    public Model getTargetModel() {
        return tgtModel;
    }

    /**
     * Set sequence item created for this record, should not be edited in handler.
     * @param sequence the sequence item
     */
    public void setSequence(final Item sequence) {
        this.sequence = sequence;
    }

    /**
     * Return the sequence Item set by setSequence()
     * @return the sequence Item
     */
    protected Item getSequence() {
        return sequence;
    }

    /**
     * Set organism item, this is global across record handler and final
     * @param organism the organism item
     */
    public void setOrganism(final Item organism) {
        this.organism = organism;
    }

    /**
     * Return the organism Item set by setOrganism()
     * @return the organism Item
     */
    protected Item getOrganism() {
        return organism;
    }

    /**
     * Set the location item for this record.
     * @param location the location item
     */
    public void setLocation(Item location) {
        items.put("_location", location);
    }

    /**
     * Return the location Item set by setLocation()
     * @return the location Item
     */
    protected Item getLocation() {
        return items.get("_location");
    }

    /**
     * Clear the location item for this record.
     */
    public void clearLocation() {
        items.remove("_location");
    }

    /**
     * Set the feature item for this record.
     * @param feature the feature item
     */
    public void setFeature(Item feature) {
        items.put("_feature", feature);
    }

    /**
     * Return the feature Item set by setFeature()
     * @return the feature Item
     */
    protected Item getFeature() {
        return items.get("_feature");
    }

    /**
     * Remove the feature item that was set with setFeature().
     */
    protected void removeFeature() {
        items.remove("_feature");
    }

    /**
     * Add an DataSet Item to this handler, to be retrieved later with getDataSetReferenceList().
     * @param dataSet the data set
     */
    public void addDataSet(Item dataSet) {
        dataSetReferenceList.addRefId(dataSet.getIdentifier());
    }

    /**
     * Return a ReferenceList containing the DataSet Items ids set by addDataSet()
     * @return the ReferenceList
     */
    public ReferenceList getDataSetReferenceList() {
        return dataSetReferenceList;
    }

    /**
     * Reset the list of DataSet items.
     */
    public void clearDataSetReferenceList() {
        dataSetReferenceList = new ReferenceList("dataSets");
    }

    /**
     * Add an Publication Item to this handler, to be retrieved later with
     * getPublicationReferenceList().
     * @param publication the data set
     */
    public void addPublication(Item publication) {
        publicationReferenceList.addRefId(publication.getIdentifier());
    }

    /**
     * Return a ReferenceList containing the Publication Items ids set by addPublication()
     * @return the ReferenceList
     */
    public ReferenceList getPublicationReferenceList() {
        return publicationReferenceList;
    }

    /**
     * Reset the list of Publication items.
     */
    public void clearPublicationReferenceList() {
        publicationReferenceList = new ReferenceList("publications");
    }

     /**
     * Get the tgtOrganism item to use in this handler
     * @param tgtOrganism the tgtOrganism item
     */
    public void setTgtOrganism(Item tgtOrganism) {
        items.put("_tgtOrganism", tgtOrganism);
    }

    /**
     * Return the tgtOrganism Item set by setTgtOrganism()
     * @return the tgtOrganism Item
     */
    protected Item getTgtOrganism() {
        return tgtOrganism;
    }

    /**
     * Set tgtSequence item created for this record, should not be edited in handler.
     * @param tgtSequence the sequence item
     */
    public void setTgtSequence(Item tgtSequence) {
        items.put("_tgtSequence", tgtSequence);
    }

    /**
     * Get the target Sequence Item set by setTgtSequence().
     * @return the target Sequence Item
     */
    protected Item getTgtSequence() {
        return tgtSequence;
    }

    /**
     * Set the tgtLocation item for this record.
     * @param tgtLocation the location item
     */
    public void setTgtLocation(Item tgtLocation) {
        items.put("_tgtLocation", tgtLocation);
    }

    /**
     * Return the tgtLocation Item set by setTgtLocation()
     * @return the tgtLocation Item
     */
    protected Item getTgtLocation() {
        return items.get("_tgtLocation");
    }

    /**
     * Return true if Location objects should be made for all features (which is the default).
     * @param record the current feature
     * @return true if Location objects should be made
     */
    protected boolean createLocations(GFF3Record record) {
        return true;
    }

    /**
     * Remove all items held locally in handler.
     */
    public void clear() {
        items = new LinkedHashMap<String, Item>();
        sequence = null;
        earlyItems.clear();
    }

    /**
     * Return all items set and created in handler in this run - excludes sequence and
     * ComputationalAnalysis items.
     * @return a set of items
     */
    public Collection<Item> getItems() {
        Set<Item> all = new LinkedHashSet<Item>(items.values());
        Set<Item> retval = new LinkedHashSet<Item>();
        for (Item item : earlyItems) {
            if (all.remove(item)) {
                retval.add(item);
            } else {
                throw new RuntimeException("Found item in earlyItems but not items: " + item);
            }
        }
        retval.addAll(all);
        return retval;
    }

    /**
     * Add a new Item to the Collection returned by getItems().
     * @param item the Item to add
     */
    public void addItem(Item item) {
        items.put(item.getIdentifier(), item);
    }

    /**
     * Add a new Item to the Collection returned by getItems, at the beginning.
     * @param item the Item to add
     */
    public void addEarlyItem(Item item) {
        items.put(item.getIdentifier(), item);
        earlyItems.add(item);
    }

    /**
     * Return items that need extra processing that can only be done after all other GFF features
     * have been read.
     * @return extra Items
     */
    public Collection<Item> getFinalItems() {
        return new ArrayList<Item>();
    }

    /**
     * Clear the list of final items.
     */
    public void clearFinalItems() {
        // do nothing
    }

    /**
     * @param parent item ID
     */
    public void addParent(String parent) {
        parents.add(parent);
    }

    /**
     * @return map listing references and collections to set for this record
     */
    public Map<String, String> getRefsAndCollections() {
        return refsAndCollections;
    }

    /**
     * @param converter the converter to set
     */
    public void setConverter(GFF3Converter converter) {
        this.converter = converter;
    }
}












public class WormBaseGFF2RecordHandler extends GFF3RecordHandler
{
    private Map<String, Item> elementsMap = new HashMap<String, Item>();

    /**
     * Create a new WormBaseGFF3RecordHandler for the given target model.
     * @param tgtModel the model for which items will be created
     */
    public WormBaseGFF2RecordHandler (Model tgtModel) {
        super(tgtModel);
        // refsAndCollections controls references and collections that are set from the
        // Parent= attributes in the GFF3 file.
        refsAndCollections.put("Exon", "transcripts");
        refsAndCollections.put("MRNA", "gene");
    }

    /**
     * {@inheritDoc}
     */
    /*    @Override necessary */
    public void process(GFF3Record record) {
        Item feature = getFeature();
	
        String clsName = feature.getClassName();
	
        if ("Gene".equals(clsName)) {
            // move Gene.primaryIdentifier to Gene.secondaryIdentifier
            // move Gene.symbol to Gene.primaryIdentifier
	    
            if (feature.getAttribute("primaryIdentifier") != null) {
                String secondary = feature.getAttribute("primaryIdentifier").getValue();
                feature.setAttribute("secondaryIdentifier", secondary);
            }
            if (feature.getAttribute("symbol") != null) {
                String primary = feature.getAttribute("symbol").getValue();
                feature.setAttribute("primaryIdentifier", primary);
                feature.removeAttribute("symbol");
            }
        }
    }
    
    
        
    /* from drosphila deletion; useful example for processing attributes */
    String note = record.getNote();
    if ("ChromosomalDeletion".equals(record.getType())) {
	if ("made".equals(note)) {
	    feature.setAttribute("available", "true");
	} else {
	    feature.setAttribute("available", "false");
	}
	String identifier = feature.getAttribute("primaryIdentifier").getValue();
	// don't need a primaryIdentifier
	feature.removeAttribute("primaryIdentifier");
	feature.setAttribute("secondaryIdentifier", identifier);
    } else {
	throw new RuntimeException("unknown type: " + record.getType());
    }


    /**
     * Return false - get locations from FlyBase.
     * {@inheritDoc}
     */
    @Override
	protected boolean createLocations(@SuppressWarnings("unused") GFF3Record record) {
        return false;
    }
    
    /**
     * Return items that need extra processing that can only be done after all other GFF features
     * have been read.  For this class TransposableElementInsertionSite items
     * @return the final Items
     */
    @Override
	public Collection<Item> getFinalItems() {
        return elementsMap.values();
    }
}







