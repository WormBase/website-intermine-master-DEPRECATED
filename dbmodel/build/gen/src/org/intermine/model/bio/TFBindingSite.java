package org.intermine.model.bio;

public interface TFBindingSite extends org.intermine.model.bio.BindingSite, org.intermine.model.bio.RegulatoryRegion
{
    public org.intermine.model.bio.CRM getcRM();
    public void setcRM(final org.intermine.model.bio.CRM CRM);
    public void proxycRM(final org.intermine.objectstore.proxy.ProxyReference CRM);
    public org.intermine.model.InterMineObject proxGetcRM();

}
