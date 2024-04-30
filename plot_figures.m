
    % Plot all figures for manuscript 
        % Unhash each section separately to plot 

        % Define metadata
    full_topology_name_list = {'BranchCrossTalk','BranchNoCrossTalk','UDregCrossTalk',...
        'UDregNoCrossTalk','Cycle','MultiSFeedback','MultiSMixed','BranchSingle','UDregSingle','MultiSSingle'};
    topology_name_list = {'Branch','UDreg','Cycle','MultiS'};
    formal_topology_name_list = {'Determined','Underdetermined','Cycle','Multi-Substrate'};
    missing_metabolite_idx_list_all = {[0,2,4],[0,2,3],0,[0,2,4]};
    more_missing_metabolite_idx_list_all = {0:1:5,0:1:4};
    %     % Determined, underdetermined
    % crosstalk_name_list = {'CrossTalk','NoCrossTalk'};
    % formal_crosstalk_name_list = {'CrossTalk','Feedback'}; 
        % MultiS
    crosstalk_name_list = {'Feedback','Mixed'}; 
    formal_crosstalk_name_list = {'Feedback','Mixed'};
    
    nT_list = [1000,500,200,100];
    all_nT_list = [1000,500,200,100,50,20,10];
    cov_list = [5,15,25];
    all_num_met = [5,4,5,5]; 
    rep_list = 1:3; 
    true_regNetwork_file = load('true_regulatory_network_structure.mat');
    
    %% Figure 2A, S2
        % Plot to show the distribution of # unidentifiable models across noise levels 
    % for topology_idx = 4:4%4:length(topology_name_list)
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
    %         % Preassign
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
    % lgd = legend('Determined','Underdetermined','Cycle','Multi-substrate'); 
    % fontsize(lgd,14,'points')
    % ax = gca;
    % ax.FontSize = 14; 
    %% Figure 3
    % topology_idx_list = [1,2,4]; % Missing metabolite profiles studies
    % performed on Branch, UDreg, and MultiS only 
    % for topology_idx = topology_idx_list
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

    %% Figure 4, S10

    % for topology_idx = 4:length(topology_name_list)
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
    %% Figure S14
    %     % Preassign
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
    %     all_regNetwork = true_regNetwork_file.regNetworks;
    % 
    %     filtered_result_struct = filter_result_struct(result_struct,{'missing_met'},{0}); 
    %     [param_related_feature_names,param_related_feature_mat,topo_all_reg_network] = get_param_corr_related_features(filtered_result_struct,topology_name);
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
    %     for reg_pair_idx = 1:size(topo_all_reg_network,1)
    %         reg_pair = topo_all_reg_network(reg_pair_idx,:); 
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
    %          if reg_spearman_corr_vec_pval(abs_param_key_idx) < 0.05/size(topo_all_reg_network,1)
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
    %     if ~isequal(topology_idx,4)
    %         load(sprintf('test_saved_files/20230627_%s_corr_analysis_updated_June.mat',topology_name));
    %     else
    %         load(sprintf('test_saved_files/%s_corr_analysis_updated_June.mat',topology_name));
    %     end
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
    %% Figure S4
    % result_fileName = 'test_saved_files/Branch_result_struct_time_course_lower_nT.mat';
    % result_file = load(result_fileName); 
    % result_struct = result_file.result_struct;
    % num_model_total = 227; 
    % 
    % missing_met_idx_list = [0,2,4];
    % count = 1; 
    
    % figure; 
    % for missing_met = missing_met_idx_list
    %     filtered_result_struct = filter_result_struct(result_struct,{'missing_met'},{missing_met});
    %     num_unidentifiable = [filtered_result_struct.num_unidentifiable]'; 
    %     [divided_num,~] = categorize_identifiability(num_unidentifiable,num_model_total);
    %     subplot(1,3,count)
    %     pie(divided_num)
    % 
    %     if isequal(count,1)
    %         title('no missing metabolite')
    %     else
    %         title(sprintf('missing metabolite #%d',missing_met))
    %     end
    %     count = count + 1; 
    % 
    % end
    
    %% Figure S3 
    % nT_list = [1000,500,200,100,50,20,10];
    % cov_list = [5,15,25];
    % figure;
    % for nT_idx = 1:length(nT_list)
    %     nT = nT_list(nT_idx); 
    %     for cov_idx = 1:length(cov_list)
    %         cov = cov_list(cov_idx); 
    %         plot_idx = (nT_idx - 1) * length(cov_list) + cov_idx; 
    % 
    %         filtered_result_struct = filter_result_struct(result_struct,{'nT','cov'},{nT,cov});
    %         num_unidentifiable = [filtered_result_struct.num_unidentifiable]';
    %         [divided_num,~] = categorize_identifiability(num_unidentifiable,num_model_total);
    % 
    %         subplot(7,3,plot_idx)
    %         p = pie(divided_num);
    %         set(findobj(p,'type','text'),'Color',[1,1,1])
    % 
    %     end
    % end

    
    %% Figure S5 
    %     % Plot to show variability across parameter sets 
    % topology_idx = 4; 
    % topology_name = topology_name_list{topology_idx}; 
    % load(sprintf('test_saved_files/%s_result_struct_time_course_updated_June.mat',topology_name));
    % allMap_struct = load(sprintf('kineticMaps/%s_allMaps.mat',topology_name));
    % allMaps = allMap_struct.allMaps;
    % num_model_total = length(allMaps); 
    % missing_metabolite_idx_list = missing_metabolite_idx_list_all{topology_idx}; 
    % figure;
    % for paramSetNum = 161:180
    %     subplot(5,4,paramSetNum - 160)
    %     filtered_result_struct = filter_result_struct(result_struct,{'crosstalk','reg_topo','missing_met','paramSetNum'},{'Feedback',3,0,paramSetNum});
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

    %% Figure S6
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

    %% Figure S7
    % for topology_idx = 1:2
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

    %% Figure S8 & S9
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

    %% Figure S11-13
    % all_reg_topo_list = {1:6,[1,2,3,5,6,7,8],1:7};
    % topology_idx_list = [1,2,4];
    % 
    % for topology_idx = topology_idx_list
    %     topology_name = topology_name_list{topology_idx}; 
    %     result_fileName = sprintf('test_saved_files/%sSingle_more_result_struct_time_course_updated_June.mat',topology_name); 
    %     result_file = load(result_fileName); 
    %     result_struct = result_file.result_struct; 
    %     reg_topo_list = all_reg_topo_list{topology_idx}; 
    %     topology_name = 'MultiS'; 
    % 
    %         % Get # putative maps
    %     allMaps_file = load(sprintf('kineticMaps/%s_allMaps.mat',topology_name)); 
    %     num_model_total = length(allMaps_file.allMaps); 
    % 
    %     for reg_topo_idx = 1:length(reg_topo_list)
    % 
    %         reg_topo_num = reg_topo_list(reg_topo_idx); 
    % 
    %         filtered_result_struct = filter_result_struct(result_struct,{'reg_topo'},{reg_topo_num});
    %         num_unidentifiable = [filtered_result_struct.num_unidentifiable]';
    %         [divided_num,~] = categorize_identifiability(num_unidentifiable,num_model_total);
    %         subplot(2,4,reg_topo_idx)
    %         pie(divided_num)
    %         set(gca,'FontSize',12)
    % 
    %     end
    % end
    
    
    %% Figure S15

    % % Get a correlation matrix of nT and time-course featuers 
    % all_tc_feature_names = cell(1,30);
    % all_tc_feature_values = nan(sum(all_num_met),30); 
    % met_profile_labels = cell(sum(all_num_met),1); 
    % for topology_idx = 1:length(topology_name_list)
    % 
    %     formal_topology_name = formal_topology_name_list{topology_idx}; 
    %     topology_name = topology_name_list{topology_idx}; 
    %     num_met = all_num_met(topology_idx); 
    %     try
    %         time_course_features = readtable(sprintf('test_saved_files/20230608_%s_time_course_feature.csv',topology_name));
    %     catch
    %         time_course_features = readtable(sprintf('test_saved_files/20240418_%s_time_course_feature.csv',topology_name));
    %     end
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


    %% Figure S17 
        % First let's check the what the lowest metabolite concentrations are
% 
% all_avg_lowest_met_conc = cell(3,1); 
% for topo_idx = 1:length(topology_name_list)
% 
%     topology_name = topology_name_list{topo_idx}; 
%     if isequal(topo_idx,length(topology_name_list))
%         crosstalk_idx_list = 3:3;
%     else
%         crosstalk_idx_list = 1:2; 
%     end
% 
%     avg_lowest_met_conc = nan(length(crosstalk_idx_list) * 3,20); 
%     for crosstalk_idx = crosstalk_idx_list
%         crosstalk_name = crosstalk_name_list{crosstalk_idx}; 
%         for reg_topo_idx = 1:3
%             for paramSetNum = 161:180
%                 fileName = sprintf('GenData/BSTData/%s%s_regNetwork_%d/BST_%s%s_k-%d_hiRes.mat',topology_name,crosstalk_name,...
%                     reg_topo_idx,topology_name,crosstalk_name,paramSetNum);
%                 data_file = load(fileName); 
%                 concMatrix = data_file.concMatrix; 
%                 avg_met_conc = mean(concMatrix,1); 
%                 if isequal(crosstalk_idx,2)
%                     avg_lowest_met_conc(3 + reg_topo_idx,paramSetNum - 160) = min(avg_met_conc);
%                 else
%                     avg_lowest_met_conc(reg_topo_idx,paramSetNum - 160) = min(avg_met_conc); 
%                 end
% 
%             end
%         end
%     end
%     [~,list_min_idx] = min(avg_lowest_met_conc(:)); 
%     row_idx = mod(list_min_idx,size(avg_lowest_met_conc,1)); 
%     if isequal(row_idx,0)
%         col_idx = floor(list_min_idx/size(avg_lowest_met_conc,1)); 
%     else
%         col_idx = ceil(list_min_idx/size(avg_lowest_met_conc,1)); 
%     end
%     fprintf(topology_name)
%     disp([row_idx,col_idx])
%     all_avg_lowest_met_conc{topo_idx,1} = avg_lowest_met_conc; 
% end
% 
%     % Branch CrossTalk reg#2, paramSet 179
%     % UDreg NoCrossTalk reg#2, paramSet 162
%     % Cycle reg#2, paramSet 163
% % For each topology, choose 10 topology + parameter set combinations with
% % lowest metabolite concentrations 
% indNoise_short_topology_list = cell(30,1); 
% indNoise_crosstalk_list = cell(30,1); 
% indNoise_regNetwork_list = nan(30,1); 
% indNoise_paramSetNum_list = nan(30,1);
% for topo_idx = 1:length(all_avg_lowest_met_conc)
%     topology_short_name = topology_name_list{topo_idx}; 
%     avg_lowest_met_conc = all_avg_lowest_met_conc{topo_idx,1}(:);
%     [sorted_lowest_met_conc,sort_idx] = sort(avg_lowest_met_conc,'ascend'); 
%     for i = 1:10
% 
%         % Find the corresponding regNetwork and parameter sets 
%         lowest_met_conc_oi = sorted_lowest_met_conc(i);
%         loc_idx = find(avg_lowest_met_conc == lowest_met_conc_oi); 
%         row_idx = mod(loc_idx,size(all_avg_lowest_met_conc{topo_idx,1},1)); 
%         if isequal(row_idx,0)
%             col_idx = floor(loc_idx/size(all_avg_lowest_met_conc{topo_idx,1},1)); 
%         else
%             col_idx = ceil(loc_idx/size(all_avg_lowest_met_conc{topo_idx,1},1)); 
%         end
% 
%         % Convert them to conventional terms and store 
%         indNoise_short_topology_list{(topo_idx - 1) * 10 + i,1} = topology_short_name; 
%         if strcmp(topology_short_name,'Cycle')
%             indNoise_crosstalk_list{(topo_idx - 1) * 10 + i,1} = ''; 
%         elseif row_idx > 3
%             indNoise_crosstalk_list{(topo_idx - 1) * 10 + i,1} = 'CrossTalk'; 
%         else
%             indNoise_crosstalk_list{(topo_idx - 1) * 10 + i,1} = 'NoCrossTalk'; 
%         end
%         if isequal(mod(row_idx,3),0) 
%             indNoise_regNetwork_list((topo_idx - 1) * 10 + i,1) = 3;
%         else
%             indNoise_regNetwork_list((topo_idx - 1) * 10 + i,1) = mod(row_idx,3);
%         end
%         indNoise_paramSetNum_list((topo_idx - 1) * 10 + i,1) = 160 + col_idx; 
% 
% 
%     end
% 
% 
% end
% 
% save('test_saved_files/20240131_indNoise_check_info.mat','indNoise_paramSetNum_list','indNoise_regNetwork_list','indNoise_crosstalk_list','indNoise_short_topology_list')
% 
%     % For these specific sets, add independent noise and compare the data 
% 
% noise_list = [1000,5;200,15;100,25];
% topology_list = {'BranchCrossTalk','UDregNoCrossTalk','Cycle'};
% regNetwork_list = [2,2,2];
% paramSetNum_list = [179,162,163];
% test_set_info_file = load('test_saved_files/20240131_indNoise_check_info.mat'); 
% mixedNoise_short_topology_list = test_set_info_file.indNoise_short_topology_list; 
% mixedNoise_crosstalk_list = test_set_info_file.indNoise_crosstalk_list;
% mixedNoise_regNetwork_list = test_set_info_file.indNoise_regNetwork_list; 
% mixedNoise_paramSetNum_list = test_set_info_file.indNoise_paramSetNum_list; 
% for topo_idx = 1:length(mixedNoise_short_topology_list)
%     topology_short_name = mixedNoise_short_topology_list{topo_idx}; 
%     crosstalk_name = mixedNoise_crosstalk_list{topo_idx}; 
%     if isempty(crosstalk_name)
%         crosstalk_name = '';
%     end
%     paramSetNum = mixedNoise_paramSetNum_list(topo_idx); 
%     regNetwork_idx = mixedNoise_regNetwork_list(topo_idx); 
%     for noise_idx = 1:size(noise_list,1)
%         nT = noise_list(noise_idx,1);
%         cov = noise_list(noise_idx,2); 
%         noiseless_data_file = load(sprintf('GenData/BSTData/%s%s_regNetwork_%d/BST_%s%s_k-%d_hiRes.mat',...
%             topology_short_name,crosstalk_name,regNetwork_idx,topology_short_name,crosstalk_name,paramSetNum));
%         noisy_data_file = load(sprintf('GenData/BSTData/%s%s_regNetwork_%d/BST_%s%s_k-%d_nT-%d_cov-%02d_rep-001.mat',...
%             topology_short_name,crosstalk_name,regNetwork_idx,topology_short_name,crosstalk_name,paramSetNum,nT,cov)); 
%         % Add noise to the noisy data
%             % Get the lowest avg metabolite concentration
%         avg_met_conc = mean(noiseless_data_file.concMatrix,1);
%         noise_mag = min(avg_met_conc); 
%         mixed_noisy_concMatrix = noisy_data_file.concMatrix + noise_mag * randn(size(noisy_data_file.concMatrix)); 
% 
%         % % Plot out the differences
%         % figure; 
%         % for met = 1:size(mixed_noisy_concMatrix,2)
%         %     subplot(2,3,met)
%         % 
%         %     % hold on 
%         %     plot(noisy_data_file.timeVec,mixed_noisy_concMatrix(:,met),'LineWidth',1.5,'Color','r')
%         %     hold on 
%         %     plot(noisy_data_file.timeVec,noisy_data_file.concMatrix(:,met),'LineWidth',1.5,'Color','k')
%         %     title(sprintf('Metabolite %d',met))
%         % end
%         % sgtitle(sprintf('%s nT = %d,cov=%.2f',topology_full_name,nT,cov/100))
% 
%     end
% end
% 
% for data_idx = 1:length(mixedNoise_short_topology_list)
%     topology_short_name = mixedNoise_short_topology_list{data_idx}; 
%     crosstalk_name = mixedNoise_crosstalk_list{data_idx}; 
%     paramSetNum = mixedNoise_paramSetNum_list(data_idx); 
%     regNetwork_idx = mixedNoise_regNetwork_list(data_idx); 
%     hiResDataFileName = sprintf('GenData/BSTData/%s%s_regNetwork_%d/BST_%s%s_k-%d_hiRes.mat',...
%         topology_short_name,crosstalk_name,regNetwork_idx,topology_short_name,crosstalk_name,paramSetNum);
%     for noise_idx = 1:size(noise_list,1)
%         nT = noise_list(noise_idx,1);
%         cov = noise_list(noise_idx,2); 
%         wrapper_genNoisyData_mixed(hiResDataFileName,nT,cov/100,3); 
% 
%     end
% 
% end

% all_num_unidentifiable = nan(length(mixedNoise_paramSetNum_list) * size(noise_list,1) * 3,2); 
% start_idx = 1; 
% for test_idx = 1:length(mixedNoise_short_topology_list)
%     topology_short_name = mixedNoise_short_topology_list{test_idx}; 
%     crosstalk_name = mixedNoise_crosstalk_list{test_idx}; 
%     regNetwork_idx = mixedNoise_regNetwork_list(test_idx);
%     paramSetNum = mixedNoise_paramSetNum_list(test_idx); 
% 
%     topo_idx_in_gs = strcmp(strcat(topology_short_name,crosstalk_name),true_regNetwork_file.topology_full_names);
%     gs_idx = true_regNetwork_file.gs_regNetwork_idx_list(topo_idx_in_gs,regNetwork_idx); 
% 
%     for noise_idx = 1:size(noise_list,1)
%         nT = noise_list(noise_idx,1);
%         cov = noise_list(noise_idx,2);
%         for rep = 1:3
%             % Mixed Noise
%             mixedNoise_resultFileName = sprintf('partial_fitting_results/%s%s_regNetwork_%d_paramSetNum-%d_nT-%d_cov-%03d_rep-%03d_missing_met-0_mixedNoise.mat',...
%                 topology_short_name,crosstalk_name,regNetwork_idx,paramSetNum,nT,cov,rep);
%             % refit_failed_attempts(mixedNoise_resultFileName,gs_idx); 
%             mixedNoise_resultFile = load(mixedNoise_resultFileName); 
%             [mixed_noise_num_unidentifiable_struct,~,~,~] = ...
%                             count_number_unidentifiable_regNetwork_v3(mixedNoise_resultFile,true_regNetwork_file);
%             % Original
%             original_resultFileName = sprintf('partial_fitting_results/%s%s_regNetwork_%d_paramSetNum-%d_nT-%d_cov-%03d_rep-%03d.mat',...
%                 topology_short_name,crosstalk_name,regNetwork_idx,paramSetNum,nT,cov,rep); 
%             original_resultFile = load(original_resultFileName); 
%             [num_unidentifiable_struct,~,~,~] = ...
%                             count_number_unidentifiable_regNetwork_v3(original_resultFile,true_regNetwork_file);
% 
%             all_num_unidentifiable(start_idx,1) = num_unidentifiable_struct;
%             all_num_unidentifiable(start_idx,2) = mixed_noise_num_unidentifiable_struct; 
% 
%             start_idx = start_idx + 1; 
%         end
% 
%     end
% end
% 
% 
% [divided_num,legend_names] = categorize_identifiability(all_num_unidentifiable(:,1),size(all_num_unidentifiable,1)); 
% [mixedNoise_divided_num,~] = categorize_identifiability(all_num_unidentifiable(:,2),size(all_num_unidentifiable,1)); 
% figure; 
% subplot(1,2,1)
% pie(divided_num)
% title('Signal-dependent noise only')
% subplot(1,2,2)
% pie(mixedNoise_divided_num)
% title('mixed noise')
% 
% [h,p] = kstest2(divided_num,mixedNoise_divided_num); % Does not reject null hypothesis
% 
% % Generate the modified noisy data 
% function wrapper_genNoisyData_mixed(hiResDataFileName,nT,cov,numSets)
% 
%     % 1) Load in hiResDataFileName
%     hiResData = load(hiResDataFileName);
% 
%     % Second '_' char should be the one at 'k-%02d_hiRes'
%     idxEnd = strfind(hiResDataFileName,'_');
%     loResDataFileNameStem = sprintf('%s_nT-%03d_cov-%02d_mixed_rep-',hiResDataFileName(1:idxEnd(end)-1),nT,cov*100);
% 
%     % 2) Interpolate to lo-res nT sampling
%     % timeVec = linspace(hiResData.tStart,hiResData.tEnd,nT+1);
%     timeVec = linspace(hiResData.timeVec(1),hiResData.timeVec(end),nT+1);
% % %     fluxTimeVec = timeVec(1:end-1)+0.5*diff(timeVec(1:2));
%     fluxTimeVec = timeVec;
% 
%     loResConcMatrix = interp1(hiResData.timeVec,hiResData.concMatrix,timeVec,'linear','extrap');
%     loResFluxMatrix = interp1(hiResData.fluxTimeVec,hiResData.fluxMatrix,fluxTimeVec,'linear','extrap');
% 
%     loResData.timeVec = timeVec;
%     loResData.fluxTimeVec = fluxTimeVec;
% 
%     avg_met_conc = mean(hiResData.concMatrix,1);
%     noise_mag = min(avg_met_conc); 
% 
%     % 3) Loop through for numSets noisy datasets
%     for k = 1:numSets
% 
%         % 3a) Add in noise: use noiseless data + random * cov 
%         loResData.concMatrix = loResConcMatrix + loResConcMatrix .* (cov*randn(size(loResConcMatrix))) + noise_mag * randn(size(loResConcMatrix));
%         loResData.fluxMatrix = loResFluxMatrix + loResFluxMatrix .* (cov*randn(size(loResFluxMatrix))) + noise_mag * randn(size(loResFluxMatrix));
% 
%         % Guarantee we have no *negative* concentation values
%         loResData.concMatrix(loResData.concMatrix<0) = 0;
% 
%         % First data point is always 'correct' and noiseless
%         % loResData.concMatrix(1,:) = loResData.x0;
%         loResData.concMatrix(1,:) = hiResData.concMatrix(1,:);
% 
%         % v1 is fixed value, no noise added
%         loResData.fluxMatrix(:,1) = loResFluxMatrix(:,1);
% 
%         % 3b) Save out this noisy dataset
%         save(sprintf('%s%03d.mat',loResDataFileNameStem,k),'-struct','loResData')
% 
%     end
% end
    %% Figure S18
 
    % for topology_idx = 1:1%1:2%length(topology_name_list)
    %     topology_short_name = topology_name_list{topology_idx};
    %     formal_topology_name = formal_topology_name_list{topology_idx}; 
    %     % for crosstalk_idx = 1:length(crosstalk_name_list)
    %         % crossTalk_name = crosstalk_name_list{crosstalk_idx};
    %         % formal_crosstalk_name = formal_crosstalk_name_list{crosstalk_idx}; 
    %         crossTalk_name = '';
    %         formal_crosstalk_name = ''; 
    %         for reg_topo_num = 1:1
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
    % num_hypothesis_test_list = nan(length(topology_name_list),1); 
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
    %     if ~isequal(topology_idx,4)
    %         load(sprintf('test_saved_files/20230627_%s_corr_analysis_updated_June.mat',topology_name));
    %     else
    %         load(sprintf('test_saved_files/%s_corr_analysis_updated_June.mat',topology_name));
    %     end
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



