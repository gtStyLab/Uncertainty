function missing_metabolite_data = remove_metabolite_data(experimental_data,missing_metabolite_idx)
    % Removes time-series data of a metabolite from experimental data
    % structure 
    missing_metabolite_data = experimental_data; 
    if ~isequal(missing_metabolite_idx,0)
        % keep the initial condition 
        concMatrix = experimental_data.concMatrix;
        concMatrix(2:end,missing_metabolite_idx) = nan(size(concMatrix,1)-1,length(missing_metabolite_idx));
    
        missing_metabolite_data.concMatrix = concMatrix;
    end
end