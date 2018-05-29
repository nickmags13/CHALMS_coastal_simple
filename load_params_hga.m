%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%  Experimental Parameter File   %%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [am0,am_slope,ampref_max,ampref_min,maxPflood,highrisk,stormfreq,maxdam,...
    Cmit,miteff,AVGFARMRETURN,STDFARMRETURN,coastvalue,midvalue,...
    inlandvalue,milecost,milestraveled,alpharisk,insurecov,...
    insurecost,timewght,coastpremium,movethresh,mvcost,riskmodel,eumodel,...
    lclcoeff,altamen]=load_params_hga(filename)

% load parameters file from hga code
load(filename{:})

% Coastal Amenity
am0=500000;        %baseline
am_slope=params(7);      %baseline, range[0.6,1]

coastpremium=18;    %baseline

% Consumer preferences
ampref_max=0.9;    %baseline
ampref_min=0.1;    %baseline
altamen=params(8);       %baseline, range[0.5,1]

% perceived risk model
alpharisk=2;  %baseline
riskmodel=params(2);
timewght=params(3);     %time discounting for subjective risk perception (Gallagher, 2014), range[0,1.05]
eumodel=params(1);      % selection of utility: 1 = maximizaiton; 2 = max w/ insurance option; 3 = saliency
lclcoeff=params(4);     % baseline; 'local thinker' coefficient for salience calc (Bordalo et al., 2014), range[0,1]

% Storm Impacts and Mitigation
maxPflood=0.7;     %baseline
highrisk=30;       %baseline
maxdam=1;            %baseline
% stormfreq_parms=1;         %baseline   
stormfreq_parms=2;         %baseline   
stormfreq=stormfreq_parms;

Cmit=3000;         %baseline
miteff=1;          %baseline
insurecov=125000;    %baseline, max NFIP building coverage, Kousky et al. (2016)
insurecost=params(9);    %baseline, estimated from floodsmart.gov  

movethresh=0.025;
mvcost=params(5);   %baseline, range[0.01,0.25]

% Initial land value
AVGFARMRETURN=2486.3;
STDFARMRETURN=0.10*AVGFARMRETURN;
coastvalue=2;      %baseline
midvalue=1.5;        %baseline
inlandvalue=1;     %baseline

% Travel costs
milecost=1.3;     %baseline, normrnd[1.3,0.65]
milestraveled=500; %baseline

end

