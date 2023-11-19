function relevant_paramSetNum_list = get_relevant_paramSetNumList(starting_paramSetNum,WTparamSetNum,num_datasets)
    %Given starting paramSetNum and WTparamSetNum, compile a list of
    %relevant parameter set labels to be loaded later 


    relevant_paramSetNum_list = nan(num_datasets,1); 
    relevant_paramSetNum_list(1) = WTparamSetNum; 
    for idx = 2:1:length(relevant_paramSetNum_list)
        paramSetNum = starting_paramSetNum + 20 * (idx-2) + (WTparamSetNum-160);
        relevant_paramSetNum_list(idx) = paramSetNum;
    end





end