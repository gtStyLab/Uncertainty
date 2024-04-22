function wrapper_fitAllMaps_v2(topology_idx,crossTalk_idx,reg_topo_num,paramSetNum,nT,cov,rep,missing_metabolite_idx)

    addpath(genpath('/storage/home/hcoda1/5/yhan309/scratch/uncertainty_main'));
    
    topology_name_list = {'Branch','UDreg','Cycle','MultiS'};
    crossTalk_list = {'CrossTalk','NoCrossTalk',''};
    if isequal(topology_idx,length(topology_name_list))
        crossTalk_list = {'Feedback','Mixed'};
    end
    noise = [nT,cov];
    
    topology_short_name = topology_name_list{topology_idx};
    if ~isequal(crossTalk_idx,0)
        crossTalk_name = crossTalk_list{crossTalk_idx};
    else
        crossTalk_name = 'Single';
    end
        
    %% Prepare input
    %paramsList 
    paramsList_fileName = sprintf('paramsList/v2_paramsList%s%s_regNetwork_%d.mat',topology_short_name,crossTalk_name,reg_topo_num);
    paramsList = load(paramsList_fileName); 
    try
        paramsList = paramsList.paramsList; 
    catch
        paramsList = paramsList.updated_paramsList;
    end
    paramsVec = paramsList{paramSetNum - 160};

    baseParameters_fileName = sprintf('paramsList/v2_baseParametersList%s%s_regNetwork_%d.mat',topology_short_name,crossTalk_name,reg_topo_num);
    baseParameters = load(baseParameters_fileName);
    try
        baseParameters = baseParameters.baseParametersList; 
    catch
        baseParameters = baseParameters.updated_baseParamsList; 
    end
    base_parameters = baseParameters{paramSetNum - 160};
    %stoichMatrix
    modelInfo = get_model_info(topology_short_name);
    stoichMatrix = modelInfo.stoichMatrix;
    if strcmp(topology_short_name,'Branch')
        stoichMatrix(3,5) = -paramsVec(1); 
        stoichMatrix(4,5) = -paramsVec(2); 
    end
    allMaps = load(sprintf('kineticMaps/%s_allMaps.mat',topology_short_name));
    all_kineticsMap = allMaps.allMaps;
    num_structures = size(all_kineticsMap,2); 
    %data 

    experimental_data = load_single_dataset_v2(topology_short_name,crossTalk_name,reg_topo_num,paramSetNum,noise,rep);

    if exist('missing_metabolite_idx','var')
        experimental_data = remove_metabolite_data(experimental_data,missing_metabolite_idx);
    end

    % Get missing metabolite index 
    missing_data_idx = isnan(experimental_data.concMatrix); 
    imputed_missing_idx = find(sum(missing_data_idx,1)~=0); 
    %% parameter estimation 
    for struct_idx = 1:num_structures
        
        kineticsMap = all_kineticsMap{1,struct_idx};
        [best_fitted_parameters,best_fval,ODEstruct,parameter_estimation_cov] = wrapper_network_fitting_v3_partial(stoichMatrix,kineticsMap,experimental_data,base_parameters);
        num_mass_action_pairs = length(find(stoichMatrix<0));
        reg_kineticsMap = kineticsMap(num_mass_action_pairs+1:end,:);
        fitted_powerLawKineticsParams = best_fitted_parameters;

        current_modelStruct = struct('ODEstruct',ODEstruct,'fitted_powerLawKineticsParams',fitted_powerLawKineticsParams,...
                            'best_fval',best_fval,'num_fitted_parameters',size(reg_kineticsMap,1),'KineticsMap',kineticsMap);
        errorMetrics = wrapper_model_evaluation(experimental_data,current_modelStruct,imputed_missing_idx);

        fitted_models(struct_idx).kineticsMap = kineticsMap; 
        fitted_models(struct_idx).reg_kineticsMap = reg_kineticsMap;
        fitted_models(struct_idx).errorMetrics = errorMetrics;
        fitted_models(struct_idx).fitted_powerLawKineticsParams = fitted_powerLawKineticsParams;
        fitted_models(struct_idx).modelStruct = current_modelStruct; 
        fitted_models(struct_idx).parameter_estimation_cov = parameter_estimation_cov;

    end

    if exist('missing_metabolite_idx','var')
        save(sprintf('partial_fitting_results/v2_%s%s_regNetwork_%d_paramSetNum-%03d_nT-%d_cov-%03d_rep-%03d_missing_met-%d.mat',topology_short_name,crossTalk_name,reg_topo_num,paramSetNum,nT,cov,rep,missing_metabolite_idx));
    else
        save(sprintf('partial_fitting_results/v2_%s%s_regNetwork_%d_paramSetNum-%03d_nT-%d_cov-%03d_rep-%03d.mat',topology_short_name,crossTalk_name,reg_topo_num,paramSetNum,nT,cov,rep));
    end

end