function [params] = init_pars(mod, lvl)
% Initialize parameters of given ABM module at specified level
    if mod == 1
        % base module: mov_cost, alt_am, am_decay, trv_cost, ins_prem
        params = [0.01 + rand * 0.24, ...
                  0.5 + rand * 0.4, ...
                  0.6 + rand * 0.4, ...
                  max([0, normrnd(1.3, 0.65)]), ...
                  610*(0.5 + (1.5-0.5)*rand)];
    elseif mod == 2
        %risk module: t_wgt
        if lvl <= 2
            params = 1;
        else 
            params = rand * 1.05;
        end
    else
        %exp. util. module: loc_think
        if lvl < 3
            params = 1;
        else
            params = rand;
        end
    end
end

