function [score] = run_sim_fit(g_id, ind_id, x, poolobj)
% Run simulation model and return fitness score
%  g_id = generation number, ind_id = individual ID, x = individual from pop
    % Reorder params 
    params = [ x.levels(3), x.levels(2), x.params{2}, x.params{3}, ...
               x.params{1}([1, 4, 3, 2, 5]) ];
    save('params.mat', 'g_id', 'ind_id', 'params');
    addAttachedFiles(poolobj,{'load_params_hga.m','loadempdata.m',...
    'parsave_hga.m','distmat.m','load_farmmap.m','load_DIST2CBD_east.m',...
    'load_distmat.m','calc_prisk.m','calc_eu.m','calc_react.m',...
    'params.mat','load_ilandscape'});
    Master_CHALMS_Coast_event_hga
    savefname=sprintf('%s_hga_results_%d_%d.mat','X:\model_results\CHALMS_event_hga_030917\',g_id,ind_id);
    save(savefname,'g_id','ind_id','params','score','p_rents','p_inscov');
end

