function KineticsMap = genMassActionKineticsMap(stoichMatrix)

    %Find mass-action regulatory interactions and construct the kineticsMap
    %with no substrate-level regulatory interaction
    
    numMet = size(stoichMatrix,1);
    
    KineticsMap = [];
    for met = 1:1:numMet
        non_zero_idx = find(stoichMatrix(met,:)<0); %find idx for effluxes
        if ~isempty(non_zero_idx)
            for flux_idx = 1:1:length(non_zero_idx)
                KineticsMap = [KineticsMap;[met,non_zero_idx(flux_idx)]];
            end
        end
    end





end