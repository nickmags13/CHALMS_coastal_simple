function [indiv] = init_indiv(nmod, levels)
% Initialize individual (3-field structure: module levels, params, and fitness)
    indiv.levels = levels;
    indiv.params = arrayfun(@init_pars, 1:nmod, levels, 'UniformOutput', 0);
    indiv.fit = NaN;
end