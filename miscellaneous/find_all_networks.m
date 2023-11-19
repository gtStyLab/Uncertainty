function all_AICs = find_all_networks(fileName)
    load(fileName);
    
    %number of networks inspected is not certain - can't preassign
    all_AICs = [];
    for i = 1:1:length(temp_storage_AICs)
        AICs = temp_storage_AICs{i}(:);
        all_AICs = [all_AICs;AICs(find(~isnan(AICs)))];
    end
        






end