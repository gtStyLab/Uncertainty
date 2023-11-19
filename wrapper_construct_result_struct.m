clear
clc

%% Workflow description
    % Organize partial fitting results and information inherent to the
    % model structure into a result structure array 


%% 1. Analyze the partial fitting results and compile into a data structure
        % (metadata) topology name, crosstalk name, regNetwork, parameter
        % setNum, nT, cov, missing metabolite 
        % (underlying data)  #unidentifiable structures for 3 noise replicates, 
        % baseline error,gold standard error, error of the identified structure, 
        % gs structure, top-ranked structure 
topology_name_list = {'Branch','UDreg','Cycle'};
crossTalk_list = {'CrossTalk','NoCrossTalk',''};
nT_list = [1000,500,200,100];
cov_list = [5,15,25];
missing_metabolite_idx_list_all = {[0,2,4],[0,2,3],[0,2,4]};
gs_regNetwork_file = load('true_regulatory_network_structure.mat');
gs_regNetwork = gs_regNetwork_file.regNetworks;

    % Use BIC for model discrimination 

for topo_idx = 1:length(topology_name_list)
    topology_name = topology_name_list{topo_idx}; 
    missing_metabolite_idx_list = missing_metabolite_idx_list_all{topo_idx}; 
    if strcmp(topology_name,'Cycle')
        true_crossTalk_list = 3;
    else
        true_crossTalk_list = 1:2;
    end
    % Preassign cell arrays
        % metadata
    array_size = length(true_crossTalk_list) * 4 * 3 * 3 * 20 * 3; 
    topology_name_array = cell(array_size,1); 
    crosstalk_array = cell(array_size,1); 
    reg_idx_array = cell(array_size,1); 
    paramSetNum_array = cell(array_size,1); 
    nT_array = cell(array_size,1); 
    cov_array = cell(array_size,1); 
    missing_metabolite_array = cell(array_size,1);
        % result 
    num_unidentifiable_array = nan(array_size,3);
    baseline_error_array = cell(array_size,1); 
    gs_error_array = cell(array_size,1);
    min_error_array = cell(array_size,1); 
    gs_structure_array = cell(array_size,1);
    top_structure_array = cell(array_size,1); 
        % Reset count 
    count = 1; 
    for crosstalk_idx = 1:length(true_crossTalk_list)
        crosstalk_name = crossTalk_list{true_crossTalk_list(crosstalk_idx)};
        for reg_idx = 1:3 
            for paramSetNum = 161:180
                for nT = nT_list
                    for cov = cov_list
                        for missing_idx = 1:length(missing_metabolite_idx_list)
                            missing_metabolite_idx = missing_metabolite_idx_list(missing_idx);
                            resultFileStem = sprintf('partial_fitting_results/%s%s_regNetwork_%d_paramSetNum-%d_nT-%d_cov-%03d',...
                                topology_name,crosstalk_name,reg_idx,paramSetNum,nT,cov);
                            if isequal(missing_metabolite_idx,0)
                                resultFileAppendix = '.mat';
                            else
                                resultFileAppendix = sprintf('_missing_met-%d.mat',missing_metabolite_idx);
                            end
                            % assign metadata to cell array 
                            topology_name_array{count,1} = topology_name;
                            crosstalk_array{count,1} = crosstalk_name; 
                            reg_idx_array{count,1} = reg_idx; 
                            paramSetNum_array{count,1} = paramSetNum; 
                            nT_array{count,1} = nT; 
                            cov_array{count,1} = cov; 
                            missing_metabolite_array{count,1} = missing_metabolite_idx; 
                            topology_full_name_idx = strcmp(gs_regNetwork_file.topology_full_names,strcat(topology_name,crosstalk_name));
                            gs_structure_array{count,1} = gs_regNetwork_file.regNetworks{topology_full_name_idx,reg_idx}; 

                            % assign values for 3 noise replicates 
                            baseline_error_rep= nan(3,1); 
                            gs_error_rep = nan(3,1);
                            top_error_rep = nan(3,1); 
                            top_structure_rep = cell(3,1); 
                            num_unidentifiable_rep = nan(3,1); 
                            for rep = 1:3
                                try
                                    resultFile = load(sprintf('%s_rep-%03d%s',resultFileStem,rep,resultFileAppendix));
                                    [num_unidentifiable_struct,baseline_error,gs_error,top_error,top_structure] = count_number_unidentifiable_regNetwork_v3(resultFile,gs_regNetwork_file);
                                    num_unidentifiable_rep(rep) = num_unidentifiable_struct;
                                    baseline_error_rep(rep) = baseline_error; 
                                    gs_error_rep(rep) = gs_error;
                                    top_error_rep(rep) = top_error; 
                                    top_structure_rep{rep} = top_structure; 
                                end
                            end

                            % assign noise replicates info to main data
                            % structure
                            num_unidentifiable_array(count,:) = num_unidentifiable_rep; 
                            baseline_error_array{count,1} = baseline_error_rep; 
                            gs_error_array{count,1} = gs_error_rep;
                            min_error_array{count,1} = top_error_rep; 
                            top_structure_array{count,1} = top_structure_rep; 

                            % update index  
                            count = count + 1; 
                        end
                    end
                end
            end
        end
    end
    num_unidentifiable_array_cell = num2cell(num_unidentifiable_array); 
    all_cells = [topology_name_array,crosstalk_array,reg_idx_array,paramSetNum_array,nT_array,cov_array,missing_metabolite_array,...
        num_unidentifiable_array_cell,baseline_error_array,gs_error_array,min_error_array,gs_structure_array,top_structure_array];
    field_names = {'topology','crosstalk','reg_topo','paramSetNum','nT','cov','missing_met','num_unidentifiable_rep1',...
        'num_unidentifiable_rep2','num_unidentifiable_rep3','baseline_error','gs_error','min_error','gs_network','top_network'}; 
    result_struct = cell2struct(all_cells,field_names,2);
    save(sprintf('test_saved_files/%s_result_struct_basic_updated_June',topology_name),'result_struct'); 
end



%% 2. Add parameter values to the result structure
for topo_idx = 1:length(topology_name_list)

    topology_name = topology_name_list{topo_idx}; 
    resultFile = load(sprintf('test_saved_files/%s_result_struct_basic_updated_June.mat',topology_name)); 
    result_struct = resultFile.result_struct;

    % Every 36 (12 noise * 3 missing metabo lites) rows there should be a unique parameter values  
    fileName_stem = 'paramsList/paramsList';
    correct_struct_length = length(result_struct); 
    for row_idx = 1:36:correct_struct_length

        topology = result_struct(row_idx).topology; 
        crosstalk = result_struct(row_idx).crosstalk;
        reg_topo_num = result_struct(row_idx).reg_topo;
        paramSetNum = result_struct(row_idx).paramSetNum;

        topology_idx = strcmp(gs_regNetwork_file.topology_full_names,strcat(topology,crosstalk)); 
        reg_network = gs_regNetwork{topology_idx,reg_topo_num}; 
        fileName = sprintf('%s%s%s_regNetwork_%d.mat',fileName_stem,topology,crosstalk,reg_topo_num);
        paramsList_file = load(fileName); 
        paramsList = paramsList_file.paramsList; 
        % 'Header' for parameters should be same here 
        %Prepare the transformation index required for
        %convertModelKineticsParams
        model_info = get_model_info(topology);
        stoichMatrix = model_info.stoichMatrix;
        kineticsMap_baseline = genMassActionKineticsMap(stoichMatrix);
        kineticsMap = [kineticsMap_baseline;reg_network];

        paramSet = paramsList{1,paramSetNum-160};
        if strcmp(topology,'Branch')
            paramsVec = paramSet(3:end-size(stoichMatrix,1));
            init_cond = paramSet(end-size(stoichMatrix,1)+1:end);
        else
            paramsVec = paramSet(1:end-size(stoichMatrix,1));
            init_cond = paramSet(end-size(stoichMatrix,1)+1:end); 
        end

        %'Label' the parameters
        flux_num_parameters = ones(size(stoichMatrix,2),1); %every flux will start off with 1 parameter
        for reg_pair_idx = 1:1:size(kineticsMap,1)
            controller_met = kineticsMap(reg_pair_idx,1);
            controlled_flux = kineticsMap(reg_pair_idx,2);
            flux_num_parameters(controlled_flux) = flux_num_parameters(controlled_flux) + 1;

        end
        index = ones(size(stoichMatrix,2),1);
        for num_parameters_idx = 1:1:(length(flux_num_parameters)-1)
            index(num_parameters_idx+1) = index(num_parameters_idx+1) + sum(flux_num_parameters(1:num_parameters_idx));
        end
        converted_params = convertModelKineticsParams(paramsVec,kineticsMap,index,size(stoichMatrix,1));
        [parameter_labels,parameter_values] = label_parameters(converted_params,init_cond);

            % Assign new fields to result struct if i = 1 
        if isequal(row_idx,1)
            for param_label_idx = 1:length(parameter_labels)
                param_label = parameter_labels{param_label_idx}; 
                eval(sprintf('[result_struct.%s] = deal(nan);',param_label));
                eval(sprintf('[result_struct(row_idx:row_idx + 36 -1).%s] = deal(parameter_values{param_label_idx});',param_label));
            end
        else
            for param_label_idx = 1:length(parameter_labels)
                param_label = parameter_labels{param_label_idx}; 
                eval(sprintf('[result_struct(row_idx:row_idx + 36 -1).%s] = deal(parameter_values{param_label_idx});',param_label));
            end
        end

    end
    save(sprintf('test_saved_files/%s_result_struct_paramVals_updated_June',topology_name),'result_struct'); 
end

%% 3. Add parameter sensitivity analysis results 
% 
% for topo_idx = 1:length(topology_name_list)
% 
%     topology_name = topology_name_list{topo_idx}; 
%     resultFile = load(sprintf('test_saved_files/%s_result_struct_paramVals_updated_June.mat',topology_name));
%     sensitivity_resultFile = load(sprintf('test_saved_files/%s_parameter_sensitivity.mat',topology_name));
%     result_struct = resultFile.result_struct; 
%     sensitivity_result_struct = sensitivity_resultFile.result_struct;
%     sensitivity_fieldNames = fieldnames(sensitivity_result_struct); 
% 
%     for row_idx = 1:36:length(result_struct)
%         % Get parameter sensitivity from result file and assign them in
%         % existing result structure 
%         sensitivity_idx = ceil(row_idx/36);
%         for field_idx = 5:length(sensitivity_fieldNames)
%             % Assign new fields if row_idx =1 
%             field_name = sensitivity_fieldNames{field_idx}; 
%             eval(sprintf('field_value = sensitivity_result_struct(sensitivity_idx).%s;',field_name)); 
%             if isequal(row_idx,1)
%                 eval(sprintf('[result_struct.%s] = deal(nan);',strcat(field_name,'_sensitivity')))
%             end
%             eval(sprintf('[result_struct(row_idx:row_idx + 36 -1).%s] = deal(field_value);',...
%                 strcat(field_name,'_sensitivity')));
%         end
%     end
%     save(sprintf('test_saved_files/%s_result_struct_param_sensitivity_updated_June',topology_name),'result_struct'); 
% end

%% 4. Add parameter ratios 
% for topo_idx = 1:length(topology_name_list)
% 
%     topology_name = topology_name_list{topo_idx}; 
%     resultFile = load(sprintf('test_saved_files/%s_result_struct_param_sensitivity_updated_June.mat',topology_name)); 
%     result_struct = resultFile.result_struct;
% 
%     modelInfo = get_model_info(topology_name);
%     numMet = size(modelInfo.stoichMatrix,1); 
% 
%     % Parameter value ratios 
%     result_struct_fieldNames = fieldnames(result_struct);
%     % Loop from v1_const to before v1_const_sensitivity
%     start_idx = find(strcmp(result_struct_fieldNames,'v1_const')); 
%     end_idx = find(contains(result_struct_fieldNames,'init_1')); 
%     param_name_fieldNames = result_struct_fieldNames(start_idx:end_idx-1); 
%     for nom_param_idx = 1:length(param_name_fieldNames)
%         nominator_param_name = param_name_fieldNames{nom_param_idx};
% 
%         for denom_param_idx = nom_param_idx + 1:length(param_name_fieldNames)
%             denom_param_name = param_name_fieldNames{denom_param_idx}; 
%             % Define header name 
%             new_field_name = [nominator_param_name '_over_' denom_param_name];
%             % Calculate parameter ratio
%             eval(sprintf('new_field_value = abs([result_struct.%s] ./ [result_struct.%s]);',nominator_param_name,denom_param_name));
%                 % Replace inf with a large positive value 
%             new_field_value(isinf(new_field_value)) = 1e+08; 
%             new_field_value_cell = num2cell(new_field_value');
%             % Assign new columns to table 
%             eval(sprintf('[result_struct.%s] = new_field_value_cell{:};',new_field_name));
%         end
%     end
% 
%     save(sprintf('test_saved_files/%s_result_struct_param_ratio_updated_June',topology_name),'result_struct'); 
% 
% end


%% 5. Unpack the current result struct and add features extracted from time-course

    % Load the result struct 
for topo_idx = 1:length(topology_name_list)

    topology_name = topology_name_list{topo_idx}; 
    resultFile = load(sprintf('test_saved_files/%s_result_struct_paramVals_updated_June.mat',topology_name)); 
    result_struct = resultFile.result_struct;


    % Get number of unidentifiabile models out of the result struct
    num_unidentifiable_models = [result_struct.num_unidentifiable_rep1;result_struct.num_unidentifiable_rep2;...
        result_struct.num_unidentifiable_rep3]'; 
    modified_result_struct = rmfield(result_struct,{'num_unidentifiable_rep1','num_unidentifiable_rep2','num_unidentifiable_rep3'});


    % Features from time-course 
        % load the generated features
    time_course_features = readtable(sprintf('test_saved_files/20230608_%s_time_course_feature.csv',topology_name));
    time_course_features_struct = table2struct(time_course_features); 
    time_course_feature_name_list = time_course_features.Properties.VariableNames; 


    % Unpack the result struct row by row 
    for result_struct_idx = 1:length(modified_result_struct)

        % Extract one row 
        result_struct_row = modified_result_struct(result_struct_idx);

        % Add rep_num, num_unidentifiable, and time-course features to the
        % row 
        for rep = 1:3
                % Make a replicate row 
            result_struct_row_rep = result_struct_row;
                % Add rep & num_unidentifiable fields
            result_struct_row_rep.rep = rep;
            result_struct_row_rep.num_unidentifiable = num_unidentifiable_models(result_struct_idx,rep);
                % Add time-course features
                    % Select the row of interest
            if ~strcmp(topology_name,'Cycle')
                % Branch & UDreg 
                select_field_names = {'topology','crosstalk','reg_topo','paramSetNum','nT','cov','rep'}; 
                select_field_values = {result_struct_row.topology,result_struct_row.crosstalk,result_struct_row.reg_topo,...
                    result_struct_row.paramSetNum,result_struct_row.nT,result_struct_row.cov,rep}; 
            else
                        % Cycle
                select_field_names = {'topology','reg_topo','paramSetNum','nT','cov','rep'}; 
                select_field_values = {result_struct_row.topology,result_struct_row.reg_topo,...
                    result_struct_row.paramSetNum,result_struct_row.nT,result_struct_row.cov,rep}; 
            end

            time_course_feature_row = filter_result_struct(time_course_features_struct,select_field_names,select_field_values);
                    % Add to rep
            for i = 2:length(time_course_feature_name_list)
                if ~ismember(time_course_feature_name_list{i},select_field_names)
                    result_struct_row_rep.(time_course_feature_name_list{i}) = time_course_feature_row.(time_course_feature_name_list{i});
                end
            end
            if ~exist('unpacked_result_struct','var')
                unpacked_result_struct = result_struct_row_rep; 
            else
                unpacked_result_struct = [unpacked_result_struct;result_struct_row_rep];
            end
        end

    end

    save(sprintf('test_saved_files/%s_result_struct_time_course_updated_June',topology_name),'unpacked_result_struct'); 
    clear unpacked_result_struct

end

%% 6. Unpack baseline error, gs error, and min error in result struct 
for topo_idx = 1:length(topology_name_list)
    topology_name = topology_name_list{topo_idx};
    result_struct_file = load(sprintf('test_saved_files/%s_result_struct_time_course_updated_June.mat',topology_name)); 
    result_struct = result_struct_file.unpacked_result_struct;
    for row_idx = 1:length(result_struct)
        rep = result_struct(row_idx).rep; 
        result_struct(row_idx).baseline_error = result_struct(row_idx).baseline_error(rep); 
        result_struct(row_idx).gs_error = result_struct(row_idx).gs_error(rep); 
        result_struct(row_idx).min_error = result_struct(row_idx).min_error(rep); 
    end

    save(sprintf('test_saved_files/%s_result_struct_time_course_updated_June.mat',topology_name),'result_struct'); 
end

