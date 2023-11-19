function MAPE = calcMAPE(model,data)
    num_datapoints = numel(data);
    if all(size(model)==size(data))
        relative_residual = abs((model-data)./data);
        MAPE = sum(sum(relative_residual))/num_datapoints;
    else
        MAPE = nan; 
        fprintf('Error: different size')
    end



end