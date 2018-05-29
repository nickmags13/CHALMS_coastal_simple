function [children] = arith_cross(parents)
% Arithmetic crossover function
%  input and output are arrays of two individuals
    children = parents;
    for i = 1:length(parents(1).levels)
        if parents(1).levels(i) == parents(2).levels(i)
            % Arithmetic cross. if both parents share level for that module
            a = rand;
            children(1).params{i} = a * parents(1).params{i} + ...
                                            (1 - a) * parents(2).params{i};
            children(2).params{i} = a * parents(2).params{i} + ...
                                            (1 - a) * parents(1).params{i};                            
        else
            % If levels are different, uniform crossover between blocks
            % (Note: could reduce prob. below 0.5 to make
            %        between-level crossover less likely)
            if (rand < 0.5)
                children(1).levels(i) = parents(2).levels(i);
                children(1).params(i) = parents(2).params(i);
                children(2).levels(i) = parents(1).levels(i);
                children(2).params(i) = parents(1).params(i);
            end
        end
    end
    % Post-crossover fitness unknown
    children(1).fit = NaN;
    children(2).fit = NaN;
end

