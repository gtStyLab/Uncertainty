function baseParameters_matrix = genBaseParameters_matrixForm(paramsVec,topology_short_name,regNetwork)


        %Get stoichMatrix
        modelInfo = get_model_info(topology_short_name);
        stoichMatrix = modelInfo.stoichMatrix;
        numMet = size(stoichMatrix,1); 
        numFlux = size(stoichMatrix,2);
        %Generate base kineticsMap based on stoichMatrix 
        kineticsMap_baseline = [];
        for met = 1:1:numMet
            non_zero_idx = find(stoichMatrix(met,:)<0);
            if ~isempty(non_zero_idx)
                for flux_idx = 1:1:length(non_zero_idx)
                    kineticsMap_baseline = [kineticsMap_baseline;[met,non_zero_idx(flux_idx)]];
                end
            end
        end
        kineticsMap = [kineticsMap_baseline;regNetwork];
            %Get index and convert into matrix form 
        flux_num_parameters = ones(numFlux,1); %every flux will start off with 1 parameter 
        for reg_pair_idx = 1:1:size(kineticsMap,1)
           controlled_flux = kineticsMap(reg_pair_idx,2);
           flux_num_parameters(controlled_flux) = flux_num_parameters(controlled_flux) + 1;
        end
        index = ones(numFlux,1);
        for num_parameters_idx = 1:1:(length(flux_num_parameters)-1)
            index(num_parameters_idx+1) = index(num_parameters_idx+1) + sum(flux_num_parameters(1:num_parameters_idx));
        end
            %Convert the vector form into matrix form 
        if strcmp(topology_short_name,'Branch')
            kineticParamsVec = paramsVec(3:end-numMet);
        else
            kineticParamsVec = paramsVec(1:end-numMet); 
        end
        kineticsParamsMat = convertModelKineticsParams(kineticParamsVec,kineticsMap,index,numMet);
            %Remove regulatory parameters
        for nma_reg_idx = 1:1:size(regNetwork,1)
            nma_reg_met = regNetwork(nma_reg_idx,1);
            nma_reg_flux = regNetwork(nma_reg_idx,2); 
            kineticsParamsMat(nma_reg_flux,nma_reg_met + 1) = 0; 
            
        end
        baseParameters_matrix = kineticsParamsMat; 
end