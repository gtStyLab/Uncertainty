function [best_fitted_parameters,best_fval,ODEstruct,cov] = wrapper_network_fitting_v3_partial(stoichMatrix,kineticsMap,experimental_data,base_parameters)
    %This version assumes that the kinetic parameters related to
    %mass-action regulatory interactions are fixed and we're only fitting
    %non-mass-action regulatory interactions

    num_iter = 8; 
    quickSearch = 0; 
    num_attempts = 0;
    min_fval = 1e08;
    while min_fval > 1e04 && num_attempts < 5 % Added to ensure bad initial parameter values do not cause any failed parmaeter estimation attempt
        [fitted_parameters,min_fval,ODEstruct,fitted_paramsVecAll,fvalAll] = network_modelFitting_v2_partial(stoichMatrix,kineticsMap,experimental_data,base_parameters,num_iter,quickSearch);
        % Do some convergence check here, if no convergence, more iteration? 
        % Let's use standard deviation/mean of fvalAll as the metric
        mean_fval = mean(fvalAll); 
        sd_fval = std(fvalAll); 
        cov = sd_fval/mean_fval; 
        if cov > 0.1 %this is an arbitrary bound
        %And for now, we're not going to enforce convergence - just trying to
        %do a few more iterations 
            num_iter = 16;
            [fitted_parameters_2nd,min_fval_2nd,ODEstruct,~,~] = network_modelFitting_v2_partial(stoichMatrix,kineticsMap,experimental_data,base_parameters,num_iter,quickSearch);
        end
        if exist('min_fval_2nd','var') && min_fval_2nd < min_fval
            best_fitted_parameters = fitted_parameters_2nd;
            best_fval = min_fval_2nd;
        else
            best_fitted_parameters = fitted_parameters; 
            best_fval = min_fval;
        end
        num_attempts = num_attempts + 1; 
    end
end