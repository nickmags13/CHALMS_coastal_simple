function [newpop] = linr_sel(pop, s, nelit)
% Linear rank selection function
% based on http://www.geatbx.com/docu/algindex-02.html
% s = selective pressure (1 = no selection, 2 = strongest selection)
% nelit = nb. of top indiv. to keep as is (elitism) 
    nind = length(pop);
    newpop = pop;
    % Rank indiv. by fitness (with small perturbation to break ties)
    fit_r = tiedrank([pop.fit] .* (1 + randn(1, nind) .* 1E-4));
    prob = 1/nind .* (2 - s + 2 .* (s - 1) * (fit_r - 1)./(nind - 1));
 
    % Keep elites, move to start of list
    newpop(1:nelit) = pop(fit_r > nind - nelit);
    
    % Redraw nind - nelit individual to replaces rest of population 
    sel_ind = randsample(nind, nind - nelit, true, prob);
    newpop((nelit + 1):nind) = pop(sel_ind); 
end