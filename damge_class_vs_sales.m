cd C:\Users\nrmagliocca\'Box Sync'\'Data Drive'\model_results\CHALMS_event_ilandscape_011718_popgrow
load results_event_ilandscape_011718_popgrow.mat
load stormrecord

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
dmgclass=3;
dmgvec=reshape(housedam,NCELLS,1);

% runnamelabel={'eu_max','salience'};
% runnamelabel={'eu_max_MA','salience_MA','eu_max_NC','salience_NC',...
%     'eu_max_TX','salience_TX','eu_max_FL','salience_FL'};
% runnamelabel={'null','eu_max','salience'};
runnamelabel={'popgrow0','popgrow025','popgrow05','popgrow075','popgrow10'};

% dmgqnt=quantile(dmgvec,[0.9 0.95]);
% idmggroup_hi=find(dmgvec > dmgqnt(2));
% idmggroup_md=find(dmgvec > dmgqnt(1) & dmgvec <= dmgqnt(2));
% idmggroup_lw=find(dmgvec <= dmgqnt(1));

idmggroup_hi=find(CDIST == 1);  %waterfront
idmggroup_md=find(CDIST > 1 & CDIST <= 5); %waterview
idmggroup_lw=find(CDIST > 5);  %low to moderate risk


start_t=-5;
end_t=5;
tspan=start_t:end_t;
realt=TSTART:TMAX;

rents=cell(dmgclass,length(tspan),ERUNS*nruns);
rlct=cell(dmgclass,length(tspan),ERUNS*nruns);
nsales=cell(dmgclass,length(tspan),ERUNS*nruns);
incomes=cell(dmgclass,length(tspan),ERUNS*nruns);
vacants=cell(dmgclass,length(tspan),ERUNS*nruns);
inscov=cell(dmgclass,length(tspan),ERUNS*nruns);
totinscov=cell(1,length(tspan),ERUNS*nruns);

rawrents=cell(dmgclass,length(tspan));
rawnsales=cell(dmgclass,length(tspan));
rawincomes=cell(dmgclass,length(tspan));
rawinscov=cell(dmgclass,length(tspan));
rawrlct=cell(dmgclass,length(tspan));
rawvacs=cell(dmgclass,length(tspan));

avgrents=zeros(dmgclass,length(tspan));
avgrents_s=zeros(dmgclass,length(tspan));
avgrents_ci=zeros(dmgclass,length(tspan),2);
avgrlct=zeros(dmgclass,length(tspan));
avgrlct_s=zeros(dmgclass,length(tspan));
avgrlct_ci=zeros(dmgclass,length(tspan),2);
avgnsales=zeros(dmgclass,length(tspan));
avgnsales_s=zeros(dmgclass,length(tspan));
avgnsales_ci=zeros(dmgclass,length(tspan),2);
avgvacant=zeros(dmgclass,length(tspan));
avgvacant_s=zeros(dmgclass,length(tspan));
avgvacant_ci=zeros(dmgclass,length(tspan),2);
avgincomes=zeros(dmgclass,length(tspan));
avgincomes_s=zeros(dmgclass,length(tspan));
avgincomes_ci=zeros(dmgclass,length(tspan),2);
avginscov=zeros(dmgclass,length(tspan));
avginscov_s=zeros(dmgclass,length(tspan));
avginscov_ci=zeros(dmgclass,length(tspan),2);
totinscov_avg=zeros(1,length(tspan),ERUNS);
totinscov_ci=zeros(2,length(tspan),ERUNS);
percaprate=zeros(dmgclass,length(tspan),ERUNS);
percaprate_hi=zeros(dmgclass,length(tspan),ERUNS);
percaprate_low=zeros(dmgclass,length(tspan),ERUNS);
for N=1:ERUNS
    % Collate data for all model runs under each experimental parameter
    % setting
    irunset=runset{N};
    strm_t=strmt_save{N};
    strm_runs=strmruns_save{N};
    runtimes=runtimes_save(N).rt;
    strmset=unique(strm_runs);
    rents_all=lotdata_store.lotrent(irunset); %rents for existing lots for all timesteps
    conid_all=lotdata_store.lotcon(irunset);  %consumers for existing lots for all timesteps
    lotloc=lotdata_store.Lotlocate(irunset);  %location vector for lots at end of model runs
    %     lotinc=lotdata_store.Lotincome(irunset);  %income of all consumers at end of model runs
    lotinc=lotdata_store.lotinc(irunset);  %income of consumers in existing lots for all timesteps
    lotins=lotdata_store.lotins(irunset);
    capitavec=htdata_store.num_lots(irunset);
    %     conincome=relocdata_store.reloc_inc(irunset,:);
    %     for irun=1:length(strm_runs)
    %         sublsales=lsales_base{strmset(irun)};
    %         subavgrents=avgrents_base{strmset(irun)};
    %         sublvalue=lvalue_base(:,:,strmset(irun));
    %         sublvaluec=lvalue_basec(:,:,strmset(irun));
    %         submrent=meanrent_base(:,:,strmset(irun));
    %     end
    %     strmset=unique(strm_runs);
    for irun=1:length(strmset)
        subrents=rents_all{strmset(irun)};
        subconid=conid_all{strmset(irun)};
        sublotloc=lotloc{strmset(irun)};
        sublotinc=lotinc{strmset(irun)};
        sublotins=lotins{strmset(irun)};
        subcapitavec=capitavec{strmset(irun)};
        %         subconinc=conincome(strmset(irun),:);
        for tt=1:length(tspan)
            %             id=find(strm_t(irun,:)==tspan(tt));
            substrm_t=runtimes{irun};
            [row,col]=find(substrm_t==tspan(tt));
            id=unique(col);
            if isempty(find(id,1))==1
                continue
            else
                for i=1:length(id)
%                     capita=
                    irents=subrents{realt(id(i))};  %identify which lots were present at the specified timestep
                    ilotins=(sublotins{realt(id(i))}==1);
                    ilotinc=sublotinc{realt(id(i))};
                    icons=subconid{realt(id(i))};
                    icons_last=subconid{realt(id(i))-1};
                    %                 iconinc=subconinc{realt(id)};
                    %                 ilotsin=sublotloc(1:length(irents),1);
                    
                    % based on lots present, find lot index for damage class
                    ilotdmg1=ismember(sublotloc(1:length(irents),2),idmggroup_hi);
                    ilotdmg2=ismember(sublotloc(1:length(irents),2),idmggroup_md);
                    ilotdmg3=ismember(sublotloc(1:length(irents),2),idmggroup_lw);
                    
                    inotzero1=(icons~=0 & ilotdmg1==1);
                    inotzero2=(icons~=0 & ilotdmg2==1);
                    inotzero3=(icons~=0 & ilotdmg3==1);
                    ivac1=(icons==0 & ilotdmg1==1);
                    ivac2=(icons==0 & ilotdmg2==1);
                    ivac3=(icons==0 & ilotdmg3==1);
                    
                    
%                     rents(1,tt,irunset(strmset(irun)))=mat2cell([...
%                         rents{1,tt,irunset(strmset(irun))}; ...
%                         irents(sublotloc(ilotdmg1,1))],...
%                         length(rents{1,tt,irunset(strmset(irun))})+...
%                         length(irents(sublotloc(ilotdmg1,1))),1);
%                     rents(2,tt,irunset(strmset(irun)))=mat2cell([...
%                         rents{2,tt,irunset(strmset(irun))}; ...
%                         irents(sublotloc(ilotdmg2,1))],...
%                         length(rents{2,tt,irunset(strmset(irun))})+...
%                         length(irents(sublotloc(ilotdmg2,1))),1);
%                     rents(3,tt,irunset(strmset(irun)))=mat2cell([...
%                         rents{3,tt,irunset(strmset(irun))}; ...
%                         irents(sublotloc(ilotdmg3,1))],...
%                         length(rents{3,tt,irunset(strmset(irun))})+...
%                         length(irents(sublotloc(ilotdmg3,1))),1);

                    rents(1,tt,irunset(strmset(irun)))=mat2cell([...
                        rents{1,tt,irunset(strmset(irun))}; ...
                        irents(sublotloc(inotzero1,1))],...
                        length(rents{1,tt,irunset(strmset(irun))})+...
                        length(irents(sublotloc(inotzero1,1))),1);
                    rents(2,tt,irunset(strmset(irun)))=mat2cell([...
                        rents{2,tt,irunset(strmset(irun))}; ...
                        irents(sublotloc(inotzero2,1))],...
                        length(rents{2,tt,irunset(strmset(irun))})+...
                        length(irents(sublotloc(inotzero2,1))),1);
                    rents(3,tt,irunset(strmset(irun)))=mat2cell([...
                        rents{3,tt,irunset(strmset(irun))}; ...
                        irents(sublotloc(inotzero3,1))],...
                        length(rents{3,tt,irunset(strmset(irun))})+...
                        length(irents(sublotloc(inotzero3,1))),1);
                    
                    if tt > 1
                        diffcons=find((icons_last==icons(1:length(icons_last)))==0);
                        idiffcons1=ismember(diffcons,find(ilotdmg1==1));
                        idiffcons2=ismember(diffcons,find(ilotdmg2==1));
                        idiffcons3=ismember(diffcons,find(ilotdmg3==1));
                        rlct(1,tt,irunset(strmset(irun)))=mat2cell([...
                            rlct{1,tt,irunset(strmset(irun))}; ...
                            length(diffcons(idiffcons1))],...
                            length(rlct{1,tt,irunset(strmset(irun))})+1,1);
                        rlct(2,tt,irunset(strmset(irun)))=mat2cell([...
                            rlct{2,tt,irunset(strmset(irun))}; ...
                            length(diffcons(idiffcons2))],...
                            length(rlct{2,tt,irunset(strmset(irun))})+1,1);
                        rlct(3,tt,irunset(strmset(irun)))=mat2cell([...
                            rlct{3,tt,irunset(strmset(irun))}; ...
                            length(diffcons(idiffcons3))],...
                            length(rlct{3,tt,irunset(strmset(irun))})+1,1);
                    end
%                     % absolute number of policies
%                     inscov(1,tt,irunset(strmset(irun)))=mat2cell([...
%                         inscov{1,tt,irunset(strmset(irun))}; ...
%                         sum(ilotins(sublotloc(inotzero1,1)))],...
%                         length(inscov{1,tt,irunset(strmset(irun))})+1,1);
%                     inscov(2,tt,irunset(strmset(irun)))=mat2cell([...
%                         inscov{2,tt,irunset(strmset(irun))}; ...
%                         sum(ilotins(sublotloc(inotzero2,1)))],...
%                         length(inscov{2,tt,irunset(strmset(irun))})+1,1);
%                     inscov(3,tt,irunset(strmset(irun)))=mat2cell([...
%                         inscov{3,tt,irunset(strmset(irun))}; ...
%                         sum(ilotins(sublotloc(inotzero3,1)))],...
%                         length(inscov{3,tt,irunset(strmset(irun))})+1,1);

                    % per capita policies
                    inscov(1,tt,irunset(strmset(irun)))=mat2cell([...
                        inscov{1,tt,irunset(strmset(irun))}; ...
                        sum(ilotins(sublotloc(inotzero1,1)))/...
                        length(irents(sublotloc(inotzero1,1)))],...
                        length(inscov{1,tt,irunset(strmset(irun))})+1,1);
                    inscov(2,tt,irunset(strmset(irun)))=mat2cell([...
                        inscov{2,tt,irunset(strmset(irun))}; ...
                        sum(ilotins(sublotloc(inotzero2,1)))/...
                        length(irents(sublotloc(inotzero2,1)))],...
                        length(inscov{2,tt,irunset(strmset(irun))})+1,1);
                    inscov(3,tt,irunset(strmset(irun)))=mat2cell([...
                        inscov{3,tt,irunset(strmset(irun))}; ...
                        sum(ilotins(sublotloc(inotzero3,1)))/...
                        length(irents(sublotloc(inotzero3,1)))],...
                        length(inscov{3,tt,irunset(strmset(irun))})+1,1);
                    
                    vacants(1,tt,irunset(strmset(irun)))=mat2cell([...
                        vacants{1,tt,irunset(strmset(irun))}; ...
                        length(find(ivac1==1))],length(vacants{1,tt,irunset(strmset(irun))})+1,1);
                    vacants(2,tt,irunset(strmset(irun)))=mat2cell([...
                        vacants{2,tt,irunset(strmset(irun))}; ...
                        length(find(ivac2==1))],length(vacants{2,tt,irunset(strmset(irun))})+1,1);
                    vacants(3,tt,irunset(strmset(irun)))=mat2cell([...
                        vacants{3,tt,irunset(strmset(irun))}; ...
                        length(find(ivac3==1))],length(vacants{3,tt,irunset(strmset(irun))})+1,1);
                    
                    incomes(1,tt,irunset(strmset(irun)))=mat2cell([...
                        incomes{1,tt,irunset(strmset(irun))}; ...
                        ilotinc(inotzero1)],...
                        length(incomes{1,tt,irunset(strmset(irun))})+...
                        length(ilotinc(inotzero1)),1);
                    incomes(2,tt,irunset(strmset(irun)))=mat2cell([...
                        incomes{2,tt,irunset(strmset(irun))}; ...
                        ilotinc(inotzero2)],...
                        length(incomes{2,tt,irunset(strmset(irun))})+...
                        length(ilotinc(inotzero2)),1);
                    incomes(3,tt,irunset(strmset(irun)))=mat2cell([...
                        incomes{3,tt,irunset(strmset(irun))}; ...
                        ilotinc(inotzero3)],...
                        length(incomes{3,tt,irunset(strmset(irun))})+...
                        length(ilotinc(inotzero3)),1);
                    
                    % identify consumers by damage group
                    if isempty(find(icons_last,1)) == 0
                        existlots=icons(1:length(icons_last));
                        iconchange=find(diff([icons_last existlots],1,2) ~= 0 & ...
                            existlots ~= 0);    % sales of existing houses
                        inewsales=length(icons_last)+find(icons(length(icons_last)+...
                            1:length(icons))~=0);
                        nsalesgrp1=length(find(ismember([iconchange; inewsales],...
                            find(ilotdmg1==1))==1));
                        nsalesgrp2=length(find(ismember([iconchange; inewsales],...
                            find(ilotdmg2==1))==1));
                        nsalesgrp3=length(find(ismember([iconchange; inewsales],...
                            find(ilotdmg3==1))==1));
                        
                        nsales(1,tt,irunset(strmset(irun)))=mat2cell([...
                            nsales{1,tt,irunset(strmset(irun))}; nsalesgrp1],...
                            length(nsales{1,tt,irunset(strmset(irun))})+1,1);
                        nsales(2,tt,irunset(strmset(irun)))=mat2cell([...
                            nsales{2,tt,irunset(strmset(irun))}; nsalesgrp2],...
                            length(nsales{2,tt,irunset(strmset(irun))})+1,1);
                        nsales(3,tt,irunset(strmset(irun)))=mat2cell([...
                            nsales{3,tt,irunset(strmset(irun))}; nsalesgrp3],...
                            length(nsales{3,tt,irunset(strmset(irun))})+1,1);
                    end
                end
                if isempty(find(cat(1,inscov{:,tt,irunset(strmset(irun))}),1))==0
                    if length(inscov(:,tt,irunset(strmset(irun)))) == ...
                            length(cat(1,inscov{:,tt,irunset(strmset(irun))}))
                        totinscov(1,tt,irunset(strmset(irun)))=mat2cell([...
                            totinscov{1,tt,irunset(strmset(irun))}; ...
                            sum(cat(1,inscov{:,tt,irunset(strmset(irun))}))],...
                            length(totinscov{1,tt,irunset(strmset(irun))})+1,1);
                    elseif length(inscov(:,tt,irunset(strmset(irun)))) < ...
                            length(cat(1,inscov{:,tt,irunset(strmset(irun))}))
                        subtotinscov=reshape(cat(1,inscov{:,tt,irunset(strmset(irun))}),...
                            length(cat(1,inscov{1,tt,irunset(strmset(irun))})),3);
                        totinscov(1,tt,irunset(strmset(irun)))=mat2cell(sum(subtotinscov,2),...
                            length(cat(1,inscov{1,tt,irunset(strmset(irun))})),1);
                    end
                end
                
            end
        end
    end
    % Aggregate results across runs for a given experimental parm set
    for it=1:length(tspan)
        rawrents(1,it)=mat2cell(cat(1,rents{1,it,runset{N}}),...
            length(cat(1,rents{1,it,runset{N}})),1);
        testrents=rawrents{1,it};
        ikeep=(testrents~=0);
        [murent,sigmarent,murentci,~]=normfit(log10(testrents(ikeep)));
        avgrents(1,it)=10^murent;
        avgrents_s(1,it)=10^sigmarent;
        avgrents_ci(1,it,:)=10.^murentci;
%         qq1=quantile(testrents(ikeep),[0.25 0.5 0.75]);
%         avgrents(1,it)=qq1(2);
% %         avgrents_s(1,it)=qq(;
%         avgrents_ci(1,it,:)=qq1([1 3]);
        rawrents(2,it)=mat2cell(cat(1,rents{2,it,runset{N}}),...
            length(cat(1,rents{2,it,runset{N}})),1);
        testrents=rawrents{2,it};
        ikeep=(testrents~=0);
        [murent,sigmarent,murentci,~]=normfit(log10(testrents(ikeep)));
        avgrents(2,it)=10^murent;
        avgrents_s(2,it)=10^sigmarent;
        avgrents_ci(2,it,:)=10.^murentci;
%         qq2=quantile(testrents(ikeep),[0.25 0.5 0.75]);
%         avgrents(2,it)=qq2(2);
% %         avgrents_s(2,it)=qq(;
%         avgrents_ci(2,it,:)=qq2([1 3]);
        rawrents(3,it)=mat2cell(cat(1,rents{3,it,runset{N}}),...
            length(cat(1,rents{3,it,runset{N}})),1);
        testrents=rawrents{3,it};
        ikeep=(testrents~=0);
        [murent,sigmarent,murentci,sigmarentci]=normfit(log10(testrents(ikeep)));
        avgrents(3,it)=10^murent;
        avgrents_s(3,it)=10^sigmarent;
        avgrents_ci(3,it,:)=10.^murentci;
%         qq3=quantile(testrents(ikeep),[0.25 0.5 0.75]);
%         avgrents(3,it)=qq3(2);
% %         avgrents_s(3,it)=qq(;
%         avgrents_ci(3,it,:)=qq3([1 3]);
        
        if it > 1
            rawrlct(1,it)=mat2cell(cat(1,rlct{1,it,runset{N}}),...
                length(cat(1,rlct{1,it,runset{N}})),1);
            [murlct,sigmarlct,murlctci,~]=normfit(cat(1,rlct{1,it,runset{N}}));
            avgrlct(1,it)=murlct;
            avgrlct_s(1,it)=sigmarlct;
            avgrlct_ci(1,it,:)=murlctci;
            rawrlct(2,it)=mat2cell(cat(1,rlct{2,it,runset{N}}),...
                length(cat(1,rlct{2,it,runset{N}})),1);
            [murlct,sigmarlct,murlctci,~]=normfit(cat(1,rlct{2,it,runset{N}}));
            avgrlct(2,it)=murlct;
            avgrlct_s(2,it)=sigmarlct;
            avgrlct_ci(2,it,:)=murlctci;
            rawrlct(3,it)=mat2cell(cat(1,rlct{3,it,runset{N}}),...
                length(cat(1,rlct{3,it,runset{N}})),1);
            [murlct,sigmarlct,murlctci,sigmarlctci]=normfit(cat(1,rlct{3,it,runset{N}}));
            avgrlct(3,it)=murlct;
            avgrlct_s(3,it)=sigmarlct;
            avgrlct_ci(3,it,:)=murlctci;
        end
        
        rawinscov(1,it)=mat2cell(cat(1,inscov{1,it,runset{N}}),...
            length(cat(1,inscov{1,it,runset{N}})),1);
        [muinscov,sigmainscov,muinscovci,~]=normfit(log10(cat(1,inscov{1,it,runset{N}})+0.1));
        avginscov(1,it)=10^muinscov-0.1;
        avginscov_s(1,it)=10^sigmainscov-0.1;
        avginscov_ci(1,it,:)=10.^muinscovci-0.1;
%         qq1=quantile(rawinscov{1,it},[0.25 0.5 0.75]);
%         avginscov(1,it)=qq1(2);
% %         avginscov_s(1,it)=10^sigmainscov-0.1;
%         avginscov_ci(1,it,:)=qq1([1 3]);
        rawinscov(2,it)=mat2cell(cat(1,inscov{2,it,runset{N}}),...
            length(cat(1,inscov{2,it,runset{N}})),1);
        [muinscov,sigmainscov,muinscovci,~]=...
            normfit(log10(cat(1,inscov{2,it,runset{N}})+0.1));
        avginscov(2,it)=10^muinscov-0.1;
        avginscov_s(2,it)=10^sigmainscov;
        avginscov_ci(2,it,:)=10.^muinscovci-0.1;
%         qq2=quantile(rawinscov{2,it},[0.25 0.5 0.75]);
%         avginscov(2,it)=qq2(2);
%         avginscov_s(1,it)=10^sigmainscov-0.1;
%         avginscov_ci(2,it,:)=qq2([1 3]);
        rawinscov(3,it)=mat2cell(cat(1,inscov{3,it,runset{N}}),...
            length(cat(1,inscov{3,it,runset{N}})),1);
        [muinscov,sigmainscov,muinscovci,sigmainscovci]=...
            normfit(log10(cat(1,inscov{3,it,runset{N}})+0.1));
        avginscov(3,it)=10^muinscov-0.1;
        avginscov_s(3,it)=10^sigmainscov;
        avginscov_ci(3,it,:)=10.^muinscovci-0.1;
%         qq3=quantile(rawinscov{3,it},[0.25 0.5 0.75]);
%         avginscov(3,it)=qq3(2);
% %         avginscov_s(3,it)=10^sigmainscov-0.1;
%         avginscov_ci(3,it,:)=qq3([1 3]);
        if isempty(find(cat(1,totinscov{1,it,runset{N}}),1))==0
            [mutot,sigtot,mutotci,sigtotci]=normfit(log10(cat(1,totinscov{1,it,runset{N}})+0.1));
            totinscov_avg(1,it,N)=10^mutot-0.1;
            totinscov_ci(:,it,N)=10.^mutotci-0.1;
        end
        rawnsales(1,it)=mat2cell(cat(1,nsales{1,it,runset{N}}),...
            length(cat(1,nsales{1,it,runset{N}})),1);
        avgnsales(1,it)=median(rawnsales{1,it});
        avgnsales_ci(1,it,:)=quantile(rawnsales{1,it},[0.025 0.975]);
        rawnsales(2,it)=mat2cell(cat(1,nsales{2,it,runset{N}}),...
            length(cat(1,nsales{2,it,runset{N}})),1);
        avgnsales(2,it)=median(rawnsales{2,it});
        avgnsales_ci(2,it,:)=quantile(rawnsales{2,it},[0.025 0.975]);
        rawnsales(3,it)=mat2cell(cat(1,nsales{3,it,runset{N}}),...
            length(cat(1,nsales{3,it,runset{N}})),1);
        avgnsales(3,it)=median(rawnsales{3,it});
        avgnsales_ci(3,it,:)=quantile(rawnsales{3,it},[0.025 0.975]);
        
        rawvacs(1,it)=mat2cell(cat(1,vacants{1,it,runset{N}}),...
            length(cat(1,vacants{1,it,runset{N}})),1);
        [muvac,sigmavac,muvacci,~]=normfit(rawvacs{1,it});
        avgvacant(1,it)=muvac;
        avgvacant_s(1,it)=sigmavac;
        avgvacant_ci(1,it,:)=muvacci;
        rawvacs(2,it)=mat2cell(cat(1,vacants{2,it,runset{N}}),...
            length(cat(1,vacants{2,it,runset{N}})),1);
        [muvac,sigmavac,muvacci,~]=normfit(rawvacs{2,it});
        avgvacant(2,it)=muvac;
        avgvacant_s(2,it)=sigmavac;
        avgvacant_ci(2,it,:)=muvacci;
        rawvacs(3,it)=mat2cell(cat(1,vacants{3,it,runset{N}}),...
            length(cat(1,vacants{3,it,runset{N}})),1);
        [muvac,sigmavac,muvacci,~]=normfit(rawvacs{3,it});
        avgvacant(3,it)=muvac;
        avgvacant_s(3,it)=sigmavac;
        avgvacant_ci(3,it,:)=muvacci;
        
        rawincomes(1,it)=mat2cell(cat(1,incomes{1,it,runset{N}}),...
            length(cat(1,incomes{1,it,runset{N}})),1);
        [muinc,sigmainc,muincci,~]=normfit(rawincomes{1,it});
        avgincomes(1,it)=muinc;
        avgincomes_s(1,it)=sigmainc;
        avgincomes_ci(1,it,:)=muincci;
        rawincomes(2,it)=mat2cell(cat(1,incomes{2,it,runset{N}}),...
            length(cat(1,incomes{2,it,runset{N}})),1);
        [muinc,sigmainc,muincci,~]=normfit(rawincomes{2,it});
        avgincomes(2,it)=muinc;
        avgincomes_s(2,it)=sigmainc;
        avgincomes_ci(2,it,:)=muincci;
        rawincomes(3,it)=mat2cell(cat(1,incomes{3,it,runset{N}}),...
            length(cat(1,incomes{3,it,runset{N}})),1);
        [muinc,sigmainc,muincci,~]=normfit(rawincomes{3,it});
        avgincomes(3,it)=muinc;
        avgincomes_s(3,it)=sigmainc;
        avgincomes_ci(3,it,:)=muincci;
    end
%     if N >= 4
%         keyboard
%     end
    filename=sprintf('dmgclass_results_ilandscape_011718_%s',runnamelabel{N});
    save(filename,'rents','nsales','incomes','inscov','rawrents','rawnsales', ...
        'rawincomes','rawinscov','avgrents','avgnsales','avgincomes',...
        'avginscov','totinscov_avg','totinscov_ci','rawrlct','avgrlct',...
        'avgvacant','avgvacant_ci','avginscov_ci','avgrents_ci')
    
    cd C:\Users\nrmagliocca\'Box Sync'\'Data Drive'\model_results\CHALMS_event_ilandscape_011718_popgrow\figs
    % plot rents by damage group
    hh1=figure;
    set(hh1,'Color','white','Visible','off')
    plot(tspan(2:length(tspan)),diff(avgrents(3,:)),'-k','LineWidth',3)
    %         xlim([min(tspan)-0.5 max(tspan)+0.5])
    hold on
    plot(tspan(2:length(tspan)),diff(avgrents(2,:)),'-b','LineWidth',3)
    plot(tspan(2:length(tspan)),diff(avgrents(1,:)),'-r','LineWidth',3)
    legend('Low Damage','Medium Damage','High Damage')
    errorbar(tspan(2:length(tspan)),diff(avgrents(3,:)),abs(diff(avgrents(3,:))-diff(avgrents_ci(3,:,1))),...
        abs(diff(avgrents(3,:))-diff(avgrents_ci(3,:,2))),'.k','LineWidth',1)
    errorbar(tspan(2:length(tspan)),diff(avgrents(2,:)),abs(diff(avgrents(2,:))-diff(avgrents_ci(2,:,1))),...
        abs(diff(avgrents(2,:))-diff(avgrents_ci(2,:,2))),'.b','LineWidth',1)
    errorbar(tspan(2:length(tspan)),diff(avgrents(1,:)),abs(diff(avgrents(1,:))-diff(avgrents_ci(1,:,1))),...
        abs(diff(avgrents(1,:))-diff(avgrents_ci(1,:,2))),'.r','LineWidth',1)
    set(gca,'Xtick',start_t:end_t)
    xlim([-3 3])
    if N == 7
        ylim([-1600 600])
%         ylim([-200 600]) %baseline
    elseif N == 8
        ylim([-1600 600])
%         ylim([-200 600]) %baseline
    elseif N == 2 || N == 4 || N == 6
        ylim([-600 400])
%         ylim([-200 300])  %baseline
    else
%         ylim([-200 300])    %baseline
        ylim([-600 400])
    end
    ylabel('Average Rent Change')
    xlabel('Time Since Storm')
    title(sprintf('Average Rent Change by Damage Category, %s',runnamelabel{N}))
    saveas(hh1,sprintf('avgrent_diff_dmg_new_%s',runnamelabel{N}),'jpg')
    clf
    
%     % plot rents by damage group
%     hh1_1=figure;
%     set(hh1_1,'Color','white','Visible','off')
%     plot(tspan,avgrents(3,:),'-k','LineWidth',3)
%     %         xlim([min(tspan)-0.5 max(tspan)+0.5])
%     hold on
%     plot(tspan,avgrents(2,:),'-b','LineWidth',3)
%     plot(tspan,avgrents(1,:),'-r','LineWidth',3)
%     legend('Low Damage','Medium Damage','High Damage')
%     errorbar(tspan,avgrents(3,:),avgrents_ci(3,:,1),...
%         avgrents_ci(3,:,2),'.k','LineWidth',1)
%     errorbar(tspan,avgrents(2,:),avgrents_ci(2,:,1),...
%         avgrents_ci(2,:,2),'.b','LineWidth',1)
%     errorbar(tspan,avgrents(1,:),avgrents_ci(1,:,1),...
%         avgrents_ci(1,:,2),'.r','LineWidth',1)
%     set(gca,'Xtick',start_t:end_t)
%     xlim([-4 4])
%     ylabel('Average Rent')
%     xlabel('Time Since Storm')
%     title(sprintf('Average Rent by Damage Category, %s',runnamelabel{N}))
%     saveas(hh1_1,sprintf('avgrent_dmg_%s',runnamelabel{N}),'jpg')
%     clf
%     
%     % plot number of sales by damage group
%     hh2=figure;
%     set(hh2,'Color','white','Visible','off')
%     plot(tspan(2:length(tspan)),diff(avgnsales(3,:)),'-k','LineWidth',3)
%     %         xlim([min(tspan)-0.5 max(tspan)+0.5])
%     hold on
%     plot(tspan(2:length(tspan)),diff(avgnsales(2,:)),'-b','LineWidth',3)
%     plot(tspan(2:length(tspan)),diff(avgnsales(1,:)),'-r','LineWidth',3)
%     legend('Low Damage','Medium Damage','High Damage')
%     errorbar(tspan(2:length(tspan)),diff(avgnsales(3,:)),diff(avgnsales_ci(3,:,1)),...
%         diff(avgnsales_ci(3,:,2)),'.k','LineWidth',1)
%     errorbar(tspan(2:length(tspan)),diff(avgnsales(2,:)),diff(avgnsales_ci(2,:,1)),...
%         diff(avgnsales_ci(2,:,2)),'.b','LineWidth',1)
%     errorbar(tspan(2:length(tspan)),diff(avgnsales(1,:)),diff(avgnsales_ci(1,:,1)),...
%         diff(avgnsales_ci(1,:,2)),'.r','LineWidth',1)
%     set(gca,'Xtick',start_t:end_t)
%     xlim([-4 4])
%     ylabel('Average Sales Change')
%     xlabel('Time Since Storm')
%     title(sprintf('Average Number of Home Sales by Damage Category, %s',runnamelabel{N}))
%     saveas(hh2,sprintf('avgnsales_diff_dmg_%s',runnamelabel{N}),'jpg')
%     clf
%     
%     % plot number of sales by damage group
%     hh2_1=figure;
%     set(hh2_1,'Color','white','Visible','off')
%     plot(tspan,avgnsales(3,:),'-k','LineWidth',3)
%     %         xlim([min(tspan)-0.5 max(tspan)+0.5])
%     hold on
%     plot(tspan,avgnsales(2,:),'-b','LineWidth',3)
%     plot(tspan,avgnsales(1,:),'-r','LineWidth',3)
%     legend('Low Damage','Medium Damage','High Damage')
%     errorbar(tspan,avgnsales(3,:),avgnsales_ci(3,:,1),...
%         avgnsales_ci(3,:,2),'.k','LineWidth',1)
%     errorbar(tspan,avgnsales(2,:),avgnsales_ci(2,:,1),...
%         avgnsales_ci(2,:,2),'.b','LineWidth',1)
%     errorbar(tspan,avgnsales(1,:),avgnsales_ci(1,:,1),...
%         avgnsales_ci(1,:,2),'.r','LineWidth',1)
%     set(gca,'Xtick',start_t:end_t)
%     xlim([-4 4])
%     ylabel('Average Number of Sales')
%     xlabel('Time Since Storm')
%     title(sprintf('Average Number of Home Sales by Damage Category, %s',runnamelabel{N}))
%     saveas(hh2_1,sprintf('avgnsales_dmg_%s',runnamelabel{N}),'jpg')
%     clf
%     
%     % plot vacancies by damage group
%     hh7=figure;
%     set(hh7,'Color','white','Visible','off')
%     plot(tspan(2:length(tspan)),diff(avgvacant(3,:)),'-k','LineWidth',3)
%     %         xlim([min(tspan)-0.5 max(tspan)+0.5])
%     hold on
%     plot(tspan(2:length(tspan)),diff(avgvacant(2,:)),'-b','LineWidth',3)
%     plot(tspan(2:length(tspan)),diff(avgvacant(1,:)),'-r','LineWidth',3)
%     legend('Low Damage','Medium Damage','High Damage')
%     errorbar(tspan(2:length(tspan)),diff(avgvacant(3,:)),diff(avgvacant_ci(3,:,1)),...
%         diff(avgvacant_ci(3,:,2)),'.k','LineWidth',1)
%     errorbar(tspan(2:length(tspan)),diff(avgvacant(2,:)),diff(avgvacant_ci(2,:,1)),...
%         diff(avgvacant_ci(2,:,2)),'.b','LineWidth',1)
%     errorbar(tspan(2:length(tspan)),diff(avgvacant(1,:)),diff(avgvacant_ci(1,:,1)),...
%         diff(avgvacant_ci(1,:,2)),'.r','LineWidth',1)
%     set(gca,'Xtick',start_t:end_t)
%     xlim([-4 4])
%     ylabel('Average Vacancies Change')
%     xlabel('Time Since Storm')
%     title(sprintf('Average Housing Vacancies by Damage Category, %s',runnamelabel{N}))
%     saveas(hh7,sprintf('avgvac_diff_dmg_%s',runnamelabel{N}),'jpg')
%     clf
%     
%     % plot vacancies by damage group
%     hh7_1=figure;
%     set(hh7_1,'Color','white','Visible','off')
%     plot(tspan,avgvacant(3,:),'-k','LineWidth',3)
%     %         xlim([min(tspan)-0.5 max(tspan)+0.5])
%     hold on
%     plot(tspan,avgvacant(2,:),'-b','LineWidth',3)
%     plot(tspan,avgvacant(1,:),'-r','LineWidth',3)
%     legend('Low Damage','Medium Damage','High Damage')
%     errorbar(tspan,avgvacant(3,:),avgvacant_ci(3,:,1),...
%         avgvacant_ci(3,:,2),'.k','LineWidth',1)
%     errorbar(tspan,avgvacant(2,:),avgvacant_ci(2,:,1),...
%         avgvacant_ci(2,:,2),'.b','LineWidth',1)
%     errorbar(tspan,avgvacant(1,:),avgvacant_ci(1,:,1),...
%         avgvacant_ci(1,:,2),'.r','LineWidth',1)
%     set(gca,'Xtick',start_t:end_t)
%     xlim([-4 4])
%     ylabel('Average Vacancies Change')
%     xlabel('Time Since Storm')
%     title(sprintf('Average Housing Vacancies by Damage Category, %s',runnamelabel{N}))
%     saveas(hh7_1,sprintf('avgvac_dmg_%s',runnamelabel{N}),'jpg')
%     clf
%     
%     % plot incomes by damage group
%     hh3=figure;
%     set(hh3,'Color','white','Visible','off')
%     plot(tspan(2:length(tspan)),diff(avgincomes(3,:)),'-k','LineWidth',3)
%     %         xlim([min(tspan)-0.5 max(tspan)+0.5])
%     hold on
%     plot(tspan(2:length(tspan)),diff(avgincomes(2,:)),'-b','LineWidth',3)
%     plot(tspan(2:length(tspan)),diff(avgincomes(1,:)),'-r','LineWidth',3)
%     legend('Low Damage','Medium Damage','High Damage')
%     errorbar(tspan(2:length(tspan)),diff(avgincomes(3,:)),diff(avgincomes_ci(3,:,1)),...
%         diff(avgincomes_ci(3,:,2)),'.k','LineWidth',1)
%     errorbar(tspan(2:length(tspan)),diff(avgincomes(2,:)),diff(avgincomes_ci(2,:,1)),...
%         diff(avgincomes_ci(2,:,2)),'.b','LineWidth',1)
%     errorbar(tspan(2:length(tspan)),diff(avgincomes(1,:)),diff(avgincomes_ci(1,:,1)),...
%         diff(avgincomes_ci(1,:,2)),'.r','LineWidth',1)
%     set(gca,'Xtick',start_t:end_t)
%     xlim([-4 4])
%     ylabel('Average Income Change')
%     xlabel('Time Since Storm')
%     title(sprintf('Average Household Income by Damage Category, %s',runnamelabel{N}))
%     saveas(hh3,sprintf('avginc_diff_dmg_%s',runnamelabel{N}),'jpg')
%     clf
%     
%     % plot incomes by damage group
%     hh3_1=figure;
%     set(hh3_1,'Color','white','Visible','off')
%     plot(tspan,avgincomes(3,:),'-k','LineWidth',3)
%     %         xlim([min(tspan)-0.5 max(tspan)+0.5])
%     hold on
%     plot(tspan,avgincomes(2,:),'-b','LineWidth',3)
%     plot(tspan,avgincomes(1,:),'-r','LineWidth',3)
%     legend('Low Damage','Medium Damage','High Damage')
%     errorbar(tspan,avgincomes(3,:),avgincomes_ci(3,:,1),...
%         avgincomes_ci(3,:,2),'.k','LineWidth',1)
%     errorbar(tspan,avgincomes(2,:),avgincomes_ci(2,:,1),...
%         avgincomes_ci(2,:,2),'.b','LineWidth',1)
%     errorbar(tspan,avgincomes(1,:),avgincomes_ci(1,:,1),...
%         avgincomes_ci(1,:,2),'.r','LineWidth',1)
%     set(gca,'Xtick',start_t:end_t)
%     xlim([-4 4])
%     ylabel('Average Income')
%     xlabel('Time Since Storm')
%     title(sprintf('Average Household Income by Damage Category, %s',runnamelabel{N}))
%     saveas(hh3_1,sprintf('avginc_dmg_%s',runnamelabel{N}),'jpg')
%     clf
    
    % plot insuarance policies by damage group
    hh4=figure;
    set(hh4,'Color','white','Visible','off')
    plot(tspan(2:length(tspan)),diff(avginscov(3,:)),'-k','LineWidth',3)
    %         xlim([min(tspan)-0.5 max(tspan)+0.5])
    hold on
    plot(tspan(2:length(tspan)),diff(avginscov(2,:)),'-b','LineWidth',3)
    plot(tspan(2:length(tspan)),diff(avginscov(1,:)),'-r','LineWidth',3)
    legend('Low Damage','Medium Damage','High Damage')
    errorbar(tspan(2:length(tspan)),diff(avginscov(3,:)),diff(avginscov_ci(3,:,1)),...
        diff(avginscov_ci(3,:,2)),'.k','LineWidth',1)
    errorbar(tspan(2:length(tspan)),diff(avginscov(2,:)),diff(avginscov_ci(2,:,1)),...
        diff(avginscov_ci(2,:,2)),'.b','LineWidth',1)
    errorbar(tspan(2:length(tspan)),diff(avginscov(1,:)),diff(avginscov_ci(1,:,1)),...
        diff(avginscov_ci(1,:,2)),'.r','LineWidth',1)
    set(gca,'Xtick',start_t:end_t)
    xlim([-3 3])
    ylabel('Average Insurance Policy Change')
    xlabel('Time Since Storm')
    title(sprintf('Average Change in Number of Insurance Policies by Damage Category, %s',runnamelabel{N}))
    saveas(hh4,sprintf('avgins_diff_dmg_%s',runnamelabel{N}),'jpg')
    clf
    
    %%% plot insurance policies by damage group
    %%% per captia conversion, relative to t=-1 to storm event
    %%% additional polcies per capita
    percaprate(:,:,N)=(avginscov-repmat(avginscov(:,5),1,length(tspan)))./...
        repmat(avginscov(:,5),1,length(tspan));
    percaprate_low(:,:,N)=(avginscov_ci(:,:,1)-repmat(avginscov_ci(:,5,1),1,length(tspan)))./...
        repmat(avginscov_ci(:,5,1),1,length(tspan));
    percaprate_hi(:,:,N)=(avginscov_ci(:,:,2)-repmat(avginscov_ci(:,5,2),1,length(tspan)))./...
        repmat(avginscov_ci(:,5,2),1,length(tspan));
    hh4_1=figure;
    set(hh4_1,'Color','white','Visible','off')
%     plot(tspan,avginscov(3,:),'-k','LineWidth',3)
%     hold on
%     plot(tspan,avginscov(2,:),'-b','LineWidth',3)
%     plot(tspan,avginscov(1,:),'-r','LineWidth',3)
    plot(tspan,percaprate(3,:,N),'-k','LineWidth',3)
    hold on
    plot(tspan,percaprate(2,:,N),'-b','LineWidth',3)
    plot(tspan,percaprate(1,:,N),'-r','LineWidth',3)
    ax=gca;
%     if N >=7
%         ax.YLim=([0 1000]);
%     else
%         ax.YLim=([0 200]);
%     end
    ax.YLim=([0 5]);
    legend('Low Damage','Medium Damage','High Damage')
%     errorbar(tspan,avginscov(3,:),avginscov(3,:)-avginscov_ci(3,:,1),...
%         avginscov_ci(3,:,2)-avginscov(3,:),'.k','LineWidth',1)
%     errorbar(tspan,avginscov(2,:),avginscov(2,:)-avginscov_ci(2,:,1),...
%         avginscov_ci(2,:,2)-avginscov(2,:),'.b','LineWidth',1)
%     errorbar(tspan,avginscov(1,:),avginscov(1,:)-avginscov_ci(1,:,1),...
%         avginscov_ci(1,:,2)-avginscov(1,:),'.r','LineWidth',1)
    errorbar(tspan,percaprate(3,:,N),abs(percaprate(3,:,N)-percaprate_low(3,:,N)),...
        abs(percaprate(3,:,N)-percaprate_hi(3,:,N)),'.k','LineWidth',1)
    errorbar(tspan,percaprate(2,:,N),abs(percaprate(2,:,N)-percaprate_low(2,:,N)),...
        abs(percaprate(2,:,N)-percaprate_hi(2,:,N)),'.b','LineWidth',1)
    errorbar(tspan,percaprate(1,:,N),abs(percaprate(1,:,N)-percaprate_low(1,:,N)),...
        abs(percaprate(1,:,N)-percaprate_hi(1,:,N)),'.r','LineWidth',1)
    set(gca,'Xtick',start_t:end_t)
    xlim([-3 3])
    ylabel('Average Insurance Policies')
    xlabel('Time Since Storm')
    title(sprintf('Average Number of Insurance Policies by Damage Category, %s',runnamelabel{N}))
    saveas(hh4_1,sprintf('avgins_dmg_new_%s',runnamelabel{N}),'jpg')
    clf
    
    % plot insuarance policies by damage group
    hh4_2=figure;
    set(hh4_2,'Color','white','Visible','off')
    plot(tspan,avginscov(3,:),'-k','LineWidth',3)
    %         xlim([min(tspan)-0.5 max(tspan)+0.5])
    hold on
    plot(tspan,avginscov(2,:),'-b','LineWidth',3)
    plot(tspan,avginscov(1,:),'-r','LineWidth',3)
    if N >= 7
        ylim([0 0.42])
    elseif N == 5 || N == 6
        ylim([0 0.031])
    else
        ylim([0 0.01])
    end
    legend('Low Damage','Medium Damage','High Damage')
    errorbar(tspan,avginscov(3,:),avginscov(3,:)-avginscov_ci(3,:,1),...
        avginscov_ci(3,:,2)-avginscov(3,:),'.k','LineWidth',1)
    errorbar(tspan,avginscov(2,:),avginscov(2,:)-avginscov_ci(2,:,1),...
        avginscov_ci(2,:,2)-avginscov(2,:),'.b','LineWidth',1)
    errorbar(tspan,avginscov(1,:),avginscov(1,:)-avginscov_ci(1,:,1),...
        avginscov_ci(1,:,2)-avginscov(1,:),'.r','LineWidth',1)
    set(gca,'Xtick',start_t:end_t)
    xlim([-3 3])
    ylabel('Average Insurance Policy Change')
    xlabel('Time Since Storm')
    title(sprintf('Average Number of Insurance Policies by Damage Category, %s',runnamelabel{N}))
    saveas(hh4_2,sprintf('avgins_tot_dmg_%s',runnamelabel{N}),'jpg')
    clf
    
%     % plot average relocations by damage group
%     hh6=figure;
%     set(hh6,'Color','white','Visible','off')
%     plot(tspan(2:length(tspan)),diff(avgrlct(3,:)),'-k','LineWidth',3)
%     %         xlim([min(tspan)-0.5 max(tspan)+0.5])
%     hold on
%     plot(tspan(2:length(tspan)),diff(avgrlct(2,:)),'-b','LineWidth',3)
%     plot(tspan(2:length(tspan)),diff(avgrlct(1,:)),'-r','LineWidth',3)
%     legend('Low Damage','Medium Damage','High Damage')
%     errorbar(tspan(2:length(tspan)),diff(avgrlct(3,:)),diff(avgrlct_ci(3,:,1)),...
%         diff(avgrlct_ci(3,:,2)),'.k','LineWidth',1)
%     errorbar(tspan(2:length(tspan)),diff(avgrlct(2,:)),diff(avgrlct_ci(2,:,1)),...
%         diff(avgrlct_ci(2,:,2)),'.b','LineWidth',1)
%     errorbar(tspan(2:length(tspan)),diff(avgrlct(1,:)),diff(avgrlct_ci(1,:,1)),...
%         diff(avgrlct_ci(1,:,2)),'.r','LineWidth',1)
%     set(gca,'Xtick',start_t:end_t)
%     xlim([-4 4])
%     ylabel('Average Change in Relocations')
%     xlabel('Time Since Storm')
%     title(sprintf('Average Relocations by Damage Category, %s',runnamelabel{N}))
%     saveas(hh6,sprintf('avgrlct_diff_dmg_%s',runnamelabel{N}),'jpg')
%     clf
%     
%     hh6_1=figure;
%     set(hh6_1,'Color','white','Visible','off')
%     plot(tspan,avgrlct(3,:),'-k','LineWidth',3)
%     %         xlim([min(tspan)-0.5 max(tspan)+0.5])
%     hold on
%     plot(tspan,avgrlct(2,:),'-b','LineWidth',3)
%     plot(tspan,avgrlct(1,:),'-r','LineWidth',3)
%     legend('Low Damage','Medium Damage','High Damage')
%     errorbar(tspan,avgrlct(3,:),avgrlct_ci(3,:,1),...
%         avgrlct_ci(3,:,2),'.k','LineWidth',1)
%     errorbar(tspan,avgrlct(2,:),avgrlct_ci(2,:,1),...
%         avgrlct_ci(2,:,2),'.b','LineWidth',1)
%     errorbar(tspan,avgrlct(1,:),avgrlct_ci(1,:,1),...
%         avgrlct_ci(1,:,2),'.r','LineWidth',1)
%     set(gca,'Xtick',start_t:end_t)
%     xlim([-4 4])
%     ylabel('Average Relocations')
%     xlabel('Time Since Storm')
%     title(sprintf('Average Relocations by Damage Category, %s',runnamelabel{N}))
%     saveas(hh6_1,sprintf('avgrlct_dmg_%s',runnamelabel{N}),'jpg')
%     clf
    
    cd C:\Users\nrmagliocca\'Box Sync'\'Data Drive'\model_results\CHALMS_event_ilandscape_011718_popgrow
end

% cd X:\model_results\CHALMS_event_ilandscape_030617_rnd\figs
% 
% hh5=figure;
% set(hh5,'Color','white','Visible','off')
% plot(tspan,totinscov_avg(1,:,2),'-k','LineWidth',3)
% hold on
% plot(tspan,totinscov_avg(1,:,4),'-b','LineWidth',3)
% legend('Expected Utility','Salience')
% errorbar(tspan,totinscov_avg(1,:,2),totinscov_ci(1,:,2),...
%     totinscov_ci(2,:,2),'.k','LineWidth',1)
% errorbar(tspan,totinscov_avg(1,:,4),totinscov_ci(1,:,4),...
%     totinscov_ci(2,:,4),'.b','LineWidth',1)
% set(gca,'Xtick',start_t:end_t)
% xlim([-4 4])
% ylabel('Average Insurance Policies')
% xlabel('Time Since Storm')
% title(sprintf('Average Number of Insurance Policies'))
% saveas(hh5,'totinscov','jpg')

