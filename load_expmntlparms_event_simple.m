%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%  Experimental Parameter File   %%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [am0,am_slope,ampref_max,ampref_min,maxPflood,highrisk,stormfreq,maxdam,...
    Cmit,miteff,AVGFARMRETURN,STDFARMRETURN,coastvalue,midvalue,...
    inlandvalue,milecost,milestraveled,alpharisk,insurecov,...
    insurecost,timewght,coastpremium,movethresh,mvcost,riskmodel,eumodel,...
    lclcoeff,altamen,propertytax,taxflag]=load_expmntlparms_event_simple(EXPTRUNS)
% Coastal Amenity
% am0=linspace(200000,800000,EXPTRUNS);
am0=500000*ones(1,EXPTRUNS);        %baseline
% am_slope_parms=[0.06 0.07 0.08 0.09 0.1];
% am_slope=repmat(am_slope_parms,1,1);
% am_slope=repmat(reshape(repmat(am_slope_parms,MRUNS,1),MRUNS*...
%     length(am_slope_parms),1),4,1);
am_slope=0.08*ones(1,EXPTRUNS);      %baseline, range[0.6,1]

coastpremium=18;    %baseline

taxflag=0;
% propertytax=repmat([0.01 0.01 0.01],EXPTRUNS,1);  %baseline
propertytax=repmat([0.02 0.01 0.005],EXPTRUNS,1);

% Consumer preferences
ampref_max=0.9*ones(1,EXPTRUNS);    %baseline
ampref_min=0.1*ones(1,EXPTRUNS);    %baseline
altamen=0.9*ones(1,EXPTRUNS);       %baseline, range[0.5,1]

% perceived risk model
alpharisk=2;  %baseline
riskmodel=3*ones(1,EXPTRUNS);    %baseline
% riskmodel=[1 1 1 2 2 2 3 3 3];
timewght=0.91*ones(1,EXPTRUNS);     %time discounting for subjective risk perception (Gallagher, 2014), range[0,1.05]
% timewght=ones(1,EXPTRUNS);     %time discounting for subjective risk perception (Gallagher, 2014)
eumodel=3*ones(1,EXPTRUNS);      % selection of utility: 1 = maximizaiton; 2 = max w/ insurance option; 3 = saliency
% eumodel=[2 3 2 3 2 3 2 3];      % selection of utility: 1 = null; 2 = max expt. utility; 3 = saliency
lclcoeff=0.5*ones(1,EXPTRUNS);     % baseline; 'local thinker' coefficient for salience calc (Bordalo et al., 2014), range[0,1]
% lclcoeff=[1 1 0.5 0.5];     % baseline; 'local thinker' coefficient for salience calc

% Storm Impacts and Mitigation
maxPflood=0.7*ones(1,EXPTRUNS);     %baseline
highrisk=30*ones(1,EXPTRUNS);       %baseline
maxdam=ones(1,EXPTRUNS);            %baseline
% stormfreq_parms=2*ones(1,EXPTRUNS);         %baseline
stormfreq_parms=[1 2 3 4];
% stormfreq=reshape(repmat(stormfreq_parms,length(am_slope_parms),1),...
%     length(am_slope_parms)*length(stormfreq_parms),1)';         
stormfreq=stormfreq_parms;

% stormthresh=15*ones(1,EXPTRUNS);
% Cdam=0.5*ones(1,EXPTRUNS);
Cmit=3000*ones(1,EXPTRUNS);         %baseline
miteff=1;          %baseline
insurecov=125000*ones(1,EXPTRUNS);    %baseline, max NFIP building coverage, Kousky et al. (2016)
insurecost=610*ones(1,EXPTRUNS);    %baseline, max premium for properties 2-4 ft above BFE Kousky et al. (2016)

% movethresh=0.025*ones(1,EXPTRUNS);
movethresh=0.1*ones(1,EXPTRUNS);
mvcost=0.1*ones(1,EXPTRUNS);   %baseline, range[0.01,0.25]

% Initial land value
AVGFARMRETURN=2486.3*ones(1,EXPTRUNS);
STDFARMRETURN=0.10*AVGFARMRETURN.*ones(1,EXPTRUNS);
coastvalue=2*ones(1,EXPTRUNS);      %baseline
midvalue=1.5*ones(1,EXPTRUNS);        %baseline
inlandvalue=1*ones(1,EXPTRUNS);     %baseline
% coastvalue=[1 2 3 4 5];
% coastvalue=reshape(repmat(coastvalue,length(am_slope_parms),1),...
%     length(am_slope_parms)*length(coastvalue),1)';
% midvalue=[1 1.5 2 2.5 3];
% midvalue=reshape(repmat(midvalue,length(am_slope_parms),1),...
%     length(am_slope_parms)*length(midvalue),1)';
% inlandvalue=[1 1 1 1 1];
% inlandvalue=reshape(repmat(inlandvalue,length(am_slope_parms),1),...
%     length(am_slope_parms)*length(inlandvalue),1)';


% Travel costs
milecost=1.30*ones(1,EXPTRUNS);     %baseline, normrnd[1.3,0.65]
milestraveled=500*ones(1,EXPTRUNS); %baseline

end

