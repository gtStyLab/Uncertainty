function finalNMAkineticsMap = genNMAkineticsMap(massActionMap,numMet,numFlux)
    %Get every possible elementary interactions 
    allPossibleElementary = zeros(numMet*(numFlux-1),2);
    for met = 1:1:numMet
        for flux = 2:1:numFlux
            allPossibleElementary((met-1)*(numFlux-1)+flux-1,:) = [met,flux];
        end
    end
    %anything in mass-action interaction is not elementary
    elementaryInterax = setdiff(allPossibleElementary,massActionMap,'row');
    %set an empty output
    NMAkineticsMap = {};
    %initialize addStatus
    moreInteraction = 1;
    %initialize maximum number of interactions in map to 1
    numMaxNMAinterax = 1;
    while isequal(moreInteraction,1) %Indicate that I can have one more interaction added 
        %This is the base case - max of 1 interaction in map
        %add all elementary interactions here
        if isequal(numMaxNMAinterax,1)
            for i = 1:1:size(elementaryInterax,1)
                singleKineticsMap = elementaryInterax(i,:);
                NMAkineticsMap{end+1} = singleKineticsMap;
            end
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
                    for k = 1:1:size(elementaryInterax,1)
                        finalSingleKineticsMap = singleKineticsMap;
                        elementaryInteraxTemp = elementaryInterax(k,:);
                        %add 1 interaction if it meets criteria
                        if ~ismember(elementaryInteraxTemp(1),singleKineticsMap(:,1)) && ~ismember(elementaryInteraxTemp(2),singleKineticsMap(:,2))
                            finalSingleKineticsMap(end,:) = elementaryInteraxTemp;
                            NMAkineticsMap{end+1} = finalSingleKineticsMap;%update output map
                        end
                    end
                end
            end
            %get another size count
            currentSize = size(NMAkineticsMap,2);
            %if equal, no updates possible, end the loop
            if isequal(numMaxNMAinterax,2)
                moreInteraction = 0;
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







end