function [Upick,eucheck,wtp_pick,eu_base,eu_ins,wtp_base,wtp_ins]=...
    calc_eu_fullinfo(eumdl,lccf,c_income,c_tc,c_dmg,c_iprate,c_good,c_hsize,...
    c_lsize,c_amen,hsize,lsize,amen,c_pstrm,c_npstrm,paskh,icov,c_tax)

% % expected utility with no action
% wtp_base=c_pstrm.*(c_income-c_tc-c_dmg).*(c_hsize+c_lsize+c_amen)+...
%     c_npstrm.*(c_income-c_tc).*(c_hsize+c_lsize+c_amen);
% eu_base=c_pstrm.*((max(c_income-c_tc-paskh-c_dmg,0).^c_good).*...
%     (hsize.^c_hsize).*(lsize.^c_lsize).*(amen.^c_amen))+...
%     c_npstrm.*((max(c_income-c_tc-paskh,0).^c_good).*...
%     (hsize.^c_hsize).*(lsize.^c_lsize).*(amen.^c_amen));

% expected utility from insurance
wtp_ins=c_pstrm.*(c_income-c_tc-c_tax-c_dmg-c_iprate+icov*c_dmg).*...
    (c_hsize+c_lsize+c_amen)+c_npstrm.*(c_income-c_tc-c_tax-c_iprate).*...
    (c_hsize+c_lsize+c_amen);
eu_ins=c_pstrm.*((max(c_income-c_tc-paskh-c_tax-c_dmg-c_iprate+icov*c_dmg,0).^c_good).*...
    (hsize.^c_hsize).*(lsize.^c_lsize).*(amen.^c_amen))+...
    c_npstrm.*((max(c_income-c_tc-c_tax-paskh-c_iprate,0).^c_good).*...
    (hsize.^c_hsize).*(lsize.^c_lsize).*(amen.^c_amen));

wtp_pick=zeros(1,length(wtp_ins));
eu_pick=zeros(1,length(wtp_ins));
if eumdl == 1
    % random choice null model
    eu_base=eu_ins;
    wtp_base=wtp_ins;
    eu_set=[eu_base eu_ins];
    eucheck=round(1+(2-1)*rand(length(eu_base(:,1)),1));
    Upick=eu_set(eucheck);
    wtpstack=[wtp_base wtp_ins];
    for iw=1:length(wtpstack(:,1))
        wtp_pick(iw)=wtpstack(iw,eucheck(iw));
    end
%     % maximization, no insurance option
%     Upick=eu_base;
%     wtp_pick=wtp_base;
%     eucheck=ones(1,length(eu_base));
    
elseif eumdl == 2
    % maximization, insurance option
    eu_base=zeros(size(eu_ins));
    wtp_base=zeros(size(wtp_ins));
    [Upick,eucheck]=max([eu_base eu_ins],[],2);
    wtpstack=[wtp_base wtp_ins];
    for iw=1:length(wtpstack(:,1))
        wtp_pick(iw)=wtpstack(iw,eucheck(iw));
    end
% elseif eumdl == 3
%     %     % salience theory, value-based
%     %     refpt=0;    %no storm, no mitigation
%     %     value_nstrm=abs(c_iprate-refpt)./(abs(c_iprate)+abs(refpt)+1);
%     %     value_strm=abs(c_dmg-(c_dmg-icov*c_dmg))./(abs(c_dmg-icov*c_dmg)+abs(c_dmg)+1);
%     %     ptnlval=sort([value_nstrm value_strm],2,'descend');
%     %     [insrow,ivalnstrm]=find(ismember(ptnlval,value_nstrm)==1);
%     %     [isrow,ivalstrm]=find(ismember(ptnlval,value_strm)==1);
%     %     dwght_nstrm=(ltcoeff.^ivalnstrm)./((ltcoeff.^ivalnstrm)*c_npstrm+...
%     %       (ltcoeff.^ivalstrm)*c_pstrm);
%     %     dwght_strm=(ltcoeff.^ivalstrm)./((ltcoeff.^ivalnstrm)*c_npstrm+...
%     %       (ltcoeff.^ivalstrm)*c_pstrm);
%     %     salwght_nstrm=c_npstrm*dwght_nstrm;
%     %     salwght_strm=c_pstrm*dwght_strm;
%     %     value_ins=salwght_nstrm*(refpt-c_iprate)+salwght_strm*(refpt-c_iprate-(c_dmg-icov*c_dmg));
%     %     value_base=salwght_nstrm*refpt+salwght_strm*(refpt-c_dmg);
%     
%     % salience theory, utility-based
%     refpt=(max(c_income-c_tc-paskh,0).^c_good).*...
%         (hsize.^c_hsize).*(lsize.^c_lsize).*(amen.^c_amen); %no storm, no mitigation
%     nstrm_mit=(max(c_income-c_tc-paskh-c_iprate,0).^c_good).*...
%         (hsize.^c_hsize).*(lsize.^c_lsize).*(amen.^c_amen); %no storm, with mitigation
%     strm_mit=(max(c_income-c_tc-paskh-c_dmg-c_iprate+icov*c_dmg,0).^c_good).*...
%         (hsize.^c_hsize).*(lsize.^c_lsize).*(amen.^c_amen); %storm, with mitigation
%     strm_nomit=(max(c_income-c_tc-paskh-c_dmg,0).^c_good).*...
%         (hsize.^c_hsize).*(lsize.^c_lsize).*(amen.^c_amen); %storm, no mitigation
%     value_nstrm=abs(nstrm_mit-refpt)./(abs(nstrm_mit)+abs(refpt)+1);
%     value_strm=abs(strm_mit-strm_nomit)./(abs(strm_nomit)+abs(strm_mit)+1);
%     [ptnlval,ipntlval]=sort([value_nstrm value_strm],2,'descend');
%     ivalnstrm=ipntlval(:,1);
%     ivalstrm=ipntlval(:,2);
%     dwght_nstrm=(lccf.^ivalnstrm)./((lccf.^ivalnstrm)*c_npstrm+...
%         (lccf.^ivalstrm)*c_pstrm);
%     dwght_strm=(lccf.^ivalstrm)./((lccf.^ivalnstrm)*c_npstrm+...
%         (lccf.^ivalstrm)*c_pstrm);
%     salwght_nstrm=c_npstrm*dwght_nstrm;
%     salwght_strm=c_pstrm*dwght_strm;
%     
%     value_ins=salwght_nstrm.*nstrm_mit+salwght_strm.*strm_mit;
%     value_base=salwght_nstrm.*refpt+salwght_strm.*strm_nomit;
%     
%     [Vpick,eucheck]=max([value_base zeros(length(value_base),1)],[],2);
%     wtpstack=[wtp_base zeros(length(wtp_ins),1)];
%     ustack=[eu_base zeros(length(eu_ins),1)];
%     for iw=1:length(wtpstack(:,1))
%         wtp_pick(iw)=wtpstack(iw,eucheck(iw));
%         eu_pick(iw)=ustack(iw,eucheck(iw));
%     end
%     Upick=eu_pick;
elseif eumdl == 3
    % salience theory, insurance option
    refpt=(max(c_income-c_tc-c_tax-paskh,0).^c_good).*...
        (hsize.^c_hsize).*(lsize.^c_lsize).*(amen.^c_amen); %no storm, no mitigation
    nstrm_mit=(max(c_income-c_tc-c_tax--paskh-c_iprate,0).^c_good).*...
        (hsize.^c_hsize).*(lsize.^c_lsize).*(amen.^c_amen); %no storm, with mitigation
    strm_mit=(max(c_income-c_tc-c_tax-paskh-c_dmg-c_iprate+icov*c_dmg,0).^c_good).*...
        (hsize.^c_hsize).*(lsize.^c_lsize).*(amen.^c_amen); %storm, with mitigation
    strm_nomit=(max(c_income-c_tc-c_tax-paskh-c_dmg,0).^c_good).*...
        (hsize.^c_hsize).*(lsize.^c_lsize).*(amen.^c_amen); %storm, no mitigation
    value_nstrm=abs(nstrm_mit-refpt)./(abs(nstrm_mit)+abs(refpt)+1);
    value_strm=abs(strm_mit-strm_nomit)./(abs(strm_nomit)+abs(strm_mit)+1);
    [~,ipntlval]=sort([value_nstrm value_strm],2,'descend');
    ivalnstrm=ipntlval(:,1);
    ivalstrm=ipntlval(:,2);
    dwght_nstrm=(lccf.^ivalnstrm)./((lccf.^ivalnstrm)*c_npstrm+...
        (lccf.^ivalstrm)*c_pstrm);
    dwght_strm=(lccf.^ivalstrm)./((lccf.^ivalnstrm)*c_npstrm+...
        (lccf.^ivalstrm)*c_pstrm);
    salwght_nstrm=c_npstrm*dwght_nstrm;
    salwght_strm=c_pstrm*dwght_strm;
    
    value_ins=salwght_nstrm.*nstrm_mit+salwght_strm.*strm_mit;
    value_base=salwght_nstrm.*refpt+salwght_strm.*strm_nomit;
    
    [~,eucheck]=max([value_base value_ins],[],2);
    wtp_base=zeros(size(wtp_ins));
    eu_base=zeros(size(eu_ins));
    wtpstack=[wtp_base wtp_ins];
    ustack=[eu_base eu_ins];
    for iw=1:length(wtpstack(:,1))
        wtp_pick(iw)=wtpstack(iw,eucheck(iw));
        eu_pick(iw)=ustack(iw,eucheck(iw));
    end
    Upick=eu_pick;
end
end

