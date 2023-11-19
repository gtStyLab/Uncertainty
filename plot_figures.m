
    % Plot all figures for manuscript 
        % Unhash each section separately to plot 

        % Define metadata
    full_topology_name_list = {'BranchCrossTalk','BranchNoCrossTalk','UDregCrossTalk',...
        'UDregNoCrossTalk','Cycle'};
    topology_name_list = {'Branch','UDreg','Cycle'};
    formal_topology_name_list = {'Determined','Underdetermined','Cycle'};
    missing_metabolite_idx_list_all = {[0,2,4],[0,2,3],0};
    more_missing_metabolite_idx_list_all = {0:1:5,0:1:4};
    crosstalk_name_list = {'CrossTalk','NoCrossTalk'};
    formal_crosstalk_name_list = {'CrossTalk','Feedback'}; 
    nT_list = [1000,500,200,100];
    all_nT_list = [1000,500,200,100,50,20,10];
    cov_list = [5,15,25];
    all_num_met = [5,4,5]; 
    rep_list = 1:3; 
    true_regNetwork_file = load('true_regulatory_network_structure.mat');
    
    %% Figure 2A, S2A, S2B
    %     % Plot to show the distribution of # unidentifiable models across noise levels 
    % for topology_idx = 1:length(topology_name_list)
    % 
    %     topology_name = topology_name_list{topology_idx}; 
    %     load(sprintf('test_saved_files/%s_result_struct_time_course_updated_June.mat',topology_name));
    %     allMap_struct = load(sprintf('kineticMaps/%s_allMaps.mat',topology_name));
    %     allMaps = allMap_struct.allMaps;
    %     num_model_total = length(allMaps); 
    %     f = figure; 
    %     t = tiledlayout(length(nT_list),length(cov_list),'TileSpacing','compact');
    %     for nT_idx = 1:length(nT_list)
    %         nT = nT_list(nT_idx);
    %         for cov_idx = 1:length(cov_list)
    %             cov = cov_list(cov_idx);
    %             filtered_result_struct = filter_result_struct(result_struct,{'missing_met','nT','cov'},{0,nT,cov});
    %             num_unidentifiable = [filtered_result_struct.num_unidentifiable]'; 
    %             [divided_num,legend_names] = categorize_identifiability(num_unidentifiable,num_model_total);
    %             ax = nexttile; 
    %             % subplot(length(nT_list),length(cov_list),(nT_idx - 1) * length(cov_list) + cov_idx)
    %             p = pie(ax,divided_num);
    %             for graphic_obj_idx = 1:length(p)
    %                 try 
    %                     p(graphic_obj_idx).Color = [1,1,1];
    %                 end
    %             end
    %         end
    %     end
    %     legend(legend_names,'FontSize',14)
    %     sgtitle(sprintf('Distribution of # unidentifiable models %s across noise levels',topology_name))
    % end

    %% Figure 2b 
    %     % Plot correlation coefficients with noise
            % Preassign
    % all_topo_nT_corr = nan(length(topology_name_list),1);
    % all_topo_CoV_corr = nan(length(topology_name_list),1);
    % for topology_idx = 1:length(topology_name_list)
    % 
    %     topology_name = topology_name_list{topology_idx}; 
    %     load(sprintf('test_saved_files/%s_result_struct_time_course_updated_June.mat',topology_name));
    %     allMap_struct = load(sprintf('kineticMaps/%s_allMaps.mat',topology_name));
    %     allMaps = allMap_struct.allMaps;
    % 
    %     filtered_result_struct = filter_result_struct(result_struct,{'missing_met'},{0});
    %     num_unidentifiable_array = [filtered_result_struct.num_unidentifiable]'; 
    %     nT_array = [filtered_result_struct.nT]';
    %     CoV_array = [filtered_result_struct.cov]';
    %     all_topo_nT_corr(topology_idx,1) = corr(nT_array,num_unidentifiable_array,'Type','Spearman');
    %     all_topo_CoV_corr(topology_idx,1) = corr(CoV_array,num_unidentifiable_array,'Type','Spearman'); 
    % end
    % 
    % figure;
    % barX = categorical({'nT','CoV'});
    % barX = reordercats(barX,{'nT','CoV'});
    % bar(barX,[all_topo_nT_corr,all_topo_CoV_corr]); 
    % lgd = legend('Determined','Underdetermined','Cycle'); 
    % fontsize(lgd,14,'points')
    % ax = gca;
    % ax.FontSize = 14; 
    %% Figure 3A & B
    
    % for topology_idx = 1:2
    % 
    %     topology_name = topology_name_list{topology_idx}; 
    %     load(sprintf('test_saved_files/%s_result_struct_time_course_updated_June.mat',topology_name));
    %     allMap_struct = load(sprintf('kineticMaps/%s_allMaps.mat',topology_name));
    %     allMaps = allMap_struct.allMaps;
    %     num_model_total = length(allMaps); 
    %     missing_metabolite_idx_list = missing_metabolite_idx_list_all{topology_idx}; 
    %     figure; 
    %     for missing_idx = 1:length(missing_metabolite_idx_list)
    %         missing_met = missing_metabolite_idx_list(missing_idx); 
    % 
    %         filtered_result_struct = filter_result_struct(result_struct,{'missing_met'},{missing_met}); 
    %         num_unidentifiable = [filtered_result_struct.num_unidentifiable]'; 
    %         [divided_num,legend_names] = categorize_identifiability(num_unidentifiable,num_model_total);
    %         subplot(1,length(missing_metabolite_idx_list),missing_idx)
    %         p = pie(divided_num); 
    %         set(findobj(p,'type','text'),'FontSize',12)
    %         % if isequal(missing_idx,1)
    %         %     title('no missing metabolite profile','FontName','Helvetica','FontSize',14)
    %         % else
    %         %     title(sprintf('missing metabolite %d',missing_met),'FontName','Helvetica','FontSize',14)
    %         % end
    % 
    %     end
    %     % legend(legend_names,'FontSize',14)
    % end

    %% Figure 4A, S8
    % 
    % for topology_idx = 1:length(topology_name_list)
    % 
    %     topology_name = topology_name_list{topology_idx}; 
    %     load(sprintf('test_saved_files/%s_result_struct_time_course_updated_June.mat',topology_name));
    %     allMap_struct = load(sprintf('kineticMaps/%s_allMaps.mat',topology_name));
    %     allMaps = allMap_struct.allMaps;
    %     num_model_total = length(allMaps); 
    %     missing_metabolite_idx_list = missing_metabolite_idx_list_all{topology_idx}; 
    %     figure; 
    %     for crosstalk_idx = 1:length(crosstalk_name_list)
    %         crosstalk_name = crosstalk_name_list{crosstalk_idx};
    %         for reg_topo_idx = 1:3
    % 
    %             filtered_result_struct = filter_result_struct(result_struct,{'missing_met','crosstalk','reg_topo'},{0,crosstalk_name,reg_topo_idx});
    %             num_unidentifiable = [filtered_result_struct.num_unidentifiable]'; 
    %             [divided_num,legend_names] = categorize_identifiability(num_unidentifiable,num_model_total);
    % 
    %             subplot(length(crosstalk_name_list),3,(crosstalk_idx - 1) * 3 + reg_topo_idx)
    %             % subplot(2,3,reg_topo_idx)
    %             p = pie(divided_num);
    %             set(findobj(p,'type','text'),'FontSize',12)
    % 
    %         end
    % 
    %     end
    %     sgtitle(sprintf('Distribution of # unidentifiable models across %s regulatory topologies',topology_name))
    %     legend(legend_names,'FontSize',14)
    % end
    %% Figure 4B
        % % Preassign
    % reg_param_corr_labels = {}; 
    % reg_param_corr = [];  
    % for topology_idx = 1:length(topology_name_list)
    % 
    %     formal_topology_name = formal_topology_name_list{topology_idx}; 
    %     topology_name = topology_name_list{topology_idx}; 
    %     load(sprintf('test_saved_files/%s_result_struct_time_course_updated_June.mat',topology_name));
    %     allMap_struct = load(sprintf('kineticMaps/%s_allMaps.mat',topology_name));
    %     allMaps = allMap_struct.allMaps;
    %     num_model_total = length(allMaps); 
    %     missing_metabolite_idx_list = missing_metabolite_idx_list_all{topology_idx}; 
    %         eval(sprintf('all_regNetwork = true_regNetwork_file.%s_reg_network;',topology_name)); 
    % 
    %     filtered_result_struct = filter_result_struct(result_struct,{'missing_met'},{0}); 
    %     [param_related_feature_names,param_related_feature_mat] = get_param_corr_related_features(filtered_result_struct,topology_name);
    % 
    %     num_unidentifiable_idx = find(strcmp(param_related_feature_names,'num_unidentifiable'));
    %     num_unidentifiable = param_related_feature_mat(:,num_unidentifiable_idx);
    % 
    %     param_related_X = [param_related_feature_mat(:,1:num_unidentifiable_idx - 1),...
    %         param_related_feature_mat(:,num_unidentifiable_idx + 1:end)];
    %     param_related_X_names = [param_related_feature_names(1:num_unidentifiable_idx - 1);...
    %         param_related_feature_names(num_unidentifiable_idx + 1:end)];
    % 
    %     [spearman_corr_vec,spearman_corr_vec_pval] = corr(param_related_X,num_unidentifiable,'type','Spearman'); 
    % 
    %     for reg_pair_idx = 1:size(all_regNetwork,1)
    %         reg_pair = all_regNetwork(reg_pair_idx,:); 
    % 
    %         param_key = sprintf('reg_%d_%d',reg_pair(1),reg_pair(2)); 
    %         abs_param_key = sprintf('reg_%d_%d_abs',reg_pair(1),reg_pair(2)); 
    % 
    %         param_key_idx = find(strcmp(param_related_X_names,param_key)); 
    %         abs_param_key_idx = find(strcmp(param_related_X_names,abs_param_key)); 
    % 
    %         keep_row_idx_list = find(~(param_related_X(:,param_key_idx)==0)); 
    %         reg_param_related_X = param_related_X(keep_row_idx_list,:); 
    %         reg_param_y = num_unidentifiable(keep_row_idx_list); 
    %         [reg_spearman_corr_vec,reg_spearman_corr_vec_pval] = corr(reg_param_related_X,reg_param_y,'type','Spearman'); 
    %          if reg_spearman_corr_vec_pval(abs_param_key_idx) < 0.05/size(all_regNetwork,1)
    %             reg_param_corr = [reg_param_corr,reg_spearman_corr_vec(abs_param_key_idx)]; 
    %             reg_param_corr_label = strcat(formal_topology_name,' ','(',num2str(reg_pair(1)),',',num2str(reg_pair(2)),')'); 
    %             reg_param_corr_labels = [reg_param_corr_labels,{reg_param_corr_label}]; 
    %         end
    %     end
    % end
    % 
    % 
    % figure;
    % [~,sort_idx] = sort(abs(reg_param_corr),'descend'); 
    % reg_param_corr_sorted = reg_param_corr(sort_idx);
    % reg_param_corr_labels_sorted = reg_param_corr_labels(sort_idx); 
    % X = categorical(reg_param_corr_labels_sorted);
    % X = reordercats(X,reg_param_corr_labels_sorted); 
    % barh(X,reg_param_corr_sorted)
    % set(gca,'FontSize',14)

    %% Figure 5 v1 
    % % Plot 20 features with highest average rank  
    % all_topo_tc_feature_name_list = {}; 
    % all_topo_tc_feature_value_list = []; 
    % all_topo_tc_feature_pval_list = []; 
    % for topology_idx = 1:length(topology_name_list)
    % 
    %     formal_topology_name = formal_topology_name_list{topology_idx}; 
    %     topology_name = topology_name_list{topology_idx}; 
    %     load(sprintf('test_saved_files/%s_result_struct_time_course_updated_June.mat',topology_name));
    %     allMap_struct = load(sprintf('kineticMaps/%s_allMaps.mat',topology_name));
    %     allMaps = allMap_struct.allMaps;
    %     num_model_total = length(allMaps); 
    %     load(sprintf('test_saved_files/20230627_%s_corr_analysis_updated_June.mat',topology_name));
    %     field_names = fieldnames(result_struct); 
    %     tc_features = field_names(contains(field_names,'x0') & ~contains(field_names,'ECDF') & ~contains(field_names,'Histogram')); 
    %     rm_features = setdiff(field_names,tc_features); 
    %     truncated_feature_struct = rmfield(result_struct,rm_features); 
    %     tc_features_topo = fieldnames(truncated_feature_struct); 
    % 
    %     tc_features_topo = strrep(tc_features_topo,'_',' ');
    %     tc_features_topo = strrep(tc_features_topo,'x0',''); % remove x0
    %     tc_features_topo = strcat(formal_topology_name,{' '},tc_features_topo);
    %     all_topo_tc_feature_name_list = [all_topo_tc_feature_name_list;tc_features_topo];
    % 
    %     all_topo_tc_feature_value_list = [all_topo_tc_feature_value_list;all_tc_corrcoef];
    %     all_topo_tc_feature_pval_list = [all_topo_tc_feature_pval_list;all_tc_corrcoef_pval]; 
    % 
    % end
    % 
    % all_rank_idx = nan(size(all_topo_tc_feature_pval_list)); 
    % for nT_idx = 1:length(nT_list)
    %     [ranked_pval,sort_idx] = sort(all_topo_tc_feature_pval_list(:,nT_idx),'ascend','MissingPlacement','last');
    %     ranked_corrcoef = all_topo_tc_feature_value_list(sort_idx,nT_idx);
    %     rank_idx = nan(size(sort_idx));
    %     for i = 1:length(sort_idx)
    %         rank_idx(i) = find(sort_idx == i); 
    %     end
    %     all_rank_idx(:,nT_idx) = rank_idx;
    % end
    % 
    % avg_rank = mean(all_rank_idx,2); 
    % [~,avg_rank_sort_idx] = sort(avg_rank,'ascend','MissingPlacement','last');
    % top20_ranked_tc_feature_name_list = all_topo_tc_feature_name_list(avg_rank_sort_idx(1:20));
    % top20_ranked_tc_feature_value_list = all_topo_tc_feature_value_list(avg_rank_sort_idx(1:20),:); 
    % 
    % 
    % 
    % figure; 
    % barX = categorical(top20_ranked_tc_feature_name_list);
    % barX = reordercats(barX,top20_ranked_tc_feature_name_list); 
    % barh(barX,top20_ranked_tc_feature_value_list); 
    % % title(sprintf('top #20 average ranked features across nTs %s',topology_name));
    % legend('nT=1000','nT=500','nT=200','nT=100'); 
    % ax = gca;
    % ax.FontSize = 14; 

        %% Figure 5 v2 
    % % Plot 5 top ranked features in each topology 
    % all_topo_tc_feature_name_list = {};
    % all_topo_tc_feature_value_list = [];
    % all_topo_tc_feature_pval_list = []; 
    % for topology_idx = 1:length(topology_name_list)
    % 
    %     formal_topology_name = formal_topology_name_list{topology_idx}; 
    %     topology_name = topology_name_list{topology_idx}; 
    %     load(sprintf('test_saved_files/%s_result_struct_time_course_updated_June.mat',topology_name));
    %     allMap_struct = load(sprintf('kineticMaps/%s_allMaps.mat',topology_name));
    %     allMaps = allMap_struct.allMaps;
    %     num_model_total = length(allMaps); 
    %     load(sprintf('test_saved_files/20230627_%s_corr_analysis_updated_June.mat',topology_name));
    %     field_names = fieldnames(result_struct); 
    %     tc_features = field_names(contains(field_names,'x0') & ~contains(field_names,'ECDF') & ~contains(field_names,'Histogram')); 
    %     rm_features = setdiff(field_names,tc_features); 
    %     truncated_feature_struct = rmfield(result_struct,rm_features); 
    %     tc_features_topo = fieldnames(truncated_feature_struct); 
    % 
    %     % Calculate average rank within each topology 
    %     all_rank_idx = nan(size(all_tc_corrcoef_pval)); 
    %     for nT_idx = 1:length(nT_list)
    %         [ranked_pval,sort_idx] = sort(all_tc_corrcoef_pval(:,nT_idx),'ascend','MissingPlacement','last');
    %         ranked_corrcoef = all_tc_corrcoef(sort_idx,nT_idx);
    %         rank_idx = nan(size(sort_idx));
    %         for i = 1:length(sort_idx)
    %             rank_idx(i) = find(sort_idx == i); 
    %         end
    %         all_rank_idx(:,nT_idx) = rank_idx;
    %     end
    % 
    %     avg_rank_idx = mean(all_rank_idx,2); 
    %     [~,avg_rank_sort_idx] = sort(avg_rank_idx,'ascend','MissingPlacement','last');
    % 
    %     top5_tc_features_topo = tc_features_topo(avg_rank_sort_idx(1:5));
    %     top5_tc_features_topo = strrep(top5_tc_features_topo,'_',' ');
    %     top5_tc_features_topo = strrep(top5_tc_features_topo,'x0',''); % remove x0
    %     top5_tc_features_topo = strcat(formal_topology_name,{' '},top5_tc_features_topo);
    %     all_topo_tc_feature_name_list = [all_topo_tc_feature_name_list;top5_tc_features_topo];
    % 
    %     all_topo_tc_feature_value_list = [all_topo_tc_feature_value_list;all_tc_corrcoef(avg_rank_sort_idx(1:5),:)];
    %     all_topo_tc_feature_pval_list = [all_topo_tc_feature_pval_list;all_tc_corrcoef_pval(avg_rank_sort_idx(1:5),:)]; 
    % 
    % end
    % 
    % figure; 
    % barX = categorical(all_topo_tc_feature_name_list);
    % barX = reordercats(barX,all_topo_tc_feature_name_list); 
    % barh(barX,all_topo_tc_feature_value_list); 
    % % title(sprintf('top #20 average ranked features across nTs %s',topology_name));
    % legend('nT=1000','nT=500','nT=200','nT=100'); 
    % ax = gca;
    % ax.FontSize = 14; 
    %% Figure S3 
    %     % Plot to show variability across parameter sets 
    % topology_idx = 1; 
    % topology_name = topology_name_list{topology_idx}; 
    % load(sprintf('test_saved_files/%s_result_struct_time_course_updated_June.mat',topology_name));
    % allMap_struct = load(sprintf('kineticMaps/%s_allMaps.mat',topology_name));
    % allMaps = allMap_struct.allMaps;
    % num_model_total = length(allMaps); 
    % missing_metabolite_idx_list = missing_metabolite_idx_list_all{topology_idx}; 
    % figure;
    % for paramSetNum = 161:180
    %     subplot(5,4,paramSetNum - 160)
    %     filtered_result_struct = filter_result_struct(result_struct,{'crosstalk','reg_topo','missing_met','paramSetNum'},{'CrossTalk',1,0,paramSetNum});
    %     num_unidentifiable = [filtered_result_struct.num_unidentifiable]'; 
    %     [divided_num,legend_names] = categorize_identifiability(num_unidentifiable,num_model_total);
    %     p = pie(divided_num);
    %     for graphic_obj_idx = 1:length(p)
    %         try 
    %             p(graphic_obj_idx).Color = [1,1,1];
    %         end
    %     end
    %     title(sprintf('Parameter set #%d',paramSetNum - 160));
    % end

    %% Figure S4
    % % More missing met 
    % for topology_idx = 1:2
    % 
    %     topology_name = topology_name_list{topology_idx}; 
    %     load(sprintf('test_saved_files/%s_result_struct_time_course_updated_June.mat',topology_name));
    %     allMap_struct = load(sprintf('kineticMaps/%s_allMaps.mat',topology_name));
    %     allMaps = allMap_struct.allMaps;
    %     num_model_total = length(allMaps); 
    %     load(sprintf('test_saved_files/%s_result_struct_time_course_more_missing.mat',topology_name));
    % 
    % 
    %     more_missing_metabolite_idx_list = more_missing_metabolite_idx_list_all{topology_idx}; 
    %     figure; 
    %     for missing_met = more_missing_metabolite_idx_list
    %         % subplot(1,length(more_missing_metabolite_idx_list),missing_met + 1)
    %         subplot(1,6,missing_met + 1)
    %         missing_result_struct = filter_result_struct(result_struct,{'missing_met'},{missing_met});
    %         num_unidentifiable = [missing_result_struct.num_unidentifiable]';
    %         divided_num = categorize_identifiability(num_unidentifiable,num_model_total);
    %         pie(divided_num)
    %         if isequal(missing_met,0)
    %             title('No missing metabolite')
    %         else
    %             title(sprintf('missing met #%d',missing_met))
    %         end
    %     end
    %     sgtitle(sprintf('%s missing metabolite impact',topology_name))
    % end

    %% Figure S5 
    % for topology_idx = 2:2
    % 
    % topology_name = topology_name_list{topology_idx}; 
    % load(sprintf('test_saved_files/%s_result_struct_time_course_updated_June.mat',topology_name));
    % allMap_struct = load(sprintf('kineticMaps/%s_allMaps.mat',topology_name));
    % allMaps = allMap_struct.allMaps;
    % num_model_total = length(allMaps); 
    % load(sprintf('test_saved_files/%s_result_struct_time_course_more_missing_lower_noise.mat',topology_name));
    % more_missing_metabolite_idx_list = more_missing_metabolite_idx_list_all{topology_idx}; 
    %     figure; 
    %     for missing_met = more_missing_metabolite_idx_list
    %         % subplot(1,length(more_missing_metabolite_idx_list),missing_met + 1)
    %         subplot(1,6,missing_met + 1)
    %         missing_result_struct = filter_result_struct(result_struct,{'missing_met'},{missing_met});
    %         num_unidentifiable = [missing_result_struct.num_unidentifiable]';
    %         divided_num = categorize_identifiability(num_unidentifiable,num_model_total);
    %         pie(divided_num)
    %         if isequal(missing_met,0)
    %             title('No missing metabolite')
    %         else
    %             title(sprintf('missing met #%d',missing_met))
    %         end
    %     end
    %     sgtitle(sprintf('%s missing metabolite impact',topology_name))
    % end

    %% Figure S6 & S7
    % % Plot to show that impact of missing metabolite is consistent across
    % % noise levels for Determined and underdetermined stoich topology
    % for topology_idx = 1:2
    % 
    %     topology_name = topology_name_list{topology_idx}; 
    %     load(sprintf('test_saved_files/%s_result_struct_time_course_updated_June.mat',topology_name));
    %     allMap_struct = load(sprintf('kineticMaps/%s_allMaps.mat',topology_name));
    %     allMaps = allMap_struct.allMaps;
    %     num_model_total = length(allMaps); 
    %     missing_metabolite_idx_list = missing_metabolite_idx_list_all{topology_idx}; 
    % 
    %     figure; 
    %     count = 1; 
    %     for nT_idx = 1:length(nT_list)
    %         nT = nT_list(nT_idx); 
    %         for cov_idx = 1:length(cov_list)
    %             cov = cov_list(cov_idx);
    %             for missing_idx = 1:length(missing_metabolite_idx_list)
    %                 missing_met = missing_metabolite_idx_list(missing_idx); 
    %                 subplot(length(nT_list) * length(cov_list),length(missing_metabolite_idx_list),count)
    %                 filtered_result_struct = filter_result_struct(result_struct,{'nT','cov','missing_met'},{nT,cov,missing_met});
    %                 num_unidentifiable = [filtered_result_struct.num_unidentifiable]'; 
    %                 [divided_num,legend_names] = categorize_identifiability(num_unidentifiable,num_model_total);
    %                 p = pie(divided_num);
    %                 set(findobj(p,'type','text'),'Color',[1,1,1])
    %                 count = count + 1; 
    %             end
    %         end
    %     end
    % end

    %% Figure S9

    % % Get a correlation matrix of nT and time-course featuers 
    % all_tc_feature_names = cell(1,30);
    % all_tc_feature_values = nan(sum(all_num_met),30); 
    % met_profile_labels = cell(sum(all_num_met),1); 
    % for topology_idx = 1:length(topology_name_list)
    % 
    %     formal_topology_name = formal_topology_name_list{topology_idx}; 
    %     topology_name = topology_name_list{topology_idx}; 
    %     num_met = all_num_met(topology_idx); 
    %     time_course_features = readtable(sprintf('test_saved_files/20230608_%s_time_course_feature.csv',topology_name));
    %     time_course_feature_name_list = time_course_features.Properties.VariableNames; 
    % 
    %     keep_idx = (contains(time_course_feature_name_list,'x0') &...
    %         ~contains(time_course_feature_name_list,'ECDF') & ~contains(time_course_feature_name_list,'Histogram'))...
    %         | strcmp(time_course_feature_name_list,'nT'); 
    %     remove_feature_name = time_course_feature_name_list(~keep_idx); 
    % 
    %     filtered_tc_features = removevars(time_course_features,remove_feature_name); 
    %     filtered_tc_feature_name = filtered_tc_features.Properties.VariableNames;
    %     filtered_tc_feature_array = table2array(filtered_tc_features); 
    % 
    %     nT_idx = find(strcmp(filtered_tc_feature_name,'nT'));
    %     nT_array = filtered_tc_feature_array(:,nT_idx); 
    % 
    %     tc_feature_array = [filtered_tc_feature_array(:,1:nT_idx-1),filtered_tc_feature_array(:,nT_idx+1:end)]; 
    %     tc_feature_names = [filtered_tc_feature_name(1:nT_idx-1),filtered_tc_feature_name(nT_idx+1:end)]; 
    % 
    %     for met = 1:num_met
    %         if isequal(topology_idx,1)
    %             met_idx = met; 
    %         else
    %             met_idx = sum(all_num_met(1:topology_idx - 1)) + met; 
    %         end
    %         met_profile_labels{met_idx,1} = strcat(formal_topology_name,{' met#'},num2str(met));
    %         eval(sprintf('met_specific_tc_feature_idx = contains(tc_feature_names,''met%d'');',met));
    %         met_specific_tc_feature_array = tc_feature_array(:,met_specific_tc_feature_idx); 
    %         met_specific_tc_feature_names = tc_feature_names(:,met_specific_tc_feature_idx); 
    %         met_specific_tc_feature_corr = corr(nT_array,met_specific_tc_feature_array,'type','Spearman');
    %         all_tc_feature_values(met_idx,:) = met_specific_tc_feature_corr; 
    %         if isequal(met_idx,1)
    %             all_tc_feature_names = strrep(met_specific_tc_feature_names,'met1','');
    %             all_tc_feature_names = strrep(all_tc_feature_names,'x0','');
    %             all_tc_feature_names = strrep(all_tc_feature_names,'_',' ');
    %         end
    %     end
    % 
    % 
    % end
    % 
    % figure;
    % h1 = heatmap(met_profile_labels,all_tc_feature_names,all_tc_feature_values');
    % h1.Colormap = colormap(jet);

    %% Figure S11
 
    % for topology_idx = 3:3%1:2%length(topology_name_list)
    %     topology_short_name = topology_name_list{topology_idx};
    %     formal_topology_name = formal_topology_name_list{topology_idx}; 
    %     % for crosstalk_idx = 1:length(crosstalk_name_list)
    %         % crossTalk_name = crosstalk_name_list{crosstalk_idx};
    %         % formal_crosstalk_name = formal_crosstalk_name_list{crosstalk_idx}; 
    %         crossTalk_name = '';
    %         formal_crosstalk_name = ''; 
    %         for reg_topo_num = 1:3
    %             kineticsMap_file = load(sprintf('kineticMaps/%s_allMaps.mat',topology_short_name));
    %             kineticsMap = kineticsMap_file.allMaps;
    %             num_reg_networks = length(kineticsMap); 
    %             metric_list = {'SSR','rmsd','AIC','BIC','MAE','MAPE','MASE'};
    % 
    %             figure(reg_topo_num) 
    %             sgtitle(sprintf('%s%s topology #%d',topology_short_name,crossTalk_name,reg_topo_num))
    %             for metric_idx = 1:length(metric_list)
    %                 metric_name = metric_list{metric_idx}; 
    %                 eval(sprintf('raw_data_for_heatmap_%s = nan(20,length(nT_list) * length(cov_list));',metric_name)); 
    %             end
    %             noise_description = nan(length(nT_list) * length(cov_list),2); 
    % 
    %             for paramSetNum = 161:180 
    %                 count = 1; 
    %                 for nT = nT_list
    %                     for cov = cov_list
    %                         [~,number_unidentifiable_regNetwork] = count_number_unidentifiable_regNetwork_v2(topology_short_name,crossTalk_name,reg_topo_num,paramSetNum,nT,cov,rep_list,'');
    %                         for metric_idx = 1:length(metric_list)
    %                             metric_name = metric_list{metric_idx}; 
    %                             eval(sprintf('raw_data_for_heatmap_%s(paramSetNum - 160,count) = number_unidentifiable_regNetwork(metric_idx);',metric_name)); 
    %                         end
    % 
    %                         noise_description(count,:) = [nT,cov];
    %                         count = count + 1; 
    %                     end
    %                 end
    %             end
    % 
    %             xlabels = {};
    %             ylabels = {}; 
    %             for nT = nT_list
    %                 ylabels{end + 1} = sprintf('nT = %d',nT);
    %             end
    %             for cov = cov_list
    %                 xlabels{end + 1} = sprintf('cov = %.2f',cov/100);
    %             end
    %             figure; 
    %             colorbar_global_min = 10000;
    %             colorbar_global_max = 0; 
    %             for metric_idx = 1:length(metric_list)
    %                 subplot(3,3,metric_idx)
    %                 metric_name = metric_list{metric_idx};
    %                 eval(sprintf('raw_data_for_heatmap = raw_data_for_heatmap_%s;',metric_name)); 
    %                 z_score = zscore(raw_data_for_heatmap);
    %                 filtered_raw_data_for_heatmap = raw_data_for_heatmap;
    %                 filtered_raw_data_for_heatmap(~(abs(z_score)<3)) = nan; 
    %                 average_raw_data = mean(filtered_raw_data_for_heatmap,1,'omitnan'); 
    %                 sd_raw_data = std(filtered_raw_data_for_heatmap,0,1,'omitnan');
    %                 if min(average_raw_data) < colorbar_global_min
    %                     colorbar_global_min = min(average_raw_data);
    %                 end
    %                 if max(average_raw_data) > colorbar_global_max
    %                     colorbar_global_max = max(average_raw_data);
    %                 end
    %                 average_raw_data = reshape(average_raw_data,[length(nT_list),length(cov_list)]);
    %                 sd_raw_data = reshape(sd_raw_data,[length(nT_list),length(cov_list)]);
    %                 eval(sprintf('h_%d = heatmap(xlabels,ylabels,average_raw_data);',metric_idx))
    %                 eval(sprintf('h_%d.Title = ''ranking with %s'';',metric_idx,metric_name));
    %             end
    %             for subplot_idx = 1:length(metric_list)
    %                 subplot(3,3,subplot_idx)
    %                 caxis([colorbar_global_min,colorbar_global_max])
    %             end
    %             sgtitle(sprintf('%s %s topology #%d',formal_topology_name,formal_crosstalk_name,reg_topo_num))
    %             % saveas(gcf,sprintf('test_saved_files/20231115_%s%s_reg_topo%d_metric_heatmap.png',topology_short_name,crossTalk_name,reg_topo_num)); 
    %         end
    %     % end
    % end

    %% Table S2 
     % Plot 20 features with highest average rank 
    % num_hypothesis_test_list = nan(3,1); 
    % for topology_idx = 1:length(topology_name_list)
    % 
    %     formal_topology_name = formal_topology_name_list{topology_idx}; 
    %     topology_name = topology_name_list{topology_idx}; 
    %     load(sprintf('test_saved_files/%s_result_struct_time_course_updated_June.mat',topology_name));
    %     allMap_struct = load(sprintf('kineticMaps/%s_allMaps.mat',topology_name));
    %     allMaps = allMap_struct.allMaps;
    %     num_model_total = length(allMaps); 
    %     load(sprintf('test_saved_files/20230627_%s_corr_analysis_updated_June.mat',topology_name));
    %     field_names = fieldnames(result_struct); 
    %     tc_features = field_names(contains(field_names,'x0') & ~contains(field_names,'ECDF') & ~contains(field_names,'Histogram')); 
    %     rm_features = setdiff(field_names,tc_features); 
    %     truncated_feature_struct = rmfield(result_struct,rm_features); 
    %     tc_features_topo = fieldnames(truncated_feature_struct); 
    % 
    %     tc_features_topo = strrep(tc_features_topo,'_',' ');
    %     tc_features_topo = strrep(tc_features_topo,'x0',''); % remove x0
    %     tc_features_topo = strcat(formal_topology_name,{' '},tc_features_topo);
    %     all_topo_tc_feature_name_list = [all_topo_tc_feature_name_list;tc_features_topo];
    % 
    %     all_topo_tc_feature_value_list = [all_topo_tc_feature_value_list;all_tc_corrcoef];
    %     all_topo_tc_feature_pval_list = [all_topo_tc_feature_pval_list;all_tc_corrcoef_pval]; 
    %     num_hypothesis_test_list(topology_idx) = size(all_tc_corrcoef_pval,1); 
    % 
    % end
    % 
    % sig_idx_list = []; 
    % start_idx = 1; 
    % for idx = 1:length(num_hypothesis_test_list)
    %     sig_idx_list_single = find(any(all_topo_tc_feature_pval_list(start_idx:start_idx + num_hypothesis_test_list(idx)-1,:) < 0.05/num_hypothesis_test_list(idx),2));
    %     sig_idx_list_single = sig_idx_list_single + start_idx - 1; 
    %     sig_idx_list = [sig_idx_list;sig_idx_list_single];
    %     start_idx = start_idx + num_hypothesis_test_list(idx); 
    % end
    % 
    % sig_feature_name_list = all_topo_tc_feature_name_list(sig_idx_list);  
    % sig_feature_value_list = all_topo_tc_feature_value_list(sig_idx_list,:); 
    % sig_feature_pval_list = all_topo_tc_feature_pval_list(sig_idx_list,:);



