function [Upick,eucheck,wtp_pick,eu_base,eu_ins,wtp_base,wtp_ins,mvcheck]=...
    calc_react(eumdl,lccf,c_income,c_tc,c_dmg,c_iprate,c_good,c_hsize,...
    c_lsize,c_amen,hsize,lsize,amen,c_pstrm,c_npstrm,paskh,icov,discount,...
    c_mov,vacpaskh,vachsize,vaclsize,vacamen,vactc,vacdmg,altpaskh,...
    alt_coastprox,stormflag,ddct,tax,vactax,alttax)

% expected utility with no action
wtp_base=c_pstrm.*(c_income-c_tc-tax-c_dmg).*(c_hsize+c_lsize+c_amen)+...
    c_npstrm.*(c_income-c_tc-tax).*(c_hsize+c_lsize+c_amen);
eu_base=c_pstrm.*((max(c_income-c_tc-paskh-tax-c_dmg,0).^c_good).*...
    (hsize.^c_hsize).*(lsize.^c_lsize).*(amen.^c_amen))+...
    c_npstrm.*((max(c_income-c_tc-paskh-tax,0).^c_good).*...
    (hsize.^c_hsize).*(lsize.^c_lsize).*(amen.^c_amen));

% expected utility from insurance
wtp_ins=c_pstrm.*(c_income-c_tc-tax-c_dmg-c_iprate-ddct+min(icov,min(c_dmg,paskh))).*...
    (c_hsize+c_lsize+c_amen)+c_npstrm.*(c_income-c_tc-tax-c_iprate).*...
    (c_hsize+c_lsize+c_amen);
eu_ins=c_pstrm.*((max(c_income-c_tc-paskh-tax-c_dmg-c_iprate-ddct+min(icov,min(c_dmg,paskh)),0).^c_good).*...
    (hsize.^c_hsize).*(lsize.^c_lsize).*(amen.^c_amen))+...
    c_npstrm.*((max(c_income-c_tc-paskh-tax-c_iprate,0).^c_good).*...
    (hsize.^c_hsize).*(lsize.^c_lsize).*(amen.^c_amen));

% expected utility from moving
if stormflag == 1
    if isempty(find(vacpaskh,1)) == 1
        wtp_mov=0;
        eu_mov=0;
    else
        % specify subset of vacant houses based on similar asking prices
        paskprct=prctile(vacpaskh,0:20:100);
        isubset=find(paskprct >= paskh,1,'first');
        if isubset == 1
%             ivacset=(vacpaskh <= paskprct(isubset));
            ivacset=[];
        elseif isempty(find(isubset,1)) == 1
            ivacset=(vacpaskh == max(vacpaskh));
        else
            ivacset=(vacpaskh >= paskprct(isubset-1) & vacpaskh <= paskprct(isubset));
        end
        if isempty(find(vacpaskh(ivacset),1))==1
            wtp_mov=0;
            eu_mov=0;
        else
            wtp_mov=c_pstrm.*(c_income-vactc(ivacset)-vactax(ivacset)-discount*c_mov-vacdmg((ivacset))).*(c_hsize+c_lsize+c_amen)+...
                c_npstrm.*(c_income-vactc(ivacset)-vactax(ivacset)-discount*c_mov-vacdmg(ivacset)).*(c_hsize+c_lsize+c_amen);
            eu_mov=c_pstrm.*(max(c_income-vactc(ivacset)-vacpaskh(ivacset)-vactax(ivacset)-discount*c_mov-vacdmg(ivacset),0).^c_good).*...
                (vachsize(ivacset).^c_hsize).*(vaclsize(ivacset).^c_lsize).*(vacamen(ivacset).^c_amen)+...
                c_npstrm.*(max(c_income-vactc(ivacset)-vacpaskh(ivacset)-vactax(ivacset)-discount*c_mov,0).^c_good).*...
                (vachsize(ivacset).^c_hsize).*(vaclsize(ivacset).^c_lsize).*(vacamen(ivacset).^c_amen);
        end
    end
else
    wtp_mov=0;
    eu_mov=0;
end

% expected utility from leaving region
% alt_mov=(max(c_income-c_tc-altpaskh-discount*c_mov,0).^c_good).*...
%     (hsize.^c_hsize).*(lsize.^c_lsize).*((0.1*amen).^c_amen);
alt_mov=(max(c_income-c_tc-altpaskh-alttax-discount*c_mov,0).^c_good).*...
    (hsize.^c_hsize).*(lsize.^c_lsize).*((alt_coastprox).^c_amen);


wtp_pick=zeros(1,length(wtp_base));
if eumdl == 1
    % random insurance, relocation choice, null model
    rndfac=min(max(round(4*rand(1)+0.5),1),4);
    if rndfac == 1
        eu_mov=0;
        alt_mov=0;
        eu_ins=0;
    elseif rndfac == 2
        eu_base=0;
        eu_mov=0;
        alt_mov=0;
    elseif rndfac == 3
        eu_base=0;
        alt_mov=0;
        eu_ins=0;
    elseif rndfac == 4
        eu_base=0;
        eu_mov=0;
        eu_ins=0;
    
    end
    [Upick,eucheck]=max([eu_base; eu_ins; mean(eu_mov); alt_mov],[],1);
    if eucheck == 1
        wtp_pick=wtp_base;
        mvcheck=0;
    elseif eucheck == 2
        wtp_pick=wtp_ins;
        mvcheck=0;
    elseif eucheck == 3
        wtp_pick=max(wtp_mov);
        mvcheck=1;
    elseif eucheck == 4
        mvcheck=2;
    end
%     % maximization, move option, no insurance option
%     [Upick,eucheck]=max([eu_base; mean(eu_mov); alt_mov],[],1);
%     if eucheck == 1
%         wtp_pick=wtp_base;
%         mvcheck=0;
%     elseif eucheck == 2
%         wtp_pick=max(wtp_mov);
%         mvcheck=1;
%     elseif eucheck == 3
%         mvcheck=2;
%     end
elseif eumdl == 2
    % maximization, move option, insurance option
    [Upick,eucheck]=max([eu_base; eu_ins; mean(eu_mov); alt_mov],[],1);
    if eucheck == 1
        wtp_pick=wtp_base;
        mvcheck=0;
    elseif eucheck == 2
        wtp_pick=wtp_ins;
        mvcheck=0;
    elseif eucheck == 3
        wtp_pick=max(wtp_mov);
        mvcheck=1;
    elseif eucheck == 4
        mvcheck=2;
    end
% elseif eumdl == 3
%     % salience theory, utility-based, move option
%     refpt=(max(c_income-c_tc-paskh,0).^c_good).*...
%         (hsize.^c_hsize).*(lsize.^c_lsize).*(amen.^c_amen); %no storm, no mitigation
%     strm_nomit=(max(c_income-c_tc-paskh-c_dmg,0).^c_good).*...
%         (hsize.^c_hsize).*(lsize.^c_lsize).*(amen.^c_amen); %storm, no mitigation
%     if isempty(find(vacpaskh,1)) == 1
%         nstrm_mov=0;
%         strm_mov=0;
%     else
%         nstrm_mov=mean((max(c_income-vactc-vacpaskh-discount*c_mov,0).^c_good).*...
%             (vachsize.^c_hsize).*(vaclsize.^c_lsize).*(vacamen.^c_amen)); %no storm, with move cost
%         strm_mov=mean((max(c_income-vactc-vacpaskh-discount*c_mov,0).^c_good).*...
%             (vachsize.^c_hsize).*(vaclsize.^c_lsize).*(vacamen.^c_amen)); %storm, same as no storm
%     end
% %     value_nstrm=abs(nstrm_mov-refpt)./(abs(nstrm_mov)+abs(refpt)+1);
% %     value_strm=abs(strm_mov-strm_nomit)./(abs(strm_nomit)+abs(strm_mov)+1);
%     value_strm=abs((strm_mov+alt_mov)/2-strm_nomit)./...
%         (abs(strm_nomit)+abs((strm_mov+alt_mov)/2)+1);
%     value_nstrm=abs((nstrm_mov+alt_mov)/2-refpt)./...
%         (abs((nstrm_mov+alt_mov)/2)+abs(refpt)+1);
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
%     value_mov=salwght_nstrm.*nstrm_mov+salwght_strm.*strm_mov;
%     value_base=salwght_nstrm.*refpt+salwght_strm.*strm_nomit;
%     value_lv=salwght_nstrm.*alt_mov+salwght_strm.*alt_mov;
%     if stormflag == 1
%         [Vpick,eucheck]=max([value_base; value_mov; value_lv],[],1);
%         if eucheck == 1
%             wtp_pick=wtp_base;
%             mvcheck=0;
%         elseif eucheck == 2
%             wtp_pick=mean(wtp_mov);
%             mvcheck=1;
%         elseif eucheck == 3
%             mvcheck=2;
%         end
%         ustack=[eu_base; mean(eu_mov); alt_mov];
%         Upick=ustack(eucheck);
%     else
%         [Vpick,eucheck]=max([value_base; 0; 0],[],1);
%         if eucheck == 1
%             wtp_pick=wtp_base;
%             mvcheck=0;
%         elseif eucheck == 2
%             wtp_pick=mean(wtp_mov);
%             mvcheck=1;
%         elseif eucheck == 3
%             mvcheck=2;
%         end
%         ustack=[eu_base; 0; 0];
%         Upick=ustack(eucheck);
%     end
elseif eumdl == 3
%     % salience theory, value-based
%     refpt=0;    %no storm, no mitigation
%     value_nstrm=abs(c_iprate-refpt)./(abs(c_iprate)+abs(refpt)+1);
%     value_strm=abs(c_dmg-(c_dmg-icov*c_dmg))./(abs(c_dmg-icov*c_dmg)+abs(c_dmg)+1);
%     ptnlval=sort([value_nstrm value_strm],2,'descend');
%     [insrow,ivalnstrm]=find(ismember(ptnlval,value_nstrm)==1);
%     [isrow,ivalstrm]=find(ismember(ptnlval,value_strm)==1);
%     dwght_nstrm=(ltcoeff.^ivalnstrm)./((ltcoeff.^ivalnstrm)*c_npstrm+...
%       (ltcoeff.^ivalstrm)*c_pstrm);
%     dwght_strm=(ltcoeff.^ivalstrm)./((ltcoeff.^ivalnstrm)*c_npstrm+...
%       (ltcoeff.^ivalstrm)*c_pstrm);
%     salwght_nstrm=c_npstrm*dwght_nstrm;
%     salwght_strm=c_pstrm*dwght_strm;
%     value_ins=salwght_nstrm*(refpt-c_iprate)+salwght_strm*(refpt-c_iprate-(c_dmg-icov*c_dmg));
%     value_base=salwght_nstrm*refpt+salwght_strm*(refpt-c_dmg);
    
    % salience theory, utility-based
    refpt=(max(c_income-c_tc-paskh-tax,0).^c_good).*...
        (hsize.^c_hsize).*(lsize.^c_lsize).*(amen.^c_amen); %no storm, no mitigation
    nstrm_mit=(max(c_income-c_tc-paskh-tax-c_iprate,0).^c_good).*...
        (hsize.^c_hsize).*(lsize.^c_lsize).*(amen.^c_amen); %no storm, with mitigation
    strm_mit=(max(c_income-c_tc-paskh-tax-c_dmg-c_iprate-ddct+min(icov,min(c_dmg,paskh)),0).^c_good).*...
        (hsize.^c_hsize).*(lsize.^c_lsize).*(amen.^c_amen); %storm, with mitigation
    strm_nomit=(max(c_income-c_tc-paskh-tax-c_dmg,0).^c_good).*...
        (hsize.^c_hsize).*(lsize.^c_lsize).*(amen.^c_amen); %storm, no mitigation
    if stormflag ==1
        if isempty(find(vacpaskh,1)) == 1
            nstrm_mov=0;
            strm_mov=0;
            strmdenom=2;
        else
            nstrm_mov=mean((max(c_income-vactc-vacpaskh-vacpaskh.*vactax-discount*c_mov,0).^c_good).*...
                (vachsize.^c_hsize).*(vaclsize.^c_lsize).*(vacamen.^c_amen)); %no storm, with move cost
            strm_mov=mean((max(c_income-vactc-vacpaskh-vacpaskh.*vactax-vacdmg-discount*c_mov,0).^c_good).*...
                (vachsize.^c_hsize).*(vaclsize.^c_lsize).*(vacamen.^c_amen)); %storm, same as no storm
            strmdenom=3;
        end
    else
        nstrm_mov=0;
        strm_mov=0;
        strmdenom=2;
    end
    value_strm=abs((strm_mit+strm_mov+alt_mov)/strmdenom-strm_nomit)./...
        (abs(strm_nomit)+abs((strm_mit+strm_mov+alt_mov)/strmdenom)+1);
    value_nstrm=abs((nstrm_mit+nstrm_mov+alt_mov)/strmdenom-refpt)./...
        (abs((nstrm_mit+nstrm_mov+alt_mov)/strmdenom)+abs(refpt)+1);
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
    value_mov=salwght_nstrm.*nstrm_mov+salwght_strm.*strm_mov;
    value_lv=salwght_nstrm.*alt_mov+salwght_strm.*alt_mov;
%     if stormflag == 1
        [~,eucheck]=max([value_base; value_ins; value_mov; value_lv],[],1);
        if eucheck == 1
            wtp_pick=wtp_base;
            eu_base=value_base;
            mvcheck=0;
        elseif eucheck == 2
            wtp_pick=wtp_ins;
            eu_ins=value_ins;
            mvcheck=0;
        elseif eucheck == 3
            wtp_pick=max(wtp_mov);
            eu_mov=max(value_mov);
            mvcheck=1;
        elseif eucheck == 4
            alt_mov=value_lv;
            mvcheck=2;
        end
        ustack=[eu_base; eu_ins; mean(eu_mov); alt_mov];
        Upick=ustack(eucheck);
%     else
%         [Vpick,eucheck]=max([value_base; 0; 0; value_ins],[],1);
%         if eucheck == 1
%             wtp_pick=wtp_base;
%             mvcheck=0;
%         elseif eucheck == 2
%             wtp_pick=max(wtp_mov);
%             mvcheck=1;
%         elseif eucheck == 3
%             mvcheck=2;
%         elseif eucheck == 4
%             wtp_pick=wtp_ins;
%             mvcheck=0;
%         end
%         ustack=[eu_base; 0; 0; eu_ins];
%         Upick=ustack(eucheck);
%     end
end

