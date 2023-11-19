function MASE = calcMASE(model,data)
    num_timepoints = size(model,1);
    num_metabolites = size(model,2); 
    if all(size(model)==size(data))
        residual = model - data; 
        vec_nominator = sum(abs(residual))/num_timepoints;
        step_data = [zeros(1,num_metabolites);data(1:end-1,:)];
        deriv_actual_values = abs(step_data - data);
        vec_denominator = sum(deriv_actual_values(2:end,:))/(num_timepoints-1);
        MASE_vec = vec_nominator ./ vec_denominator;
        MASE = mean(MASE_vec);
    else
        MASE = nan; 
        fprintf('Error: different size')
    end




end