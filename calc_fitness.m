function [score,p_rents,p_inscov] = calc_fitness(MRUNS,g_id,ind_id,TSTART,TMAX,CDIST)

% % % % % test set
% g_id=0;
% ind_id=10;
MRUNS=30;
TSTART=10;
TMAX=30;
NWIDTH=80;
NLENGTH=80;
CDIST=repmat((NWIDTH+1)-(1:NWIDTH),NLENGTH,1);

%%%%%%%%%%%%%%   CHALMS Coast Fitness Code   %%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Purpose of code is to extract targeted results from multiple model runs
%%% under the same experimental settings, compare results to target
%%% patterns for pattern-oriented modeling approach, and provide 'fitness'
%%% score to hierarchical genetic algorithm (HGA).
%%%
%%% Target patterns for fitness evaluation:
%%% 1. Percent change in housing prices immediately after storm
%%% 2. Percent change in insurance policy uptake immediately after storm
%%% 3. Average rates of housing sales per year
%%%
%%% Output: A MRUNSx1 vector of fitness scores for each member (i.e., model
%%% run) of the population size = MRUNS in one generation (erun = 1:ERUNS)
%%% 

% navigate to results file storage
cd X:\model_results\CHALMS_event_hga_030917
fnames=dir;
fnamescell=struct2cell(fnames);
% (2) change the prefix of the results file names
if g_id < 10 && ind_id < 10
    h=strncmp(sprintf('coast_event_simple_%d_%d_',g_id,ind_id),fnamescell(1,:),23);
elseif g_id < 10 && ind_id >= 10 && ind_id < 100
    h=strncmp(sprintf('coast_event_simple_%d_%d_',g_id,ind_id),fnamescell(1,:),24);
elseif g_id < 10 && ind_id >= 100
    h=strncmp(sprintf('coast_event_simple_%d_%d_',g_id,ind_id),fnamescell(1,:),25);
elseif g_id >=10 && g_id < 100 && ind_id < 10
    h=strncmp(sprintf('coast_event_simple_%d_%d_',g_id,ind_id),fnamescell(1,:),24);
elseif g_id >=10 && g_id < 100 && ind_id >= 10 && ind_id < 100
    h=strncmp(sprintf('coast_event_simple_%d_%d_',g_id,ind_id),fnamescell(1,:),25);
elseif g_id >=10 && g_id < 100 && ind_id >= 100
    h=strncmp(sprintf('coast_event_simple_%d_%d_',g_id,ind_id),fnamescell(1,:),26);
elseif g_id >=100 && ind_id < 10
    h=strncmp(sprintf('coast_event_simple_%d_%d_',g_id,ind_id),fnamescell(1,:),25);
elseif g_id >=100 && ind_id >= 10 && ind_id < 100
    h=strncmp(sprintf('coast_event_simple_%d_%d_',g_id,ind_id),fnamescell(1,:),26);    
else
    h=strncmp(sprintf('coast_event_simple_%d_%d_',g_id,ind_id),fnamescell(1,:),27);
end
hind=find(h==1);

% batchind=[reshape(repmat(1:ERUNS,MRUNS,1),MRUNS*ERUNS,1) ...
%     repmat((1:MRUNS)',ERUNS,1)];
% batchind=[repmat(g_id,MRUNS,1) (1:MRUNS)'];
% runset=mat2cell(reshape(1:MRUNS*ERUNS,MRUNS,ERUNS)',ones(ERUNS,1),MRUNS);
dmgclass=3;

% time specs for before/after storm analysis
start_t=-5;
end_t=5;
realt=TSTART:TMAX;
tspan=start_t:end_t;

idmggroup_hi=find(CDIST == 1);  %waterfront
idmggroup_md=find(CDIST > 1 & CDIST <= 5); %waterview
idmggroup_lw=find(CDIST > 5);  %low to moderate risk

% Variables to extract from model results
strmocc=zeros(length(hind),TMAX);
Lotrent=cell(1,length(hind));
Lotcon=cell(1,length(hind));
Lotinc=cell(1,length(hind));
Lotins=cell(1,length(hind));
Lotlocate=cell(1,length(hind));
Lotincome=cell(1,length(hind));

rents=cell(dmgclass,length(tspan),MRUNS);
aggrents=cell(1,length(tspan),MRUNS);
nsales=cell(dmgclass,length(tspan),MRUNS);
allsales_pct=cell(1,length(tspan),MRUNS);
% incomes=cell(dmgclass,length(tspan),MRUNS);
inscov=cell(dmgclass,length(tspan),MRUNS);
totinscov=cell(1,length(tspan),MRUNS);
totinscov_cap=cell(1,length(tspan),MRUNS);
tothouses=cell(1,length(tspan),MRUNS);
allhouses=cell(1,length(tspan),MRUNS);
incomes=cell(dmgclass,length(tspan),MRUNS);
vacants=cell(dmgclass,length(tspan),MRUNS);


% rawrents=cell(dmgclass,length(tspan));
% rawnsales=cell(dmgclass,length(tspan));
% rawincomes=cell(dmgclass,length(tspan));
% rawinscov=cell(dmgclass,length(tspan));
% rawvacs=cell(dmgclass,length(tspan));

avgrents=zeros(dmgclass,length(tspan));
avgrents_s=zeros(dmgclass,length(tspan));
avgrents_ci=zeros(dmgclass,length(tspan),2);
avgnsales=zeros(dmgclass,length(tspan));
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
% totinscov_avg=zeros(1,length(tspan));
% totinscov_ci=zeros(2,length(tspan));
% totinscovcap_avg=zeros(1,length(tspan));
% totinscovcap_ci=zeros(2,length(tspan));

% Fitness variables
% p_nsales=zeros(MRUNS,1);
% ks_nsales=zeros(MRUNS,1);
% p_rents=zeros(MRUNS,1);
% t_rents=zeros(MRUNS,1);
% p_inscov=zeros(MRUNS,1);
% t_inscov=zeros(MRUNS,1);
avgrunrents=zeros(MRUNS,length(tspan));
avgruninscov=zeros(MRUNS,length(tspan));

% Extract data from model results
for mr=1:length(hind)   % MRUNS*EXPTRUNS
%     h=strcmp(sprintf('coast_event_simple_%d_%d',g_id,ind_id),fnamescell(1,:));
    filename=fnamescell{1,hind(mr)};
    load(filename)
    
    Lotrent{mr}=LOTRENT;
    Lotcon{mr}=LOTCON;
    Lotinc{mr}=LOTINC;
    Lotins{mr}=LOTINS;
    Lotlocate(mr)=mat2cell(lotlocate,length(lotlocate),2);
    Lotincome(mr)=mat2cell(cat(1,CONINFO{:,1}),length(CONINFO),1); % CONINFO loaded from results files
    strmocc(mr,:)=stormoccur;
end

% for N=1:ERUNS
% Identify time steps in which storms occur and build time before/after
% storm vectors
% strms_base=strmocc(runset{N},:);
strms_base=strmocc;
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
            multistrm(1)=mat2cell([multistrm{1}; srun],length(multistrm{1})+1,1);
            multistrm(2)=mat2cell([multistrm{2}; (1:TMAX)-istrm(s)],...
                length(multistrm{1}),TMAX);
        end
        substrmt=multistrm{2};
        tslice_before=zeros(1,TMAX);
        tslice_after=zeros(1,TMAX);
        for tt=1:TMAX
            tslice=substrmt(:,tt);
            if isempty(find(tslice <= 0,1))==0
                tslice_before(tt)=max(tslice(tslice <= 0));
            end
            if isempty(find(tslice >= 0,1))==0
                tslice_after(tt)=min(tslice(tslice >= 0));
            end
        end
        tslice_before(tslice_before==0)=tslice_after(tslice_before==0);
        tslice_after(tslice_after==0)=tslice_before(tslice_after==0);
        strmrcd=[tslice_before; tslice_after];
        subse2=strm_event{2};
        strm_event(1)=mat2cell([strm_event{1}; srun*ones(2,1)],...
            length(strm_event{1})+2,1);
        if isempty(find(strm_event{2},1))==1
            strm_event(2)=mat2cell([strm_event{2}; strmrcd],...
                length(strm_event{2})+2,TMAX);
        else
            strm_event(2)=mat2cell([strm_event{2}; strmrcd],...
                length(subse2(:,1))+2,TMAX);
        end
    end
end

%%% Assemble storm event data
strm_times=strm_event{2};
strm_runs=strm_event{1};
strm_t=strm_times(:,TSTART:TMAX);
runtimes=cell(1,length(unique(strm_runs)));
strmset=unique(strm_runs);
for jrun=1:length(strmset)
    runtimes(jrun)=mat2cell([max(strm_t(strm_runs==strmset(jrun),:),[],1); ...
        min(strm_t(strm_runs==strmset(jrun),:),[],1)],2,length(strm_t(1,:)));
end

for irun=1:length(strmset)
    subrents=Lotrent{strmset(irun)};    %rents for existing lots for all timesteps
    subconid=Lotcon{strmset(irun)}; %consumers for existing lots for all timesteps
    sublotloc=Lotlocate{strmset(irun)}; %location vector for lots at end of model runs
    sublotinc=Lotinc{strmset(irun)};    %income of consumers in existing lots for all timesteps
    sublotins=Lotins{strmset(irun)};    %number of consumers choosing insurance in existing lots for all timesteps
    for tt=1:length(tspan)
        substrm_t=runtimes{irun};
        [~,col]=find(substrm_t==tspan(tt));
        id=unique(col);
        if isempty(find(id,1))==1
            continue
        else
            for ii=1:length(id)
                irents=subrents{realt(id(ii))};  %identify which lots were present at the specified timestep
                ilotins=sublotins{realt(id(ii))};
                ilotinc=sublotinc{realt(id(ii))};
                icons=subconid{realt(id(ii))};
                icons_last=subconid{realt(id(ii))-1};
                
%                 tothouses(1,tt,irunset(strmset(irun)))=mat2cell([...
%                     tothouses{1,tt,irunset(strmset(irun))}; length(find(ilotinc~=0))],...
%                     length(tothouses{1,tt,irunset(strmset(irun))})+1,1);
                tothouses(1,tt,strmset(irun))=mat2cell([...
                    tothouses{1,tt,strmset(irun)}; length(find(ilotinc~=0))],...
                    length(tothouses{1,tt,strmset(irun)})+1,1);
                allhouses(1,tt,strmset(irun))=mat2cell([...
                    allhouses{1,tt,strmset(irun)}; length(irents)],...
                    length(allhouses{1,tt,strmset(irun)})+1,1);
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
                    
                rents(1,tt,strmset(irun))=mat2cell([...
                    rents{1,tt,strmset(irun)}; ...
                    irents(sublotloc(inotzero1,1))],...
                    length(rents{1,tt,strmset(irun)})+...
                    length(irents(sublotloc(inotzero1,1))),1);
                rents(2,tt,strmset(irun))=mat2cell([...
                    rents{2,tt,strmset(irun)}; ...
                    irents(sublotloc(inotzero2,1))],...
                    length(rents{2,tt,strmset(irun)})+...
                    length(irents(sublotloc(inotzero2,1))),1);
                rents(3,tt,strmset(irun))=mat2cell([...
                    rents{3,tt,strmset(irun)}; ...
                    irents(sublotloc(inotzero3,1))],...
                    length(rents{3,tt,strmset(irun)})+...
                    length(irents(sublotloc(inotzero3,1))),1);
                aggrents(1,tt,strmset(irun))=mat2cell(...
                    cat(1,rents{:,tt,strmset(irun)}),...
                    length(cat(1,rents{:,tt,strmset(irun)})),1);
                    
                inscov(1,tt,strmset(irun))=mat2cell([...
                    inscov{1,tt,strmset(irun)}; ...
                    sum(ilotins(sublotloc(inotzero1,1)))/...
                    length(irents(sublotloc(inotzero1,1)))],...
                    length(inscov{1,tt,strmset(irun)})+1,1);
                inscov(2,tt,strmset(irun))=mat2cell([...
                    inscov{2,tt,strmset(irun)}; ...
                    sum(ilotins(sublotloc(inotzero2,1)))/...
                    length(irents(sublotloc(inotzero2,1)))],...
                    length(inscov{2,tt,strmset(irun)})+1,1);
                inscov(3,tt,strmset(irun))=mat2cell([...
                    inscov{3,tt,strmset(irun)}; ...
                    sum(ilotins(sublotloc(ilotdmg3,1)))/...
                    length(irents(sublotloc(inotzero3,1)))],...
                    length(inscov{3,tt,strmset(irun)})+1,1);
                
                vacants(1,tt,strmset(irun))=mat2cell([...
                    vacants{1,tt,strmset(irun)}; ...
                    length(find(ivac1==1))],length(vacants{1,tt,strmset(irun)})+1,1);
                vacants(2,tt,strmset(irun))=mat2cell([...
                    vacants{2,tt,strmset(irun)}; ...
                    length(find(ivac2==1))],length(vacants{2,tt,strmset(irun)})+1,1);
                vacants(3,tt,strmset(irun))=mat2cell([...
                    vacants{3,tt,strmset(irun)}; ...
                    length(find(ivac3==1))],length(vacants{3,tt,strmset(irun)})+1,1);
                    
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
                    totsales=nsalesgrp1+nsalesgrp2+nsalesgrp3;
                    
                    nsales(1,tt,strmset(irun))=mat2cell([...
                        nsales{1,tt,strmset(irun)}; nsalesgrp1],...
                        length(nsales{1,tt,strmset(irun)})+1,1);
                    nsales(2,tt,strmset(irun))=mat2cell([...
                        nsales{2,tt,strmset(irun)}; nsalesgrp2],...
                        length(nsales{2,tt,strmset(irun)})+1,1);
                    nsales(3,tt,strmset(irun))=mat2cell([...
                        nsales{3,tt,strmset(irun)}; nsalesgrp3],...
                        length(nsales{3,tt,strmset(irun)})+1,1);
                    allsales_pct(1,tt,strmset(irun))=mat2cell([...
                        allsales_pct{1,tt,strmset(irun)}; ...
                        totsales/length(irents)],...
                        length(allsales_pct{1,tt,strmset(irun)})+1,1);
                end
            end
            if isempty(find(cat(1,inscov{:,tt,strmset(irun)}),1))==0
                if length(inscov(:,tt,strmset(irun))) == ...
                        length(cat(1,inscov{:,tt,strmset(irun)}))
                    totinscov(1,tt,strmset(irun))=mat2cell([...
                        totinscov{1,tt,strmset(irun)}; ...
                        sum(cat(1,inscov{:,tt,strmset(irun)}))],...
                        length(totinscov{1,tt,strmset(irun)})+1,1);
                    % insurance policies per capita
                    totinscov_cap(1,tt,strmset(irun))=mat2cell([...
                        totinscov_cap{1,tt,strmset(irun)}; ...
                        sum(cat(1,inscov{:,tt,strmset(irun)}))/...
                        tothouses{1,tt,strmset(irun)}],...
                        length(totinscov_cap{1,tt,strmset(irun)})+1,1);
                elseif length(inscov(:,tt,strmset(irun))) < ...
                        length(cat(1,inscov{:,tt,strmset(irun)}))
                    subtotinscov=reshape(cat(1,inscov{:,tt,strmset(irun)}),...
                        length(cat(1,inscov{1,tt,strmset(irun)})),3);
                    totinscov(1,tt,strmset(irun))=mat2cell(sum(subtotinscov,2),...
                        length(cat(1,inscov{1,tt,strmset(irun)})),1);
                    % insurance policies per capita
                    totinscov_cap(1,tt,strmset(irun))=mat2cell([...
                        totinscov_cap{1,tt,strmset(irun)}; ...
                        mean(sum(subtotinscov,2)./tothouses{1,tt,strmset(irun)})],...
                        length(totinscov_cap{1,tt,strmset(irun)})+1,1);
                end
            end
        end
    end
end
% % May need to aggregate results across runs for a given experimental parm set
% for it=1:length(tspan)
% rawrents(1,it)=mat2cell(cat(1,rents{1,it,:}),...
%             length(cat(1,rents{1,it,:})),1);
%         testrents=rawrents{1,it};
%         ikeep=(testrents~=0);
%         [murent,sigmarent,murentci,~]=normfit(log10(testrents(ikeep)));
%         avgrents(1,it)=10^murent;
%         avgrents_s(1,it)=10^sigmarent;
%         avgrents_ci(1,it,:)=10.^murentci;
% %         qq1=quantile(testrents(ikeep),[0.25 0.5 0.75]);
% %         avgrents(1,it)=qq1(2);
% % %         avgrents_s(1,it)=qq(;
% %         avgrents_ci(1,it,:)=qq1([1 3]);
%         rawrents(2,it)=mat2cell(cat(1,rents{2,it,:}),...
%             length(cat(1,rents{2,it,:})),1);
%         testrents=rawrents{2,it};
%         ikeep=(testrents~=0);
%         [murent,sigmarent,murentci,~]=normfit(log10(testrents(ikeep)));
%         avgrents(2,it)=10^murent;
%         avgrents_s(2,it)=10^sigmarent;
%         avgrents_ci(2,it,:)=10.^murentci;
% %         qq2=quantile(testrents(ikeep),[0.25 0.5 0.75]);
% %         avgrents(2,it)=qq2(2);
% % %         avgrents_s(2,it)=qq(;
% %         avgrents_ci(2,it,:)=qq2([1 3]);
%         rawrents(3,it)=mat2cell(cat(1,rents{3,it,:}),...
%             length(cat(1,rents{3,it,:})),1);
%         testrents=rawrents{3,it};
%         ikeep=(testrents~=0);
%         [murent,sigmarent,murentci,~]=normfit(log10(testrents(ikeep)));
%         avgrents(3,it)=10^murent;
%         avgrents_s(3,it)=10^sigmarent;
%         avgrents_ci(3,it,:)=10.^murentci;
% %         qq3=quantile(testrents(ikeep),[0.25 0.5 0.75]);
% %         avgrents(3,it)=qq3(2);
% % %         avgrents_s(3,it)=qq(;
% %         avgrents_ci(3,it,:)=qq3([1 3]);
%        
%         
%         rawinscov(1,it)=mat2cell(cat(1,inscov{1,it,:}),...
%             length(cat(1,inscov{1,it,:})),1);
%         [muinscov,sigmainscov,muinscovci,~]=normfit(log10(cat(1,inscov{1,it,:})+0.1));
%         avginscov(1,it)=10^muinscov-0.1;
%         avginscov_s(1,it)=10^sigmainscov-0.1;
%         avginscov_ci(1,it,:)=10.^muinscovci-0.1;
% %         qq1=quantile(rawinscov{1,it},[0.25 0.5 0.75]);
% %         avginscov(1,it)=qq1(2);
% % %         avginscov_s(1,it)=10^sigmainscov-0.1;
% %         avginscov_ci(1,it,:)=qq1([1 3]);
%         rawinscov(2,it)=mat2cell(cat(1,inscov{2,it,:}),...
%             length(cat(1,inscov{2,it,:})),1);
%         [muinscov,sigmainscov,muinscovci,~]=...
%             normfit(log10(cat(1,inscov{2,it,:})+0.1));
%         avginscov(2,it)=10^muinscov-0.1;
%         avginscov_s(2,it)=10^sigmainscov;
%         avginscov_ci(2,it,:)=10.^muinscovci-0.1;
% %         qq2=quantile(rawinscov{2,it},[0.25 0.5 0.75]);
% %         avginscov(2,it)=qq2(2);
% %         avginscov_s(1,it)=10^sigmainscov-0.1;
% %         avginscov_ci(2,it,:)=qq2([1 3]);
%         rawinscov(3,it)=mat2cell(cat(1,inscov{3,it,:}),...
%             length(cat(1,inscov{3,it,:})),1);
%         [muinscov,sigmainscov,muinscovci,~]=...
%             normfit(log10(cat(1,inscov{3,it,:})+0.1));
%         avginscov(3,it)=10^muinscov-0.1;
%         avginscov_s(3,it)=10^sigmainscov;
%         avginscov_ci(3,it,:)=10.^muinscovci-0.1;
% %         qq3=quantile(rawinscov{3,it},[0.25 0.5 0.75]);
% %         avginscov(3,it)=qq3(2);
% % %         avginscov_s(3,it)=10^sigmainscov-0.1;
% %         avginscov_ci(3,it,:)=qq3([1 3]);
%         
%         rawnsales(1,it)=mat2cell(cat(1,nsales{1,it,:}),...
%             length(cat(1,nsales{1,it,:})),1);
%         avgnsales(1,it)=median(rawnsales{1,it});
%         avgnsales_ci(1,it,:)=quantile(rawnsales{1,it},[0.025 0.975]);
%         rawnsales(2,it)=mat2cell(cat(1,nsales{2,it,:}),...
%             length(cat(1,nsales{2,it,:})),1);
%         avgnsales(2,it)=median(rawnsales{2,it});
%         avgnsales_ci(2,it,:)=quantile(rawnsales{2,it},[0.025 0.975]);
%         rawnsales(3,it)=mat2cell(cat(1,nsales{3,it,:}),...
%             length(cat(1,nsales{3,it,:})),1);
%         avgnsales(3,it)=median(rawnsales{3,it});
%         avgnsales_ci(3,it,:)=quantile(rawnsales{3,it},[0.025 0.975]);
%         
%         rawvacs(1,it)=mat2cell(cat(1,vacants{1,it,:}),...
%             length(cat(1,vacants{1,it,:})),1);
%         [muvac,sigmavac,muvacci,~]=normfit(rawvacs{1,it});
%         avgvacant(1,it)=muvac;
%         avgvacant_s(1,it)=sigmavac;
%         avgvacant_ci(1,it,:)=muvacci;
%         rawvacs(2,it)=mat2cell(cat(1,vacants{2,it,:}),...
%             length(cat(1,vacants{2,it,:})),1);
%         [muvac,sigmavac,muvacci,~]=normfit(rawvacs{2,it});
%         avgvacant(2,it)=muvac;
%         avgvacant_s(2,it)=sigmavac;
%         avgvacant_ci(2,it,:)=muvacci;
%         rawvacs(3,it)=mat2cell(cat(1,vacants{3,it,:}),...
%             length(cat(1,vacants{3,it,:})),1);
%         [muvac,sigmavac,muvacci,~]=normfit(rawvacs{3,it});
%         avgvacant(3,it)=muvac;
%         avgvacant_s(3,it)=sigmavac;
%         avgvacant_ci(3,it,:)=muvacci;
%         
%         rawincomes(1,it)=mat2cell(cat(1,incomes{1,it,:}),...
%             length(cat(1,incomes{1,it,:})),1);
%         [muinc,sigmainc,muincci,~]=normfit(rawincomes{1,it});
%         avgincomes(1,it)=muinc;
%         avgincomes_s(1,it)=sigmainc;
%         avgincomes_ci(1,it,:)=muincci;
%         rawincomes(2,it)=mat2cell(cat(1,incomes{2,it,:}),...
%             length(cat(1,incomes{2,it,:})),1);
%         [muinc,sigmainc,muincci,~]=normfit(rawincomes{2,it});
%         avgincomes(2,it)=muinc;
%         avgincomes_s(2,it)=sigmainc;
%         avgincomes_ci(2,it,:)=muincci;
%         rawincomes(3,it)=mat2cell(cat(1,incomes{3,it,:}),...
%             length(cat(1,incomes{3,it,:})),1);
%         [muinc,sigmainc,muincci,~]=normfit(rawincomes{3,it});
%         avgincomes(3,it)=muinc;
%         avgincomes_s(3,it)=sigmainc;
%         avgincomes_ci(3,it,:)=muincci;
% end

%%% Fitness score calculation
% Housing prices
%-0.0421 (0.0135) change in housing prices post-storm (Walls and Chu)


% Insurance uptake

%%% Number of sales
% MD property view data: Worcester, Somerset, Wicomico, Dorchester, Talbot,...
% Queen Anne's,Kent,Cecil,Harford,Bmore Co.,Anne Arundel,Calvert, St. Mary's, Charles
empnsales=[0.0052 0.0059 0.0055 0.0057 0.0054 0.0033 0.0029 0.0020 0.0018 ...
    0.0018 0.0018 0.0021 0.0025 0.0026 0.0034 0.0039 0.0044 0.0050 0.0052 ... 
    0.0046 0.0032 0.0020 0.0014 0.0013 0.0012 0.0012 0.0016 0.0016 0.0037 ...
    0.0050 0.0053 0.0059 0.0055 0.0041 0.0033 0.0020 0.0013 0.0017 0.0016 ... 
    0.0018 0.0021 0.0022 0.0045 0.0053 0.0054 0.0059 0.0058 0.0049 0.0039 ...
    0.0027 0.0026 0.0023 0.0022 0.0025 0.0030 0.0030 0.0039 0.0057 0.0061 ... 
    0.0062 0.0052 0.0054 0.0040 0.0023 0.0021 0.0021 0.0021 0.0022 0.0025 ...
    0.0026];
[~,xempnsales]=ecdf(empnsales);
% [ftest,xtest]=ecdf(empnsales+0.0001.*randn(size(empnsales))); %test cdf
xlsales=cell(MRUNS,1);
avgrunrents1=zeros(MRUNS,length(tspan));
avgrunrents2=zeros(MRUNS,length(tspan));
avgrunrents3=zeros(MRUNS,length(tspan));
for j=1:MRUNS
    if isempty(find(strmocc(j,:) == 1,1)) == 0
        [~,xmdlsales]=ecdf(cat(1,allsales_pct{1,:,j}));
        xlsales{j}=xmdlsales;
        for it=1:length(tspan)
%             avgrunrents(j,it)=nanmean(log10(aggrents{1,it,j}));
%             avgrunrents1(j,it)=nanmean(log10(rents{1,it,j}));
%             avgrunrents2(j,it)=nanmean(log10(rents{2,it,j}));
%             avgrunrents3(j,it)=nanmean(log10(rents{3,it,j}));
            avgrunrents(j,it)=nanmean(aggrents{1,it,j});
            avgrunrents1(j,it)=nanmean(rents{1,it,j});
            avgrunrents2(j,it)=nanmean(rents{2,it,j});
            avgrunrents3(j,it)=nanmean(rents{3,it,j});
            if isempty(find(totinscov{1,it,j},1)) == 1
                totinscov{1,it,j}=0;
            end
            avgruninscov(j,it)=mean(log10(totinscov{1,it,j}+0.1));
        end
    end
end
% percaprate=(avgruninscov-repmat(avgruninscov(:,5),1,length(tspan)))./...
%         repmat(avgruninscov(:,5),1,length(tspan));
%## house sales
xsales=cat(1,xlsales{:});
[~,xmdlsales]=ecdf(xsales);
[~,p_sales,kstat_sales]=kstest2(xempnsales,xmdlsales); % KS test to compare to cdfs
%     p_nsales(j)=p_sales;
%     ks_nsales(j)=kstat_sales;
p_nsales=p_sales;
ks_nsales=kstat_sales;

%## change in housing rents
% diffrunrent=diff(avgrunrents,1,2); %test average of iterations
% avgpctchange_rent=(avgrunrents(:,7)-mean(avgrunrents(:,5:6),2))./...
%     mean(avgrunrents(:,5:6),2);
% avgpctchange_rent=(10.^(avgrunrents(:,7))-mean(10.^(avgrunrents(:,5:6)),2))./...
%     mean(10.^(avgrunrents(:,5:6)),2);
avgpctchange_rent=(avgrunrents(:,7)-avgrunrents(:,6))./avgrunrents(:,6);
[~,prents,~,trents]=ztest(avgpctchange_rent,-0.0421,0.0135);    %Walls and Chu
p_rents=prents;
t_rents=trents;

%## change in insurance uptake
% diffruninscov=diff(avgruninscov,1,2);  %test average of iterations
avgpctchange_inscov=nanmean(10.^(avgruninscov(:,6:8))-0.1,2)-(10.^avgruninscov(:,5)-0.1);
[~,pinscov,~,tinscov]=ztest(avgpctchange_inscov,0.08,0.04);     %Gallagher
% [~,pinscov,~,tinscov]=ztest(percaprate(:,6),0.08,0.02);
p_inscov=pinscov;
t_inscov=tinscov;

% Maximize p-values
% score=p_rents*p_inscov*p_nsales; 
score=p_rents+p_inscov;% higher p-value produces higher...
%fitness score, i.e., not statistically different than empirical distribution

% fitness_parms=[eumodel(erun) riskmodel(erun) timewght(erun) lclcoeff(erun) ...
%     mvcost(erun) movethresh(erun) milecost(erun) am_slope(erun) altamen(erun) ...
%     coastpremium(erun)];
cd C:\Users\nmagliocca\Documents\Matlab_code\CHALMS_coast\simple-chalms
