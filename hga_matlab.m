% HGA implementation in MATLAB
poolobj=parpool(10);

% Genetic algorithm parameters
nind = 10; % number of individuals, baseline = 20
nmod = 3; % number of modules
ngen = 5; % number of generations, baseline = 2
nelit = ceil(0.05 * nind); % how many elites to carryforward each gen.
s = 2; % selection pressure in interval (1,2)
pcross = 0.2; % probability of crossover (per parent pair)
scal = 1; % scaling parameter for Gaussian mutation
pmut = 0.2; % probability of mutation per parameter
pjump = 0.5; % probability of level change (up or down) per module

nlevels = [1, 3, 3]; % number of levels by module
ilevel = [1, 1, 1]; % initial level
adj_lvl = [1, 2, 3]; % min. level with adjustable params.

% Cell arrays to hold parameter min., max. and std.dev. values
%   for mutation function
minp = {[0.01 0.5 0.6 0    0.5*610], 0,    0  };
maxp = {[0.25 1   1   1.3    1.5*610  ], 1.05, 1  };
sdp  = {[0.1  0.2 0.2 0.65 0.5*610], 0.5 , 0.5};

% Initialize population (array of individuals)
pop = arrayfun(@(x) init_indiv(nmod, ilevel), 1:nind);

% Calculate fitness
for i = 1:nind
    pop(i).fit = run_sim_fit(0, i, pop(i),poolobj);
end

% Main genetic algorithm loop
%  Note: this overwrites the population at each step
for g = 1:ngen
    % Apply selection operator
    pop = linr_sel(pop, s, nelit);

    % Crossover
    for i = (nelit + 1):2:(nind - 1)
        if rand < pcross
            pop(i:(i+1)) = arith_cross(pop(i:(i+1))); 
        end
    end
    
    % Mutation
    for i = (nelit + 1):nind
        pop(i) = norm_mutate(pop(i), scal, pmut, pjump, nlevels, ...
                             adj_lvl, minp, maxp, sdp);
    end
    
    % Calculate fitness when missing
    for i = 1:nind
        if isnan(pop(i).fit)
            pop(i).fit = run_sim_fit(g, i, pop(i),poolobj);
        end
    end
end

    

