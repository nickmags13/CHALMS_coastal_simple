%%%%%%%%% Revise figures to percentage %%%%%%%%%%%%%%%
cd C:\Users\nrmagliocca\'Box Sync'\'Data Drive'\model_results\CHALMS_event_ilandscape_030617_rnd
start_t=-5;
end_t=5;
tspan=start_t:end_t;
ERUNS=8;
nruns=30;
TSTART=10;
TMAX=30;


runnamelabel={'eu_max_MA','salience_MA','eu_max_NC','salience_NC',...
    'eu_max_TX','salience_TX','eu_max_FL','salience_FL'};

for N=1:ERUNS
    filename=sprintf('dmgclass_results_ilandscape_030617_rnd_%s.mat',runnamelabel{N});
    load(filename)
    
    totrents=mean(avgrents,2);
    
    cd C:\Users\nrmagliocca\'Box Sync'\'Data Drive'\model_results\CHALMS_event_ilandscape_030617_rnd\figs
    
    hh1=figure;
    set(hh1,'Color','white','Visible','off')
    plot(tspan(2:length(tspan)),diff(avgrents(3,:))./totrents(3),'-k','LineWidth',3)
    %         xlim([min(tspan)-0.5 max(tspan)+0.5])
    hold on
    plot(tspan(2:length(tspan)),diff(avgrents(2,:))./totrents(2),'-b','LineWidth',3)
    plot(tspan(2:length(tspan)),diff(avgrents(1,:))./totrents(1),'-r','LineWidth',3)
%     legend('Low Damage','Medium Damage','High Damage')
    errorbar(tspan(2:length(tspan)),diff(avgrents(3,:))./totrents(3),...
        abs(diff(avgrents(3,:))-diff(avgrents_ci(3,:,1)))./totrents(3),...
        abs(diff(avgrents(3,:))-diff(avgrents_ci(3,:,2)))./totrents(3),'.k','LineWidth',1)
    errorbar(tspan(2:length(tspan)),diff(avgrents(2,:))./totrents(2),...
        abs(diff(avgrents(2,:))-diff(avgrents_ci(2,:,1)))./totrents(2),...
        abs(diff(avgrents(2,:))-diff(avgrents_ci(2,:,2)))./totrents(2),'.b','LineWidth',1)
    errorbar(tspan(2:length(tspan)),diff(avgrents(1,:))./totrents(1),...
        abs(diff(avgrents(1,:))-diff(avgrents_ci(1,:,1)))./totrents(1),...
        abs(diff(avgrents(1,:))-diff(avgrents_ci(1,:,2)))./totrents(1),'.r','LineWidth',1)
    set(gca,'Xtick',start_t:end_t)
    xlim([-3 3])
    ylabel('Average Pct. Rent Change')
    xlabel('Time Since Storm')
    title(sprintf('Average Pct Rent Change by Damage Category, %s',runnamelabel{N}))
    saveas(hh1,sprintf('avgrent_pct_diff_dmg_new_%s',runnamelabel{N}),'jpg')
    clf
    cd ..
end