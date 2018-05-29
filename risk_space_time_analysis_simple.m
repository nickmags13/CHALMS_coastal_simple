cd C:\Users\nrmagliocca\'Box Sync'\'Data Drive'\model_results\CHALMS_event_ilandscape_011718_popgrow
load results_event_ilandscape_011718_popgrow.mat

ERUNS=5;
nruns=30;
TSTART=10;
TMAX=30;
HT=1;
cell2mile=0.0395;   %cell side equals 0.0395 mi
cell2ft=cell2mile*5280;
NCELLS=6400;
NWIDTH=80;
NLENGTH=80;
CDIST=repmat((NWIDTH+1)-(1:NWIDTH),NLENGTH,1);
housedam=10.23749-0.23462*(CDIST*cell2ft/1000)+...
    0.001649*(CDIST*cell2ft/1000).^2;
runset=mat2cell(reshape(1:nruns*ERUNS,nruns,ERUNS)',ones(ERUNS,1),nruns);
start_t=-5;
end_t=5;
realt=TSTART:TMAX;
tspan=start_t:end_t;
% N=3;    % set to scenario number
% runnamelabel={'Mid-Atl','NC','FL'};
% runnamelabel={'null','eu max','salience'};
% runnamelabel={'eu max','salience'};
% runnamelabel={'eu_max_MA','salience_MA','eu_max_NC','salience_NC',...
%     'eu_max_TX','salience_TX','eu_max_FL','salience_FL'};
runnamelabel={'popgrow0','popgrow025','popgrow05','popgrow075','popgrow10'};

strmset_save=cell(1,ERUNS);
runtimes_save=struct('rt',{});
strmruns_save=cell(1,ERUNS);
strmt_save=cell(1,ERUNS);
strmoccr_save=cell(1,ERUNS);
dlotscell=cell(1,ERUNS);
dlotscicell=cell(1,ERUNS);
% subjrisk_data=cell(ERUNS,3);
% for ii=1:ERUNS
%     for t=TSTART:TMAX
%         srmap=cat(2,mapdata_store.subjriskmap{t,1+nruns*(ii-1):nruns*ii});
% %         for g=1:NCELLS
% %             idata=find(srmap(g,:)~=0);
%             idata=find(srmap~=0);
%             if isempty(find(idata,1))==0
%             subjrisk_data(ii,1)=mat2cell([subjrisk_data{ii,1}; srmap(idata)],...
%                 length(subjrisk_data{ii,1})+length(idata),1);
% %             [nsdist,coastd]=ind2sub([80 80],g);
%             [irow,icol]=ind2sub(size(srmap),idata);
%             [nsdist,coastd]=ind2sub([80 80],irow);
%             subjrisk_data(ii,2)=mat2cell([subjrisk_data{ii,2}; (81-coastd)],...
%                 length(subjrisk_data{ii,2})+length(idata),1);
%             subjrisk_data(ii,3)=mat2cell([subjrisk_data{ii,3}; t*ones(length(idata),1)],...
%                 length(subjrisk_data{ii,3})+length(idata),1);
%             end
% %         end
%     end
% end

% scatter(subjrisk_data{1,2}+min(max(randn(length(subjrisk_data{1,2}),1),1),-1),...
%     subjrisk_data{1,3}+min(max(randn(length(subjrisk_data{1,2}),1),1),-1),...
%     1,subjrisk_data{1,1})
endrents=zeros(1,ERUNS);
endrents_ci=zeros(2,ERUNS);
endrents_s=zeros(1,ERUNS);
endlvalue=zeros(1,ERUNS);
endlvalue_ci=zeros(2,ERUNS);
endlvalue_s=zeros(1,ERUNS);

% Saving variables
vacrate_avg_save=zeros(ERUNS,length(tspan));
vacrate_ci_save=zeros(2,length(tspan),ERUNS);
vacrate_s_save=zeros(ERUNS,length(tspan));
dlots_avg_save=zeros(ERUNS,length(tspan));
dlots_ci_save=zeros(2,length(tspan),ERUNS);
dlots_s_save=zeros(ERUNS,length(tspan));
rlcon_avg_save=zeros(ERUNS,length(tspan));
rlcon_ci_save=zeros(2,length(tspan),ERUNS);
rlcon_s_save=zeros(ERUNS,length(tspan));
lvalue_avg_save=zeros(ERUNS,length(tspan));
lvalue_ci_save=zeros(2,length(tspan),ERUNS);
lvalue_s_save=zeros(ERUNS,length(tspan));
lvaluec_avg_save=zeros(ERUNS,length(tspan));
lvaluec_ci_save=zeros(2,length(tspan),ERUNS);
lvaluec_s_save=zeros(ERUNS,length(tspan));
lvaluerl_avg_save=zeros(ERUNS,length(tspan));
lvaluerl_ci_save=zeros(2,length(tspan),ERUNS);
lvaluerl_s_save=zeros(ERUNS,length(tspan));
meanrent_avg_save=zeros(ERUNS,length(tspan));
meanrent_ci_save=zeros(2,length(tspan),ERUNS);
meanrent_s_save=zeros(ERUNS,length(tspan));
meanrentc_avg_save=zeros(ERUNS,length(tspan));
meanrentc_ci_save=zeros(2,length(tspan),ERUNS);
meanrentc_s_save=zeros(ERUNS,length(tspan));
meanrentrl_avg_save=zeros(ERUNS,length(tspan));
meanrentrl_ci_save=zeros(2,length(tspan),ERUNS);
meanrentrl_s_save=zeros(ERUNS,length(tspan));
hmc_avg_save=zeros(ERUNS,length(tspan));
hmc_ci_save=zeros(2,length(tspan),ERUNS);
hmc_s_save=zeros(ERUNS,length(tspan));

paired_id_rl_save=cell(ERUNS,1);
paired_id_nc_save=cell(ERUNS,1);
paired_rent_rl_save=cell(ERUNS,1);
paired_rent_nc_save=cell(ERUNS,1);
paired_dmg_rl_save=cell(ERUNS,1);
paired_dmg_nc_save=cell(ERUNS,1);
paired_grp_rl_save=cell(ERUNS,1);
paired_grp_nc_save=cell(ERUNS,1);
paired_inc_rl_save=cell(ERUNS,1);
paired_inc_nc_save=cell(ERUNS,1);
paired_incgrp_rl_save=cell(ERUNS,1);
paired_incgrp_nc_save=cell(ERUNS,1);
id_rl_save=cell(ERUNS,1);
id_nc_save=cell(ERUNS,1);
rent_rl_save=cell(ERUNS,1);
rent_nc_save=cell(ERUNS,1);
dmg_rl_save=cell(ERUNS,1);
dmg_nc_save=cell(ERUNS,1);
grp_rl_save=cell(ERUNS,1);
grp_nc_save=cell(ERUNS,1);
inc_rl_save=cell(ERUNS,1);
inc_nc_save=cell(ERUNS,1);
incgrp_rl_save=cell(ERUNS,1);
incgrp_nc_save=cell(ERUNS,1);

for N=1:ERUNS
    %%% Find storm timing and calculate before/after stats
    strms_base=aggdata_store.storm_occur(runset{N},:);
    strm_event=cell(1,2);   %model run, time till/since
    
    for srun=1:length(strms_base(:,1))
        istrm=find(strms_base(srun,:)==1);
        if length(istrm)==1
            strm_event(1)=mat2cell([strm_event{1}; srun],length(strm_event{1})+1,1);
            strm_event(2)=mat2cell([strm_event{2}; (1:TMAX)-istrm],...
                length(strm_event{1}),TMAX);
        elseif length(istrm) > 1
            multistrm=cell(1,2);
            for s=1:length(istrm)
%                 strm_event(1)=mat2cell([strm_event{1}; srun],length(strm_event{1})+1,1);
%                 strm_event(2)=mat2cell([strm_event{2}; (1:TMAX)-istrm(s)],...
%                     length(strm_event{1}),TMAX);
                multistrm(1)=mat2cell([multistrm{1}; srun],length(multistrm{1})+1,1);
                multistrm(2)=mat2cell([multistrm{2}; (1:TMAX)-istrm(s)],...
                    length(multistrm{1}),TMAX);
            end
            substrmt=multistrm{2};
            for tt=1:TMAX
                tslice=substrmt(:,tt);
                tslice(tslice <= 0)=max(tslice(tslice <= 0));
                tslice(tslice >= 0)=min(tslice(tslice >= 0));
                substrmt(:,tt)=tslice;
            end
            subse2=strm_event{2};
            strm_event(1)=mat2cell([strm_event{1}; srun*ones(length(istrm),1)],...
                length(strm_event{1})+length(substrmt(:,1)),1);
            if isempty(find(strm_event{2},1))==1
                strm_event(2)=mat2cell([strm_event{2}; substrmt],...
                    length(strm_event{2})+length(substrmt(:,1)),TMAX);
            else
                strm_event(2)=mat2cell([strm_event{2}; substrmt],...
                    length(subse2(:,1))+length(substrmt(:,1)),TMAX);
            end
        end
    end
     %%% Assemble storm event data
    strm_times=strm_event{2};
    strm_runs=strm_event{1};
    strm_t=strm_times(:,TSTART:TMAX);
    % start_t=min(min(strm_t));
    % end_t=max(max(strm_t));
    
    %%% Data for time analysis
    vacrate_base=aggdata_store.vacany_rates(runset{N},:);
    lsales_base=land_sales.landsales_all(:,N);
    lsales_coast_base=reshape(land_sales.landsales_coast(:,N,:),8,7);
    avgrents_base=htdata_store.avg_rents(runset{N});
    hprices_base=mapdata_store.house_prices(:,runset{N});
    hprices_coast=hprices_base(5601:NCELLS,:);
    
    reloccon_base=relocdata_store.reloc_conid(runset{N},:);
    reloclots_full=relocdata_store.reloc_lots(runset{N},:);
    reloclots=cell(nruns,1);
    reloclots_id=cell(nruns,1);
    leavecon_base=relocdata_store.lv_conid(runset{N},:);
    leavelots_full=relocdata_store.lv_lotid(runset{N},:);
    leavelots=cell(nruns,1);
    leavelots_id=cell(nruns,1);
    lvaluerl_run=cell(nruns,length(tspan));
    mrentrl_run=cell(nruns,length(tspan));
     
    nlots=htdata_store.num_lots(runset{N});
    totlots=zeros(nruns,TMAX);
    difflots=zeros(nruns,TMAX);
    hmc=aggdata_store.hmcp(runset{N},:);
    
    reloccon=zeros(nruns,TMAX);
    leavecon=zeros(nruns,TMAX);
    lvalue_base=zeros(NCELLS,TMAX,nruns);
    lvalue_basec=zeros(length(5601:NCELLS),TMAX,nruns);
    meanrent_base=zeros(NCELLS,TMAX,nruns);
    meanrent_basec=zeros(length(5601:NCELLS),TMAX,nruns);
    
    phousediff=cell(nruns,TMAX);
    
    lotpairs_id_nc=cell(HT,TMAX,nruns);
    lotpairs_id_rl=cell(HT,TMAX,nruns);
    lotpairs_id_lv=cell(HT,TMAX,nruns);
    lotpairs_rent_nc=cell(HT,TMAX,nruns);
    lotpairs_rent_rl=cell(HT,TMAX,nruns);
    lotpairs_rent_lv=cell(HT,TMAX,nruns);
    lotpairs_dmg_nc=cell(HT,TMAX,nruns);
    lotpairs_dmg_rl=cell(HT,TMAX,nruns);
    lotpairs_dmg_lv=cell(HT,TMAX,nruns);
    lotpairs_grp_rl=cell(HT,TMAX,nruns);
    lotpairs_grp_lv=cell(HT,TMAX,nruns);
    lotpairs_grp_nc=cell(HT,TMAX,nruns);
    lotpairs_inc_rl=cell(HT,TMAX,nruns);
    lotpairs_inc_lv=cell(HT,TMAX,nruns);
    lotpairs_inc_nc=cell(HT,TMAX,nruns);
    lotpairs_incgrp_rl=cell(HT,TMAX,nruns);
    lotpairs_incgrp_lv=cell(HT,TMAX,nruns);
    lotpairs_incgrp_nc=cell(HT,TMAX,nruns);
    inruns=runset{N};
    for n=1:nruns
        isample=find(mapdata_store.avgrentmap{TMAX,inruns(n)}~=0);
        dmgrange=housedam(isample);
        dmgdist=CDIST(isample);
        dmgqnt=quantile(dmgrange,[0.33 0.66]);
        idmggroup_hi=find(dmgrange > dmgqnt(2));
        idmggroup_md=find(dmgrange > dmgqnt(1) & dmgrange <= dmgqnt(2));
        idmggroup_lw=find(dmgrange <= dmgqnt(1));
       
        INCOME=lotdata_store.Lotincome{inruns(n)};
        LOTRENT=lotdata_store.lotrent{inruns(n)};
        LOTCON=lotdata_store.lotcon{inruns(n)};
        LOTTYPE=cat(2,mapdata_store.lot_types{:,inruns(n)});
        lotlocate=lotdata_store.Lotlocate{inruns(n)};
        for it=1:TMAX
            lvalue_base(:,it,n)=mapdata_store.landvaluemap{it,inruns(n)};
            lvalue_basec(:,it,n)=lvalue_base(5601:NCELLS,it,n);
            meanrent_base(:,it,n)=mapdata_store.avgrentmap{it,inruns(n)};
            meanrent_basec(:,it,n)=meanrent_base(5601:NCELLS,it,n);
            reloccon(n,it)=length(cat(1,reloccon_base{n,it}));
            leavecon(n,it)=length(cat(1,leavecon_base{n,it}));
            
            ltrent=LOTRENT{it};
            ltcon=LOTCON{it};
            lotlist=1:length(LOTRENT{it});
            ilotlist=find(LOTTYPE(:,it)~=0);
            %             if isempty(find(cat(1,reloclots_full{n,:}),1))==0
            %                 reloclots(n)=mat2cell(cat(1,reloclots_full{n,:}),...
            %                     length(cat(1,reloclots_full{n,:})),1);
            %                 reloclots_id(n)=mat2cell(unique(cat(1,reloclots{n})),...
            %                     length(unique(cat(1,reloclots{n}))),1);
            rllots=reloclots_full{n,it};
            lvlots=leavelots_full{n,it};
            nclots=lotlist(~ismember(lotlist,rllots))';
            irllots=lotlocate(ismember(lotlocate(:,1),rllots),2);
            inclots=lotlocate(ismember(lotlocate(:,1),nclots),2);
            ilvlots=lotlocate(ismember(lotlocate(:,1),lvlots),2);
            
            %find lots of comparable type that are affected/not affected (by
            %relocations)
            rlltype=LOTTYPE(irllots,it);
            lvltype=LOTTYPE(ilvlots,it);
            ncltype=LOTTYPE(inclots,it);
            rllot_bridge=lotlocate(ismember(lotlocate(:,1),rllots),1);
            nclot_bridge=lotlocate(ismember(lotlocate(:,1),nclots),1);
            lvlot_bridge=lotlocate(ismember(lotlocate(:,1),lvlots),1);
            
            lotind=zeros(length(lotlist),1);
            for i=1:length(lotlist)
                lotind(i)=lotlocate(find(lotlocate(:,1)==lotlist(i),1,'first'),2);
            end
            
            for ht=1:HT
                ilot_rl=unique(rllot_bridge(rlltype == ht));
                ilot_lv=unique(lvlot_bridge(lvltype == ht));
                lotpairs_id_rl(ht,it,n)=mat2cell(ilot_rl,length(ilot_rl),1);
                lotpairs_id_lv(ht,it,n)=mat2cell(ilot_lv,length(ilot_lv),1);
                ilot_nc=unique(nclot_bridge(ncltype == ht));
                lotpairs_id_nc(ht,it,n)=mat2cell(ilot_nc,length(ilot_nc),1);
                
                lotpairs_rent_rl(ht,it,n)=mat2cell(ltrent(ilot_rl),length(ilot_rl),1);
                lotpairs_rent_nc(ht,it,n)=mat2cell(ltrent(ilot_nc),length(ilot_nc),1);
                lotpairs_rent_lv(ht,it,n)=mat2cell(ltrent(ilot_lv),length(ilot_lv),1);
                
                lotpairs_dmg_rl(ht,it,n)=mat2cell(housedam(lotind(ilot_rl)),length(ilot_rl),1);
                lotpairs_dmg_nc(ht,it,n)=mat2cell(housedam(lotind(ilot_nc)),length(ilot_nc),1);
                lotpairs_dmg_lv(ht,it,n)=mat2cell(housedam(lotind(ilot_lv)),length(ilot_lv),1);
                
                iocc_rl=(ltcon(ilot_rl)~=0);
                lotpairs_incgrp_rl(ht,it,n)=mat2cell(iocc_rl,length(iocc_rl),1);
                if isempty(find(iocc_rl,1))==0
                    lotpairs_inc_rl(ht,it,n)=mat2cell(INCOME(ltcon(ilot_rl(iocc_rl))),...
                        length(ilot_rl(iocc_rl)),1);
                end
                iocc_nc=(ltcon(ilot_nc)~=0);
                lotpairs_incgrp_nc(ht,it,n)=mat2cell(iocc_nc,length(iocc_nc),1);
                if isempty(find(iocc_nc,1))==0
                    lotpairs_inc_nc(ht,it,n)=mat2cell(INCOME(ltcon(ilot_nc(iocc_nc))),...
                        length(ilot_nc(iocc_nc)),1);
                end
                if isempty(find(cat(1,relocdata_store.lv_coninc{inruns(n),:}),1))==0
%                     lvconinc=relocdata_store.lv_coninc(inruns(n),:);
                    lotpairs_inc_lv(ht,it,n)=relocdata_store.lv_coninc(inruns(n),it);
                    leavelots(n)=mat2cell(cat(1,leavelots_full{n,:}),...
                        length(cat(1,leavelots_full{n,:})),1);
                end
                
                rlgrp=zeros(length(ilot_rl),1);
                ncgrp=zeros(length(ilot_nc),1);
                rlgrp(ismember(lotind(ilot_rl),isample(idmggroup_hi)))=3;
                rlgrp(ismember(lotind(ilot_rl),isample(idmggroup_md)))=2;
                rlgrp(ismember(lotind(ilot_rl),isample(idmggroup_lw)))=1;
                ncgrp(ismember(lotind(ilot_nc),isample(idmggroup_hi)))=3;
                ncgrp(ismember(lotind(ilot_nc),isample(idmggroup_md)))=2;
                ncgrp(ismember(lotind(ilot_nc),isample(idmggroup_lw)))=1;
                lotpairs_grp_rl(ht,it,n)=mat2cell(rlgrp,length(ilot_rl),1);
                lotpairs_grp_nc(ht,it,n)=mat2cell(ncgrp,length(ilot_nc),1);
            end
        end
        totlots(n,:)=sum(nlots{n},1);
        difflots(n,2:TMAX)=diff(totlots(n,:));
        if isempty(find(cat(1,reloclots_full{n,:}),1))==0
            reloclots(n)=mat2cell(cat(1,reloclots_full{n,:}),length(cat(1,reloclots_full{n,:})),1);
            reloclots_id(n)=mat2cell(unique(cat(1,reloclots{n})),length(unique(cat(1,reloclots{n}))),1);
        end
    end
    submrc=reshape(meanrent_basec(:,TMAX,:),800,nruns);
    inozero=(submrc~=0);
    [mu,sig,muci,sigci]=normfit(submrc(inozero));
    endrents(N)=mu;
    endrents_s(N)=sig;
    endrents_ci(:,N)=muci;
    
    sublvc=reshape(lvalue_basec(:,TMAX,:),800,nruns);
    inozero=(sublvc>0);
    [mu,sig,muci,sigci]=normfit(log10(sublvc(inozero)));
    endlvalue(N)=mu;
    endlvalue_s(N)=sig;
    endlvalue_ci(:,N)=muci;
    
    vacrate=cell(1,length(tspan));
    lsales=cell(1,length(tspan));
    lsales_coast=cell(1,length(tspan));
    avgrents=cell(HT,length(tspan));
    lvalue=cell(1,length(tspan));
    lvaluec=cell(1,length(tspan));
    lvaluerl=cell(1,length(tspan));
    mrentrl=cell(1,length(tspan));
   
    mrent=cell(1,length(tspan));
    mrentc=cell(1,length(tspan));
    
    dlots=cell(1,length(tspan));
    rlcon=cell(1,length(tspan));
    hmcp=cell(1,length(tspan));
    
    lotsp_rent_rl=cell(HT,length(tspan));
    lotsp_rent_nc=cell(HT,length(tspan));
    lotsp_id_rl=cell(HT,length(tspan));
    lotsp_id_nc=cell(HT,length(tspan));
    lotsp_dmg_rl=cell(HT,length(tspan));
    lotsp_dmg_nc=cell(HT,length(tspan));
    lotsp_grp_rl=cell(HT,length(tspan));
    lotsp_grp_nc=cell(HT,length(tspan));
    lotsp_inc_rl=cell(HT,length(tspan));
    lotsp_inc_nc=cell(HT,length(tspan));
    lotsp_incgrp_rl=cell(HT,length(tspan));
    lotsp_incgrp_nc=cell(HT,length(tspan));
    
    runtimes=cell(1,length(unique(strm_runs)));
    strmset=unique(strm_runs);
    for jrun=1:length(strmset)
        runtimes(jrun)=mat2cell([max(strm_t(strm_runs==strmset(jrun),:),[],1); ...
            min(strm_t(strm_runs==strmset(jrun),:),[],1)],2,length(strm_t(1,:)));
    end
    %%% For comparing base runs to event runs
    strmset_save(N)=mat2cell(strmset,length(strmset),1);
    runtimes_save(N).rt=runtimes;
    strmruns_save(N)=mat2cell(strm_runs,length(strm_runs),1);
    strmt_save(N)=mat2cell(strm_t,length(strm_t(:,1)),length(strm_t(1,:)));
    strmoccr_save(N)=mat2cell(aggdata_store.storm_occur(runset{N},:),nruns,TMAX);
    
    for irun=1:length(strmset)
        sublsales=lsales_base{strmset(irun)};
        subavgrents=avgrents_base{strmset(irun)};
        sublvalue=lvalue_base(:,:,strmset(irun));
        sublvaluec=lvalue_basec(:,:,strmset(irun));
        submrent=meanrent_base(:,:,strmset(irun));
        submrentc=meanrent_basec(:,:,strmset(irun));
        sublotpairs_id_rl=lotpairs_id_rl(:,:,strmset(irun));
        sublotpairs_id_nc=lotpairs_id_nc(:,:,strmset(irun));
        sublotpairs_rent_rl=lotpairs_rent_rl(:,:,strmset(irun));
        sublotpairs_rent_nc=lotpairs_rent_nc(:,:,strmset(irun));
        sublotpairs_dmg_rl=lotpairs_dmg_rl(:,:,strmset(irun));
        sublotpairs_dmg_nc=lotpairs_dmg_nc(:,:,strmset(irun));
        sublotpairs_grp_rl=lotpairs_grp_rl(:,:,strmset(irun));
        sublotpairs_grp_nc=lotpairs_grp_nc(:,:,strmset(irun));
        sublotpairs_inc_rl=lotpairs_inc_rl(:,:,strmset(irun));
        sublotpairs_inc_nc=lotpairs_inc_nc(:,:,strmset(irun));
        sublotpairs_incgrp_rl=lotpairs_incgrp_rl(:,:,strmset(irun));
        sublotpairs_incgrp_nc=lotpairs_incgrp_nc(:,:,strmset(irun));
        for tt=1:length(tspan)
            substrm_t=runtimes{irun};
            [row,col]=find(substrm_t==tspan(tt));
            id=unique(col);
            if isempty(find(id,1))==1
                continue
            else
                vacrate(tt)=mat2cell([vacrate{tt}; vacrate_base(strmset(irun),...
                    id)'],length(vacrate{tt})+length(id),1);
                hmcp(tt)=mat2cell([hmcp{tt}; hmc(strmset(irun),...
                    realt(id))'],length(hmcp{tt})+length(id),1);
                dlots(tt)=mat2cell([dlots{tt}; difflots(strmset(irun),...
                    realt(id))'],length(dlots{tt})+length(id),1);
                rlcon(tt)=mat2cell([rlcon{tt}; reloccon(strmset(irun),...
                    realt(id))'],length(rlcon{tt})+length(id),1);
                if isempty(find(sublsales,1)) == 0
                    lsales(tt)=mat2cell([lsales{tt}; sublsales(ismember(sublsales(:,2),...
                        realt(id)),1)],length(lsales{tt})+length(sublsales(ismember(sublsales(:,2),...
                        realt(id)),1)),1);
                    icoast=find(ismember(sublsales(:,2),realt(id))==1 & sublsales(:,3)<20);
                    lsales_coast(tt)=mat2cell([lsales_coast{tt}; sublsales(...
                        icoast,1)],length(lsales_coast{tt})+length(icoast),1);
                end
                subsublvalue=sublvalue(:,realt(id));
                iposlv=find(subsublvalue > 0);
                lvalue(tt)=mat2cell([lvalue{tt}; subsublvalue(iposlv)],...
                    length(lvalue{tt})+length(iposlv),1);
%                 lvalue(tt)=mat2cell([lvalue{tt}; sublvalue(iposlv,realt(id))],...
%                     length(lvalue{tt})+length(iposlv),1);
                subsublvaluec=sublvaluec(:,realt(id));
                iposlvc=find(subsublvaluec > 0);
%                 lvaluec(tt)=mat2cell([lvaluec{tt}; sublvaluec(iposlvc,realt(id))],...
%                     length(lvaluec{tt})+length(iposlvc),1);
                lvaluec(tt)=mat2cell([lvaluec{tt}; subsublvaluec(iposlvc)],...
                    length(lvaluec{tt})+length(iposlvc),1);
                sublvaluerl=sublvalue(reloclots_id{strmset(irun)},realt(id));
                iposlvrl=find(sublvaluerl > 0);
                if isempty(find(iposlvrl,1))==0
                lvaluerl(tt)=mat2cell([lvaluerl{tt}; sublvaluerl(iposlvrl)],...
                    length(lvaluerl{tt})+length(iposlvrl),1);
                end
                subsubmrent=submrent(:,realt(id));
                iposmr=find(subsubmrent > 0);
%                 mrent(tt)=mat2cell([mrent{tt}; submrent(iposmr,realt(id))],...
%                     length(mrent{tt})+length(iposmr),1);
                mrent(tt)=mat2cell([mrent{tt}; subsubmrent(iposmr)],...
                    length(mrent{tt})+length(iposmr),1);
                subsubmrentc=submrentc(:,realt(id));
                iposmrc=find(subsubmrentc > 0);
                mrentc(tt)=mat2cell([mrentc{tt}; submrentc(iposmrc)],...
                    length(mrentc{tt})+length(iposmrc),1);
                subsubmrentrl=submrent(reloclots_id{strmset(irun)},realt(id));
                iposmrrl=find(subsubmrentrl > 0);
                if isempty(find(iposmrrl,1))==0
                mrentrl(tt)=mat2cell([mrentrl{tt}; subsubmrentrl(iposmrrl)],...
                    length(mrentrl{tt})+length(iposmrrl),1);
                end
                
                %%% paired data
                for ht=1:HT
                    lotsp_id_rl(ht,tt)=mat2cell([lotsp_id_rl{ht,tt}; ...
                        cat(1,sublotpairs_id_rl{ht,realt(id)})],...
                        length(lotsp_id_rl{ht,tt})+...
                        length(cat(1,sublotpairs_id_rl{ht,realt(id)})),1);
                    lotsp_id_nc(ht,tt)=mat2cell([lotsp_id_nc{ht,tt}; ...
                        cat(1,sublotpairs_id_nc{ht,realt(id)})],...
                        length(lotsp_id_nc{ht,tt})+...
                        length(cat(1,sublotpairs_id_nc{ht,realt(id)})),1);
                    lotsp_rent_rl(ht,tt)=mat2cell([lotsp_rent_rl{ht,tt}; ...
                        cat(1,sublotpairs_rent_rl{ht,realt(id)})],...
                        length(lotsp_rent_rl{ht,tt})+...
                        length(cat(1,sublotpairs_rent_rl{ht,realt(id)})),1);
                    lotsp_rent_nc(ht,tt)=mat2cell([lotsp_rent_nc{ht,tt}; ...
                        cat(1,sublotpairs_rent_nc{ht,realt(id)})],...
                        length(lotsp_rent_nc{ht,tt})+...
                        length(cat(1,sublotpairs_rent_nc{ht,realt(id)})),1);
                    lotsp_dmg_rl(ht,tt)=mat2cell([lotsp_dmg_rl{ht,tt}; ...
                        cat(1,sublotpairs_dmg_rl{ht,realt(id)})],...
                        length(lotsp_dmg_rl{ht,tt})+...
                        length(cat(1,sublotpairs_dmg_rl{ht,realt(id)})),1);
                    lotsp_dmg_nc(ht,tt)=mat2cell([lotsp_dmg_nc{ht,tt}; ...
                        cat(1,sublotpairs_dmg_nc{ht,realt(id)})],...
                        length(lotsp_dmg_nc{ht,tt})+...
                        length(cat(1,sublotpairs_dmg_nc{ht,realt(id)})),1);
                    lotsp_grp_rl(ht,tt)=mat2cell([lotsp_grp_rl{ht,tt}; ...
                        cat(1,sublotpairs_grp_rl{ht,realt(id)})],...
                        length(lotsp_grp_rl{ht,tt})+...
                        length(cat(1,sublotpairs_grp_rl{ht,realt(id)})),1);
                    lotsp_grp_nc(ht,tt)=mat2cell([lotsp_grp_nc{ht,tt}; ...
                        cat(1,sublotpairs_grp_nc{ht,realt(id)})],...
                        length(lotsp_grp_nc{ht,tt})+...
                        length(cat(1,sublotpairs_grp_nc{ht,realt(id)})),1);
                    
                    lotsp_incgrp_rl(ht,tt)=mat2cell([lotsp_incgrp_rl{ht,tt}; ...
                        cat(1,sublotpairs_incgrp_rl{ht,realt(id)})],...
                        length(lotsp_incgrp_rl{ht,tt})+...
                        length(cat(1,sublotpairs_incgrp_rl{ht,realt(id)})),1);
                    if isempty(find(cat(1,sublotpairs_inc_rl{ht,realt(id)}),1))==0
                        lotsp_inc_rl(ht,tt)=mat2cell([lotsp_inc_rl{ht,tt}; ...
                            cat(1,sublotpairs_inc_rl{ht,realt(id)})],...
                            length(lotsp_inc_rl{ht,tt})+...
                            length(cat(1,sublotpairs_inc_rl{ht,realt(id)})),1);
                    end
                    lotsp_incgrp_nc(ht,tt)=mat2cell([lotsp_incgrp_nc{ht,tt}; ...
                        cat(1,sublotpairs_incgrp_nc{ht,realt(id)})],...
                        length(lotsp_incgrp_nc{ht,tt})+...
                        length(cat(1,sublotpairs_incgrp_nc{ht,realt(id)})),1);
                    if isempty(find(cat(1,sublotpairs_inc_nc{ht,realt(id)}),1))==0
                        lotsp_inc_nc(ht,tt)=mat2cell([lotsp_inc_nc{ht,tt}; ...
                            cat(1,sublotpairs_inc_nc{ht,realt(id)})],...
                            length(lotsp_inc_nc{ht,tt})+...
                            length(cat(1,sublotpairs_inc_nc{ht,realt(id)})),1);
                    end
                end
            end
        end
    end
    
    for irun=1:length(strm_runs)
        sublsales=lsales_base{strm_runs(irun)};
        subavgrents=avgrents_base{strm_runs(irun)};
        sublvalue=lvalue_base(:,:,strm_runs(irun));
        sublvaluec=lvalue_basec(:,:,strm_runs(irun));
        submrent=meanrent_base(:,:,strm_runs(irun));
        submrentc=meanrent_basec(:,:,strm_runs(irun));
        
        for tt=1:length(tspan)
            id=find(strm_t(irun,:)==tspan(tt));
            if isempty(find(id,1))==1
                continue
            else
                vacrate(tt)=mat2cell([vacrate{tt}; vacrate_base(strm_runs(irun),...
                    id)'],length(vacrate{tt})+length(id),1);
                dlots(tt)=mat2cell([dlots{tt}; difflots(strm_runs(irun),...
                    realt(id))'],length(dlots{tt})+length(id),1);
                if isempty(find(sublsales,1)) == 0
                    lsales(tt)=mat2cell([lsales{tt}; sublsales(ismember(sublsales(:,2),...
                        realt(id)),1)],length(lsales{tt})+length(sublsales(ismember(sublsales(:,2),...
                        realt(id)),1)),1);
                    icoast=find(ismember(sublsales(:,2),realt(id))==1 & sublsales(:,3)<20);
                    lsales_coast(tt)=mat2cell([lsales_coast{tt}; sublsales(...
                        icoast,1)],length(lsales_coast{tt})+length(icoast),1);
                end
                subsublvalue=sublvalue(:,realt(id));
                iposlv=find(subsublvalue > 0);
                lvalue(tt)=mat2cell([lvalue{tt}; subsublvalue(iposlv)],...
                    length(lvalue{tt})+length(iposlv),1);
%                 lvalue(tt)=mat2cell([lvalue{tt}; sublvalue(iposlv,realt(id))],...
%                     length(lvalue{tt})+length(iposlv),1);
                subsublvaluec=sublvaluec(:,realt(id));
                iposlvc=find(subsublvaluec > 0);
%                 lvaluec(tt)=mat2cell([lvaluec{tt}; sublvaluec(iposlvc,realt(id))],...
%                     length(lvaluec{tt})+length(iposlvc),1);
                lvaluec(tt)=mat2cell([lvaluec{tt}; subsublvaluec(iposlvc)],...
                    length(lvaluec{tt})+length(iposlvc),1);
                subsubmrent=submrent(:,realt(id));
                iposmr=find(subsubmrent > 0);
%                 mrent(tt)=mat2cell([mrent{tt}; submrent(iposmr,realt(id))],...
%                     length(mrent{tt})+length(iposmr),1);
                mrent(tt)=mat2cell([mrent{tt}; subsubmrent(iposmr)],...
                    length(mrent{tt})+length(iposmr),1);
                subsubmrentc=submrentc(:,realt(id));
                iposmrc=find(subsubmrentc > 0);
                mrentc(tt)=mat2cell([mrentc{tt}; submrentc(iposmrc)],...
                    length(mrentc{tt})+length(iposmrc),1);
                
                
% %                 avgrents(1,tt)=mat2cell([avgrents{1,tt}; subavgrents(1,realt(id))],...
% %                     length(avgrents{1,tt})+1,1);
% %                 avgrents(2,tt)=mat2cell([avgrents{2,tt}; subavgrents(2,realt(id))],...
% %                     length(avgrents{2,tt})+1,1);
% %                 avgrents(3,tt)=mat2cell([avgrents{3,tt}; subavgrents(3,realt(id))],...
% %                     length(avgrents{3,tt})+1,1);
% %                 avgrents(4,tt)=mat2cell([avgrents{4,tt}; subavgrents(4,realt(id))],...
% %                     length(avgrents{4,tt})+1,1);
% %                 avgrents(5,tt)=mat2cell([avgrents{5,tt}; subavgrents(5,realt(id))],...
% %                     length(avgrents{5,tt})+1,1);
% %                 avgrents(6,tt)=mat2cell([avgrents{6,tt}; subavgrents(6,realt(id))],...
% %                     length(avgrents{6,tt})+1,1);
% %                 avgrents(7,tt)=mat2cell([avgrents{7,tt}; subavgrents(7,realt(id))],...
% %                     length(avgrents{7,tt})+1,1);
% %                 avgrents(8,tt)=mat2cell([avgrents{8,tt}; subavgrents(8,realt(id))],...
% %                     length(avgrents{8,tt})+1,1);
%                 
            end
        end
    end
    
    lsalesdata=cell(1,2);
    for i=1:length(lsales)
        if isempty(find(lsales{i},1)) == 1
            continue
        end
        lsalesdata(1)=mat2cell([lsalesdata{1}; lsales{i}],length(lsalesdata{1})+length(lsales{i}),1);
        lsalesdata(2)=mat2cell([lsalesdata{2}; ones(length(lsales{i}),1)*tspan(i)],length(lsalesdata{2})+length(lsales{i}),1);
    end
    
    %%% Aggregate across runs for given time before/after storm
    vacrate_avg=zeros(1,length(tspan));
    vacrate_ci=zeros(2,length(tspan));
    vacrate_s=zeros(1,length(tspan));
    hmc_avg=zeros(1,length(tspan));
    hmc_ci=zeros(2,length(tspan));
    hmc_s=zeros(1,length(tspan));
    dlots_avg=zeros(1,length(tspan));
    dlots_ci=zeros(2,length(tspan));
    dlots_s=zeros(1,length(tspan));
    rlcon_avg=zeros(1,length(tspan));
    rlcon_ci=zeros(2,length(tspan));
    rlcon_s=zeros(1,length(tspan));
    lsales_avg=zeros(1,length(tspan));
    lsales_ci=zeros(2,length(tspan));
    lsalesc_avg=zeros(1,length(tspan));
    lsalesc_ci=zeros(2,length(tspan));
    avgrent_avg=zeros(HT,length(tspan));
    avgrent_ci=zeros(HT,2,length(tspan));
    
    lvalue_avg=zeros(1,length(tspan));
    lvalue_ci=zeros(2,length(tspan));
    lvalue_s=zeros(1,length(tspan));
    lvaluec_avg=zeros(1,length(tspan));
    lvaluec_ci=zeros(2,length(tspan));
    lvaluec_s=zeros(1,length(tspan));
    lvaluerl_avg=zeros(1,length(tspan));
    lvaluerl_ci=zeros(2,length(tspan));
    lvaluerl_s=zeros(1,length(tspan));
    meanrent_avg=zeros(1,length(tspan));
    meanrent_ci=zeros(2,length(tspan));
    meanrent_s=zeros(1,length(tspan));
    meanrentc_avg=zeros(1,length(tspan));
    meanrentc_ci=zeros(2,length(tspan));
    meanrentc_s=zeros(1,length(tspan));
    meanrentrl_avg=zeros(1,length(tspan));
    meanrentrl_ci=zeros(2,length(tspan));
    meanrentrl_s=zeros(1,length(tspan));
    
    lvalue_avg_up25=zeros(1,length(tspan));
    lvalue_ci_up25=zeros(2,length(tspan));
    lvaluec_avg_up25=zeros(1,length(tspan));
    lvaluec_ci_up25=zeros(2,length(tspan));
    lvalue_avg_up50=zeros(1,length(tspan));
    lvalue_ci_up50=zeros(2,length(tspan));
    lvaluec_avg_up50=zeros(1,length(tspan));
    lvaluec_ci_up50=zeros(2,length(tspan));
    
    mrent_avg_up25=zeros(1,length(tspan));
    mrent_ci_up25=zeros(2,length(tspan));
    mrentc_avg_up25=zeros(1,length(tspan));
    mrentc_ci_up25=zeros(2,length(tspan));
    mrent_avg_lw25=zeros(1,length(tspan));
    mrent_ci_lw25=zeros(2,length(tspan));
    mrentc_avg_lw25=zeros(1,length(tspan));
    mrentc_ci_lw25=zeros(2,length(tspan));
    
    
    for tt=1:length(tspan)
        [muavgvr,sigmaavgvr,muavgvrci,sigmaavgvrci]=normfit(vacrate{tt});
        vacrate_avg(tt)=muavgvr;
        vacrate_s(tt)=sigmaavgvr;
        vacrate_ci(:,tt)=muavgvrci;
        
        [muavghmc,sigmaavghmc,muavghmcci,sigmaavghmcci]=normfit(hmcp{tt});
        hmc_avg(tt)=muavghmc;
        hmc_s(tt)=sigmaavghmc;
        hmc_ci(:,tt)=muavghmcci;
        
        [muavgdl,sigmaavgdl,muavgdlci,sigmaavgdlci]=normfit(dlots{tt});
        dlots_avg(tt)=muavgdl;
        dlots_s(tt)=sigmaavgdl;
        dlots_ci(:,tt)=muavgdlci;
        
        [muavgrl,sigmaavgrl,muavgrlci,sigmaavgrlci]=normfit(rlcon{tt});
        rlcon_avg(tt)=muavgrl;
        rlcon_s(tt)=sigmaavgrl;
        rlcon_ci(:,tt)=muavgrlci;
        
        if isempty(find(lsales{tt},1)) == 0
            [muavgls,sigmaavgls,muavglsci,sigmaavglsci]=normfit(log10(lsales{tt}));
            lsales_avg(tt)=muavgls;
            lsales_ci(:,tt)=muavglsci;
        end
        %     lsse=sigmaavgls/sqrt(length(lsales{tt}));
        
        if isempty(find(lsales_coast{tt},1)) == 0
            [muavglsc,sigmaavglsc,muavglscci,sigmaavglscci]=normfit(log10(lsales_coast{tt}));
            lsalesc_avg(tt)=muavglsc;
            lsalesc_ci(:,tt)=muavglscci;
        end
        
        [muavglv,sigmaavglv,muavglvci,sigmaavglvci]=normfit(log10(lvalue{tt}));
        lvalue_avg(tt)=muavglv;
        lvalue_s(tt)=sigmaavglv;
        lvalue_ci(:,tt)=muavglvci;
        
        [muavglvc,sigmaavglvc,muavglvcci,sigmaavglvcci]=normfit(log10(lvaluec{tt}));
        lvaluec_avg(tt)=muavglvc;
        lvaluec_s(tt)=sigmaavglvc;
        lvaluec_ci(:,tt)=muavglvcci;
        
        if isempty(find(lvaluerl{tt},1)) == 0
            [muavglvrl,sigmaavglvrl,muavglvcirl,sigmaavglvcirl]=normfit(log10(lvaluerl{tt}));
            lvaluerl_avg(tt)=muavglvrl;
            lvaluerl_s(tt)=sigmaavglvrl;
            lvaluerl_ci(:,tt)=muavglvcirl;
        end
        %     sublv=lvalue{tt};
        %     lvqrt=quantile(sublv,[0.25 0.5 0.75]);
        %     iup25=find(sublv>lvqrt(3));
        %     iup50=find(sublv>lvqrt(2));
        %     [muavglv,sigmaavglv,muavglvci,sigmaavglvci]=normfit(sublv(iup25));
        %     lvalue_avg_up25(tt)=muavglv;
        %     lvalue_ci_up25(:,tt)=muavglvci;
        %     [muavglv,sigmaavglv,muavglvci,sigmaavglvci]=normfit(sublv(iup50));
        %     lvalue_avg_up50(tt)=muavglv;
        %     lvalue_ci_up50(:,tt)=muavglvci;
        %
        %     sublvc=lvaluec{tt};
        %     lvcqrt=quantile(sublvc,[0.25 0.5 0.75]);
        %     iup25=find(sublvc>lvcqrt(3));
        %     iup50=find(sublvc>lvcqrt(2));
        %     [muavglvc,sigmaavglv,muavglvcci,sigmaavglvci]=normfit(sublvc(iup25));
        %     lvaluec_avg_up25(tt)=muavglvc;
        %     lvaluec_ci_up25(:,tt)=muavglvcci;
        %     [muavglvc,sigmaavglv,muavglvcci,sigmaavglvci]=normfit(sublvc(iup50));
        %     lvaluec_avg_up50(tt)=muavglvc;
        %     lvaluec_ci_up50(:,tt)=muavglvcci;
        
        [muavgmr,sigmaavgmr,muavgmrci,sigmaavgmrci]=normfit(mrent{tt});
        meanrent_avg(tt)=muavgmr;
        meanrent_s(tt)=sigmaavgmr;
        meanrent_ci(:,tt)=muavgmrci;
        
        [muavgmrc,sigmaavgmrc,muavgmrcci,sigmaavgmrcci]=normfit(mrentc{tt});
        meanrentc_avg(tt)=muavgmrc;
        meanrentc_s(tt)=sigmaavgmrc;
        meanrentc_ci(:,tt)=muavgmrcci;
        
        if isempty(find(mrentrl{tt},1)) == 0
            [muavgmrrl,sigmaavgmrrl,muavgmrcirl,sigmaavgmrcirl]=normfit(mrentrl{tt});
            meanrentrl_avg(tt)=muavgmrrl;
            meanrentrl_s(tt)=sigmaavgmrrl;
            meanrentrl_ci(:,tt)=muavgmrcirl;
        end
        
        % quantile rents
        submrc=mrentc{tt};
        mrcqrt=quantile(submrc,[0.25 0.5 0.75]);
        iup25=find(submrc>mrcqrt(3));
        ilw25=find(submrc<mrcqrt(1));
        [muavgmrc,sigmaavgmr,muavgmrcci,sigmaavgmrci]=normfit(submrc(iup25));
        mrentc_avg_up25(tt)=muavgmrc;
        mrentc_ci_up25(:,tt)=muavgmrcci;
        [muavgmrc,sigmaavgmr,muavgmrcci,sigmaavgmrci]=normfit(submrc(ilw25));
        mrentc_avg_lw25(tt)=muavgmrc;
        mrentc_ci_lw25(:,tt)=muavgmrcci;
        
%         for ht=1:HT
%             [muavgrent,sigmaavgrent,muavgrentci,sigmaavgrentci]=normfit(avgrents{ht,tt});
%             avgrent_avg(ht,tt)=muavgrent;
%             avgrent_ci(ht,:,tt)=muavgrentci;
%         end
    end
    
    %
%     cd C:\Users\nmagliocca\Documents\Matlab_code\CHALMS_coast\figs\event_strmfreq
    cd C:\Users\nrmagliocca\'Box Sync'\'Data Drive'\model_results\CHALMS_event_ilandscape_011718_popgrow\figs
    % vacancy rate
    h1=figure;
    set(h1, 'Color','white','Position',[1,1,700,700],'Visible','off');
    errorbar(tspan,vacrate_avg,vacrate_ci(1,:)-vacrate_avg,vacrate_avg-...
        vacrate_ci(2,:),'.k','LineWidth',2)
    xlim([min(tspan)-0.5 max(tspan)+0.5])
    hold on
    plot(tspan,vacrate_avg,'.r','MarkerSize',15)
    set(gca,'Xtick',start_t:end_t)
    xlabel('Time Since Storm','FontSize',14)
    ylabel('Avg. Vacancy Rate','FontSize',14)
    title(sprintf('avg_vacrate_%s',runnamelabel{N}))
    saveas(h1,sprintf('avg_vacrate_%s',runnamelabel{N}),'jpg')
    %
    % %land sales
    % h2=figure;
    % set(h2, 'Color','white','Position',[1,1,700,700],'Visible','off');
    % errorbar(tspan,lsales_avg,lsales_ci(1,:),lsales_ci(2,:),'.k')
    % xlim([min(tspan)-0.5 max(tspan)+0.5])
    % hold on
    % plot(tspan,lsales_avg,'.r')
    % xlabel('Time Since Storm')
    % ylabel('Avg. Land Sale Price')
    %
    % % land sales, coast
    % h3=figure;
    % set(h3, 'Color','white','Position',[1,1,700,700],'Visible','off');
    % errorbar(tspan,lsalesc_avg,lsalesc_ci(1,:)-lsalesc_avg,lsalesc_avg-lsalesc_ci(2,:),'.k')
    % xlim([min(tspan)-0.5 max(tspan)+0.5])
    % hold on
    % plot(tspan,lsalesc_avg,'.r')
    % xlabel('Time Since Storm')
    % ylabel('Avg. Coastal Land Sale Price')
    
    % % housing rents
    % h4=figure;
    % set(h4, 'Color','white','Position',[1,1,700,700],'Visible','off');
    % errorbar(tspan,avgrent_avg(1,:),reshape(avgrent_ci(1,1,:),1,length(tspan))-avgrent_avg(1,:),...
    %     avgrent_avg(1,:)-reshape(avgrent_ci(1,2,:),1,length(tspan)),'.k')
    % xlim([min(tspan)-0.5 max(tspan)+0.5])
    % hold on
    % plot(tspan,avgrent_avg(1,:),'.r')
    % xlabel('Time Since Storm')
    % ylabel('Avg. Housing Price')
    
    % land values
    h5=figure;
    set(h5, 'Color','white','Position',[1,1,700,700],'Visible','off');
    errorbar(tspan,lvalue_avg,lvalue_ci(1,:)-lvalue_avg,lvalue_avg-...
        lvalue_ci(2,:),'.k','LineWidth',2)
    xlim([min(tspan)-0.5 max(tspan)+0.5])
    hold on
    plot(tspan,lvalue_avg,'.r','MarkerSize',15)
    set(gca,'Xtick',start_t:end_t)
    xlabel('Time Since Storm','FontSize',14)
    ylabel('Log Avg. Land Values','FontSize',14)
    title(sprintf('avg_lvalue_%s',runnamelabel{N}))
    saveas(h5,sprintf('avg_lvalue_%s',runnamelabel{N}),'jpg')
    
    % coastal land values
    h6=figure;
    set(h6, 'Color','white','Position',[1,1,700,700],'Visible','off');
    errorbar(tspan,lvaluec_avg,lvaluec_ci(1,:)-lvaluec_avg,lvaluec_avg-...
        lvaluec_ci(2,:),'.k','LineWidth',2)
    xlim([min(tspan)-0.5 max(tspan)+0.5])
    hold on
    plot(tspan,lvaluec_avg,'.r','MarkerSize',15)
    set(gca,'Xtick',start_t:end_t)
    xlabel('Time Since Storm','FontSize',14)
    ylabel('Log Avg. Coastal Land Values','FontSize',14)
    title(sprintf('avg_lvaluec_%s',runnamelabel{N}))
    saveas(h6,sprintf('avg_lvaluec_%s',runnamelabel{N}),'jpg')
    
    % % land values, up 25
    % h7=figure;
    % set(h7, 'Color','white','Position',[1,1,700,700],'Visible','off');
    % errorbar(tspan,lvalue_avg_up25,lvalue_ci_up25(1,:)-lvalue_avg_up25,lvalue_avg_up25-lvalue_ci_up25(2,:),'.k')
    % xlim([min(tspan)-0.5 max(tspan)+0.5])
    % hold on
    % plot(tspan,lvalue_avg_up25,'.r')
    % xlabel('Time Since Storm')
    % ylabel('Avg. Land Values, Upper 25%')
    %
    % % coastal land values
    % h8=figure;
    % set(h8, 'Color','white','Position',[1,1,700,700],'Visible','off');
    % errorbar(tspan,lvaluec_avg_up25,lvaluec_ci_up25(1,:),lvaluec_ci_up25(2,:),'.k')
    % xlim([min(tspan)-0.5 max(tspan)+0.5])
    % hold on
    % plot(tspan,lvaluec_avg_up25,'.r')
    % xlabel('Time Since Storm')
    % ylabel('Avg. Coastal Land Values, Upper 25%')
    
    % avgrents
    h9=figure;
    set(h9, 'Color','white','Position',[1,1,700,700],'Visible','off');
    errorbar(tspan,meanrent_avg,meanrent_ci(1,:)-meanrent_avg,meanrent_avg-...
        meanrent_ci(2,:),'.k','LineWidth',2)
    xlim([min(tspan)-0.5 max(tspan)+0.5])
    hold on
    plot(tspan,meanrent_avg,'.r','MarkerSize',15)
    set(gca,'Xtick',start_t:end_t)
    xlabel('Time Since Storm','FontSize',14)
    ylabel('Avg. Housing Rents','FontSize',14)
    title(sprintf('avg_houserent_%s',runnamelabel{N}))
    saveas(h9,sprintf('avg_houserent_%s',runnamelabel{N}),'jpg')
    %
    % coastal avgrents
    h10=figure;
    set(h10, 'Color','white','Position',[1,1,700,700],'Visible','off');
    errorbar(tspan,meanrentc_avg,meanrentc_ci(1,:)-meanrentc_avg,...
        meanrentc_avg-meanrentc_ci(2,:),'.k','LineWidth',2)
    xlim([min(tspan)-0.5 max(tspan)+0.5])
    hold on
    plot(tspan,meanrentc_avg,'.r','MarkerSize',15)
    set(gca,'Xtick',start_t:end_t)
    xlabel('Time Since Storm','FontSize',14)
    ylabel('Avg. Coastal Housing Rents','FontSize',14)
    title(sprintf('avg_houserentc_%s',runnamelabel{N}))
    saveas(h10,sprintf('avg_houserentc_%s',runnamelabel{N}),'jpg')
    
    % % avgrents, up 25
    % h11=figure;
    % set(h11, 'Color','white','Position',[1,1,700,700],'Visible','off');
    % errorbar(tspan,mrentc_avg_up25,mrentc_ci_up25(1,:),mrentc_ci_up25(2,:),'.k')
    % xlim([min(tspan)-0.5 max(tspan)+0.5])
    % hold on
    % plot(tspan,mrentc_avg_up25,'.r')
    % xlabel('Time Since Storm')
    % ylabel('Avg. Coastal Housing Rents, Upper 25%')
    %
    % % coastal avgrent, low 25%
    % h12=figure;
    % set(h12, 'Color','white','Position',[1,1,700,700],'Visible','off');
    % errorbar(tspan,mrentc_avg_lw25,mrentc_ci_lw25(1,:),mrentc_ci_lw25(2,:),'.k')
    % xlim([min(tspan)-0.5 max(tspan)+0.5])
    % hold on
    % plot(tspan,mrentc_avg_lw25,'.r')
    % xlabel('Time Since Storm')
    % ylabel('Avg. Coastal Land Values, Lower 25%')
    h13=figure;
    set(h13, 'Color','white','Position',[1,1,700,700],'Visible','off');
    errorbar(tspan,dlots_avg,dlots_ci(1,:)-dlots_avg,dlots_avg-...
        dlots_ci(2,:),'.k','LineWidth',2)
    xlim([min(tspan)-0.5 max(tspan)+0.5])
    hold on
    plot(tspan,dlots_avg,'.r','MarkerSize',15)
    set(gca,'Xtick',start_t:end_t)
    xlabel('Time Since Storm','FontSize',14)
    ylabel('Avg. Growth Rate','FontSize',14)
    title(sprintf('avg_dlots_%s',runnamelabel{N}))
    saveas(h13,sprintf('avg_dlots_%s',runnamelabel{N}),'jpg')
    
%     dlotscell{N}=mat2cell(dlots_avg,length(dlots_avg),1);
%     dlotscicell{N}=mat2cell(dlots_ci,length(dlots_ci(1,:)),2);
%     save dlotsdata 
    
    %relocating consumers
    h17=figure;
    set(h17, 'Color','white','Position',[1,1,700,700],'Visible','off');
    errorbar(tspan,rlcon_avg,rlcon_ci(1,:)-rlcon_avg,rlcon_avg-...
        rlcon_ci(2,:),'.k','LineWidth',2)
    xlim([min(tspan)-0.5 max(tspan)+0.5])
    hold on
    plot(tspan,rlcon_avg,'.r','MarkerSize',15)
    set(gca,'Xtick',start_t:end_t)
    xlabel('Time Since Storm','FontSize',14)
    ylabel('Number of Relocations','FontSize',14)
    title(sprintf('avg_rlcon_%s',runnamelabel{N}))
    saveas(h17,sprintf('avg_rlcon_%s',runnamelabel{N}),'jpg')
    
    if N == 3
        keyboard
    end
    h18=figure;
    set(h18, 'Color','white','Position',[1,1,700,700],'Visible','off');
    errorbar(tspan(2:10),hmc_avg(2:10),hmc_ci(1,2:10)-hmc_avg(2:10),hmc_avg(2:10)-...
        hmc_ci(2,2:10),'.k','LineWidth',2)
    xlim([min(tspan)+1-0.5 max(tspan)-1+0.5])
    hold on
    plot(tspan(2:10),hmc_avg(2:10),'.r','MarkerSize',15)
    set(gca,'Xtick',start_t+1:end_t-1)
    xlabel('Time Since Storm','FontSize',14)
    ylabel('Housing Market Competition Index','FontSize',14)
    title(sprintf('avg_hmc_%s',runnamelabel{N}))
    saveas(h18,sprintf('avg_hmc_%s',runnamelabel{N}),'jpg')
    
    h19=figure;
    set(h19, 'Color','white','Position',[1,1,700,700],'Visible','off');
    errorbar(tspan,lvaluerl_avg,lvaluerl_ci(1,:)-lvaluerl_avg,lvaluerl_avg-...
        lvaluerl_ci(2,:),'.k','LineWidth',2)
    xlim([min(tspan)-0.5 max(tspan)+0.5])
    hold on
    plot(tspan,lvaluerl_avg,'.r','MarkerSize',15)
    set(gca,'Xtick',start_t:end_t)
    xlabel('Time Since Storm','FontSize',14)
    ylabel('Land Value of Relocations','FontSize',14)
    title(sprintf('lvaluerl_%s',runnamelabel{N}))
    saveas(h19,sprintf('lvaluerl_%s',runnamelabel{N}),'jpg')
    
    h20=figure;
    set(h20, 'Color','white','Position',[1,1,700,700],'Visible','off');
    errorbar(tspan,meanrentrl_avg,meanrentrl_ci(1,:)-meanrentrl_avg,meanrentrl_avg-...
        meanrentrl_ci(2,:),'.k','LineWidth',2)
    xlim([min(tspan)-0.5 max(tspan)+0.5])
    hold on
    plot(tspan,meanrentrl_avg,'.r','MarkerSize',15)
    set(gca,'Xtick',start_t:end_t)
    xlabel('Time Since Storm','FontSize',14)
    ylabel('Housing Prices of Relocations','FontSize',14)
    title(sprintf('meanrentrl_%s',runnamelabel{N}))
    saveas(h20,sprintf('meanrentrl_%s',runnamelabel{N}),'jpg')
    
    % Saving variables
    vacrate_avg_save(N,:)=vacrate_avg;
    vacrate_ci_save(:,:,N)=vacrate_ci;
    vacrate_s_save(N,:)=vacrate_s;
    dlots_avg_save(N,:)=dlots_avg;
    dlots_ci_save(:,:,N)=dlots_ci;
    dlots_s_save(N,:)=dlots_s;
    rlcon_avg_save(N,:)=rlcon_avg;
    rlcon_ci_save(:,:,N)=rlcon_ci;
    rlcon_s_save(N,:)=rlcon_s;
    lvalue_avg_save(N,:)=lvalue_avg;
    lvalue_ci_save(:,:,N)=lvalue_ci;
    lvalue_s_save(N,:)=lvalue_s;
    lvaluec_avg_save(N,:)=lvaluec_avg;
    lvaluec_ci_save(:,:,N)=lvalue_ci;
    lvaluec_s_save(N,:)=lvalue_s;
    meanrent_avg_save(N,:)=meanrent_avg;
    meanrent_ci_save(:,:,N)=meanrent_ci;
    meanrent_s_save(N,:)=meanrent_s;
    meanrentc_avg_save(N,:)=meanrentc_avg;
    meanrentc_ci_save(:,:,N)=meanrentc_ci;
    meanrentc_s_save(N,:)=meanrentc_s;
    hmc_avg_save(N,:)=hmc_avg;
    hmc_ci_save(:,:,N)=hmc_ci;
    hmc_s_save(N,:)=hmc_s;
    lvaluerl_avg_save(N,:)=lvaluerl_avg;
    lvaluerl_ci_save(:,:,N)=lvaluerl_ci;
    lvaluerl_s_save(N,:)=lvaluerl_s;
    meanrentrl_avg_save(N,:)=meanrentrl_avg;
    meanrentrl_ci_save(:,:,N)=meanrentrl_ci;
    meanrentrl_s_save(N,:)=meanrentrl_s;
    
    paired_id_rl_save{N}=lotpairs_id_rl;
    paired_id_nc_save{N}=lotpairs_id_nc;
    paired_rent_rl_save{N}=lotpairs_rent_rl;
    paired_rent_nc_save{N}=lotpairs_rent_nc;
    paired_dmg_rl_save{N}=lotpairs_dmg_rl;
    paired_dmg_nc_save{N}=lotpairs_dmg_nc;
    paired_grp_rl_save{N}=lotpairs_grp_rl;
    paired_grp_nc_save{N}=lotpairs_grp_nc;
    paired_inc_rl_save{N}=lotpairs_inc_rl;
    paired_inc_nc_save{N}=lotpairs_inc_nc;
    paired_incgrp_rl_save{N}=lotpairs_incgrp_rl;
    paired_incgrp_nc_save{N}=lotpairs_incgrp_nc;
    
    id_rl_save{N}=lotsp_id_rl;
    id_nc_save{N}=lotsp_id_nc;
    rent_rl_save{N}=lotsp_rent_rl;
    rent_nc_save{N}=lotsp_rent_nc;
    dmg_rl_save{N}=lotsp_dmg_rl;
    dmg_nc_save{N}=lotsp_dmg_nc;
    grp_rl_save{N}=lotsp_grp_rl;
    grp_nc_save{N}=lotsp_grp_nc;
    inc_rl_save{N}=lotsp_inc_rl;
    inc_nc_save{N}=lotsp_inc_nc;
    incgrp_rl_save{N}=lotsp_incgrp_rl;
    incgrp_nc_save{N}=lotsp_incgrp_nc;
end

% % average rents
% h14=figure;
% set(h14, 'Color','white','Position',[1,1,700,700],'Visible','off');
% % errorbar(tspan,endrents,endrents_ci(1,:)-endrents,endrents-...
% %     endrents_ci(2,:),'.k','LineWidth',2)
% errorbar(1:4,endrents([1 2 4 3]),endrents_ci(1,[1 2 4 3])-...
%     endrents([1 2 4 3]),endrents([1 2 4 3])-endrents_ci(2,[1 2 4 3]),...
%     '.k','LineWidth',2)
% hold on
% plot(1:4,endrents([1 2 4 3]),'.r','MarkerSize',15)
% set(gca,'XTick',1:4,'XTickLabel',{'Mid-Atl','NC','TX','FL'},'FontSize',16)
% ylabel('Avg. Housing Rents','FontSize',16)
% saveas(h14,'endrents','jpg')
% 
% % average land prices
% h15=figure;
% set(h15, 'Color','white','Position',[1,1,700,700],'Visible','off');
% errorbar(1:4,10.^endlvalue([1 2 4 3]),10.^endlvalue_ci(1,[1 2 4 3])-...
%     10.^endlvalue([1 2 4 3]),10.^endlvalue([1 2 4 3])-...
%     10.^endlvalue_ci(2,[1 2 4 3]),'.k','LineWidth',2)
% hold on
% plot(1:4,10.^endlvalue([1 2 4 3]),'.r','MarkerSize',15)
% set(gca,'XTick',1:4,'XTickLabel',{'Mid-Atl','NC','TX','FL'},'FontSize',16)
% ylabel('Avg. Land Prices','FontSize',16)
% saveas(h15,'endlvalue','jpg')

cd C:\Users\nrmagliocca\'Box Sync'\'Data Drive'\model_results\CHALMS_event_ilandscape_011718_popgrow
save stormrecord runtimes_save strmruns_save strmset_save strmt_save strmoccr_save
save mvcost_results_altmodels vacrate_avg_save vacrate_ci_save vacrate_s_save ...
    lvalue_avg_save lvalue_ci_save lvalue_s_save lvaluec_avg_save ...
    lvaluec_ci_save lvaluec_s_save meanrent_avg_save meanrent_ci_save ...
    meanrent_s_save meanrentc_avg_save meanrentc_ci_save ...
    meanrentc_s_save endlvalue endlvalue_ci endlvalue_s dlots_avg_save ...
    dlots_ci_save dlots_s_save endrents endrents_ci endrents_s rlcon_avg_save ...
    rlcon_ci_save rlcon_s_save hmc_avg_save hmc_ci_save hmc_s_save ...
    lvaluerl_avg_save lvaluerl_ci_save lvaluerl_s_save meanrentrl_avg_save ...
    meanrentrl_ci_save meanrentrl_s_save paired_id_rl_save ...
    paired_id_nc_save paired_rent_rl_save paired_rent_nc_save ...
    paired_dmg_rl_save paired_dmg_nc_save paired_grp_rl_save ...
    paired_grp_nc_save paired_inc_rl_save paired_inc_nc_save ...
    id_rl_save id_nc_save rent_rl_save rent_nc_save dmg_rl_save ...
    dmg_nc_save grp_rl_save grp_nc_save inc_rl_save inc_nc_save ...
    paired_incgrp_rl_save paired_incgrp_nc_save incgrp_rl_save incgrp_nc_save
