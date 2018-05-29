% Create overlaid figures

cd X:\model_results\CHALMS_event_ilandscape_030617
load mvcost_results_altmodels.mat

EXPTRUNS=8;
runnamelabel={'eu_max_MA','salience_MA','eu_max_NC','salience_NC',...
    'eu_max_TX','salience_TX','eu_max_FL','salience_FL'};

start_t=-4;
end_t=4;
tspan=start_t:end_t;

%correlation matrices
CORRn2=zeros(7,7,EXPTRUNS);   %[rent (dmg_hi dmg_med dmg_low), vacancy (dmg_hi dmg_med dmg_low), # lots], lag of 2
CORRn1=zeros(7,7,EXPTRUNS);
CORR0=zeros(7,7,EXPTRUNS);
CORRp1=zeros(7,7,EXPTRUNS);
CORRp2=zeros(7,7,EXPTRUNS);

for N=1:EXPTRUNS
    load(sprintf('dmgclass_results_ilandscape_030617_%s.mat',runnamelabel{N}))
    
%     rentvec=(diff(avgrents,1,2)-mean(diff(avgrents,1,2),2)*...
%         ones(1,length(2:11)))';
%     vacvec=(avgvacant(:,2:11)-mean(avgvacant,2)*ones(1,length(2:11)))';
%     lotvec=(dlots_avg_save(N,2:11)-mean(dlots_avg_save(N,2:11)))';
%     [R,P,RLO,RUP]=corrcoef([rentvec vacvec lotvec]);
    % Calculate pairwise time series cross-correlations 
    for dgr=1:3 %referencing avgrent
        for dgv=1:3 %referencing avgvacant
            if isempty(find(avgvacant(dgv,2:11),1)) == 1
                CORRn2(dgr,3+dgv,N)=r_rentvac(1);
                CORRn1(dgr,3+dgv,N)=0;
                CORR0(dgr,3+dgv,N)=0;
                CORRp1(dgr,3+dgv,N)=0;
                CORRp2(dgr,3+dgv,N)=0;
            else
%                 r_rentvac=xcorr(diff(avgrents(dgr,:))-mean(diff(avgrents(dgr,:))),...
%                     avgvacant(dgv,2:11)-mean(avgvacant(dgv,2:11)),2,'coeff');
                r_rentvac=xcorr(diff(avgrents(dgr,:))-median(diff(avgrents(dgr,:))),...
                    avgvacant(dgv,2:11)-median(avgvacant(dgv,2:11)),2,'coeff');
%                 r_rentvac=xcorr(diff(avgrents(dgr,:)),avgvacant(dgv,2:11),2,'coeff');
                CORRn2(dgr,3+dgv,N)=r_rentvac(1);
                CORRn1(dgr,3+dgv,N)=r_rentvac(2);
                CORR0(dgr,3+dgv,N)=r_rentvac(3);
                CORRp1(dgr,3+dgv,N)=r_rentvac(4);
                CORRp2(dgr,3+dgv,N)=r_rentvac(5);
            end
            if isempty(find(dlots_avg_save(N,:),1)) == 1
                CORRn2(7,3+dgv,N)=0;
                CORRn1(7,3+dgv,N)=0;
                CORR0(7,3+dgv,N)=0;
                CORRp1(7,3+dgv,N)=0;
                CORRp2(7,3+dgv,N)=0;
            else
%                 r_lotvac=xcorr(dlots_avg_save(N,:)-mean(dlots_avg_save(N,:)),...
%                     avgvacant(dgv,:)-mean(avgvacant(dgv,:)),2,'coeff');
                r_lotvac=xcorr(dlots_avg_save(N,:)-median(dlots_avg_save(N,:)),...
                    avgvacant(dgv,:)-median(avgvacant(dgv,:)),2,'coeff');
%                 r_lotvac=xcorr(dlots_avg_save(N,:),avgvacant(dgv,:),2,'coeff');
                CORRn2(7,3+dgv,N)=r_lotvac(1);
                CORRn1(7,3+dgv,N)=r_lotvac(2);
                CORR0(7,3+dgv,N)=r_lotvac(3);
                CORRp1(7,3+dgv,N)=r_lotvac(4);
                CORRp2(7,3+dgv,N)=r_lotvac(5);
            end
        end
        if isempty(find(dlots_avg_save(N,:),1)) == 1
            CORRn2(7,dgr,N)=0;
            CORRn1(7,dgr,N)=0;
            CORR0(7,dgr,N)=0;
            CORRp1(7,dgr,N)=0;
            CORRp2(7,dgr,N)=0;
        else
%             r_lotrent=xcorr(dlots_avg_save(N,2:11)-mean(dlots_avg_save(N,2:11)),...
%                 diff(avgrents(dgr,:))-mean(diff(avgrents(dgr,:))),2,'coeff');
            r_lotrent=xcorr(dlots_avg_save(N,2:11)-median(dlots_avg_save(N,2:11)),...
                diff(avgrents(dgr,:))-median(diff(avgrents(dgr,:))),2,'coeff');
%             r_lotrent=xcorr(dlots_avg_save(N,2:11),diff(avgrents(dgr,:)),2,'coeff');
            CORRn2(7,dgr,N)=r_lotrent(1);
            CORRn1(7,dgr,N)=r_lotrent(2);
            CORR0(7,dgr,N)=r_lotrent(3);
            CORRp1(7,dgr,N)=r_lotrent(4);
            CORRp2(7,dgr,N)=r_lotrent(5);
        end
    end
    
%     cd X:\model_results\CHALMS_event_ilandscape_030217\figs
%     h1=figure;
%     set(h1, 'Color','white','Position',[1,1,700,700],'Visible','off');
%     [ax,p1,p2]=plotyy(tspan,dlots_avg_save(N,2:10),tspan,avgvacant(:,2:10));
%     ylabel(ax(1),'Change in Number of Lots','FontSize',14,'Color','k')
%     set(ax(1),'YColor','k','FontSize',14)
%     set(ax(2),'YColor','k','FontSize',14)
%     ax(1).YLim=([0 20]);
%     ax(2).YLim=([0 40]);
%     ylabel(ax(2),'Average Vacancies by Damage Group')
%     p1.LineStyle='--';
%     p1.LineWidth=3;
%     p1.Color='k';
%     p2(1).LineStyle='-';
%     p2(1).Color='r';
%     p2(1).LineWidth=3;
%     p2(2).LineStyle='-';
%     p2(2).Color='b';
%     p2(2).LineWidth=3;
%     p2(3).LineStyle='-';
%     p2(3).Color='k';
%     p2(3).LineWidth=3;
%     set(gca,'Xtick',start_t:end_t)
% %     xlim([-4 4])
%     xlabel('Time Since Storm','FontSize',14)
%     legend('# Lots','High Damage','Medium Damage','Low Damage','Location','northwest')
%     title('Average Vacancies by Damage Category and Rate of Growth')
%     saveas(h1,sprintf('avgvac_dmg_dlots_%s',runnamelabel{N}),'jpg')
%     clf
%     cd X:\model_results\CHALMS_event_ilandscape_030217
end
save crosscorrs CORRn2 CORRn1 CORR0 CORRp1 CORRp2
    cd X:\model_results\CHALMS_event_ilandscape_030617\figs
% %Assemble histogram data
% % [(vac_med,#lot) MA NC TX FL;
% % [(vac_low,#lot) MA NC TX FL;
% % [(vac_med,rent_low) MA NC TX FL;
% % [(vac_low,rent_low) MA NC TX FL]
sameyr_eu=[CORR0(7,5,1) CORR0(7,5,3) CORR0(7,5,5) CORR0(7,5,7); ...
    CORR0(7,6,1) CORR0(7,6,3) CORR0(7,6,5) CORR0(7,6,7); ...
    CORR0(3,5,1) CORR0(3,5,3) CORR0(3,5,5) CORR0(3,5,7); ...
    CORR0(3,6,1) CORR0(3,6,3) CORR0(3,6,5) CORR0(3,6,7)];

plus1yr_eu=[CORRp1(7,5,1) CORRp1(7,5,3) CORRp1(7,5,5) CORRp1(7,5,7); ...
    CORRp1(7,6,1) CORRp1(7,6,3) CORRp1(7,6,5) CORRp1(7,6,7); ...
    CORRp1(3,5,1) CORRp1(3,5,3) CORRp1(3,5,5) CORRp1(3,5,7); ...
    CORRp1(3,6,1) CORRp1(3,6,3) CORRp1(3,6,5) CORRp1(3,6,7)];

plus2yr_eu=[CORRp2(7,5,1) CORRp2(7,5,3) CORRp2(7,5,5) CORRp2(7,5,7); ...
    CORRp2(7,6,1) CORRp2(7,6,3) CORRp2(7,6,5) CORRp2(7,6,7); ...
    CORRp2(3,5,1) CORRp2(3,5,3) CORRp2(3,5,5) CORRp2(3,5,7); ...
    CORRp2(3,6,1) CORRp2(3,6,3) CORRp2(3,6,5) CORRp2(3,6,7)];

sameyr_sal=[CORR0(7,5,2) CORR0(7,5,4) CORR0(7,5,6) CORR0(7,5,8); ...
    CORR0(7,6,2) CORR0(7,6,4) CORR0(7,6,6) CORR0(7,6,8); ...
    CORR0(3,5,2) CORR0(3,5,4) CORR0(3,5,6) CORR0(3,5,8); ...
    CORR0(3,6,2) CORR0(3,6,4) CORR0(3,6,6) CORR0(3,6,8)];

plus1yr_sal=[CORRp1(7,5,2) CORRp1(7,5,4) CORRp1(7,5,6) CORRp1(7,5,8); ...
    CORRp1(7,6,2) CORRp1(7,6,4) CORRp1(7,6,6) CORRp1(7,6,8); ...
    CORRp1(3,5,2) CORRp1(3,5,4) CORRp1(3,5,6) CORRp1(3,5,8); ...
    CORRp1(3,6,2) CORRp1(3,6,4) CORRp1(3,6,6) CORRp1(3,6,8)];

plus2yr_sal=[CORRp2(7,5,2) CORRp2(7,5,4) CORRp2(7,5,6) CORRp2(7,5,8); ...
    CORRp2(7,6,2) CORRp2(7,6,4) CORRp2(7,6,6) CORRp2(7,6,8); ...
    CORRp2(3,5,2) CORRp2(3,5,4) CORRp2(3,5,6) CORRp2(3,5,8); ...
    CORRp2(3,6,2) CORRp2(3,6,4) CORRp2(3,6,6) CORRp2(3,6,8)];
% 
% labels(1,1)={'med vac'
%     '#lots'};
% %%% plot bar charts
% Salience, same year
h1=figure;
set(h1,'color','white','Visible','off')
bar(sameyr_sal)
ax=gca;
ax.XTickLabel={'med vac,#lots','low vac,#lots',...
    'med vac,low rent','low vac,low rent'};
ax.YLim=[-1 0.8];
title('Cross-Correlation With No Lag, Salience Model')
ylabel('Correlation Coefficient')
xlabel('Correlates')
legend('MA','NC','TX','FL')
saveas(h1,'xcorr_sal_nolag','jpg')

% % Salience, plus one year
h2=figure;
set(h2,'color','white','Visible','off')
bar(plus1yr_sal)
ax=gca;
ax.XTickLabel={'med vac,#lots','low vac,#lots',...
    'med vac,low rent','low vac,low rent'};
ax.YLim=[-1 0.8];
title('Cross-Correlation With 1-yr Forward Lag, Salience Model')
ylabel('Correlation Coefficient')
xlabel('Correlates')
legend('MA','NC','TX','FL')
saveas(h2,'xcorr_sal_p1lag','jpg')

% % Salience, plus two year
h3=figure;
set(h3,'color','white','Visible','off')
bar(plus2yr_sal)
ax=gca;
ax.XTickLabel={'med vac,#lots','low vac,#lots',...
    'med vac,low rent','low vac,low rent'};
ax.YLim=([-1 0.8]);
title('Cross-Correlation With 2-yr Forward Lag, Salience Model')
ylabel('Correlation Coefficient')
xlabel('Correlates')
legend('MA','NC','TX','FL')
saveas(h3,'xcorr_sal_p2lag','jpg')

% % EU, same year
h4=figure;
set(h4,'color','white','Visible','off')
bar(sameyr_eu)
ax=gca;
ax.XTickLabel={'med vac,#lots','low vac,#lots',...
    'med vac,low rent','low vac,low rent'};
ax.YLim=[-1 0.8];
title('Cross-Correlation With No Lag, EU Model')
ylabel('Correlation Coefficient')
xlabel('Correlates')
legend('MA','NC','TX','FL')
saveas(h4,'xcorr_eu_nolag','jpg')

% % EU, plus one year
h5=figure;
set(h5,'color','white','Visible','off')
bar(plus1yr_eu)
ax=gca;
ax.XTickLabel={'med vac,#lots','low vac,#lots',...
    'med vac,low rent','low vac,low rent'};
ax.YLim=[-1 0.8];
title('Cross-Correlation With 1-yr Forward Lag, EU Model')
ylabel('Correlation Coefficient')
xlabel('Correlates')
legend('MA','NC','TX','FL')
saveas(h5,'xcorr_eu_p1lag','jpg')

% % EU, plus two year
h6=figure;
set(h6,'color','white','Visible','off')
bar(plus2yr_eu)
ax=gca;
ax.XTickLabel={'med vac,#lots','low vac,#lots',...
    'med vac,low rent','low vac,low rent'};
ax.YLim=([-1 0.8]);
title('Cross-Correlation With 2-yr Forward Lag, EU Model')
ylabel('Correlation Coefficient')
xlabel('Correlates')
legend('MA','NC','TX','FL')
saveas(h6,'xcorr_eu_p2lag','jpg')
