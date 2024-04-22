clear
clc


% Include analysis and plot function here 
    % Summary fo review process


%% Section 1 - Kinetics Formulation 
    %% Section 1.1 Saturated BST 

    %% 1.1.1. Missing Metabolite Impact Plot & Statistical Significance
% high_noise_result_struct_file = load('test_saved_files/v2_Branch_result_struct_time_course_more_missing_higher_noise.mat');
% low_noise_result_struct_file = load('test_saved_files/v2_Branch_result_struct_time_course_more_missing_lower_noise.mat');
% high_noise_result_struct = high_noise_result_struct_file.result_struct; 
% low_noise_result_struct = low_noise_result_struct_file.result_struct; 
% num_model_total = 227; 
% 
% figure; 
% missing_met_idx_list = 0:5; 
% lower_noise_p_val_list = nan(1,length(missing_met_idx_list) - 1); 
% for missing_met = missing_met_idx_list
%     filtered_low_noise_result_struct = filter_result_struct(low_noise_result_struct,{'missing_met','crosstalk'},{missing_met,'CrossTalk'});
%     num_unidentifiable = [filtered_low_noise_result_struct.num_unidentifiable]';
%     [divided_num,~] = categorize_identifiability(num_unidentifiable,num_model_total);
%     subplot(1,length(missing_met_idx_list),missing_met + 1)
%     pie(divided_num)
%     if isequal(missing_met,0)
%         title('no missing met')
%         base_num_unidentifiable_array = num_unidentifiable; 
%     else
%         title(sprintf('missing met %d',missing_met))
%         [h,p] = kstest2(num_unidentifiable,base_num_unidentifiable_array); 
%         lower_noise_p_val_list(missing_met) = p; 
%     end
% end
% sgtitle('Branch missing metabolite impact - lower noise')
% 
% figure; 
% missing_met_idx_list = 0:5; 
% higher_noise_p_val_list = nan(1,length(missing_met_idx_list) - 1); 
% for missing_met = missing_met_idx_list
%     filtered_high_noise_result_struct = filter_result_struct(high_noise_result_struct,{'missing_met','crosstalk'},{missing_met,'CrossTalk'});
%     num_unidentifiable = [filtered_high_noise_result_struct.num_unidentifiable]';
%     [divided_num,~] = categorize_identifiability(num_unidentifiable,num_model_total);
%     subplot(1,length(missing_met_idx_list),missing_met + 1)
%     pie(divided_num)
%     if isequal(missing_met,0)
%         title('no missing met')
%         base_num_unidentifiable_array = num_unidentifiable; 
%     else
%         title(sprintf('missing met %d',missing_met))
%         [h,p] = kstest2(num_unidentifiable,base_num_unidentifiable_array); 
%         higher_noise_p_val_list(missing_met) = p; 
%     end
% end
% sgtitle('Branch missing metabolite impact - higher noise')
% 
% % None of the differences are statistically significant 

    %% Section 1.2 - MM fit MM 

% result_fileName = 'test_saved_files/MMfitMM_Branch_result_struct.mat'; 
% result_file = load(result_fileName); 
% result_struct = result_file.result_struct;
% 
% ctrl_BST_result_fileName = 'test_saved_files/Branch_result_struct_time_course_updated_June.mat'; 
% ctrl_BST_result_file = load(ctrl_BST_result_fileName);
% ctrl_BST_result_struct = ctrl_BST_result_file.result_struct; 
% 
% num_model_total = 227; 
% nT_list = [1000,500,200,100];
% cov_list = [5,15,25];
% 
% figure; 
% subplot(1,2,1)
% ctrl_BST_unidentifiable = [ctrl_BST_result_struct.num_unidentifiable]';
% [ctrl_BST_divided_num,~] = categorize_identifiability(ctrl_BST_unidentifiable,num_model_total);
% pie(ctrl_BST_divided_num)
% title('Biochemical Systems Theory')
% set(gca,'FontSize',12)
% subplot(1,2,2)
% num_unidentifiable = [result_struct.num_unidentifiable]';
% [divided_num,~] = categorize_identifiability(num_unidentifiable,num_model_total);
% pie(divided_num)
% title('Michaelis-Menten')
% set(gca,'FontSize',12)
% 
% figure; 
% for nT_idx = 1:length(nT_list)
%     for cov_idx = 1:length(cov_list)
%         nT = nT_list(nT_idx);
%         cov = cov_list(cov_idx);
%         filtered_result_struct = filter_result_struct(result_struct,{'nT','cov'},{nT,cov});
%         num_unidentifiable = [filtered_result_struct.num_unidentifiable]';
%         [divided_num,~] = categorize_identifiability(num_unidentifiable,num_model_total);
% 
%         plot_idx = (nT_idx - 1) * length(cov_list) + cov_idx; 
%         subplot(length(nT_list),length(cov_list),plot_idx)
%         pie(divided_num)
% 
%     end
% end

%% Section 2 - Single regulation 

    %% Generate parameterization
    % 
% true_regNetwork_file = load('true_regulatory_network_structure.mat'); 
% 
% % Define time specifics 
% tStart = 0; 
% tEnd = 10; 
% nT = 1000; 
% 
%     % Get all single regulatory interactions for each topology 
% topology_short_names = true_regNetwork_file.topology_short_names; 
% topology_short_names_unique = unique(topology_short_names); 
% regNetworks = true_regNetwork_file.regNetworks; 
% topology_reg_int_list = cell(length(topology_short_names_unique),1); 
% for topo_idx = 1:1%length(topology_short_names_unique)
%     topology_short_name = topology_short_names_unique{topo_idx}; 
%     topo_row_idx = contains(true_regNetwork_file.topology_full_names,topology_short_name); 
%     topo_regNetworks = regNetworks(topo_row_idx,:); 
%     all_topo_reg_int = []; 
%     for row_idx = 1:size(topo_regNetworks,1)
%         for col_idx = 1:size(topo_regNetworks,2)
%             all_topo_reg_int = [all_topo_reg_int; topo_regNetworks{row_idx,col_idx}];
%         end
%     end
%     all_topo_reg_int_unique = unique(all_topo_reg_int,'rows'); 
%     topology_reg_int_list{topo_idx,1} = all_topo_reg_int_unique; 
% end
% 
%     % Load paramsList and identify the parameters for each regulatory
%     % interaction (use the first 20 parameter sets found) 
% 
% % For each regulatory interaction in topology, find the corresponding full topology
% % name and load parameter sets 
% for topo_idx = 1:length(topology_reg_int_list)
%     % Get all regulatory pairs for each topology 
%     all_topo_reg_int_unique = topology_reg_int_list{topo_idx,1}; 
%     % Also get the relevant regulatory networks 
%     topology_short_name = topology_short_names_unique{topo_idx}; 
%     topo_row_idx = contains(true_regNetwork_file.topology_full_names,topology_short_name); 
%     topo_regNetworks = regNetworks(topo_row_idx,:); 
%     topology_full_name = true_regNetwork_file.topology_full_names(topo_row_idx); 
%     % Get stoich info
%     modelInfo = get_model_info(topology_short_name); 
%     stoichMatrix = modelInfo.stoichMatrix; 
%     kineticsMap_baseline = [];
%     for met = 1:1:size(stoichMatrix,1)
%         non_zero_idx = find(stoichMatrix(met,:)<0);
%         if ~isempty(non_zero_idx)
%             for flux_idx = 1:1:length(non_zero_idx)
%                 kineticsMap_baseline = [kineticsMap_baseline;[met,non_zero_idx(flux_idx)]];
%             end
%         end
%     end
% 
%     for reg_int_idx = 1:size(all_topo_reg_int_unique,1)
%         reg_pair = all_topo_reg_int_unique(reg_int_idx,:); 
%         % Find a regulatory network that contains the interaction
%         successFlag = false; 
%         for row_idx = 1:size(topo_regNetworks,1)
%             for col_idx = 1:size(topo_regNetworks,2)
%                 topo_regNetwork = topo_regNetworks{row_idx,col_idx};
%                 if ismember(reg_pair,topo_regNetwork,'rows') % Choose the first one found 
%                     successFlag = true; 
%                     topology_full_name_oi = topology_full_name{row_idx}; 
%                     reg_topo_num_oi = col_idx; 
%                     regNetwork_oi = topo_regNetwork; 
%                 end
%             end
%         end
%         % Load the params list / base parameter list 
%         paramsList_fileName = sprintf('paramsList/paramsList%s_regNetwork_%d.mat',topology_full_name_oi,reg_topo_num_oi);
%         paramsList_file = load(paramsList_fileName);
%         paramsList = paramsList_file.paramsList; 
%         base_paramsList_fileName = sprintf('paramsList/baseParametersList%s_regNetwork_%d.mat',topology_full_name_oi,reg_topo_num_oi); 
%         base_paramsList_file = load(base_paramsList_fileName); 
%         base_paramsList = base_paramsList_file.baseParametersList; 
% 
%         index = get_index_for_param_convertion(stoichMatrix,[kineticsMap_baseline;regNetwork_oi]); 
%         updated_paramsList = cell(20,1); 
%         updated_baseParamsList = cell(20,1); 
%         for param_idx = 1:length(paramsList)
%             if isequal(param_idx,1) % Find the index of regulatory param
%                 paramsVec = paramsList{param_idx}; 
%                 if contains(topology_full_name_oi,'Branch')
%                     kineticParamsVec = paramsVec(3:end-size(stoichMatrix,1));
%                     stoichMatrix(3,5) = -1 * paramsVec(1);
%                     stoichMatrix(4,5) = -1 * paramsVec(2); 
%                 else
%                     kineticParamsVec = paramsVec(1:end-size(stoichMatrix,1));
%                 end
%                 paramsMat = convertModelKineticsParams(kineticParamsVec,[kineticsMap_baseline;regNetwork_oi],index,size(stoichMatrix,1)); 
%                 base_paramsMat = base_paramsList{param_idx}; 
%                 reg_param_oi = paramsMat(reg_pair(2),reg_pair(1) + 1); 
%             end
%             % Try to solve BST ODE with the current parameters 
%             new_paramsMat = base_paramsMat; 
%             new_paramsMat(reg_pair(2),reg_pair(1) + 1) = reg_param_oi; 
% 
%             [timeVec,concMatrix] = SolveBranchedPathwayBSTODE(new_paramsMat,stoichMatrix,tStart,tEnd,nT,paramsVec(end-size(stoichMatrix,1) + 1:end)); 
%             if ~all(isreal(concMatrix)) && isequal(length(timeVec), nT + 1)
%                 % If not successful, add a small perturbation to the
%                 % regulatory parameter and re-solve 
%                 reg_param_oi_perturb = reg_param_oi; 
%                 perturbation_size = 1e-04; 
%                 perturb_successFlag = false; 
%                 while ~perturb_successFlag
%                     reg_param_oi_perturb = reg_param_oi_perturb + perturbation_size * randn; 
%                     new_paramsMat(reg_pair(2),reg_pair(1) + 1) = reg_param_oi_perturb; 
%                     [timeVec,concMatrix] = SolveBranchedPathwayBSTODE(new_paramsMat,stoichMatrix,tStart,tEnd,nT,paramsVec(end-size(stoichMatrix,1) + 1:end));
%                     if all(isreal(concMatrix)) && isequal(length(timeVec), nT + 1)
%                         perturb_successFlag = true; 
%                     else
%                         perturbation_size = perturbation_size * 1.01; 
%                     end
%                 end
%             end
%             % If successful, save the parameter list as topology_single
%             kineticsParamsVec = reshape(new_paramsMat',[],1);
%             kineticsParamsVec = kineticsParamsVec(find(kineticsParamsVec));
%             if contains(topology_full_name_oi,'Branch')
%                 updated_paramsVec = [paramsVec(1);paramsVec(2);kineticsParamsVec;paramsVec(end-size(stoichMatrix,1) + 1:end)];
%             else
%                 updated_paramsVec = [kineticsParamsVec;paramsVec(end-size(stoichMatrix,1) + 1:end)];
%             end
%             updated_baseParamsList{param_idx} = base_paramsMat;
%             updated_paramsList{param_idx} = updated_paramsVec; 
%         end
% 
% 
% 
% 
%         save(sprintf('paramsList/paramsList%sSingle_regNetwork_%d.mat',topology_short_name,reg_int_idx),'updated_paramsList','topology_reg_int_list','topology_short_names_unique');
%         save(sprintf('paramsList/baseParametersList%sSingle_regNetwork_%d.mat',topology_short_name,reg_int_idx),'updated_baseParamsList','topology_reg_int_list','topology_short_names_unique'); 
%     end
% 
% end

    %% Statistical Significance among regulatory topologies 
% result_fileName = 'test_saved_files/MultiSSingle_more_result_struct_time_course_updated_June.mat'; 
% result_file = load(result_fileName); 
% result_struct = result_file.result_struct; 
% reg_topo_list = 1:7;
% 
% reg_topo_p_val_matrix = nan(length(reg_topo_list),length(reg_topo_list)); 
% outperform_superstruct_matrix = nan(length(reg_topo_list),length(reg_topo_list)); 
% for reg_topo_num_1_idx = 1:length(reg_topo_list)
%     reg_topo_num_1 = reg_topo_list(reg_topo_num_1_idx); 
%     for reg_topo_num_2_idx = 1:length(reg_topo_list) 
%         reg_topo_num_2 = reg_topo_list(reg_topo_num_2_idx); 
%         filtered_result_struct_1 = filter_result_struct(result_struct,{'reg_topo'},{reg_topo_num_1});
%         num_unidentifiable_1 = [filtered_result_struct_1.num_unidentifiable]';
%         % num_outperform_superstruct_1 = [filtered_result_struct_1.num_outperform_superstructure]';
%         filtered_result_struct_2 = filter_result_struct(result_struct,{'reg_topo'},{reg_topo_num_2});
%         num_unidentifiable_2 = [filtered_result_struct_2.num_unidentifiable]';
%         % num_outperform_superstruct_2 = [filtered_result_struct_2.num_outperform_superstructure]';
% 
%         [h,p] = kstest2(num_unidentifiable_1,num_unidentifiable_2); 
%         reg_topo_p_val_matrix(reg_topo_num_1_idx,reg_topo_num_2_idx) = p; 
% 
%         % [h_st,p_st] = kstest2(num_outperform_superstruct_1,num_outperform_superstruct_2);
%         % outperform_superstruct_matrix(reg_topo_num_1,reg_topo_num_2) = p_st; 
% 
%     end
% end
% % Branch: Reg topology 125 are statistically significantly different from 346 
% % UDreg: all different except 27 and 56
% % MultiS: all different 

    %% Formalize the plot 
% topology_name = 'MultiS'; 
% result_fileName = sprintf('test_saved_files/%sSingle_more_result_struct_time_course_updated_June.mat',topology_name); 
% result_file = load(result_fileName); 
% result_struct = result_file.result_struct; 
% 
%     % Get # putative maps
% allMaps_file = load(sprintf('kineticMaps/%s_allMaps.mat',topology_name)); 
% num_model_total = length(allMaps_file.allMaps); 
% 
% reg_topo_list = 1:7;
% for reg_topo_idx = 1:length(reg_topo_list)
% 
%     reg_topo_num = reg_topo_list(reg_topo_idx); 
% 
%     filtered_result_struct = filter_result_struct(result_struct,{'reg_topo'},{reg_topo_num});
%     num_unidentifiable = [filtered_result_struct.num_unidentifiable]';
%     [divided_num,~] = categorize_identifiability(num_unidentifiable,num_model_total);
%     subplot(2,4,reg_topo_idx)
%     pie(divided_num)
%     set(gca,'FontSize',12)
% 
% end
%% Section 3 - MultiS topology
    %% Missing metabolite impact 
% result_fileName = 'test_saved_files/MultiS_result_struct_time_course_updated_June.mat';
% result_file = load(result_fileName); 
% result_struct = result_file.result_struct; 
% 
% num_model_total = 227; 
% missing_metabolite_idx_list = [0,2,4];
% figure; 
% for missing_met_idx = 1:length(missing_metabolite_idx_list)
%     missing_met = missing_metabolite_idx_list(missing_met_idx); 
%     if isequal(missing_met,0)
%         baseline_result_struct = filter_result_struct(result_struct,{'missing_met'},{missing_met});
%         baseline_num_unidentifiable = [baseline_result_struct.num_unidentifiable]'; 
%     else
%         filtered_result_struct = filter_result_struct(result_struct,{'missing_met'},{missing_met}); 
%         num_unidentifiable = [filtered_result_struct.num_unidentifiable]';
%         [h,p_val] = kstest2(baseline_num_unidentifiable,num_unidentifiable,'Tail','smaller')
%     end
% 
%     filtered_result_struct = filter_result_struct(result_struct,{'missing_met'},{missing_met}); 
%     num_unidentifiable = [filtered_result_struct.num_unidentifiable]';
% 
%     [divided_num,~] = categorize_identifiability(num_unidentifiable,num_model_total);
%     subplot(1,3,missing_met_idx)
%     pie(divided_num)
%     if isequal(missing_met,0)
%         title('No missing metabolite')
%     else
%         title(sprintf('missing metabolite #%d',missing_met))
%     end
%     set(gca,'FontSize',12)
% end


%% Section 4 - lower nT 
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


%% Section 5 - Independent Noise
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






