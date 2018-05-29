%%%%%%%%%%%%% Create new landscape setting based on past model results %%%
cd X:\model_results\CHALMS_event_simple_altmodels_091216
load results_event_simple_altmodels_091216_struct.mat

MRUNS=30;
TMAX=30;
NCELLS=6400;
% Initial developed area based on utility maximization runs
% startmap=(mapdata_store.devprob_map(:,2)>0);
% istartmap=find(startmap==1);
istartmap=lotdata_store.Lotlocate{49}; %exemplar development pattern

% Average rent trend for training data
allrents=lotdata_store.lotrent(31:60);
timerents=cell(1,10);
meantrendrents=zeros(1,length(timerents));
for k=1:MRUNS
    subrents=allrents{k};
    for j=1:10
        timerents(j)=mat2cell([timerents{j}; subrents{TMAX-(10-j)}],...
            length(timerents{j})+length(subrents{TMAX-(10-j)}),1);
    end
end
for jj=1:10
    meantrendrents(jj)=mean(timerents{jj});
end

% Spatially explict average rents for initialization
finalrents=cat(2,mapdata_store.avgrentmap{30,31:60});
startrents=zeros(NCELLS,1);
for i=1:length(istartmap)
    inotzero=(finalrents(istartmap(i,2),:)~=0);
    startrents(istartmap(i,2))=mean(finalrents(istartmap(i,2),inotzero));
end

% Spatially explicit average land price projections
lproj=zeros(64,MRUNS);
for m=1:MRUNS
    sublproj=land_sales.landproj{m,2};
   lproj(:,m)=sublproj(:,15);
end
% lproj=lproj(:,[1:19 21:MRUNS]);
meanlproj=mean(lproj,2);

% % starting number of consumers
% ncons=zeros(MRUNS,1);
% for i=31:60
%     sublotcon=lotdata_store.lotcon(i);
%     test=sublotcon{:};
%     ncons(i-MRUNS)=length(test{TMAX});
% end


cd C:\Users\nmagliocca\Documents\Matlab_code\CHALMS_coast\simple-chalms
save ilandscape istartmap startrents meantrendrents meanlproj