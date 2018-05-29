% function [R,beta_t,beta_g,beta_tg,beta_z,err,ERUNS,tspan]=diffNdiff(...
%     id_rl_save,id_nc_save,rent_rl_save,rent_nc_save,dmg_rl_save,...
%     dmg_nc_save,grp_rl_save,grp_nc_save,inc_rl_save,inc_nc_save)

cd C:\Users\nrmagliocca\'Box Sync'\'Data Drive'\model_results\CHALMS_event_ilandscape_011718_popgrow
load mvcost_results_062016.mat
load stormrecord

ERUNS=5;
HT=1;
start_t=-5;
end_t=5;
tspan=start_t:end_t;

% runnamelabel={'Mid-Atl','NC','FL','TX'};
runnamelabel={'1','2_5','5'};
rentdiff_ht_save=cell(3,ERUNS); %housing type by damage class
rentdiff_rl_save=cell(1,ERUNS);
rentdiff_nc_save=cell(1,ERUNS);
rentdiff_grprl_save=cell(3,ERUNS);
rentdiff_grpnc_save=cell(3,ERUNS);
incdiff_ht_save=cell(3,ERUNS); %housing type by damage class
incdiff_rl_save=cell(1,ERUNS);
incdiff_nc_save=cell(1,ERUNS);
incdiff_grprl_save=cell(3,ERUNS);
incdiff_grpnc_save=cell(3,ERUNS);

rent_ht_save=cell(3,ERUNS); %housing type by damage class
rentrl_save=cell(1,ERUNS);
rentnc_save=cell(1,ERUNS);
rent_grprl_save=cell(3,ERUNS);
rent_grpnc_save=cell(3,ERUNS);
inc_ht_save=cell(3,ERUNS); %housing type by damage class
incrl_save=cell(1,ERUNS);
incnc_save=cell(1,ERUNS);
inc_grprl_save=cell(3,ERUNS);
inc_grpnc_save=cell(3,ERUNS);
for N=1:ERUNS
    grp_rl=grp_rl_save{N};
    grp_nc=grp_nc_save{N};
    rent_rl=rent_rl_save{N};
    rent_nc=rent_nc_save{N};
    inc_rl=inc_rl_save{N};
    inc_nc=inc_nc_save{N};
    incgrp_rl=incgrp_rl_save{N};
    incgrp_nc=incgrp_nc_save{N};
    
    rent_rl_avg=zeros(HT,length(tspan));
    rent_rl_ci=zeros(HT,length(tspan),2);
    rent_rl_s=zeros(HT,length(tspan));
    rent_nc_avg=zeros(HT,length(tspan));
    rent_nc_ci=zeros(HT,length(tspan),2);
    rent_nc_s=zeros(HT,length(tspan));
    
    inc_rl_avg=zeros(HT,length(tspan));
    inc_rl_ci=zeros(HT,length(tspan),2);
    inc_rl_s=zeros(HT,length(tspan));
    inc_nc_avg=zeros(HT,length(tspan));
    inc_nc_ci=zeros(HT,length(tspan),2);
    inc_nc_s=zeros(HT,length(tspan));
    
    grp1rent_avg=zeros(HT,length(tspan));
    grp1rent_ci=zeros(HT,length(tspan),2);
    grp1rent_s=zeros(HT,length(tspan));
    grp2rent_avg=zeros(HT,length(tspan));
    grp2rent_ci=zeros(HT,length(tspan),2);
    grp2rent_s=zeros(HT,length(tspan));
    grp3rent_avg=zeros(HT,length(tspan));
    grp3rent_ci=zeros(HT,length(tspan),2);
    grp3rent_s=zeros(HT,length(tspan));
    
    ngrp1rent_avg=zeros(HT,length(tspan));
    ngrp1rent_ci=zeros(HT,length(tspan),2);
    ngrp1rent_s=zeros(HT,length(tspan));
    ngrp2rent_avg=zeros(HT,length(tspan));
    ngrp2rent_ci=zeros(HT,length(tspan),2);
    ngrp2rent_s=zeros(HT,length(tspan));
    ngrp3rent_avg=zeros(HT,length(tspan));
    ngrp3rent_ci=zeros(HT,length(tspan),2);
    ngrp3rent_s=zeros(HT,length(tspan));
    
    grp1rent_rl_avg=zeros(HT,length(tspan));
    grp1rent_rl_ci=zeros(HT,length(tspan),2);
    grp1rent_rl_s=zeros(HT,length(tspan));
    grp2rent_rl_avg=zeros(HT,length(tspan));
    grp2rent_rl_ci=zeros(HT,length(tspan),2);
    grp2rent_rl_s=zeros(HT,length(tspan));
    grp3rent_rl_avg=zeros(HT,length(tspan));
    grp3rent_rl_ci=zeros(HT,length(tspan),2);
    grp3rent_rl_s=zeros(HT,length(tspan));
    
    grp1rent_nc_avg=zeros(HT,length(tspan));
    grp1rent_nc_ci=zeros(HT,length(tspan),2);
    grp1rent_nc_s=zeros(HT,length(tspan));
    grp2rent_nc_avg=zeros(HT,length(tspan));
    grp2rent_nc_ci=zeros(HT,length(tspan),2);
    grp2rent_nc_s=zeros(HT,length(tspan));
    grp3rent_nc_avg=zeros(HT,length(tspan));
    grp3rent_nc_ci=zeros(HT,length(tspan),2);
    grp3rent_nc_s=zeros(HT,length(tspan));
    
    grp1inc_avg=zeros(HT,length(tspan));
    grp1inc_ci=zeros(HT,length(tspan),2);
    grp1inc_s=zeros(HT,length(tspan));
    grp2inc_avg=zeros(HT,length(tspan));
    grp2inc_ci=zeros(HT,length(tspan),2);
    grp2inc_s=zeros(HT,length(tspan));
    grp3inc_avg=zeros(HT,length(tspan));
    grp3inc_ci=zeros(HT,length(tspan),2);
    grp3inc_s=zeros(HT,length(tspan));
    
    grp1inc_rl_avg=zeros(HT,length(tspan));
    grp1inc_rl_ci=zeros(HT,length(tspan),2);
    grp1inc_rl_s=zeros(HT,length(tspan));
    grp2inc_rl_avg=zeros(HT,length(tspan));
    grp2inc_rl_ci=zeros(HT,length(tspan),2);
    grp2inc_rl_s=zeros(HT,length(tspan));
    grp3inc_rl_avg=zeros(HT,length(tspan));
    grp3inc_rl_ci=zeros(HT,length(tspan),2);
    grp3inc_rl_s=zeros(HT,length(tspan));
    
    grp1inc_nc_avg=zeros(HT,length(tspan));
    grp1inc_nc_ci=zeros(HT,length(tspan),2);
    grp1inc_nc_s=zeros(HT,length(tspan));
    grp2inc_nc_avg=zeros(HT,length(tspan));
    grp2inc_nc_ci=zeros(HT,length(tspan),2);
    grp2inc_nc_s=zeros(HT,length(tspan));
    grp3inc_nc_avg=zeros(HT,length(tspan));
    grp3inc_nc_ci=zeros(HT,length(tspan),2);
    grp3inc_nc_s=zeros(HT,length(tspan));
    
    grprents=cell(HT,length(tspan),3);
    ngrprents=cell(HT,length(tspan),3);
    grprents_rl=cell(HT,length(tspan),3);
    grprents_nc=cell(HT,length(tspan),3);
    grpincome=cell(HT,length(tspan),3);
    grpincome_rl=cell(HT,length(tspan),3);
    grpincome_nc=cell(HT,length(tspan),3);
    for ht=1:HT
        for tt=1:length(tspan)
            [mu,sigma,muci,~]=normfit(rent_rl{ht,tt});
            rent_rl_avg(ht,tt)=mu;
            rent_rl_s(ht,tt)=sigma;
            rent_rl_ci(ht,tt,:)=muci;
            
            [mu,sigma,muci,sigmaci]=normfit(rent_nc{ht,tt});
            rent_nc_avg(ht,tt)=mu;
            rent_nc_s(ht,tt)=sigma;
            rent_nc_ci(ht,tt,:)=muci;
            
            if isempty(find(inc_rl{ht,tt},1))==0
                [mu,sigma,muci,sigmaci]=normfit(inc_rl{ht,tt});
                inc_rl_avg(ht,tt)=mu;
                inc_rl_s(ht,tt)=sigma;
                inc_rl_ci(ht,tt,:)=muci;
            end
            
            if isempty(find(inc_nc{ht,tt},1))==0
                [mu,sigma,muci,sigmaci]=normfit(inc_nc{ht,tt});
                inc_nc_avg(ht,tt)=mu;
                inc_nc_s(ht,tt)=sigma;
                inc_nc_ci(ht,tt,:)=muci;
            end
            
            % Group by damage level
            igrp1_rl=(grp_rl{ht,tt} == 1);
            igrp2_rl=(grp_rl{ht,tt} == 2);
            igrp3_rl=(grp_rl{ht,tt} == 3);
            igrp1_nc=(grp_nc{ht,tt} == 1);
            igrp2_nc=(grp_nc{ht,tt} == 2);
            igrp3_nc=(grp_nc{ht,tt} == 3);
            % damage-grouped rents
            subrent_rl=rent_rl{ht,tt};
            subrent_nc=rent_nc{ht,tt};
            % relocation groups combined
            % rents by damage group
            grprents(ht,tt,1)=mat2cell([grprents{ht,tt,1}; subrent_rl(igrp1_rl);...
                subrent_nc(igrp1_nc)],length(grprents{ht,tt,1})+...
                length(subrent_rl(igrp1_rl))+length(subrent_nc(igrp1_nc)),1);
            grprents(ht,tt,2)=mat2cell([grprents{ht,tt,2}; subrent_rl(igrp2_rl);...
                subrent_nc(igrp2_nc)],length(grprents{ht,tt,2})+...
                length(subrent_rl(igrp2_rl))+length(subrent_nc(igrp2_nc)),1);
            grprents(ht,tt,3)=mat2cell([grprents{ht,tt,3}; subrent_rl(igrp3_rl);...
                subrent_nc(igrp3_nc)],length(grprents{ht,tt,3})+...
                length(subrent_rl(igrp3_rl))+length(subrent_nc(igrp3_nc)),1);
            
            % number of sales by damage group
            ngrprents(ht,tt,1)=mat2cell([ngrprents{ht,tt,1}; subrent_rl(igrp1_rl);...
                subrent_nc(igrp1_nc)],length(ngrprents{ht,tt,1})+...
                length(subrent_rl(igrp1_rl))+length(subrent_nc(igrp1_nc)),1);
            ngrprents(ht,tt,2)=mat2cell([ngrprents{ht,tt,2}; subrent_rl(igrp2_rl);...
                subrent_nc(igrp2_nc)],length(ngrprents{ht,tt,2})+...
                length(subrent_rl(igrp2_rl))+length(subrent_nc(igrp2_nc)),1);
            ngrprents(ht,tt,3)=mat2cell([ngrprents{ht,tt,3}; subrent_rl(igrp3_rl);...
                subrent_nc(igrp3_nc)],length(ngrprents{ht,tt,3})+...
                length(subrent_rl(igrp3_rl))+length(subrent_nc(igrp3_nc)),1);
            
            [mu,sigma,muci,sigmaci]=normfit(grprents{ht,tt,1});
            grp1rent_avg(ht,tt)=mu;
            grp1rent_s(ht,tt)=sigma;
            grp1rent_ci(ht,tt,:)=muci;
            
            [mu,sigma,muci,sigmaci]=normfit(grprents{ht,tt,2});
            grp2rent_avg(ht,tt)=mu;
            grp2rent_s(ht,tt)=sigma;
            grp2rent_ci(ht,tt,:)=muci;
            
            [mu,sigma,muci,sigmaci]=normfit(grprents{ht,tt,3});
            grp3rent_avg(ht,tt)=mu;
            grp3rent_s(ht,tt)=sigma;
            grp3rent_ci(ht,tt,:)=muci;
            
            % damage group by relocation
            if isempty(find(subrent_rl(igrp1_rl),1))==0
            grprents_rl(ht,tt,1)=mat2cell([grprents_rl{ht,tt,1}; ...
                subrent_rl(igrp1_rl)],length(grprents_rl{ht,tt,1})+...
                length(subrent_rl(igrp1_rl)),1);
            end
            if isempty(find(subrent_rl(igrp2_rl),1))==0
            grprents_rl(ht,tt,2)=mat2cell([grprents_rl{ht,tt,2}; ...
                subrent_rl(igrp2_rl)],length(grprents_rl{ht,tt,2})+...
                length(subrent_rl(igrp2_rl)),1);
            end
            if isempty(find(subrent_rl(igrp3_rl),1))==0
            grprents_rl(ht,tt,3)=mat2cell([grprents_rl{ht,tt,3}; ...
                subrent_rl(igrp3_rl)],length(grprents_rl{ht,tt,3})+...
                length(subrent_rl(igrp3_rl)),1);
            end
            
            [mu,sigma,muci,sigmaci]=normfit(grprents_rl{ht,tt,1});
            if isempty(find(grprents_rl{ht,tt,1},1))==0
            grp1rent_rl_avg(ht,tt)=mu;
            grp1rent_rl_s(ht,tt)=sigma;
            grp1rent_rl_ci(ht,tt,:)=muci;
            end
            
            [mu,sigma,muci,sigmaci]=normfit(grprents_rl{ht,tt,2});
            if isempty(find(grprents_rl{ht,tt,2},1))==0
            grp2rent_rl_avg(ht,tt)=mu;
            grp2rent_rl_s(ht,tt)=sigma;
            grp2rent_rl_ci(ht,tt,:)=muci;
            end
            
            [mu,sigma,muci,sigmaci]=normfit(grprents_rl{ht,tt,3});
            if isempty(find(grprents_rl{ht,tt,3},1))==0
            grp3rent_rl_avg(ht,tt)=mu;
            grp3rent_rl_s(ht,tt)=sigma;
            grp3rent_rl_ci(ht,tt,:)=muci;
            end
            % damage group by no change
            grprents_nc(ht,tt,1)=mat2cell([grprents_nc{ht,tt,1}; ...
                subrent_nc(igrp1_nc)],length(grprents_nc{ht,tt,1})+...
                length(subrent_nc(igrp1_nc)),1);
            grprents_nc(ht,tt,2)=mat2cell([grprents_nc{ht,tt,2}; ...
                subrent_nc(igrp2_nc)],length(grprents_nc{ht,tt,2})+...
                length(subrent_nc(igrp2_nc)),1);
            grprents_nc(ht,tt,3)=mat2cell([grprents_nc{ht,tt,3}; ...
                subrent_nc(igrp3_nc)],length(grprents_nc{ht,tt,3})+...
                length(subrent_nc(igrp3_nc)),1);
            
            [mu,sigma,muci,sigmaci]=normfit(grprents_nc{ht,tt,1});
            grp1rent_nc_avg(ht,tt)=mu;
            grp1rent_nc_s(ht,tt)=sigma;
            grp1rent_nc_ci(ht,tt,:)=muci;
            
            [mu,sigma,muci,sigmaci]=normfit(grprents_nc{ht,tt,2});
            grp2rent_nc_avg(ht,tt)=mu;
            grp2rent_nc_s(ht,tt)=sigma;
            grp2rent_nc_ci(ht,tt,:)=muci;
            
            [mu,sigma,muci,sigmaci]=normfit(grprents_nc{ht,tt,3});
            grp3rent_nc_avg(ht,tt)=mu;
            grp3rent_nc_s(ht,tt)=sigma;
            grp3rent_nc_ci(ht,tt,:)=muci;
            
            % damage-grouped incomes
            subgrp_rl=grp_rl{ht,tt};
            subgrp_nc=grp_nc{ht,tt};
            subincgrp_rl=incgrp_rl{ht,tt};
            subincgrp_nc=incgrp_nc{ht,tt};
            isgrp1_rl=(subgrp_rl(subincgrp_rl == 1) == 1);
            isgrp2_rl=(subgrp_rl(subincgrp_rl == 1) == 2);
            isgrp3_rl=(subgrp_rl(subincgrp_rl == 1) == 3);
            isgrp1_nc=(subgrp_nc(subincgrp_nc == 1) == 1);
            isgrp2_nc=(subgrp_nc(subincgrp_nc == 1) == 2);
            isgrp3_nc=(subgrp_nc(subincgrp_nc == 1) == 3);
            
            subinc_rl=inc_rl{ht,tt};
            subinc_nc=inc_nc{ht,tt};
            grpincome(ht,tt,1)=mat2cell([grpincome{ht,tt,1}; subinc_rl(isgrp1_rl);...
                subinc_nc(isgrp1_nc)],length(grpincome{ht,tt,1})+...
                length(subinc_rl(isgrp1_rl))+length(subinc_nc(isgrp1_nc)),1);
            grpincome(ht,tt,2)=mat2cell([grpincome{ht,tt,2}; subinc_rl(isgrp2_rl);...
                subinc_nc(isgrp2_nc)],length(grpincome{ht,tt,2})+...
                length(subinc_rl(isgrp2_rl))+length(subinc_nc(isgrp2_nc)),1);
            grpincome(ht,tt,3)=mat2cell([grpincome{ht,tt,3}; subinc_rl(isgrp3_rl);...
                subinc_nc(isgrp3_nc)],length(grpincome{ht,tt,3})+...
                length(subinc_rl(isgrp3_rl))+length(subinc_nc(isgrp3_nc)),1);
            
            [mu,sigma,muci,sigmaci]=normfit(grpincome{ht,tt,1});
            grp1inc_avg(ht,tt)=mu;
            grp1inc_s(ht,tt)=sigma;
            grp1inc_ci(ht,tt,:)=muci;
            
            [mu,sigma,muci,sigmaci]=normfit(grpincome{ht,tt,2});
            grp2inc_avg(ht,tt)=mu;
            grp2inc_s(ht,tt)=sigma;
            grp2inc_ci(ht,tt,:)=muci;
            
            [mu,sigma,muci,sigmaci]=normfit(grpincome{ht,tt,3});
            grp3inc_avg(ht,tt)=mu;
            grp3inc_s(ht,tt)=sigma;
            grp3inc_ci(ht,tt,:)=muci;
            
            % damage group by relocation
            if isempty(find(subinc_rl(isgrp1_rl),1))==0
            grpincome_rl(ht,tt,1)=mat2cell([grpincome_rl{ht,tt,1}; subinc_rl(isgrp1_rl)],...
                length(grpincome_rl{ht,tt,1})+length(subinc_rl(isgrp1_rl)),1);
            end
            if isempty(find(subinc_rl(isgrp2_rl),1))==0
            grpincome_rl(ht,tt,2)=mat2cell([grpincome_rl{ht,tt,2}; subinc_rl(isgrp2_rl)],...
                length(grpincome_rl{ht,tt,2})+length(subinc_rl(isgrp2_rl)),1);
            end
            if isempty(find(subinc_rl(isgrp3_rl),1))==0
                grpincome_rl(ht,tt,3)=mat2cell([grpincome_rl{ht,tt,3}; subinc_rl(isgrp3_rl)],...
                length(grpincome_rl{ht,tt,3})+length(subinc_rl(isgrp3_rl)),1);
            end
            [mu,sigma,muci,sigmaci]=normfit(grpincome_rl{ht,tt,1});
            if isempty(find(grpincome_rl{ht,tt,1},1))==0
            grp1inc_rl_avg(ht,tt)=mu;
            grp1inc_rl_s(ht,tt)=sigma;
            grp1inc_rl_ci(ht,tt,:)=muci;
            end
            
            [mu,sigma,muci,sigmaci]=normfit(grpincome_rl{ht,tt,2});
            if isempty(find(grpincome_rl{ht,tt,2},1))==0
            grp2inc_rl_avg(ht,tt)=mu;
            grp2inc_rl_s(ht,tt)=sigma;
            grp2inc_rl_ci(ht,tt,:)=muci;
            end
            
            [mu,sigma,muci,sigmaci]=normfit(grpincome_rl{ht,tt,3});
            if isempty(find(grpincome_rl{ht,tt,3},1))==0
            grp3inc_rl_avg(ht,tt)=mu;
            grp3inc_rl_s(ht,tt)=sigma;
            grp3inc_rl_ci(ht,tt,:)=muci;
            end
            
            % damage group by no change
            grpincome_nc(ht,tt,1)=mat2cell([grpincome_nc{ht,tt,1}; subinc_nc(isgrp1_nc)],...
                length(grpincome_nc{ht,tt,1})+length(subinc_nc(isgrp1_nc)),1);
            grpincome_nc(ht,tt,2)=mat2cell([grpincome_nc{ht,tt,2}; subinc_nc(isgrp2_nc)],...
                length(grpincome_nc{ht,tt,2})+length(subinc_nc(isgrp2_nc)),1);
            grpincome_nc(ht,tt,3)=mat2cell([grpincome_nc{ht,tt,3}; subinc_nc(isgrp3_nc)],...
                length(grpincome_nc{ht,tt,3})+length(subinc_nc(isgrp3_nc)),1);
            
            [mu,sigma,muci,sigmaci]=normfit(grpincome_nc{ht,tt,1});
            grp1inc_nc_avg(ht,tt)=mu;
            grp1inc_nc_s(ht,tt)=sigma;
            grp1inc_nc_ci(ht,tt,:)=muci;
            
            [mu,sigma,muci,sigmaci]=normfit(grpincome_nc{ht,tt,2});
            grp2inc_nc_avg(ht,tt)=mu;
            grp2inc_nc_s(ht,tt)=sigma;
            grp2inc_nc_ci(ht,tt,:)=muci;
            
            [mu,sigma,muci,sigmaci]=normfit(grpincome_nc{ht,tt,3});
            grp3inc_nc_avg(ht,tt)=mu;
            grp3inc_nc_s(ht,tt)=sigma;
            grp3inc_nc_ci(ht,tt,:)=muci;
        end
        cd X:\model_results\CHALMS_event_simple_062016\figs
        %%% Absolute level figures
        % plot rents by damage group
        hh=figure;
        set(hh,'Color','white','Visible','off')
        plot(tspan,grp1rent_avg(ht,:),'-k','LineWidth',3)
        xlim([min(tspan)-0.5 max(tspan)+0.5])
        hold on
        plot(tspan,grp2rent_avg(ht,:),'-b','LineWidth',3)
        plot(tspan,grp3rent_avg(ht,:),'-r','LineWidth',3)
        legend('Low Damage','Medium Damage','High Damage')
        errorbar(tspan,grp1rent_avg(ht,:),grp1rent_ci(ht,:,1)-grp1rent_avg(ht,:),...
            grp1rent_avg(ht,:)-grp1rent_ci(ht,:,2),'.k','LineWidth',1)
        errorbar(tspan,grp2rent_avg(ht,:),grp2rent_ci(ht,:,1)-grp2rent_avg(ht,:),...
            grp2rent_avg(ht,:)-grp2rent_ci(ht,:,2),'.b','LineWidth',1)
        errorbar(tspan,grp3rent_avg(ht,:),grp3rent_ci(ht,:,1)-grp3rent_avg(ht,:),...
            grp3rent_ci(ht,:,2)-grp3rent_avg(ht,:),'.r','LineWidth',1)
        set(gca,'Xtick',start_t:end_t)
        ylabel('Average Housing Prices')
        xlabel('Time Since Storm')
        title(sprintf('Average Prices for Housing, %s',runnamelabel{N}))
        saveas(hh,sprintf('rent_dmg_%s',runnamelabel{N}),'jpg')
        clf
        
        % plot rents by relocate vs no change
        hh1=figure;
        set(hh1,'Color','white','Visible','off')
        plot(tspan,rent_rl_avg(ht,:),'-r','LineWidth',3)
        xlim([min(tspan)-0.5 max(tspan)+0.5])
        hold on
        plot(tspan,rent_nc_avg(ht,:),'-k','LineWidth',3)
        legend('Lots with Relocations','No Relocations')
        errorbar(tspan,rent_rl_avg(ht,:),rent_rl_ci(ht,:,1)-rent_rl_avg(ht,:),...
            rent_rl_avg(ht,:)-rent_rl_ci(ht,:,2),'.r','LineWidth',1)
        errorbar(tspan,rent_nc_avg(ht,:),rent_nc_ci(ht,:,1)-rent_nc_avg(ht,:),...
            rent_nc_avg(ht,:)-rent_nc_ci(ht,:,2),'.k','LineWidth',1)
        set(gca,'Xtick',start_t:end_t)
        ylabel('Average Housing Prices')
        xlabel('Time Since Storm')
        title(sprintf('Average Prices for Housing, %s',runnamelabel{N}))
        saveas(hh1,sprintf('rent_reloc_%s',runnamelabel{N}),'jpg')
        clf
        
        % plot incomes by damage group
        hh2=figure;
        set(hh2,'Color','white','Visible','off')
        plot(tspan,grp1inc_avg(ht,:),'-k','LineWidth',3)
        xlim([min(tspan)-0.5 max(tspan)+0.5])
        hold on
        plot(tspan,grp2inc_avg(ht,:),'-b','LineWidth',3)
        plot(tspan,grp3inc_avg(ht,:),'-r','LineWidth',3)
        legend('Low Damage','Medium Damage','High Damage')
        errorbar(tspan,grp1inc_avg(ht,:),grp1inc_ci(ht,:,2)-grp1inc_avg(ht,:),...
            grp1inc_avg(ht,:)-grp1inc_ci(ht,:,1),'.k','LineWidth',1)
        errorbar(tspan,grp2inc_avg(ht,:),grp2inc_ci(ht,:,2)-grp2inc_avg(ht,:),...
            grp2inc_avg(ht,:)-grp2inc_ci(ht,:,1),'.b','LineWidth',1)
        errorbar(tspan,grp3inc_avg(ht,:),grp3inc_ci(ht,:,2)-grp3inc_avg(ht,:),...
            grp3inc_avg(ht,:)-grp3inc_ci(ht,:,1),'.r','LineWidth',1)
        set(gca,'Xtick',start_t:end_t)
        ylabel('Average Income')
        xlabel('Time Since Storm')
        title(sprintf('Average Income for Housing, %s',runnamelabel{N}))
        saveas(hh2,sprintf('inc_dmg_%s',runnamelabel{N}),'jpg')
        clf
        
        % plot incomes by relocate vs no change
        hh3=figure;
        set(hh3,'Color','white','Visible','off')
        plot(tspan,inc_rl_avg(ht,:),'-r','LineWidth',3)
        xlim([min(tspan)-0.5 max(tspan)+0.5])
        hold on
        plot(tspan,inc_nc_avg(ht,:),'-k','LineWidth',3)
        legend('Lots with Relocations','No Relocations')
        errorbar(tspan,inc_rl_avg(ht,:),inc_rl_ci(ht,:,1)-inc_rl_avg(ht,:),...
            inc_rl_avg(ht,:)-inc_rl_ci(ht,:,2),'.r','LineWidth',1)
        errorbar(tspan,inc_nc_avg(ht,:),inc_nc_ci(ht,:,1)-inc_nc_avg(ht,:),...
            inc_nc_avg(ht,:)-inc_nc_ci(ht,:,2),'.k','LineWidth',1)
        set(gca,'Xtick',start_t:end_t)
        ylabel('Average Income Change')
        xlabel('Time Since Storm')
        title(sprintf('Average Incomes for Housing, %s',runnamelabel{N}))
        saveas(hh3,sprintf('inc_reloc_%s',runnamelabel{N}),'jpg')
        clf
                
        %%% Change figures
        % plot rents by damage group
        hh4=figure;
        set(hh4,'Color','white','Visible','off')
        plot(tspan(2:length(tspan)),diff(grp1rent_avg(ht,:)),'-k','LineWidth',3)
        hold on
        plot(tspan(2:length(tspan)),diff(grp2rent_avg(ht,:)),'-b','LineWidth',3)
        plot(tspan(2:length(tspan)),diff(grp3rent_avg(ht,:)),'-r','LineWidth',3)
        legend('Low Damage','Medium Damage','High Damage')
        errorbar(tspan(2:length(tspan)),diff(grp1rent_avg(ht,:)),diff(grp1rent_ci(ht,:,1)),...
            diff(grp1rent_ci(ht,:,2)),'.k','LineWidth',1)
        errorbar(tspan(2:length(tspan)),diff(grp2rent_avg(ht,:)),diff(grp2rent_ci(ht,:,1)),...
            diff(grp2rent_ci(ht,:,2)),'.b','LineWidth',1)
        errorbar(tspan(2:length(tspan)),diff(grp3rent_avg(ht,:)),diff(grp3rent_ci(ht,:,1)),...
            diff(grp3rent_ci(ht,:,2)),'.r','LineWidth',1)
        set(gca,'Xtick',start_t:end_t)
        xlim([-2.5 2.5])
        ylabel('Average Housing Price Change')
        xlabel('Time Since Storm')
        title(sprintf('Price Change for Housing by Damage Category, %s',runnamelabel{N}))
        saveas(hh4,sprintf('rent_diff_dmg_%s',runnamelabel{N}),'jpg')
        clf
        
        % plot rents by relocate vs no change
        hh5=figure;
        set(hh5,'Color','white','Visible','off')
        plot(tspan(2:length(tspan)),diff(rent_rl_avg(ht,:)),'-r','LineWidth',3)
%         xlim([min(tspan)-0.5 max(tspan)+0.5])
        hold on
        plot(tspan(2:length(tspan)),diff(rent_nc_avg(ht,:)),'-k','LineWidth',3)
        legend('Lots with Relocations','No Relocations')
        errorbar(tspan(2:length(tspan)),diff(rent_rl_avg(ht,:)),diff(rent_rl_ci(ht,:,1)),...
            diff(rent_rl_ci(ht,:,2)),'.r','LineWidth',1)
        errorbar(tspan(2:length(tspan)),diff(rent_nc_avg(ht,:)),diff(rent_nc_ci(ht,:,1)),...
            diff(rent_nc_ci(ht,:,2)),'.k','LineWidth',1)
        set(gca,'Xtick',start_t:end_t)
        xlim([-2.5 2.5])
        ylabel('Average Housing Price Change')
        xlabel('Time Since Storm')
        title(sprintf('Price Change for Housing by Ownership Status, %s',runnamelabel{N}))
        saveas(hh5,sprintf('rent_diff_reloc_%s',runnamelabel{N}),'jpg')
        clf
        
        % plot incomes by damage group
        hh6=figure;
        set(hh6,'Color','white','Visible','off')
        plot(tspan(2:length(tspan)),diff(grp1inc_avg(ht,:)),'-k','LineWidth',3)
%         xlim([min(tspan)-0.5 max(tspan)+0.5])
        hold on
        plot(tspan(2:length(tspan)),diff(grp2inc_avg(ht,:)),'-b','LineWidth',3)
        plot(tspan(2:length(tspan)),diff(grp3inc_avg(ht,:)),'-r','LineWidth',3)
        legend('Low Damage','Medium Damage','High Damage')
        errorbar(tspan(2:length(tspan)),diff(grp1inc_avg(ht,:)),diff(grp1inc_ci(ht,:,1)),...
            diff(grp1inc_ci(ht,:,2)),'.k','LineWidth',1)
        errorbar(tspan(2:length(tspan)),diff(grp2inc_avg(ht,:)),diff(grp2inc_ci(ht,:,1)),...
            diff(grp2inc_ci(ht,:,2)),'.b','LineWidth',1)
        errorbar(tspan(2:length(tspan)),diff(grp3inc_avg(ht,:)),diff(grp3inc_ci(ht,:,1)),...
            diff(grp3inc_ci(ht,:,2)),'.r','LineWidth',1)
        set(gca,'Xtick',start_t:end_t)
        xlim([-2.5 2.5])
        ylabel('Average Household Income Change')
        xlabel('Time Since Storm')
        title(sprintf('Average Household Income Change by Damage Category, %s',runnamelabel{N}))
        saveas(hh6,sprintf('inc_diff_dmg_%s',runnamelabel{N}),'jpg')
        clf
        
        % plot incomes by relocate vs no change
        hh7=figure;
        set(hh7,'Color','white','Visible','off')
        plot(tspan(2:length(tspan)),diff(inc_rl_avg(ht,:)),'-r','LineWidth',3)
%         xlim([min(tspan)-0.5 max(tspan)+0.5])
        hold on
        plot(tspan(2:length(tspan)),diff(inc_nc_avg(ht,:)),'-k','LineWidth',3)
        legend('Lots with Relocations','No Relocations')
        errorbar(tspan(2:length(tspan)),diff(inc_rl_avg(ht,:)),diff(inc_rl_ci(ht,:,1)),...
            diff(inc_rl_ci(ht,:,2)),'.r','LineWidth',1)
        errorbar(tspan(2:length(tspan)),diff(inc_nc_avg(ht,:)),diff(inc_nc_ci(ht,:,1)),...
            diff(inc_nc_ci(ht,:,2)),'.k','LineWidth',1)
        set(gca,'Xtick',start_t:end_t)
        xlim([-2.5 2.5])
        ylabel('Average Income Change')
        xlabel('Time Since Storm')
        title(sprintf('Average Household Income Change by Ownership Status, %s',runnamelabel{N}))
        saveas(hh7,sprintf('inc_diff_reloc_%s',runnamelabel{N}),'jpg')
        clf
        
        cd X:\model_results\CHALMS_event_simple_062016
    end
    %%% Calculate diff
    rentdiff_ht_save(3,N)=mat2cell(diff(grp3rent_avg,1,2),HT,length(tspan)-1);
    rentdiff_ht_save(2,N)=mat2cell(diff(grp2rent_avg,1,2),HT,length(tspan)-1);
    rentdiff_ht_save(1,N)=mat2cell(diff(grp1rent_avg,1,2),HT,length(tspan)-1);
    rentdiff_rl_save(N)=mat2cell(diff(rent_rl_avg,1,2),HT,length(tspan)-1);
    rentdiff_nc_save(N)=mat2cell(diff(rent_nc_avg,1,2),HT,length(tspan)-1);
    
    rent_ht_save(3,N)=mat2cell(grp3rent_avg,HT,length(tspan));
    rent_ht_save(2,N)=mat2cell(grp2rent_avg,HT,length(tspan));
    rent_ht_save(1,N)=mat2cell(grp1rent_avg,HT,length(tspan));
    rentrl_save(N)=mat2cell(rent_rl_avg,HT,length(tspan));
    rentnc_save(N)=mat2cell(rent_nc_avg,HT,length(tspan));
    rent_grprl_save(3,N)=mat2cell(grp3rent_rl_avg,HT,length(tspan));
    rent_grprl_save(2,N)=mat2cell(grp2rent_rl_avg,HT,length(tspan));
    rent_grprl_save(1,N)=mat2cell(grp1rent_rl_avg,HT,length(tspan));
    rent_grpnc_save(3,N)=mat2cell(grp3rent_nc_avg,HT,length(tspan));
    rent_grpnc_save(2,N)=mat2cell(grp2rent_nc_avg,HT,length(tspan));
    rent_grpnc_save(1,N)=mat2cell(grp1rent_nc_avg,HT,length(tspan));
    
    inc_ht_save(3,N)=mat2cell(grp3inc_avg,HT,length(tspan));
    inc_ht_save(2,N)=mat2cell(grp2inc_avg,HT,length(tspan));
    inc_ht_save(1,N)=mat2cell(grp1inc_avg,HT,length(tspan));
    incrl_save(N)=mat2cell(inc_rl_avg,HT,length(tspan));
    incnc_save(N)=mat2cell(inc_nc_avg,HT,length(tspan));
    inc_grprl_save(3,N)=mat2cell(grp3inc_rl_avg,HT,length(tspan));
    inc_grprl_save(2,N)=mat2cell(grp2inc_rl_avg,HT,length(tspan));
    inc_grprl_save(1,N)=mat2cell(grp1inc_rl_avg,HT,length(tspan));
    inc_grpnc_save(3,N)=mat2cell(grp3inc_nc_avg,HT,length(tspan));
    inc_grpnc_save(2,N)=mat2cell(grp2inc_nc_avg,HT,length(tspan));
    inc_grpnc_save(1,N)=mat2cell(grp1inc_nc_avg,HT,length(tspan));
end


% 
% % figures
% cd X:\model_results\diffNdiff_analysis
% runnamelabel={'Mid-Atl','NC','FL','TX'};
% for N=1:ERUNS
%     for ht=1:HT
%         % plot rents by damage group
%         hh=figure;
%         set(hh,'Color','white','Visible','off')
%         plot(tspan(2:length(tspan)),diff(grp1rent_avg(ht,:)),'-k','LineWidth',3)
%         xlim([-4.5 4.5])
%         hold on
%         plot(tspan(2:length(tspan)),diff(grp2rent_avg(ht,:)),'-b','LineWidth',3)
%         plot(tspan(2:length(tspan)),diff(grp3rent_avg(ht,:)),'-r','LineWidth',3)
%         legend('Low Damage','Medium Damage','High Damage')
%         errorbar(tspan(2:length(tspan)),diff(grp1rent_ci(ht,:,1)),...
%             diff(grp1rent_ci(ht,:,2)),'.k','LineWidth',1)
%         errorbar(tspan(2:length(tspan)),diff(grp2rent_ci(ht,:,1)),...
%             diff(grp2rent_ci(ht,:,2)),'.b','LineWidth',1)
%         errorbar(tspan(2:length(tspan)),diff(grp3rent_ci(ht,:,1)),...
%             diff(grp3rent_ci(ht,:,2)),'.r','LineWidth',1)
%         ylabel('Average Housing Price Change')
%         xlabel('Time Since Storm')
%         title(sprintf('Price Change for Housing Type %d, %s',ht,runnamelabel{N}))
%         saveas(hh,sprintf('rent_diff_dmg_%d_%s',ht,runnamelabel{N}),'jpg')
%         clf
%         
%         % plot rents by relocate vs no change
%         hh1=figure;
%         set(hh1,'Color','white','Visible','off')
%         plot(tspan(2:length(tspan)),diff(rent_rl_avg(ht,:)),'-r','LineWidth',3)
%         xlim([-4.5 4.5])
%         hold on
%         plot(tspan(2:length(tspan)),diff(rent_nc_avg(ht,:)),'-k','LineWidth',3)
%         legend('Lots with Relocations','No Relocations')
%         errorbar(tspan(2:length(tspan)),diff(rent_rl_ci(ht,:,1)),...
%             diff(rent_rl_ci(ht,:,2)),'.r','LineWidth',1)
%         errorbar(tspan(2:length(tspan)),diff(rent_nc_ci(ht,:,1)),...
%             diff(rent_nc_ci(ht,:,2)),'.k','LineWidth',1)
%         ylabel('Average Housing Price Change')
%         xlabel('Time Since Storm')
%         title(sprintf('Price Change for Housing Type %d, %s',ht,runnamelabel{N}))
%         saveas(hh1,sprintf('rent_diff_reloc_%d_%s',ht,runnamelabel{N}),'jpg')
%         clf
%         
%         % plot incomes by damage group
%         hh2=figure;
%         set(hh2,'Color','white','Visible','off')
%         plot(tspan(2:length(tspan)),diff(grp1inc_avg(ht,:)),'-k','LineWidth',3)
%         xlim([-4.5 4.5])
%         hold on
%         plot(tspan(2:length(tspan)),diff(grp2inc_avg(ht,:)),'-b','LineWidth',3)
%         plot(tspan(2:length(tspan)),diff(grp3inc_avg(ht,:)),'-r','LineWidth',3)
%         legend('Low Damage','Medium Damage','High Damage')
%         errorbar(tspan(2:length(tspan)),diff(grp1inc_ci(ht,:,1)),...
%             diff(grp1inc_ci(ht,:,2)),'.k','LineWidth',1)
%         errorbar(tspan(2:length(tspan)),diff(grp2inc_ci(ht,:,1)),...
%             diff(grp2inc_ci(ht,:,2)),'.b','LineWidth',1)
%         errorbar(tspan(2:length(tspan)),diff(grp3inc_ci(ht,:,1)),...
%             diff(grp3inc_ci(ht,:,2)),'.r','LineWidth',1)
%         ylabel('Average Housing Price Change')
%         xlabel('Time Since Storm')
%         title(sprintf('Price Change for Housing Type %d, %s',ht,runnamelabel{N}))
%         saveas(hh2,sprintf('inc_diff_dmg_%d_%s',ht,runnamelabel{N}),'jpg')
%         clf
%         
%         % plot incomes by relocate vs no change
%         hh3=figure;
%         set(hh3,'Color','white','Visible','off')
%         plot(tspan(2:length(tspan)),diff(inc_rl_avg(ht,:)),'-r','LineWidth',3)
%         xlim([-4.5 4.5])
%         hold on
%         plot(tspan(2:length(tspan)),diff(inc_nc_avg(ht,:)),'-k','LineWidth',3)
%         legend('Lots with Relocations','No Relocations')
%         errorbar(tspan(2:length(tspan)),diff(inc_rl_ci(ht,:,1)),...
%             diff(inc_rl_ci(ht,:,2)),'.r','LineWidth',1)
%         errorbar(tspan(2:length(tspan)),diff(inc_nc_ci(ht,:,1)),...
%             diff(inc_nc_ci(ht,:,2)),'.k','LineWidth',1)
%         ylabel('Average Income Change')
%         xlabel('Time Since Storm')
%         title(sprintf('Price Change for Housing Type %d, %s',ht,runnamelabel{N}))
%         saveas(hh3,sprintf('inc_diff_reloc_%d_%s',ht,runnamelabel{N}),'jpg')
%         clf
%     end
% end
%%%%%%%%%%%% Difference in Differences Analysis %%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Analyses to run
% 1. baseline vs. different storm climates, objective risk perception
%   % a. across potential damage categories
%   % b. across housing types
%   % c. across damage groups and housing types
% 2. baseline vs. different storm climates, subjective risk perception
%   % a. across potential damage categories
%   % b. across housing types
%   % c. across damage groups and housing types
% 3. compare objective vs. subjective risk outcomes

