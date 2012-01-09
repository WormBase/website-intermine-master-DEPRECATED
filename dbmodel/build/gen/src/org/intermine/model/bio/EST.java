package org.intermine.model.bio;

public interface EST extends org.intermine.model.bio.Oligo
{
    public java.util.Set<org.intermine.model.bio.OverlappingESTSet> getOverlappingESTSets();
    public void setOverlappingESTSets(final java.util.Set<org.intermine.model.bio.OverlappingESTSet> overlappingESTSets);
    public void addOverlappingESTSets(final org.intermine.model.bio.OverlappingESTSet arg);

}
