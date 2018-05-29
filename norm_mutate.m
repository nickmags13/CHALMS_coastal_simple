function [mut_x] = norm_mutate(x, scal, pmut, pjump, nlevels,...
                               adj_lvl, minp, maxp, sdp)
% Hierarchical mutation function applied to individual 'x' from population
%  For each module, may swith level with prob. pjump
%   - If there's a switch, re-initialize level
%   - If not, try mutating each parameter with prob. pmut
%   - Mutation is normally distr. around current value, with scaling scal
%  nlevels: nb. of levels by module
%  adj_lvl: min. level with adjustable parameters by module
%  minp, maxp, sdp: cell arrays of min., max. and mutation std. dev.
%    for parameters
    mut_x = x;
    for i = 1:length(x.levels)
        if nlevels(i) > 1 && rand < pjump
            if x.levels(i) == 1
                mut_x.levels(i) = 2;
            elseif x.levels(i) == nlevels(i)
                mut_x.levels(i) = nlevels(i) - 1;
            else % equal prob. of going up or down a level
                mut_x.levels(i) = x.levels(i) + sign(rand - 0.5);
            end
            % Draw new set of parameters
            mut_x.params{i} = init_pars(i, mut_x.levels(i)); 
            mut_x.fit = NaN;
        else
            if x.levels(i) >= adj_lvl(i)
                % has_mut = 0 or 1 depending if parameter is mutated
                has_mut = rand(1, length(x.params{i})) < pmut;
                if (any(has_mut)) 
                    mut_x.fit = NaN;
                end
                new_vals = x.params{i} + has_mut .* scal .* sdp{i} .* ...
                    randn(1, length(x.params{i}));
                mut_x.params{i} = max(min(new_vals, maxp{i}), minp{i});
            end
        end
    end
end

