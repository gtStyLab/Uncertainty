function wrapper_genRandParams(topology_full_name,topology_short_name,reg_networks,reg_network_idx)



    %get stoichMatrix and baseline kineticsMap 
    model_info = get_model_info(topology_short_name);
    stoichMatrix = model_info.stoichMatrix;
    numFlux = size(stoichMatrix,2);
    numMet = size(stoichMatrix,1);
    kineticsMap_baseline = genMassActionKineticsMap(stoichMatrix);

    %Construct full kineticsMap 
    kineticsMap = [kineticsMap_baseline;reg_networks];

    %get total number of parameters 
    total_num_parameters = size(stoichMatrix,2) + size(kineticsMap,1);

    %% parameter generation 
    % 20 different sets 
    paramsList = cell(1,20);
    for rep = 1:20 
    %     rng(rep) %for replicability control 

        %if branch pathway, we'll need to replace 2 stoich numbers
        if strcmp(topology_short_name,'Branch')
            bm1 = rand;
            bm2 = 1 - bm1; 
            temp_stoichMatrix = stoichMatrix;
            temp_stoichMatrix(3,5) = -bm1;
            temp_stoichMatrix(4,5) = -bm2;
        end
        successFlag = false;

        %% while flag not true 
        while ~successFlag
        %generate rand parameters in the right range (i.e. [-2,2] for
        %substrate-level regulation, [0,2] for mass-action and a's ) 
        %Get indexes of parameters that have to be positive, get total number of
        %parameters
            flux_num_parameters = ones(numFlux,1);
            temp_parameters_matrix = zeros(numFlux,numMet + 1);
            temp_parameters_matrix(1,1) = 1;
            temp_parameters_matrix(2:end,1) = 2 * rand(numFlux-1,1); 
            for reg_pair_idx = 1:1:size(kineticsMap,1)
                controller_met = kineticsMap(reg_pair_idx,1);
                controlled_flux = kineticsMap(reg_pair_idx,2);
                %decide whether a mass-action 
                if stoichMatrix(controller_met,controlled_flux) < 0 
                    temp_parameters_matrix(controlled_flux,controller_met + 1) = 2 * rand; %positive index 
                    %Mass-action regulatory interaction has + exponent 
                else
                    temp_parameters_matrix(controlled_flux,controller_met + 1) = -2 + 4 * rand; %not necessarily positive
                    %non-mass action interaction has no constraint
                end
                flux_num_parameters(controlled_flux) = flux_num_parameters(controlled_flux) + 1;
            end
            %generate rand initial conditions (from interval [0 1])
            x0 = rand(numMet,1);

            %update ODEstruct 
            ODEstruct.tStart = 0;
            ODEstruct.tEnd = 10;
            ODEstruct.nT = 1000; 
            ODEstruct.MBParams = stoichMatrix;
            ODEstruct.x0 = x0;

            %define all possible flux perturbatios (we want most flux perturbation
            %to be working) 
            perturbedFluxList = [1,repmat(2:numFlux,1,2)];
            perturbSizeList = [1,2*ones(1,length(2:numFlux)),0.5*ones(1,length(2:numFlux))];
            paramsStatus = 1;

            %test if valid parameter set by solving the ode 
            for fluxPerturbidx = 1:1:length(perturbedFluxList)
              perturbedFlux = perturbedFluxList(fluxPerturbidx);
              perturbSize = perturbSizeList(fluxPerturbidx);
              adjustedPowerLawKineticsParams = temp_parameters_matrix;
              adjustedPowerLawKineticsParams(perturbedFlux,1) = perturbSize * adjustedPowerLawKineticsParams(perturbedFlux,1);
              [~,xData] = SolveBranchedPathwayBSTODE(adjustedPowerLawKineticsParams,ODEstruct.MBParams,ODEstruct.tStart,ODEstruct.tEnd,ODEstruct.nT,ODEstruct.x0);
              if ~isequal(size(xData,1),1001) || ~isreal(xData)
                paramsStatus = 0;
                break
              end

            end

            %if yes, get a flag to be true 
            if isequal(paramsStatus,1)
                successFlag = true;
            end
        end
        %% organize a valid parameter set 
        kineticsParamsVec = reshape(temp_parameters_matrix',[],1);
        kineticsParamsVec = kineticsParamsVec(find(kineticsParamsVec));

        %%%%%%%%%% if branch pathway
        if strcmp(topology_short_name,'Branch')
            paramsVec = [bm1;bm2;kineticsParamsVec;x0];
        else
            paramsVec = [kineticsParamsVec;x0];
        end
        paramsList{1,rep} = paramsVec;

    end
    save(sprintf('paramsList/paramsList%s_regNetwork_%d.mat',topology_full_name,reg_network_idx),'paramsList');
end