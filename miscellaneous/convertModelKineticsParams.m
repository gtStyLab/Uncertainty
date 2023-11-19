function modelKineticsParams = convertModelKineticsParams(VectorModelKineticsParams,kineticsMap,index,numMet)

    numFlux = length(index);
    modelKineticsParams = zeros(numFlux,numMet + 1);

    for m = 1:1:numFlux
        modelKineticsParams(m,1) = VectorModelKineticsParams(index(m));
        regulatedIdxs = kineticsMap(:,2)==m;
        regulatorMets = sort(kineticsMap(regulatedIdxs,1),'ascend');
        if ~isempty(regulatorMets)
            for n = 1:1:length(regulatorMets)
                regulatorMet = regulatorMets(n);
                modelKineticsParams(m,regulatorMet + 1) = VectorModelKineticsParams(index(m)+n);
            end
        end
        
     
    end



end