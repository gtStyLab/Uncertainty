function wrapper_genRandParamsMM(topology_full_name,topology_short_name,reg_network_idx)



    %get stoichMatrix and baseline kineticsMap 
    model_info = get_model_info(topology_short_name);
    stoichMatrix = model_info.stoichMatrix;
    numFlux = size(stoichMatrix,2);
    numMet = size(stoichMatrix,1);

    %get total number of parameters 
    num_params_list = [12,18,18]; 
    topology_short_name_list = {'Branch','UDreg','Cycle'};
    num_params = num_params_list(strcmp(topology_short_name_list,topology_short_name)); 


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
            %generate rand parameters from the log10 space. log10(Vmax) values should
            %be from [-3,3]; log10(Km) values should be from [-3,3]
        
            %Get indexes of parameters that have to be positive, get total number of
            %parameters
            log_kineticsParamsVec = -3 + 6 * rand(num_params,1); 
            kineticsParamsVec = 10 .^ log_kineticsParamsVec; 
           
            %generate rand initial conditions (from interval [0 1])
            x0 = rand(numMet,1);
        
            %update ODEstruct 
            tStart = 0;
            tEnd = 10;
            nT = 1000; 
        
            % test if ODE system can be solved without raising numerical issue 
            switch topology_short_name
                case 'Branch'
                    paramsVec = [bm1;bm2;kineticsParamsVec];
                    [~, concMatrix, ~] = solveOdeMmBranch(tStart,tEnd,nT,x0,paramsVec); 
                    if ~isequal(size(concMatrix,1),1001) || ~isreal(concMatrix)
                        paramsStatus = 0;
                    else
                        paramsStatus = 1; 
                    end
                case 'UDreg'
                    [~, concMatrix, ~] = solveOdeMmUDreg(tStart,tEnd,nT,x0,kineticsParamsVec); 
                    if ~isequal(size(concMatrix,1),1001) || ~isreal(concMatrix)
                        paramsStatus = 0;
                    else
                        paramsStatus = 1; 
                    end
                case 'Cycle'
                    [~, concMatrix, ~] = solveOdeMmCycle(tStart,tEnd,nT,x0,kineticsParamsVec); 
                    if ~isequal(size(concMatrix,1),1001) || ~isreal(concMatrix)
                        paramsStatus = 0;
                    else
                        paramsStatus = 1; 
                    end
            end
        
            %if yes, get a flag to be true 
            if isequal(paramsStatus,1)
                successFlag = true;
            end
        end

        %%%%%%%%%% if branch pathway
        if strcmp(topology_short_name,'Branch')
            paramsVec = [bm1;bm2;kineticsParamsVec;x0];
        else
            paramsVec = [kineticsParamsVec;x0];
        end
        paramsList{1,rep} = paramsVec;

    end
    save(sprintf('paramsList/MMparamsList%s_regNetwork_%d.mat',topology_full_name,reg_network_idx),'paramsList');
end