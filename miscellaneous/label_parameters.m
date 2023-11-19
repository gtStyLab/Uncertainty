function [parameter_labels,parameter_values] = label_parameters(parameterMatrix,init_cond)
    % parameterMatrix - a numFlux * (numMet + 1) matrix that represents the
    % BST equation 
    parameter_labels = cell(numel(parameterMatrix)+numel(init_cond),1);
    parameter_values = cell(numel(parameterMatrix)+numel(init_cond),1);
    count = 1; 
    for i = 1:size(parameterMatrix,1)
        for j = 1:size(parameterMatrix,2)
            parameter_values{count,1} = parameterMatrix(i,j); 
            if isequal(j,1)
                parameter_labels{count,1} = sprintf('v%d_const',i);
            else
                parameter_labels{count,1} = sprintf('reg_%d_%d',j-1,i);
            end
            count = count + 1;
        end
    end


    for k = 1:length(init_cond)
        parameter_values{count,1} = init_cond(k);
        parameter_labels{count,1} = sprintf('init_%d',k);
        count = count + 1; 
    end



end