%%%%%%%%%%%%%%%  Tax revenue results %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

NLENGTH=80;
NWIDTH=80;
NCELLS=NLENGTH*NWIDTH;
TSTART=10;
TMAX=40;
HT=1;
cell2mile=0.0395;
cell2ft=cell2mile*5280;
z = [1 2000];
% number of model iterations
MRUNS=1;
EXPTRUNS=12;
ERUNS=EXPTRUNS;
% index numbers of storm climate settings and 1:MRUNS model runs
batchind=[reshape(repmat(1:ERUNS,MRUNS,1),MRUNS*ERUNS,1) ...
    repmat((1:MRUNS)',ERUNS,1)];
batchruns=mat2cell(reshape(1:MRUNS*ERUNS,MRUNS,ERUNS),MRUNS,ones(1,ERUNS));

COAST=zeros(NLENGTH,NWIDTH);
SCAPE=zeros(NLENGTH,NWIDTH);
icoast=find(COAST==1);
SCAPE(COAST~=1)=1;
coastdist=reshape(NWIDTH+1-cumsum(SCAPE,2),NCELLS,1);

%%% Specify tax rate used
% proptax=[0.01 0.01 0.01]; %baseline tax
% name='basetax';
% proptax=[0.02 0.01 0.005];  %variable tax
% name='vartax';
votetax=[0.01 0.01 0.01; 0.03 0.015 0.01];
name='vote';
% !!! Change directory below !!!
deltadmg=[0.01 0.01 0.01 0.01 0.05 0.05 0.05 0.05 0.1 0.1 0.1 0.1];

ZONEMAP=zeros(NLENGTH,NWIDTH);
ZONEMAP(:,NWIDTH)=1;   %waterfront
ZONEMAP(:,(NWIDTH-10):(NWIDTH-1))=2;    %water access
ZONEMAP(:,1:NWIDTH-11)=3;   %inland
zone1list=find(ZONEMAP == 1);
zone2list=find(ZONEMAP == 2);
zone3list=find(ZONEMAP == 3);

taxrevenue=zeros(EXPTRUNS,TMAX);
inspolicies=zeros(EXPTRUNS,TMAX);
insrate=zeros(EXPTRUNS,TMAX);
taxzone=zeros(3,TMAX,EXPTRUNS);
avgtaxlot=zeros(3,TMAX,EXPTRUNS);
avgrentzone=zeros(3,TMAX,EXPTRUNS);
vacrentzone=zeros(3,TMAX,EXPTRUNS);
nlotszone=zeros(3,TMAX,EXPTRUNS);
amprefzone=zeros(3,TMAX,EXPTRUNS);
incomezone=zeros(3,TMAX,EXPTRUNS);
totdmgzone=zeros(3,TMAX,EXPTRUNS);
avgdmgzone=zeros(3,TMAX,EXPTRUNS);
avoiddmgzone=zeros(3,TMAX,EXPTRUNS);
votetime=zeros(EXPTRUNS,TMAX);
stormtime=zeros(EXPTRUNS,TMAX);

cd C:\Users\nrmagliocca\'Box Sync'\'Data Drive'\model_results\CHALMS_event_ilandscape_vote_061418

housedam=0.01*(10.23749-0.23462*(coastdist*cell2ft/1000)+...
    0.001649*(coastdist*cell2ft/1000).^2);
for q=1:EXPTRUNS
    fname=sprintf('coast_event_simple_%d_1.mat',q);
    load(fname)
    
    ivotetime=find(votedecision == 1,1,'first');
    if isempty(find(ivotetime,1)) == 1
        votetime(q,:)=1;
    else
        votetime(q,1:ivotetime)=1;
        votetime(q,ivotetime+1:TMAX)=2;
    end
    stormtime(q,:)=stormoccur;
    taxrevenue(q,:)=TAXREV;
    vaclots=unique(cat(1,vacantlist{:}));
    for t=TSTART+1:TMAX
        inspolicies(q,t)=sum(LOTINS{t},1);
        insrate(q,t)=inspolicies(q,t)./numlt(t);
        
        izone1=ismember(zone1list,find(AVGRENT(:,t)~=0));
        izone2=ismember(zone2list,find(AVGRENT(:,t)~=0)); 
        izone3=ismember(zone3list,find(AVGRENT(:,t)~=0));
        
        zone1lots=lotlocate(ismember(lotlocate(:,2),zone1list(izone1)),1);
        zone2lots=lotlocate(ismember(lotlocate(:,2),zone2list(izone2)),1);
        zone3lots=lotlocate(ismember(lotlocate(:,2),zone3list(izone3)),1);
        
        iz1=zone1lots(~ismember(zone1lots,vacantlist{t}));
        iz2=zone2lots(~ismember(zone2lots,vacantlist{t}));
        iz3=zone3lots(~ismember(zone3lots,vacantlist{t}));
        
        rents=LOTRENT{:,t};
%         rents=rents(rents~=0);
%         taxzone(1,t,q)=sum(sum(((1/(1+0.05)).^(1:30)).*rents(iz1)).*proptax(1));
%         taxzone(2,t,q)=sum(sum(((1/(1+0.05)).^(1:30)).*rents(iz2)).*proptax(2));
%         taxzone(3,t,q)=sum(sum(((1/(1+0.05)).^(1:30)).*rents(iz3)).*proptax(3));
        
        taxzone(1,t,q)=sum(sum(((1/(1+0.05)).^(1:30)).*rents(iz1)).*votetax(votetime(q,t),1));
        taxzone(2,t,q)=sum(sum(((1/(1+0.05)).^(1:30)).*rents(iz2)).*votetax(votetime(q,t),2));
        taxzone(3,t,q)=sum(sum(((1/(1+0.05)).^(1:30)).*rents(iz3)).*votetax(votetime(q,t),3));
        
        avgtaxlot(1,t,q)=taxzone(1,t,q)/length(rents(iz1));
        avgtaxlot(2,t,q)=taxzone(2,t,q)/length(rents(iz2));
        avgtaxlot(3,t,q)=taxzone(3,t,q)/length(rents(iz3));
        
        avgrentzone(1,t,q)=median(rents(iz1));
        avgrentzone(2,t,q)=median(rents(iz2));
        avgrentzone(3,t,q)=median(rents(iz3));
        
        vacrentzone(1,t,q)=median(rents(vaclots(ismember(vaclots,zone1lots))));
        vacrentzone(2,t,q)=median(rents(vaclots(ismember(vaclots,zone2lots))));
        vacrentzone(3,t,q)=median(rents(vaclots(ismember(vaclots,zone3lots))));
        
        nlotszone(1,t,q)=length(rents(iz1));
        nlotszone(2,t,q)=length(rents(iz2));
        nlotszone(3,t,q)=length(rents(iz3));
        
        amprefzone(1,t,q)=mean(PREFMAP(zone1list(izone1),t));
        amprefzone(2,t,q)=mean(PREFMAP(zone2list(izone2),t));
        amprefzone(3,t,q)=mean(PREFMAP(zone3list(izone3),t));
        
        incomes=cat(1,LOTINC{:,t});
        incomezone(1,t,q)=median(incomes(iz1));
        incomezone(2,t,q)=median(incomes(iz2));
        incomezone(3,t,q)=median(incomes(iz3));
        
        if stormtime(q,t) == 1
            totdmgzone(1,t,q)=sum(cat(1,Cdam{iz1,t}));
            totdmgzone(2,t,q)=sum(cat(1,Cdam{iz2,t}));
            totdmgzone(3,t,q)=sum(cat(1,Cdam{iz3,t}));
            
            avgdmgzone(1,t,q)=totdmgzone(1,t,q)/length(rents(iz1));
            avgdmgzone(2,t,q)=totdmgzone(2,t,q)/length(rents(iz2));
            avgdmgzone(3,t,q)=totdmgzone(3,t,q)/length(rents(iz3));
            
            if votetime(q,t) == 2
                avoiddmgzone(1,t,q)=sum((1+deltadmg(q)*t).*rents(iz1).*...
                    housedam(lotlocate(iz1,2)))-totdmgzone(1,t,q);
                avoiddmgzone(2,t,q)=sum((1+deltadmg(q)*t).*rents(iz2).*...
                    housedam(lotlocate(iz2,2)))-totdmgzone(1,t,q);
                avoiddmgzone(3,t,q)=sum((1+deltadmg(q)*t).*rents(iz3).*...
                    housedam(lotlocate(iz3,2)))-totdmgzone(1,t,q);
            end
            
%             totdmgzone(1,t,q)=sum(rents(iz1).*housedam(lotlocate(iz1,2)));
%             totdmgzone(2,t,q)=sum(rents(iz2).*housedam(lotlocate(iz2,2)));
%             totdmgzone(3,t,q)=sum(rents(iz3).*housedam(lotlocate(iz3,2)));

        end
    end
end
totaldmg=reshape(sum(totdmgzone,2),3,EXPTRUNS);
avoiddmg=reshape(sum(avoiddmgzone,2),3,EXPTRUNS);

%%
%%%%%%%%% Figures %%%%%%%%%%%%%%%%
% %%% Cumulative tax revenue
% h1=figure;
% set(h1,'color','white','position',[100 10 450 1000])
% subplot(3,1,1)
% plot(10:40,cumsum(reshape(taxzone(1,10:40,:),31,4),1),'-')
% % ylim([0 1500000])
% ylabel('Revenues ($)')
% title('Waterfront Properties')
% legend('M-A','NC','TX','FL','Location','NorthWest')
% subplot(3,1,2)
% plot(10:40,cumsum(reshape(taxzone(2,10:40,:),31,4),1),'-')
% % ylim([0 5000000])
% ylabel('Revenues ($)')
% title('Water Access Properties')
% subplot(3,1,3)
% plot(10:40,cumsum(reshape(taxzone(3,10:40,:),31,4),1),'-')
% % ylim([0 1600000])
% ylabel('Revenues ($)')
% xlabel('Year')
% title('Inland Properties')
% saveas(h1,sprintf('cumulative_taxrev_%s',name),'png')

%%% Cumulative tax revenue
h1=figure;
set(h1,'color','white','position',[10 10 800 600])
subplot(2,2,1)
plot(11:40,cumsum(taxzone(:,11:40,1),1),'-')
% ylim([0 1500000])
ylabel('Revenues ($)')
title('M-A')
legend('Waterfront','Water Access','Inland','Location','East')
subplot(2,2,2)
plot(11:40,cumsum(taxzone(:,11:40,2),1),'-')
% ylim([0 5000000])
title('NC')
subplot(2,2,3)
plot(11:40,cumsum(taxzone(:,11:40,3),1),'-')
% ylim([0 1600000])
ylabel('Revenues ($)')
xlabel('Year')
title('TX')
subplot(2,2,4)
plot(11:40,cumsum(taxzone(:,11:40,4),1),'-')
% ylim([0 1600000])
xlabel('Year')
title('FL')
saveas(h1,sprintf('cumulative_taxrev_1_%s',name),'png')

%%% Annual tax revenue
% h2=figure;
% set(h2,'color','white','position',[100 10 450 1000])
% subplot(3,1,1)
% plot(11:40,reshape(taxzone(1,11:40,:),30,4),'-')
% % ylim([15000 38000])
% ylabel('Revenues ($)')
% title('Waterfront Properties')
% subplot(3,1,2)
% plot(11:40,reshape(taxzone(2,11:40,:),30,4),'-')
% % ylim([120000 150000])
% ylabel('Revenues ($)')
% title('Water Access Properties')
% legend('M-A','NC','TX','FL','Location','NorthWest')
% subplot(3,1,3)
% plot(11:40,reshape(taxzone(3,11:40,:),30,4),'-')
% % ylim([15000 80000])
% ylabel('Revenues ($)')
% xlabel('Year')
% title('Inland Properties')
% saveas(h2,sprintf('annual_taxrev_%s',name),'png')
h2=figure;
set(h2,'color','white','position',[10 10 800 600])
subplot(2,2,1)
plot(11:40,taxzone(:,11:40,1),'-')
% ylim([0 1500000])
ylabel('Revenues ($)')
title('M-A')
legend('Waterfront','Water Access','Inland','Location','East')
subplot(2,2,2)
plot(11:40,taxzone(:,11:40,2),'-')
% ylim([0 5000000])
title('NC')
subplot(2,2,3)
plot(11:40,taxzone(:,11:40,3),'-')
% ylim([0 1600000])
ylabel('Revenues ($)')
xlabel('Year')
title('TX')
subplot(2,2,4)
plot(11:40,taxzone(:,11:40,4),'-')
% ylim([0 1600000])
xlabel('Year')
title('FL')
saveas(h2,sprintf('annual_taxrev_1_%s',name),'png')

h2_2=figure;
set(h2_2,'color','white','position',[10 10 800 600])
subplot(2,2,1)
plot(11:40,taxzone(:,11:40,5),'-')
% ylim([0 1500000])
ylabel('Revenues ($)')
title('M-A')
legend('Waterfront','Water Access','Inland','Location','East')
subplot(2,2,2)
plot(11:40,taxzone(:,11:40,6),'-')
% ylim([0 5000000])
title('NC')
subplot(2,2,3)
plot(11:40,taxzone(:,11:40,7),'-')
% ylim([0 1600000])
ylabel('Revenues ($)')
xlabel('Year')
title('TX')
subplot(2,2,4)
plot(11:40,taxzone(:,11:40,8),'-')
% ylim([0 1600000])
xlabel('Year')
title('FL')
saveas(h2_2,sprintf('annual_taxrev_5_%s',name),'png')

h2_3=figure;
set(h2_3,'color','white','position',[10 10 800 600])
subplot(2,2,1)
plot(11:40,taxzone(:,11:40,9),'-')
% ylim([0 1500000])
ylabel('Revenues ($)')
title('M-A')
legend('Waterfront','Water Access','Inland','Location','East')
subplot(2,2,2)
plot(11:40,taxzone(:,11:40,10),'-')
% ylim([0 5000000])
title('NC')
subplot(2,2,3)
plot(11:40,taxzone(:,11:40,11),'-')
% ylim([0 1600000])
ylabel('Revenues ($)')
xlabel('Year')
title('TX')
subplot(2,2,4)
plot(11:40,taxzone(:,11:40,12),'-')
% ylim([0 1600000])
xlabel('Year')
title('FL')
saveas(h2_3,sprintf('annual_taxrev_10_%s',name),'png')

% %%% Average annual tax revenue per lot
% h2_1=figure;
% set(h2_1,'color','white','position',[100 10 450 1000])
% subplot(3,1,1)
% plot(11:40,reshape(avgtaxlot(1,11:40,:),30,4),'-')
% % ylim([180 460])
% ylabel('Avg. Tax Revenue Per Lot')
% title('Waterfront Properties')
% subplot(3,1,2)
% plot(11:40,reshape(avgtaxlot(2,11:40,:),30,4),'-')
% % ylim([150 190])
% ylabel('Avg. Tax Revenue Per Lot')
% title('Water Access Properties')
% legend('M-A','NC','TX','FL','Location','NorthWest')
% subplot(3,1,3)
% plot(11:40,reshape(avgtaxlot(3,11:40,:),30,4),'-')
% % ylim([45 140])
% ylabel('Avg. Tax Revenue Per Lot')
% xlabel('Year')
% title('Inland Properties')
% saveas(h2_1,sprintf('avgtaxlot_%s',name),'png')

%%% Median house prices
h3=figure;
set(h3,'color','white','position',[10 10 800 600])
subplot(2,2,1)
plot(11:40,avgrentzone(:,11:40,1),'-')
% ylim([18000 24000])
ylabel('Median House Price')
title('M-A')
subplot(2,2,2)
plot(11:40,avgrentzone(:,11:40,2),'-')
% ylim([14000 19000])
title('NC')
legend('Waterfront','Water Access','Inland','Location','East')
subplot(2,2,3)
plot(11:40,avgrentzone(:,11:40,3),'-')
% ylim([8000 14000])
ylabel('Median House Price')
xlabel('Year')
title('TX')
subplot(2,2,4)
plot(11:40,avgrentzone(:,11:40,4),'-')
ylim([10000 22000])
xlabel('Year')
title('FL')
saveas(h3,sprintf('houseprice_1_%s',name),'png')

h3_2=figure;
set(h3_2,'color','white','position',[10 10 800 600])
subplot(2,2,1)
plot(11:40,avgrentzone(:,11:40,5),'-')
% ylim([18000 24000])
ylabel('Median House Price')
title('M-A')
subplot(2,2,2)
plot(11:40,avgrentzone(:,11:40,6),'-')
% ylim([14000 19000])
title('NC')
legend('Waterfront','Water Access','Inland','Location','East')
subplot(2,2,3)
plot(11:40,avgrentzone(:,11:40,7),'-')
% ylim([8000 14000])
ylabel('Median House Price')
xlabel('Year')
title('TX')
subplot(2,2,4)
plot(11:40,avgrentzone(:,11:40,8),'-')
ylim([10000 22000])
xlabel('Year')
title('FL')
saveas(h3_2,sprintf('houseprice_5_%s',name),'png')

h3_3=figure;
set(h3_3,'color','white','position',[10 10 800 600])
subplot(2,2,1)
plot(11:40,avgrentzone(:,11:40,9),'-')
% ylim([18000 24000])
ylabel('Median House Price')
title('M-A')
subplot(2,2,2)
plot(11:40,avgrentzone(:,11:40,10),'-')
% ylim([14000 19000])
title('NC')
legend('Waterfront','Water Access','Inland','Location','East')
subplot(2,2,3)
plot(11:40,avgrentzone(:,11:40,11),'-')
% ylim([8000 14000])
ylabel('Median House Price')
xlabel('Year')
title('TX')
subplot(2,2,4)
plot(11:40,avgrentzone(:,11:40,12),'-')
ylim([10000 22000])
xlabel('Year')
title('FL')
saveas(h3_3,sprintf('houseprice_10_%s',name),'png')

% %%% Median vacant house prices
% h3_1=figure;
% set(h3_1,'color','white','position',[100 10 450 1000])
% subplot(3,1,1)
% plot(11:40,reshape(vacrentzone(1,11:40,:),30,4),'-')
% % ylim([20000 26000])
% ylabel('Median House Price of Vacated Properties')
% title('Waterfront Properties')
% subplot(3,1,2)
% plot(11:40,reshape(vacrentzone(2,11:40,:),30,4),'-')
% % ylim([19000 22000])
% ylabel('Median House Price of Vacated Properties')
% title('Water Access Properties')
% legend('M-A','NC','TX','FL','Location','NorthEast')
% subplot(3,1,3)
% plot(11:40,reshape(vacrentzone(3,11:40,:),30,4),'-')
% % ylim([6000 14000])
% ylabel('Median House Price of Vacated Properties')
% xlabel('Year')
% title('Inland Properties')
% saveas(h3_1,sprintf('vachouseprice_%s',name),'png')

%%% Number of lots
% h4=figure;
% set(h4,'color','white','position',[100 10 450 1000])
% subplot(3,1,1)
% plot(11:40,reshape(nlotszone(1,11:40,:),30,4),'-')
% % ylim([70 80])
% ylabel('Number of lots')
% title('Waterfront Properties')
% legend('M-A','NC','TX','FL','Location','SouthEast')
% subplot(3,1,2)
% plot(11:40,reshape(nlotszone(2,11:40,:),30,4),'-')
% % ylim([770 800])
% ylabel('Number of lots')
% title('Water Access Properties')
% subplot(3,1,3)
% plot(11:40,reshape(nlotszone(3,11:40,:),30,4),'-')
% % ylim([200 600])
% ylabel('Number of lots')
% xlabel('Year')
% title('Inland Properties')
% saveas(h4,sprintf('nlots_%s',name),'png')
h4=figure;
set(h4,'color','white','position',[10 10 800 600])
subplot(2,2,1)
plot(11:40,nlotszone(:,11:40,1),'-')
% ylim([70 80])
ylabel('Number of lots')
title('M-A')
legend('Waterfront','Water Access','Inland','Location','East')
subplot(2,2,2)
plot(11:40,nlotszone(:,11:40,2),'-')
% ylim([770 800])
title('NC')
subplot(2,2,3)
plot(11:40,nlotszone(:,11:40,3),'-')
% ylim([200 600])
ylabel('Number of lots')
xlabel('Year')
title('TX')
subplot(2,2,4)
plot(11:40,nlotszone(:,11:40,4),'-')
% ylim([200 600])
xlabel('Year')
title('FL')
saveas(h4,sprintf('nlots_1_%s',name),'png')

h4_2=figure;
set(h4_2,'color','white','position',[10 10 800 600])
subplot(2,2,1)
plot(11:40,nlotszone(:,11:40,5),'-')
% ylim([70 80])
ylabel('Number of lots')
title('M-A')
legend('Waterfront','Water Access','Inland','Location','East')
subplot(2,2,2)
plot(11:40,nlotszone(:,11:40,6),'-')
% ylim([770 800])
title('NC')
subplot(2,2,3)
plot(11:40,nlotszone(:,11:40,7),'-')
% ylim([200 600])
ylabel('Number of lots')
xlabel('Year')
title('TX')
subplot(2,2,4)
plot(11:40,nlotszone(:,11:40,8),'-')
% ylim([200 600])
xlabel('Year')
title('FL')
saveas(h4_2,sprintf('nlots_5_%s',name),'png')

h4_3=figure;
set(h4_3,'color','white','position',[10 10 800 600])
subplot(2,2,1)
plot(11:40,nlotszone(:,11:40,9),'-')
% ylim([70 80])
ylabel('Number of lots')
title('M-A')
legend('Waterfront','Water Access','Inland','Location','East')
subplot(2,2,2)
plot(11:40,nlotszone(:,11:40,10),'-')
% ylim([770 800])
title('NC')
subplot(2,2,3)
plot(11:40,nlotszone(:,11:40,11),'-')
% ylim([200 600])
ylabel('Number of lots')
xlabel('Year')
title('TX')
subplot(2,2,4)
plot(11:40,nlotszone(:,11:40,12),'-')
% ylim([200 600])
xlabel('Year')
title('FL')
saveas(h4_3,sprintf('nlots_10_%s',name),'png')

%%% Average amenity preferences
h5=figure;
set(h5,'color','white','Position',[100 100 800 600])
subplot(2,2,1)
plot(11:40,amprefzone(:,11:40,1),'-')
ylabel('Amenity Preference')
title('M-A')
legend('Waterfront','Water Access','Inland','Location','NorthEast')
subplot(2,2,2)
plot(11:40,amprefzone(:,11:40,2),'-')
title('NC')
subplot(2,2,3)
plot(11:40,amprefzone(:,11:40,3),'-')
ylabel('Amenity Preference')
xlabel('Year')
title('TX')
subplot(2,2,4)
plot(11:40,amprefzone(:,11:40,4),'-')
ylim([0.05 0.25])
xlabel('Year')
title('FL')
saveas(h5,sprintf('ampref_1_%s',name),'png')

h5_2=figure;
set(h5_2,'color','white','Position',[100 100 800 600])
subplot(2,2,1)
plot(11:40,amprefzone(:,11:40,5),'-')
ylabel('Amenity Preference')
title('M-A')
legend('Waterfront','Water Access','Inland','Location','NorthEast')
subplot(2,2,2)
plot(11:40,amprefzone(:,11:40,6),'-')
title('NC')
subplot(2,2,3)
plot(11:40,amprefzone(:,11:40,7),'-')
ylabel('Amenity Preference')
xlabel('Year')
title('TX')
subplot(2,2,4)
plot(11:40,amprefzone(:,11:40,8),'-')
ylim([0.05 0.25])
xlabel('Year')
title('FL')
saveas(h5_2,sprintf('ampref_5_%s',name),'png')

h5_3=figure;
set(h5_3,'color','white','Position',[100 100 800 600])
subplot(2,2,1)
plot(11:40,amprefzone(:,11:40,9),'-')
ylabel('Amenity Preference')
title('M-A')
legend('Waterfront','Water Access','Inland','Location','NorthEast')
subplot(2,2,2)
plot(11:40,amprefzone(:,11:40,10),'-')
title('NC')
subplot(2,2,3)
plot(11:40,amprefzone(:,11:40,11),'-')
ylabel('Amenity Preference')
xlabel('Year')
title('TX')
subplot(2,2,4)
plot(11:40,amprefzone(:,11:40,12),'-')
ylim([0.05 0.25])
xlabel('Year')
title('FL')
saveas(h5_3,sprintf('ampref_10_%s',name),'png')

%%% Median Income
h6=figure;
set(h6,'color','white','Position',[100 100 800 600])
subplot(2,2,1)
plot(11:40,incomezone(:,11:40,1),'-')
ylabel('Median Income')
title('M-A')
legend('Waterfront','Water Access','Inland','Location','NorthWest')
subplot(2,2,2)
plot(11:40,incomezone(:,11:40,2),'-')
title('NC')
subplot(2,2,3)
plot(11:40,incomezone(:,11:40,3),'-')
ylabel('Median Income')
xlabel('Year')
title('TX')
subplot(2,2,4)
plot(11:40,incomezone(:,11:40,4),'-')
xlabel('Year')
title('FL')
saveas(h6,sprintf('income_1_%s',name),'png')

h6_2=figure;
set(h6_2,'color','white','Position',[100 100 800 600])
subplot(2,2,1)
plot(11:40,incomezone(:,11:40,5),'-')
ylabel('Median Income')
title('M-A')
legend('Waterfront','Water Access','Inland','Location','NorthWest')
subplot(2,2,2)
plot(11:40,incomezone(:,11:40,6),'-')
title('NC')
subplot(2,2,3)
plot(11:40,incomezone(:,11:40,7),'-')
ylabel('Median Income')
xlabel('Year')
title('TX')
subplot(2,2,4)
plot(11:40,incomezone(:,11:40,8),'-')
xlabel('Year')
title('FL')
saveas(h6_2,sprintf('income_5_%s',name),'png')

h6_3=figure;
set(h6_3,'color','white','Position',[100 100 800 600])
subplot(2,2,1)
plot(11:40,incomezone(:,11:40,9),'-')
ylabel('Median Income')
title('M-A')
legend('Waterfront','Water Access','Inland','Location','NorthWest')
subplot(2,2,2)
plot(11:40,incomezone(:,11:40,10),'-')
title('NC')
subplot(2,2,3)
plot(11:40,incomezone(:,11:40,11),'-')
ylabel('Median Income')
xlabel('Year')
title('TX')
subplot(2,2,4)
plot(11:40,incomezone(:,11:40,12),'-')
xlabel('Year')
title('FL')
saveas(h6_3,sprintf('income_10_%s',name),'png')

%%% Total damages
h7=figure;
set(h7,'color','white','Position',[100 100 800 600])
subplot(2,2,1)
plot(11:40,totdmgzone(:,11:40,1),'-')
ylabel('Total Damages')
title('M-A')
legend('Waterfront','Water Access','Inland','Location','NorthWest')
subplot(2,2,2)
plot(11:40,totdmgzone(:,11:40,2),'-')
title('NC')
subplot(2,2,3)
plot(11:40,totdmgzone(:,11:40,3),'-')
ylabel('Total Damages')
xlabel('Year')
title('TX')
subplot(2,2,4)
plot(11:40,totdmgzone(:,11:40,4),'-')
xlabel('Year')
title('FL')
saveas(h7,sprintf('totdmg_%s',name),'png')

%%% Averge damages
h7=figure;
set(h7,'color','white','Position',[100 100 800 600])
subplot(2,2,1)
plot(11:40,avgdmgzone(:,11:40,1),'-')
ylabel('Average Damages')
title('M-A')
legend('Waterfront','Water Access','Inland','Location','NorthWest')
subplot(2,2,2)
plot(11:40,avgdmgzone(:,11:40,2),'-')
title('NC')
subplot(2,2,3)
plot(11:40,avgdmgzone(:,11:40,3),'-')
ylabel('Average Damages')
xlabel('Year')
title('TX')
subplot(2,2,4)
plot(11:40,avgdmgzone(:,11:40,4),'-')
xlabel('Year')
title('FL')
saveas(h7,sprintf('avgdmg_%s',name),'png')

%%% Storm Time
h8=figure;
set(h8,'color','white','Position',[100 100 800 600])
subplot(4,1,1)
st1=find(stormtime(1,:)==1);
x1=[st1; st1];
y1=[zeros(1,length(st1)); ones(1,length(st1))];
for i=1:length(st1)
   plot(x1(:,i),y1(:,i),'-k')
   hold on
end
xlim([TSTART+0.5 TMAX+0.5])
ylabel('Damage Increase Rate')
title('M-A')
subplot(4,1,2)
st2=find(stormtime(2,:)==1);
x2=[st2; st2];
y2=[zeros(1,length(st2)); ones(1,length(st2))];
for i=1:length(st2)
   plot(x2(:,i),y2(:,i),'-k')
   hold on
end
xlim([TSTART+0.5 TMAX+0.5])
title('NC')
subplot(4,1,3)
st3=find(stormtime(3,:)==1);
x3=[st3; st3];
y3=[zeros(1,length(st3)); ones(1,length(st3))];
for i=1:length(st3)
   plot(x3(:,i),y3(:,i),'-k')
   hold on
end
xlim([TSTART+0.5 TMAX+0.5])
ylabel('Damage Increase Rate')
xlabel('Year')
title('TX')
subplot(4,1,4)
st4=find(stormtime(4,:)==1);
x4=[st4; st4];
y4=[zeros(1,length(st4)); ones(1,length(st4))];
for i=1:length(st4)
   plot(x4(:,i),y4(:,i),'-k')
   hold on
end
xlim([TSTART+0.5 TMAX+0.5])
xlabel('Year')
title('FL')
saveas(h8,sprintf('stormtime_%s',name),'png')