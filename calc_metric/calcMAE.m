function MAE = calcMAE(model,data)
    num_datapoints = numel(data);
    if all(size(model)==size(data))
        MAE = sum(sum(abs(model-data)))/num_datapoints;
    else
        MAE = nan; 
        fprintf('Error: different size')
    end



end