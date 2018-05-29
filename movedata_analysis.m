cd X:\model_results\CHALMS_event_ilandscape_111616
load results_event_ilandscape_111616_struct.mat
load dmgclass_results_ilandscape_111616_salience.mat

ERUNS=3;
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

runnamelabel={'null','eu_max','salience'};

% dmgqnt=quantile(dmgvec,[0.9 0.95]);
% idmggroup_hi=find(dmgvec > dmgqnt(2));
% idmggroup_md=find(dmgvec > dmgqnt(1) & dmgvec <= dmgqnt(2));
% idmggroup_lw=find(dmgvec <= dmgqnt(1));

idmggroup_hi=find(CDIST == 1);  %waterfront
idmggroup_md=find(CDIST > 1 & CDIST <= 5); %waterview
idmggroup_lw=find(CDIST > 5);  %low to moderate risk

extractddata=ddata_store.decisiondata;

nmoves=zeros(ERUNS*nruns,TMAX);
mvloct=cell(ERUNS*nruns,TMAX);

for n=1:ERUNS*nruns
    decisiondata=extractddata{n};
    for q=TSTART+1:TMAX
        subdata=cat(1,decisiondata{1,q});
        nmoves(n,q)=length(find(subdata(:,4)==3));
        %     uu(1,q)=mean(subdata(subdata(:,4)==3,8));
        mvloct(n,q)=mat2cell(subdata(subdata(:,4)==3,3),length(find(subdata(:,4)==3)),1);
        
        %     icon=find(subdata(:,1)==8);
        %     if isempty(find(icon,1))==0
        %         trackconU(1,q)=subdata(icon,7);
        %         trackconM(1,q)=subdata(icon,4);
        %     end
    end
end
