package org.intermine.model.bio;

public interface OverlappingESTSet extends org.intermine.model.bio.SequenceFeature
{
    public java.util.Set<org.intermine.model.bio.EST> geteSTs();
    public void seteSTs(final java.util.Set<org.intermine.model.bio.EST> ESTs);
    public void addeSTs(final org.intermine.model.bio.EST arg);

}
