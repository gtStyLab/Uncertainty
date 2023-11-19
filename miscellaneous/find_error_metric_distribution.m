function [all_regMaps,all_SSR,all_rmsd,all_AIC,all_BIC,all_MAE,all_MAPE,all_MASE,all_fitted_params,fitted_models] = find_error_metric_distribution(result_stem_fileName,rep_list,num_map,result_append_string,get_fitted_params)
    %% Organize error metrics and fitted parameters (optional) for 3 noise replicates from structure arrays to cell/numerical arrays
    all_regMaps = {};
    num_rep = length(rep_list);
    all_SSR = nan(num_map,num_rep);
    all_rmsd = nan(num_map,num_rep); 
    all_AIC = nan(num_map,num_rep);
    all_BIC = nan(num_map,num_rep);
    all_MAE = nan(num_map,num_rep);
    all_MAPE = nan(num_map,num_rep);
    all_MASE = nan(num_map,num_rep);
    all_fitted_params = cell(num_map,num_rep);
    for idx = 1:num_rep
        rep = rep_list(idx);
        result_fileName = sprintf('%s_rep-%03d%s.mat',result_stem_fileName,rep,result_append_string);
        if isfile(result_fileName)
            result_file = load(result_fileName); 
            if ~isfield(result_file,'noise')
                result_file.noise = [result_file.nT,result_file.cov];
            end
        else
            error('result file does not exist');
        end
        fitted_models = result_file.fitted_models; 
        for model_idx = 1:1:length(fitted_models)
            if isequal(idx,1)
                all_regMaps{end + 1} = fitted_models(model_idx).reg_kineticsMap;
            end
            all_SSR(model_idx,idx) = fitted_models(model_idx).errorMetrics.SSR;
            all_rmsd(model_idx,idx) = fitted_models(model_idx).errorMetrics.RMSD;
            all_AIC(model_idx,idx) = fitted_models(model_idx).errorMetrics.AIC;
            all_MAE(model_idx,idx) = fitted_models(model_idx).errorMetrics.MAE;
            all_MAPE(model_idx,idx) = fitted_models(model_idx).errorMetrics.MAPE;
            all_MASE(model_idx,idx) = fitted_models(model_idx).errorMetrics.MASE;
            num_datapoints = result_file.noise(1) * size(result_file.stoichMatrix,1);
            num_params = size(fitted_models(model_idx).reg_kineticsMap,1);
            all_BIC(model_idx,idx) = num_datapoints * log(fitted_models(model_idx).errorMetrics.SSR/num_datapoints) + num_params * log(num_datapoints);
            if exist('get_fitted_params','var') && get_fitted_params
                all_fitted_params{model_idx,idx} = fitted_models(model_idx).fitted_powerLawKineticsParams;
            end
        end
    end
end

