package org.intermine.model.bio;

public interface CRM extends org.intermine.model.bio.RegulatoryRegion
{
    public java.util.Set<org.intermine.model.bio.TFBindingSite> gettFBindingSites();
    public void settFBindingSites(final java.util.Set<org.intermine.model.bio.TFBindingSite> TFBindingSites);
    public void addtFBindingSites(final org.intermine.model.bio.TFBindingSite arg);

}
