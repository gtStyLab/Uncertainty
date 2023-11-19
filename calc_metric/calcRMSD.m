function RMSD = calcRMSD(model,data)
    num_datapoints = numel(data);
    if all(size(model)==size(data))
        residual = model - data;
        RMSD_vec = sqrt(sum(residual.^2,1)/num_datapoints);
        RMSD = mean(RMSD_vec);
    else
        error('different size')
    end

end