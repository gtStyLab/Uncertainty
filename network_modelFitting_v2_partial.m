function [fitted_parameters,min_fval,ODEstruct,fitted_paramsVecAll,fvalAll] = network_modelFitting_v2_partial(stoichMatrix,kineticsMap,experimental_data,base_parameters,num_iter,quickSearch,init_parameters)
    %This function takes in a topology, a putative regulatory network,
    %experimental data, and all parameters except the regulatory ones.
    %It will automatically construct a BST-based ODE
    %model and fit the parameters. 
    
    %Compared to the previous version, this version treats those parameters
    %inherent to the metabolic pathway topology to be fixed - so it
    %decouples structural and parameter uncertainty to some degree

    %v2 allows parameter estimation with missing metabolite
    
    
    %Input
        % stoichMatrix 
        % kineticsMap - A k*2 matrix with 1st column as controller
                % metabolites and 2nd column as controlled fluxes
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
    timeVec = experimental_data.timeVec;
    nT = length(timeVec)-1;
    tStart = timeVec(1);
    tEnd = timeVec(end);
    conc_data = experimental_data.concMatrix;
%     flux_data = experimental_data.fluxMatrix;
    x0 = conc_data(1,:);
    ODEstruct = struct('MBParams',stoichMatrix,'tStart',tStart,'tEnd',tEnd,'nT',nT,'x0',x0);

    % Get missing metabolite index 
    missing_data_idx = isnan(conc_data); 
    imputed_missing_idx = find(sum(missing_data_idx,1)~=0); 
  
    %% Parameter fitting 
    
    %Define #parameters to be estimated and set lb/ub
    num_mass_action_reg_pairs = length(find(stoichMatrix<0));
    num_reg_pairs = numRegulation - num_mass_action_reg_pairs;
    reg_kineticsMap = kineticsMap(num_mass_action_reg_pairs+1:end,:);
    
    lb = -10 * ones(num_reg_pairs,1);
    ub = 10 * ones(num_reg_pairs,1); 
    
    fvalAll = nan(num_iter,1);
    fitted_paramsVecAll= cell(num_iter,1);
    for j = 1:1:num_iter
        %Set up initial parameter values 
        paramsVec_init = -10 + 20 * rand(num_reg_pairs,1);
        if quickSearch
            fmincon_options = optimoptions('fmincon','disp','off','MaxIterations',50);
        else
            fmincon_options = optimoptions('fmincon','disp','off');
            if exist('init_parameters','var') && isequal(j,1)
                paramsVec_init = init_parameters;
            end
        end
        
        [fitted_paramsVec,fval] = fmincon(@(x) calcFcnErrWrapper(x,base_parameters,conc_data,ODEstruct,reg_kineticsMap,imputed_missing_idx),paramsVec_init,[],[],[],[],lb,ub,[],fmincon_options);
        fitted_kineticsParams = base_parameters;
        for idx = 1:1:size(reg_kineticsMap,1)
            reg_met = reg_kineticsMap(idx,1);
            reg_flux = reg_kineticsMap(idx,2);
            fitted_kineticsParams(reg_flux,reg_met + 1) = fitted_paramsVec(idx);
        end
        fvalAll(j) = fval;
        fitted_paramsVecAll{j,1} = fitted_kineticsParams;
    end
    [min_fval,best_parameter_idx] = min(fvalAll);
    fitted_parameters = fitted_paramsVecAll{best_parameter_idx,1};
    function totalError = calcFcnErrWrapper(x,base_parameters,concData,ODEstruct,reg_kineticsMap,imputed_missing_idx)
        fitted_powerLawKineticsParams = base_parameters;
        for reg_idx = 1:1:size(reg_kineticsMap,1)
            reg_met = reg_kineticsMap(reg_idx,1);
            reg_flux = reg_kineticsMap(reg_idx,2);
            fitted_powerLawKineticsParams(reg_flux,reg_met + 1) = x(reg_idx);
        end
        
        [t,xData] = SolveBranchedPathwayBSTODE(fitted_powerLawKineticsParams,ODEstruct.MBParams,ODEstruct.tStart,ODEstruct.tEnd,ODEstruct.nT,ODEstruct.x0);
        if isempty(imputed_missing_idx)
            predicted_data = xData; 
            observed_data = concData; 
        else
            predicted_data = [xData(:,1:imputed_missing_idx-1),xData(:,imputed_missing_idx+1:end)];
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
