function [num_unidentifiable_struct,baseline_error,gs_error,top_error,top_structure] = count_number_unidentifiable_regNetwork_v3(resultFile,true_regulatory_network_file)
    % Get a summary of metrics for model discrimination assessment
        % Input:
    % resultFile: a struct with all fitting results from the folder
    % 'partial-fitting_results
    % true_regulatory_network_file: a struct containing info about gold
    % standard regulatory networks
        % Output: 
    % num_unidentifiaible_struct: number of models with better fitting than
    % the gold standard
    % baseline_error: SSE between noisy and noiseless data
    % gs_error: SSE between the gold standard model and noisy data
    % top_error: SSE between the best fitting model and noisy data
    % top_structure: regulatory network with the best fitting 

    %% Extract information from input structures 
    fitted_model = resultFile.fitted_models; 

    true_regulatory_networks = true_regulatory_network_file.regNetworks;
    true_regulatory_network_topo = true_regulatory_networks(strcmp(sprintf('%s%s',resultFile.topology_short_name,resultFile.crossTalk_name),true_regulatory_network_file.topology_full_names),:);
    true_regulatory_network = true_regulatory_network_topo{1,resultFile.reg_topo_num};
    true_regulatory_network_idx = true_regulatory_network_file.gs_regNetwork_idx_list(strcmp(sprintf('%s%s',resultFile.topology_short_name,resultFile.crossTalk_name),true_regulatory_network_file.topology_full_names),resultFile.reg_topo_num);
   
    %% Getting error metrics 
    all_regMaps = cell(length(fitted_model),1); 
    all_SSR = nan(length(fitted_model),1);
    all_BIC = nan(length(fitted_model),1); 
    for model_idx = 1:length(fitted_model)
        all_regMaps{model_idx,1} = fitted_model(model_idx).reg_kineticsMap;
        all_SSR(model_idx,1) = fitted_model(model_idx).errorMetrics.SSR;
        num_datapoints = sum(sum(~isnan(resultFile.experimental_data.concMatrix))); 
        num_params = size(fitted_model(model_idx).reg_kineticsMap,1);
        all_BIC(model_idx,1) = num_datapoints * log(fitted_model(model_idx).errorMetrics.SSR/num_datapoints) + num_params * log(num_datapoints);
    end

    [min_BIC,sort_idx] = sort(all_BIC,'ascend'); 
    sorted_regMaps = all_regMaps(sort_idx,:); 

    gs_rank_idx = find(sort_idx == true_regulatory_network_idx); 
    num_unidentifiable_struct = gs_rank_idx;    
    gs_error = all_BIC(true_regulatory_network_idx);
    top_error = min_BIC(1); 
    top_structure = sorted_regMaps{1,1}; 

    %% Calculate baseline error by comparing to the noiseless data
    noiseless_data_fileName = sprintf('GenData/BSTData/%s%s_regNetwork_%d/BST_%s%s_k-%03d_hiRes.mat',...
        resultFile.topology_short_name,resultFile.crossTalk_name,resultFile.reg_topo_num,...
        resultFile.topology_short_name,resultFile.crossTalk_name,resultFile.paramSetNum - 160); 
    noiseless_data = load(noiseless_data_fileName); 
    
    interpolated_noiseless_data = interp1(noiseless_data.timeVec,noiseless_data.concMatrix,resultFile.experimental_data.timeVec,'linear','extrap'); 
    if isfield(resultFile,'missing_data_idx')
        missing_data_idx = resultFile.missing_data_idx;
        baseline_SSE = calcSSR(resultFile.experimental_data.concMatrix(~missing_data_idx),interpolated_noiseless_data(~missing_data_idx));
        num_datapoints = numel(resultFile.experimental_data.concMatrix(~missing_data_idx)); 
    else
        baseline_SSE = calcSSR(resultFile.experimental_data.concMatrix,interpolated_noiseless_data);
        num_datapoints = numel(resultFile.experimental_data.concMatrix);
    end
    num_params = (length(find(resultFile.stoichMatrix < 0)) + 2); 
    baseline_error = num_datapoints * log(baseline_SSE/num_datapoints) + num_params * log(num_datapoints);

end