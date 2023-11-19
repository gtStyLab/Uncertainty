function inMap = mapInStorage(kineticsMap,uncertain_networks)
    %returns a logical value for whether the matrix kineticsMap is in 
    %the cell uncertain_networks
    inMap = 0;
    for i = 1:1:size(uncertain_networks,1)
        for j = 1:1:size(uncertain_networks,2)
            test_kineticsMap = uncertain_networks{i,j};
            inMap = inMap + same_network(kineticsMap,test_kineticsMap);
        end
    end

    






end