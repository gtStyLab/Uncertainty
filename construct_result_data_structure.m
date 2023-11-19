function param_correlation_struct = construct_result_data_structure(topology_short_name,crossTalk_name,missing_metabolite,result_fileName_stem)
    %% Construct structure array to store results (i.e. number of unidentifiable structures) 
    regNetworks = {[3,4;4,3;],[3,4;4,2],[3,4;5,2];...
        [3,3;4,4;],[3,2;4,4;],[3,3;5,4;];...
        [2,2;5,3;],[3,2;2,6;],[5,5;4,2;];...
        [2,3;4,8;],[2,3;4,2;],[2,6;4,8;];...
        [2,2;4,3;],[2,2;3,3;],[2,2;4,6;];};
    nT_list = [1000,500,200,100];
    cov_list = [5,15,25]; 
    topology_full_names = {'BranchCrossTalk','BranchNoCrossTalk','Cycle','UDregCrossTalk','UDregNoCrossTalk'};
    topology_idx = find(strcmp(strcat(topology_short_name,crossTalk_name),topology_full_names)); 
    crossTalk_names = {'CrossTalk','NoCrossTalk'};
    rep_list = 1:3; 

    if isnan(missing_metabolite)
        result_append_string = '';
    else
        result_append_string = sprintf('_missing_met-%d',missing_metabolite);
    end

    % Construct a structure array to store the number of unidentifiable
    % structures and its metadata (nT,cov,topo,crossTalk,regNetwork), as well
    % as the underlying real parameters and the connection that they represent 

    % param_correlation_struct = struct(); 
    array_size = length(crossTalk_names) * 20 * length(nT_list) * length(cov_list) * 3;
    nT_array = cell(array_size,1);
    cov_array = cell(array_size,1);
    crossTalk_array = cell(array_size,1);
    paramSetNum_array = cell(array_size,1); 
    parameter_array = nan(array_size,35); 
    parameter_label = cell(array_size,1); 
    num_unidentifiable_array = cell(array_size,1); 
    reg_network_array = cell(array_size,1); 

    count = 1; 

    fileName_stem = 'paramsList/paramsList';
    for reg_topo_num = 1:3
        reg_network = regNetworks{topology_idx,reg_topo_num}; 
        fileName = sprintf('%s%s%s_regNetwork_%d.mat',fileName_stem,topology_short_name,crossTalk_name,reg_topo_num);
        paramsList_file = load(fileName); 
        paramsList = paramsList_file.paramsList; 
        % 'Header' for parameters should be same here 
        %Prepare the transformation index required for
        %convertModelKineticsParams
        model_info = get_model_info(topology_short_name);
        stoichMatrix = model_info.stoichMatrix;
        kineticsMap_baseline = genMassActionKineticsMap(stoichMatrix);
        kineticsMap = [kineticsMap_baseline;reg_network];

        for paramSetNum = 161:180 
            paramSet = paramsList{1,paramSetNum-160};
            if strcmp(topology_short_name,'Branch')
                paramsVec = paramSet(3:end-size(stoichMatrix,1));
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
            for nT = nT_list
                for cov = cov_list
                    [metric_list,number_unidentifiable_regNetwork,all_fitted_params,fitted_models] = count_number_unidentifiable_regNetwork_v2(topology_short_name,crossTalk_name,reg_topo_num,paramSetNum,nT,cov,rep_list,result_append_string);
                    nT_array{count} = nT; 
                    cov_array{count} = cov; 
                    crossTalk_array{count} = crossTalk_name;
                    num_unidentifiable_array{count} = min(number_unidentifiable_regNetwork); 
                    paramSetNum_array{count} = paramSetNum;
                    parameter_array(count,:) = cell2mat(parameter_values);
                    parameter_label{count} = parameter_labels;
                    reg_network_array{count} = reg_network;

                    count = count + 1; 
                end
            end
        end
    end

    % 
    % param_correlation_struct = struct('regNetwork',reg_network_array,'nT',nT_array,'cov',cov_array,'crossTalk',crossTalk_array,'num_unidentifiable',num_unidentifiable_array);
    parameter_cell = num2cell(parameter_array);

    non_params_field_names = {'num_unidentifiable','regNetwork','crossTalk','paramSetNum','nT','cov'};
    field_names = [non_params_field_names,parameter_labels'];

    all_cells = [num_unidentifiable_array,reg_network_array,crossTalk_array,paramSetNum_array,nT_array,cov_array,parameter_cell];

    param_correlation_struct = cell2struct(all_cells,field_names,2);

    save(sprintf('%s%s.mat',result_fileName_stem,result_append_string));

end