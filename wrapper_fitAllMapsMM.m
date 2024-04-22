function wrapper_fitAllMapsMM(topology_idx,reg_topo_num,paramSetNum,nT,cov,rep,missing_metabolite_idx)

    addpath(genpath(pwd))
    addpath(genpath('/storage/home/hcoda1/5/yhan309/scratch/uncertainty_main'));
    
    topology_short_name_list = {'Branch','UDreg','Cycle'};
    topology_full_name_list = {'BranchCrossTalk','UDregCrossTalk','Cycle'}; 
    
    noise = [nT,cov];

    num_iter_qs = 50;
    num_iter_fs = 3;
    num_init_parameter_fs = 3; 

    topology_short_name = topology_short_name_list{topology_idx};
    topology_full_name = topology_full_name_list{topology_idx}; 
        

    %% Prepare input
    

    %paramsList 
    paramsList_fileName = sprintf('paramsList/MMparamsList%s_regNetwork_%d.mat',topology_full_name,reg_topo_num);
    paramsList = load(paramsList_fileName); 
    paramsList = paramsList.paramsList; 
    paramsVec = paramsList{1,paramSetNum - 160};

    %base paramsList 
    base_paramsList_fileName = sprintf('paramsList/baseMMparamsList%s_regNetwork_%d.mat',topology_full_name,reg_topo_num); 
    base_paramsList_file = load(base_paramsList_fileName); 
    base_paramsList = base_paramsList_file.baseParamsList; 
    base_parameters = base_paramsList{1,paramSetNum - 160}; 

    %stoichMatrix
    modelInfo = get_model_info(topology_short_name);
    stoichMatrix = modelInfo.stoichMatrix;
    if strcmp(topology_short_name,'Branch')
        stoichMatrix(3,5) = -paramsVec(1); 
        stoichMatrix(4,5) = -paramsVec(2); 
    end
    allMaps = load(sprintf('kineticMaps/%s_allMaps.mat',topology_short_name));
    all_kineticsMap_indicator = allMaps.all_kineticsMap_indicator; 
    all_kineticsMap = allMaps.allMaps;
    num_structures = size(all_kineticsMap,2); 

    base_paramsVec = base_parameters(1:end-size(stoichMatrix,1)); 

    %data 
    experimental_data = load(sprintf('GenData/MMData/%s_regNetwork_%d_MMsampled/MM_%s_k-%d_nT-%d_cov-%02d_rep-%03d.mat',topology_full_name,reg_topo_num,topology_full_name,paramSetNum,nT,cov,rep)); 

    if exist('missing_metabolite_idx','var')
        experimental_data = remove_metabolite_data(experimental_data,missing_metabolite_idx);
    end

    % Get missing metabolite index 
    missing_data_idx = isnan(experimental_data.concMatrix); 
    imputed_missing_idx = find(sum(missing_data_idx,1)~=0); 
    %% parameter estimation 
    for struct_idx = 1:num_structures
        % fprintf('\n Running struct %d',struct_idx)
        kineticsMap = all_kineticsMap{1,struct_idx};
        kineticsMap_indicator = all_kineticsMap_indicator{struct_idx}; 
        [best_fitted_parameters,best_fval,ODEstruct,param_cov] = ...
            wrapper_network_fitting_partialMM(topology_short_name,kineticsMap,kineticsMap_indicator,experimental_data,base_paramsVec); 
        num_mass_action_pairs = length(find(stoichMatrix<0));
        reg_kineticsMap = kineticsMap(num_mass_action_pairs+1:end,:);
        fitted_MMparams = best_fitted_parameters;

        current_modelStruct = struct('ODEstruct',ODEstruct,'topology_short_name',topology_short_name,'fitted_MMparams',fitted_MMparams,...
                            'best_fval',best_fval,'num_fitted_parameters',size(reg_kineticsMap,1),'kineticsMap',kineticsMap,...
                            'kineticsMap_indicator',kineticsMap_indicator);
        errorMetrics = wrapper_model_evaluationMM(experimental_data,current_modelStruct,imputed_missing_idx);

        fitted_models(struct_idx).kineticsMap = kineticsMap; 
        fitted_models(struct_idx).reg_kineticsMap = reg_kineticsMap;
        fitted_models(struct_idx).errorMetrics = errorMetrics;
        fitted_models(struct_idx).fitted_MMparams = fitted_MMparams;
        fitted_models(struct_idx).modelStruct = current_modelStruct; 
        fitted_models(struct_idx).param_cov = param_cov; 

    end
    
    if exist('missing_metabolite_idx','var')
        save(sprintf('partial_fitting_results/MMfitMM_%s_regNetwork_%d_paramSetNum-%03d_nT-%d_cov-%03d_rep-%03d_missing_met-%d.mat',topology_full_name,reg_topo_num,paramSetNum,nT,cov,rep,missing_metabolite_idx));
    else
        save(sprintf('partial_fitting_results/MMfitMM_%s_regNetwork_%d_paramSetNum-%03d_nT-%d_cov-%03d_rep-%03d.mat',topology_full_name,reg_topo_num,paramSetNum,nT,cov,rep));
    end










end