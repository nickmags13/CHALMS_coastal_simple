%%%%%%%%%%% Get HGA results %%%%%%%%%%%%%%%%%%%

% navigate to results file storage
cd X:\model_results\CHALMS_event_hga_030917
fnames=dir;
fnamescell=struct2cell(fnames);
% (2) change the prefix of the results file names
h=strncmp('_hga_results',fnamescell(1,:),12);
hind=find(h==1);

parmmat=zeros(10,9,6);
scoremat=zeros(10,6);

for i=1:length(hind)
    filename=fnamescell{1,hind(i)};
    load(filename)
%     A=sscanf(fnamescell{1,hind(i)},'%*13s %d %*1c %d', [1, inf]);
%     gen=A(1)+1;
%     ind=A(2);
    parmmat(ind_id,:,g_id+1)=params;
    scoremat(ind_id,g_id+1)=score;
end
subscoremat=scoremat;
for j=1:5
    [xelite,ielite]=max(scoremat(:,j),[],1);
    if xelite > subscoremat(1,j)
        subscoremat(1,j+1)=xelite;
        parmmat(1,:,j+1)=parmmat(ielite,:,j);
    else
        subscoremat(1,j+1)=subscoremat(1,j);
        parmmat(1,:,j+1)=parmmat(1,:,j);
    end
end
scoremat=subscoremat;
genvec=reshape(repmat(1:6,10,1),10*6,1);
scorevec=reshape(scoremat,10*6,1);
eumod=reshape(parmmat(:,1,:),10*6,1);
riskmod=reshape(parmmat(:,2,:),10*6,1);
tmwght=reshape(parmmat(:,3,:),10*6,1);
lcthnk=reshape(parmmat(:,4,:),10*6,1);
mvcost=reshape(parmmat(:,5,:),10*6,1);
amslp=reshape(parmmat(:,7,:),10*6,1);
altamen=reshape(parmmat(:,8,:),10*6,1);
inscost=reshape(parmmat(:,9,:),10*6,1);

% Fitness by generation
h1=figure;
set(h1,'Color','white')
labels={'Null-Obj','Null-Sub','Null-Twght','EU-Obj','EU-Sub','EU-Twght',...
    'Sal-Obj','Sal-Sub','Sal-Twght'};
cmap=jet(9);
for k=1:9
    if k == 1
        irun=(eumod == 1 & riskmod == 1);
    elseif k == 2
        irun=(eumod == 1 & riskmod == 2);
    elseif k == 3
        irun=(eumod == 1 & riskmod == 3);
    elseif k == 4
        irun=(eumod == 2 & riskmod == 1);
    elseif k == 5
        irun=(eumod == 2 & riskmod == 2);
    elseif k == 6
        irun=(eumod == 2 & riskmod == 3);
    elseif k == 7
        irun=(eumod == 3 & riskmod == 1);
    elseif k == 8
        irun=(eumod == 3 & riskmod == 2);
    elseif k == 9
        irun=(eumod == 3 & riskmod == 3);
    end
   plot(genvec(irun),scorevec(irun),'o','MarkerSize',13,...
       'MarkerFaceColor',cmap(k,:),'MarkerEdgeColor','k');
   hold on
end
legend(labels,'Location','Northwest','FontSize',16);
ylabel('Fitness','FontSize',16)
xlabel('Generation','FontSize',16)
plot(linspace(1,6,100),0.1*ones(1,100),'--k')
ax=gca;
ax.XTick=1:6;
ax.FontSize=16;
saveas(h1,'hga_fitness_gen.png')

% Fitness by amslp
h2=figure;
set(h2,'Color','white')
labels={'Null-Obj','Null-Sub','Null-Twght','EU-Obj','EU-Sub','EU-Twght',...
    'Sal-Obj','Sal-Sub','Sal-Twght'};
cmap=jet(9);
for k=1:9
    if k == 1
        irun=(eumod == 1 & riskmod == 1);
    elseif k == 2
        irun=(eumod == 1 & riskmod == 2);
    elseif k == 3
        irun=(eumod == 1 & riskmod == 3);
    elseif k == 4
        irun=(eumod == 2 & riskmod == 1);
    elseif k == 5
        irun=(eumod == 2 & riskmod == 2);
    elseif k == 6
        irun=(eumod == 2 & riskmod == 3);
    elseif k == 7
        irun=(eumod == 3 & riskmod == 1);
    elseif k == 8
        irun=(eumod == 3 & riskmod == 2);
    elseif k == 9
        irun=(eumod == 3 & riskmod == 3);
    end
   plot(amslp(irun),scorevec(irun),'o','MarkerSize',13,...
       'MarkerFaceColor',cmap(k,:),'MarkerEdgeColor','k');
   hold on
end
legend(labels,'Location','Northwest','FontSize',16);
ylabel('Fitness','FontSize',16)
xlabel('Coastal Amenity Decay Rate','FontSize',16)
plot(linspace(min(amslp),max(amslp),100),0.1*ones(1,100),'--k')
ax=gca;
% ax.XTick=1:6;
ax.FontSize=16;
saveas(h2,'hga_fitness_amslp.png')

% Fitness by amslp
h3=figure;
set(h3,'Color','white')
labels={'Null-Obj','Null-Sub','Null-Twght','EU-Obj','EU-Sub','EU-Twght',...
    'Sal-Obj','Sal-Sub','Sal-Twght'};
cmap=jet(9);
for k=1:9
    if k == 1
        irun=(eumod == 1 & riskmod == 1);
    elseif k == 2
        irun=(eumod == 1 & riskmod == 2);
    elseif k == 3
        irun=(eumod == 1 & riskmod == 3);
    elseif k == 4
        irun=(eumod == 2 & riskmod == 1);
    elseif k == 5
        irun=(eumod == 2 & riskmod == 2);
    elseif k == 6
        irun=(eumod == 2 & riskmod == 3);
    elseif k == 7
        irun=(eumod == 3 & riskmod == 1);
    elseif k == 8
        irun=(eumod == 3 & riskmod == 2);
    elseif k == 9
        irun=(eumod == 3 & riskmod == 3);
    end
   plot3(mvcost(irun),inscost(irun),scorevec(irun),'o','MarkerSize',13,...
       'MarkerFaceColor',cmap(k,:),'MarkerEdgeColor','k');
   hold on
end
legend(labels,'Location','BestOutside','FontSize',16);
zlabel('Fitness','FontSize',16)
xlabel('Moving Costs','FontSize',16)
ylabel('Insurance Costs','FontSize',16)
% plot(linspace(min(mvcost),max(mvcost),100),0.1*ones(1,100),'--k')
ax=gca;
ax.Box='on';
ax.XGrid='on';
ax.YGrid='on';
ax.ZGrid='on';
% ax.XTick=1:6;
ax.FontSize=16;
saveas(h3,'hga_fitness_mvcost.png')