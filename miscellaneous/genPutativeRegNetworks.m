function allMaps = genPutativeRegNetworks(stoichMatrix)
    
    %% Generate baseline kineticsMap based on stoichMatrix
    numMet = size(stoichMatrix,1);
    numFlux = size(stoichMatrix,2); 
    kineticsMap_baseline = [];
    for met = 1:1:numMet
        non_zero_idx = find(stoichMatrix(met,:)<0);
        if ~isempty(non_zero_idx)
            for flux_idx = 1:1:length(non_zero_idx)
                kineticsMap_baseline = [kineticsMap_baseline;[met,non_zero_idx(flux_idx)]];
            end
        end
    end
    num_baseline_intrx = size(kineticsMap_baseline,1); 
    
    %% Get elementary interaction pairs 
    elementary_intrx = nan(numMet * (numFlux - 1) - size(kineticsMap_baseline,1),2); 
    elementary_idx = 1; 
    for met_idx = 1:1:numMet
        for flux_idx = 2:1:numFlux
            if ~ismember([met_idx,flux_idx],kineticsMap_baseline,'rows')
                elementary_intrx(elementary_idx,:) = [met_idx,flux_idx];
                elementary_idx = elementary_idx + 1;
            end
        end
    end

    %% Start combining elementary interactions 
    
    %Limiting criteria: (1) 1 metabolite cannot control more than 1 fluxes
    %(2) 1 flux cannot be controlled by more than 1 metabolites

    %set an empty output
    NMAkineticsMap = {};
    %initialize addStatus
    moreInteraction = 1;
    %initialize maximum number of interactions in map to 1
    numMaxNMAinterax = 1;
    while isequal(moreInteraction,1) %Indicate that I can have one more interaction added 
        %This is the base case - max of 1 interaction in map
        %add all elementary interactions here
        moreInteraction = 0; 
        if isequal(numMaxNMAinterax,1)
            for i = 1:1:size(elementary_intrx,1)
                singleKineticsMap = elementary_intrx(i,:);
                NMAkineticsMap{end+1} = singleKineticsMap;
                
            end
            moreInteraction = 1;
        %having max of more than 1 interactions in map
        else
            %get a size count for kineticsMap
            originalSize = size(NMAkineticsMap,2);
            
            for j = 1:1:size(NMAkineticsMap,2)
                %Loop through all members of kinetics map
                singleKineticsMapTemp = NMAkineticsMap{1,j};
                if isequal(size(singleKineticsMapTemp,1),numMaxNMAinterax-1)
                    %if it has max # interaction -1 interactions, it is the
                    %target for addition of 1 interaction
                    singleKineticsMap = zeros(numMaxNMAinterax,2);%preallocation
                    singleKineticsMap(1:end-1,:) = singleKineticsMapTemp;
                    for k = 1:1:size(elementary_intrx,1)
                        finalSingleKineticsMap = singleKineticsMap;
                        elementary_intrxTemp = elementary_intrx(k,:);
                        finalSingleKineticsMap(end,:) = elementary_intrxTemp; 
                        %add 1 interaction if it meets criteria
                        reg_met_count = length(find(finalSingleKineticsMap(:,1) == elementary_intrxTemp(1)));
                        reg_flux_count = length(find(finalSingleKineticsMap(:,2) == elementary_intrxTemp(2)));
                        if ~ismember(elementary_intrxTemp,singleKineticsMap,'rows') && reg_met_count <= 1 && reg_flux_count <= 1
                            NMAkineticsMap{end+1} = finalSingleKineticsMap;%update output map
                            moreInteraction = 1;
                        end
                    end
                end
            end

        end
        numMaxNMAinterax = numMaxNMAinterax + 1;
    end
        
    %screen the generated map for any repetitive maps
    finalNMAkineticsMap = {};
    for i = 1:1:size(NMAkineticsMap,2)
        element = NMAkineticsMap{i};
        addStatus = 1;
        for j = i+1:1:size(NMAkineticsMap,2)
            if isequal(size(element),size(NMAkineticsMap{j})) && isEquivalentMatrix(element,NMAkineticsMap{j})
                addStatus = 0;
            end
        end
        if isequal(addStatus,1)
            finalNMAkineticsMap{end+1} = element;
        end
    end




    %% Add mass-action to the regMap 

    allMaps = {};
    for i = 1:1:size(finalNMAkineticsMap,2)
        singleNMAkineticsMap = finalNMAkineticsMap{i};
        singleKineticsMap = [kineticsMap_baseline;singleNMAkineticsMap];
        allMaps{end+1} = singleKineticsMap;
    end









end