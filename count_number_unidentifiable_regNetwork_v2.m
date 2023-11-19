function [metric_list,number_unidentifiable_regNetwork,all_fitted_params,fitted_models] = count_number_unidentifiable_regNetwork_v2(topology_short_name,crossTalk_name,reg_topo_num,paramSetNum,nT,cov,rep_list,result_append_string)
    % Use the metric that best identifies the correct structure instead of
    % using a specified metric; also count any incorrect structures that
    % are better than the correct to be added to the number of
    % unidentifiable networks 

    kineticMaps_file = load(sprintf('kineticMaps/%s_allMaps.mat',topology_short_name));
    num_map = length(kineticMaps_file.allMaps);
    result_stem_fileName = sprintf('partial_fitting_results/%s%s_regNetwork_%d_paramSetNum-%d_nT-%d_cov-%03d',topology_short_name,crossTalk_name,reg_topo_num,paramSetNum,nT,cov);

    true_regulatory_network_file = load('true_regulatory_network_structure.mat');
    true_regulatory_networks = true_regulatory_network_file.regNetworks;
    true_regulatory_network = true_regulatory_networks(strcmp(sprintf('%s%s',topology_short_name,crossTalk_name),true_regulatory_network_file.topology_full_names),:);
    true_regulatory_network = true_regulatory_network{1,reg_topo_num};
    %% Use BIC/SSR
%     [all_regMaps,all_SSR,~,~,~,~,~] = find_error_metric_distribution(result_stem_fileName,num_rep,num_map);
%     [sorted_SSR,sort_idx] = sort(all_SSR,'ascend');
%     sorted_regMaps = all_regMaps{sort_idx};
%     optimal_distribution = sorted_SSR(1,:);
%     distinguished = 0; 
%     rank_idx = 2;
%     while isequal(distinguished,0)
%         [distinguished,~,~,~] = ttest(optimal_distribution,sorted_SSR(rank_idx,:));
%        rank_idx = rank_idx + 1; 
%     end
%     number_unidentifiable_regNetwork = rank_idx - 1; 

    get_fitted_params = false; 
    [all_regMaps,all_SSR,all_rmsd,all_AIC,all_BIC,all_MAE,all_MAPE,all_MASE,all_fitted_params,fitted_models] = find_error_metric_distribution(result_stem_fileName,rep_list,num_map,result_append_string,get_fitted_params);
    for i = 1:length(all_regMaps)
        if isequal(all_regMaps{1,i},true_regulatory_network) || isequal(all_regMaps{1,i},true_regulatory_network([2,1],:))
            true_regNetwork_idx = i;
            break
        end
    end

    metric_list = {'SSR','rmsd','AIC','BIC','MAE','MAPE','MASE'};
    metrics = [all_SSR,all_rmsd,all_AIC,all_BIC,all_MAE,all_MAPE,all_MASE];
    sorted_metric_all = nan(size(metrics));
    number_unidentifiable_regNetwork = nan(length(metric_list),1);
    for metric_idx = 1:1:length(metric_list)
        metric_all = metrics(:,(metric_idx-1) * 3 + 1:metric_idx * 3);
        [~,sort_idx] = sort(mean(metric_all,2),'ascend');
        true_idx = find(sort_idx==true_regNetwork_idx);
        sorted_metric = metric_all(sort_idx,:);
        sorted_metric_all(:,(metric_idx-1) * 3 + 1:metric_idx * 3) = sorted_metric;

        distinguished = 0; 
        rank_idx = true_idx+1;
        while isequal(distinguished,0) && rank_idx < length(all_regMaps)
            [distinguished,~,~,~] = ttest(sorted_metric(true_idx,:),sorted_metric(rank_idx,:));
            rank_idx = rank_idx + 1; 
        end
        number_unidentifiable_regNetwork(metric_idx) = rank_idx - 1;
    end

end