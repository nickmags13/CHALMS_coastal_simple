function vote = go2vote(eumdl,lccf,c_income,c_tc,c_dmg,c_good,c_hsize,...
    c_lsize,c_amen,hsize,lsize,amen,c_pstrm,c_npstrm,paskh,newtax,tax,c_dmg0)

if eumdl == 2
    eu_base=c_pstrm.*((max(c_income-c_tc-paskh-tax-c_dmg,0).^c_good).*...
        (hsize.^c_hsize).*(lsize.^c_lsize).*(amen.^c_amen))+...
        c_npstrm.*((max(c_income-c_tc-paskh-tax,0).^c_good).*...
        (hsize.^c_hsize).*(lsize.^c_lsize).*(amen.^c_amen));
    
    eu_tax=c_pstrm.*((max(c_income-c_tc-paskh-newtax-c_dmg0,0).^c_good).*...
        (hsize.^c_hsize).*(lsize.^c_lsize).*(amen.^c_amen))+...
        c_npstrm.*((max(c_income-c_tc-paskh-newtax,0).^c_good).*...
        (hsize.^c_hsize).*(lsize.^c_lsize).*(amen.^c_amen));
    
    vote=eu_tax > eu_base;
elseif eumdl == 3
    refpt=(max(c_income-c_tc-paskh-tax,0).^c_good).*...
        (hsize.^c_hsize).*(lsize.^c_lsize).*(amen.^c_amen); %no storm, no mitigation
    nstrm_tax=(max(c_income-c_tc-paskh-newtax,0).^c_good).*...
        (hsize.^c_hsize).*(lsize.^c_lsize).*(amen.^c_amen); %no storm, with mitigation
    strm_tax=(max(c_income-c_tc-paskh-newtax-c_dmg0,0).^c_good).*...
        (hsize.^c_hsize).*(lsize.^c_lsize).*(amen.^c_amen); %storm, with mitigation
    strm_notax=(max(c_income-c_tc-paskh-tax-c_dmg,0).^c_good).*...
        (hsize.^c_hsize).*(lsize.^c_lsize).*(amen.^c_amen); %storm, no mitigation
    
    value_nstrm=abs(nstrm_tax-refpt)./(abs(nstrm_tax)+abs(refpt)+1);
    value_strm=abs(strm_tax-strm_notax)./(abs(strm_notax)+abs(strm_tax)+1);
    [~,ipntlval]=sort([value_nstrm value_strm],2,'descend');
    ivalnstrm=ipntlval(:,1);
    ivalstrm=ipntlval(:,2);
    dwght_nstrm=(lccf.^ivalnstrm)./((lccf.^ivalnstrm)*c_npstrm+...
        (lccf.^ivalstrm)*c_pstrm);
    dwght_strm=(lccf.^ivalstrm)./((lccf.^ivalnstrm)*c_npstrm+...
        (lccf.^ivalstrm)*c_pstrm);
    salwght_nstrm=c_npstrm*dwght_nstrm;
    salwght_strm=c_pstrm*dwght_strm;
    
    value_tax=salwght_nstrm.*nstrm_tax+salwght_strm.*strm_tax;
    value_base=salwght_nstrm.*refpt+salwght_strm.*strm_notax;
    
    vote=value_tax > value_base;
end