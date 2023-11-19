function logical_value = same_network(kineticsMap,test_kineticsMap)

    if ~isequal(size(kineticsMap,1),size(test_kineticsMap,1))
        logical_value = 0; 
    else
        difference = sort(kineticsMap,2) - sort(test_kineticsMap,2); 
        non_zeros = find(difference);
        if isempty(non_zeros)
            logical_value = 1;
        else
            logical_value = 0;
        end
    end




end