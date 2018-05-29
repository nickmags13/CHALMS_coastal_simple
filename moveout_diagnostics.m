%%%%%%%%%% Rent change diagnostics
% meant to be used postrun or in debug mode due to variable dependencies
tprobe=t-2;
iposrents=find(rentdiff(:,tprobe) > 0);
iposlots=cat(1,lotchoice{ismember(cat(1,lotchoice{:,2}),iposrents),1});
sublotcon=LOTCON{tprobe};
posrents_cons=sublotcon(iposlots);
posrents_restime=cat(1,lotchoice{ismember(cat(1,lotchoice{:,2}),iposrents),6});
inegrents=find(rentdiff(:,tprobe) < 0);
ineglots=cat(1,lotchoice{ismember(cat(1,lotchoice{:,2}),inegrents),1});
negrents_cons=sublotcon(ineglots);

%which of the vacancies that show-up as zeros in the consumer variables are
%due to new vs. existing vacancies?
newmoves=cat(1,regmoveouts{tprobe});
newvacpos=length(find(ismember(iposlots,newmoves)==1));
newvacneg=length(find(ismember(ineglots,newmoves)==1));

vacrecord=zeros(length(lotchoice(:,1)),TMAX);
vacrecord_alt=zeros(length(lotchoice(:,1)),TMAX);
%find first moveout date
mvouts=regmoveouts{tprobe};
for i=1:length(mvouts)
    for k=TSTART+1:tprobe
        vacrecord(mvouts(i),k)=ismember(mvouts(i),regmoveouts{k});
    end
end
for i=1:length(ineglots)
    for k=TSTART+1:tprobe
        firstmovechk=ismember(ineglots(i),regmoveouts{k});
        stillvacchk=ismember(ineglots(i),vacantlist{k});
        vacrecord_alt(ineglots(i),k)=(firstmovechk == 1 | stillvacchk == 1);
    end
end  
%trace relocation tracks and differences in expected damages
cd X:\model_results\CHALMS_event_ilandscape_122216
load coast_event_simple_7_26.mat
NLENGTH=80;
NWIDTH=80;
% trgtyr=15;  %salience, NC, 4, 26
% trgtyr=16;
trgtyr=find(stormoccur ~= 0,1,'first');
rlccons=reloc_stats{1,trgtyr+1};
startloc=reloc_stats{2,trgtyr+1};
irlc=ismember(LOTCON{trgtyr+1},rlccons);

% imoved=ismember(cat(1,lotchoice{:,5}),reloc_stats{1,trgtyr});
imoved=ismember(LOTCON{trgtyr+1},reloc_stats{1,trgtyr});
imoving=ismember(reloc_stats{1,trgtyr},LOTCON{trgtyr+1});
inotmoving=~ismember(reloc_stats{1,trgtyr},cat(1,lotchoice{:,5}));
subspos=reloc_stats{2,trgtyr};
startpos=subspos(imoving);
endpos=cat(1,lotchoice{imoved,2});

hh=figure;
set(hh,'color','white')
imagesc(reshape(LOTTYPE(:,trgtyr+1),NLENGTH,NWIDTH))
colormap([1 1 1; 0 0 0])
hold on
[ystart,xstart]=ind2sub([NLENGTH NWIDTH],startpos);
[yend,xend]=ind2sub([NLENGTH NWIDTH],endpos);
plot(xstart,ystart,'og')
plot(xend,yend,'or')
for g=1:length(startpos)
    plot([xstart(g); xend(g)],[ystart(g); yend(g)],'-w')
end
legend('startpos','endpos','Location','northwest')
title(sprintf('Post-Storm Relocations,t=%d',trgtyr+1))
subincomes=reloc_stats{4,t-1};

% regular move-outs
regmvlots=regmoveouts{trgtyr};
startloc=cat(1,lotchoice{regmvlots,2});
cons_t0=LOTCON{trgtyr};
cons_t1=LOTCON{trgtyr+1};
ioccmove=(cons_t0(regmvlots) ~= 0);
iregmoved=ismember(cons_t1,cons_t0(regmvlots(ioccmove)));
endloc=cat(1,lotchoice{find(iregmoved == 1),2});
[yregstart,xregstart]=ind2sub([NLENGTH NWIDTH],startloc(ioccmove));
[yvacstart,xvacstart]=ind2sub([NLENGTH NWIDTH],startloc(~ioccmove));
[yregend,xregend]=ind2sub([NLENGTH NWIDTH],endloc);

figure
imagesc(reshape(LOTTYPE(:,trgtyr),80,80))
hold on
plot(xregstart,yregstart,'go')
plot(xregend,yregend,'r.')
plot(xvacstart,yvacstart,'ko')
for g=1:length(startloc(ioccmove))
    plot([xregstart(g); xregend(g)],[yregstart(g); yregend(g)],'-k')
end
legend('startpos','endpos','Vacancies','Location','northwest')
title('Regular Move-Outs')


%Do locations of relcations correspond with rent increases or decreases?
rlc=zeros(80,80);
rlc(reloc_stats{2,15})=1;

%Income changes
incdiff=zeros(NCELLS,TMAX);
for tt=TSTART+1:tprobe
    incdiff(cat(1,lotchoice{:,2}),tt)=LOTINC{tt}-LOTINC{tt-1};
end