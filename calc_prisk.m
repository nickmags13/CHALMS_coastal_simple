function [p_risk,strmevnt,tmevnt]=calc_prisk(riskmdl,stormoccur,t,TSTART,...
    alpharisk,betarisk,timeweight)
    
if riskmdl == 1
    % objective risk perception
    strmevnt=0;
    tmevnt=0;
    p_risk=alpharisk/(alpharisk+betarisk);
    
elseif riskmdl == 2
    % subjective risk perception
    strmevnt=sum(stormoccur(t:-1:TSTART+1).*1.^(t-TSTART-(t-TSTART:-1:1)));
    tmevnt=sum(1.^(t-TSTART-(t-TSTART:-1:1)));
    p_risk=(strmevnt+alpharisk)/(tmevnt+alpharisk+betarisk);
    
elseif riskmdl == 3
    % subjective risk perception wiht time distortion
    strmevnt=sum(stormoccur(t:-1:TSTART+1).*...
        timeweight.^(t-TSTART-(t-TSTART:-1:1)));
    tmevnt=sum(timeweight.^(t-TSTART-(t-TSTART:-1:1)));
    p_risk=(strmevnt+alpharisk)/(tmevnt+alpharisk+betarisk);
end
end

