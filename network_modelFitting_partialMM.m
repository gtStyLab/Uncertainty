function [fitted_parameters,min_fval,ODEstruct,fitted_paramsVecAll,fvalAll] = network_modelFitting_partialMM(topology_short_name,kineticsMap,kineticsMap_indicator,experimental_data,base_parameters,num_iter,quickSearch,init_parameters)
    %This function takes in a topology, a putative regulatory network,
    %experimental data, and all parameters except the regulatory ones.
    %It will automatically construct a MM-based ODE
    %model and fit the parameters. 
    
    %Input
        % stoichMatrix 
        % kineticsMap - A k*2 matrix with 1st column as controller
                % metabolites and 2nd column as controlled fluxes
        % kineticsMap_indicator - A #reg * 1 vector indicating
        % positive/negative regulatory interaction 
        % experimental_data - a struct with timeVec and concMatrix
        % base_parameters - kinetic parameters for pathway, no regulatory
        % network, in matrix form 
        % num_iter - number of different initial points used in parameter
                % estimation
        % quickSearch - If 1, fmincon will stop at 5 iterations. This is to
        %               ensure that solver doesn't get stuck at a bad
        %               initial point
        % init_parameters - Optional input initial parameters, should be a
        % vector of length #regulatory pairs
        
    %Output
        % fitted_parameters - a vector form of the fitted parameters 
        % min_fval - best fval from iterations
        % index - position of a parameters, used to convert
                % fitted_parametes into matrix form 
        % ODEstruct - contains stoichMatrix, tStart, tEnd, nT, x0
        % fitted_paramsVecAll - all fitted parameters from different
                % intial points
        % fvalAll - all fval
    %% extract info
    numRegulation = size(kineticsMap,1);
    exp_timeVec = experimental_data.timeVec;
    nT = length(exp_timeVec)-1;
    tStart = exp_timeVec(1);
    tEnd = exp_timeVec(end);
    conc_data = experimental_data.concMatrix;
%     flux_data = experimental_data.fluxMatrix;
    x0 = conc_data(1,:);
    model_info = get_model_info(topology_short_name);
    stoichMatrix = model_info.stoichMatrix;
    ODEstruct = struct('MBParams',stoichMatrix,'tStart',tStart,'tEnd',tEnd,'nT',nT,'x0',x0);

    % Get missing metabolite index 
    missing_data_idx = isnan(conc_data); 
    imputed_missing_idx = find(sum(missing_data_idx,1)~=0); 
  
    %% Parameter fitting 
    
    %Define #parameters to be estimated and set lb/ub
    num_mass_action_reg_pairs = length(find(stoichMatrix<0));
    num_reg_pairs = numRegulation - num_mass_action_reg_pairs;
    reg_kineticsMap = kineticsMap(num_mass_action_reg_pairs+1:end,:);
    
    % log_kineticsParamsVec = -3 + 6 * rand(num_params,1); 
    % kineticsParamsVec = 10 .^ log_kineticsParamsVec; 
    if strcmp(topology_short_name,'Branch')
        num_params = length(kineticsMap_indicator);
    else
        num_params = 3 * length(find(kineticsMap_indicator > 0)) + length(find(kineticsMap_indicator < 0)); 
    end

    lb = -3 * ones(num_params,1);
    ub = 3 * ones(num_params,1);

    % %%%%%%%Troubleshooting%%%%%
    % paramsListFile = load('paramsList/MMparamsListUDregCrossTalk_regNetwork_1.mat'); 
    % base_paramsListFile = load('paramsList/baseMMparamsListUDregCrossTalk_regNetwork_1.mat'); 
    % paramsList = paramsListFile.paramsList; 
    % base_paramsList = base_paramsListFile.baseParamsList; 
    % paramsVec = paramsList{4}; 
    % baseParamsVec = base_paramsList{4}; 
    % gs_regKineticParams = setdiff(paramsVec,baseParamsVec); 
    % 
    % % %%%%%%%%%%%%
    
    fvalAll = nan(num_iter,1);
    fitted_paramsVecAll= cell(num_iter,1);
    for j = 1:1:num_iter
        %Set up initial parameter values 
        logParamsVec_init = -3 + 6 * rand(num_params,1); 
        
        % % %%%%Troubleshoot%%%%
        % paramsVec_init = [0.0527337328092692;0.148429596352131;22.3330564115569;200.785735776672;]; 
        % logParamsVec_init = log10(paramsVec_init); 
        % % %%%%%%%%
        % 


        if quickSearch
            fmincon_options = optimoptions('fmincon','disp','iter','MaxIterations',50);
        else
            fmincon_options = optimoptions('fmincon','disp','iter');
            if exist('init_parameters','var') && isequal(j,1)
                logParamsVec_init = init_parameters;
            end
        end
        
        [fitted_paramsVec,fval] = fmincon(@(x) calcFcnErrWrapper(x,base_parameters,conc_data,ODEstruct,topology_short_name,kineticsMap,kineticsMap_indicator,imputed_missing_idx),logParamsVec_init,[],[],[],[],lb,ub,[],fmincon_options);

        fitted_MM_paramsVec = [base_parameters;10.^fitted_paramsVec]; % transform regulatory parameters 
        fvalAll(j) = fval;
        fitted_paramsVecAll{j,1} = fitted_MM_paramsVec;
    end
    [min_fval,best_parameter_idx] = min(fvalAll);
    fitted_parameters = fitted_paramsVecAll{best_parameter_idx,1};



    function totalError = calcFcnErrWrapper(x,base_parameters,concData,ODEstruct,topology_short_name,kineticsMap,kineticsMap_indicator,imputed_missing_idx)

        % Combine base parameters with the regulatory parameters to be
        % estimated 
        MM_paramsVec = [base_parameters;10.^x]; % transform regulatory parameters 
        
        [~, concMatrix, ~] = solveOdeMm(topology_short_name,kineticsMap,kineticsMap_indicator,ODEstruct.tStart,ODEstruct.tEnd,ODEstruct.nT,ODEstruct.x0,MM_paramsVec);
        % [t,xData] = SolveBranchedPathwayBSTODE(fitted_powerLawKineticsParams,ODEstruct.MBParams,ODEstruct.tStart,ODEstruct.tEnd,ODEstruct.nT,ODEstruct.x0);
        if isempty(imputed_missing_idx)
            predicted_data = concMatrix; 
            observed_data = concData; 
        else
            predicted_data = [concMatrix(:,1:imputed_missing_idx-1),concMatrix(:,imputed_missing_idx+1:end)];
            observed_data = [concData(:,1:imputed_missing_idx-1),concData(:,imputed_missing_idx+1:end)];
        end
        if isreal(predicted_data) && isequal(size(predicted_data,1),size(observed_data,1))
            errorConcVec = sum((predicted_data-observed_data).^2);
            totalError = sum(errorConcVec);
        else
            totalError = 10000;
        end
    
    end

end
