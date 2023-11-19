function experimental_data = load_multiple_datasets(topology_name,crossTalk_name,reg_topo_num,WTparamSetNum,data_type,num_datasets,noise)
    %This function prepares the datasets in a structure array 
    
    %topology_name, crossTalk_name, reg_topo_num, WTparamSetNum -
    %identifier for loading data 
        %WTparamSetNum - 161-180
    %num_datasets - a dummy variable that's going to be 5 in this study 
    %data_type - case 'multiple_IC' or 'multiple_perturbation'
    %noise - {[],[nT,cov]} / noiseless or noisy 


    %Locate the folder with data 
    prefix = sprintf('BSTData/%s%s_regNetwork_%d/BST_%s%s_',topology_name,crossTalk_name,reg_topo_num,topology_name,crossTalk_name);
    
    %obtain the suffix 
    if isempty(noise)
        suffix = 'hiRes.mat';
    else
        nT = noise(1);
        cov = noise(2);
        suffix = sprintf('nT-%d_cov-%02d_rep-001.mat',nT,cov);
    end

    switch data_type
        case 'multiple_IC'
            %Obtain relevant paramSetNum label to be loaded 
            starting_paramSetNum = 80;
            relevant_paramSetNum_list = get_relevant_paramSetNumList(starting_paramSetNum,WTparamSetNum,num_datasets);
            
            experimental_data(num_datasets) = struct();
            %load and organize data 
            for param_idx = 1:1:length(relevant_paramSetNum_list)
                paramSetNum = relevant_paramSetNum_list(param_idx);
                temp_data_load = load(sprintf('%sk-%03d_hiRes.mat',prefix,paramSetNum));
                perturbFlux = temp_data_load.perturbFlux;
                perturbSize = temp_data_load.perturbSize;
                data_single_set = load(sprintf('%sk-%03d_%s',prefix,paramSetNum,suffix));
                experimental_data(param_idx).timeVec = data_single_set.timeVec;
                experimental_data(param_idx).concMatrix = data_single_set.concMatrix;
                experimental_data(param_idx).perturbFlux = perturbFlux; 
                experimental_data(param_idx).perturbSize = perturbSize;
                experimental_data(param_idx).nT = data_single_set.nT;
                experimental_data(param_idx).tStart = data_single_set.tStart;
                experimental_data(param_idx).tEnd = data_single_set.tEnd;
                experimental_data(param_idx).fluxTimeVec = data_single_set.fluxTimeVec;
                
            end
            
        case 'multiple_perturbation'
            %Obtain relevant paramSetNum label to be loaded 
            starting_paramSetNum = 0; 
            relevant_paramSetNum_list = get_relevant_paramSetNumList(starting_paramSetNum,WTparamSetNum,num_datasets);
%             experimental_data(num_datasets) = struct();
            %load and organize data 
            for param_idx = 1:1:length(relevant_paramSetNum_list)
                paramSetNum = relevant_paramSetNum_list(param_idx);
                temp_data_load = load(sprintf('%sk-%03d_hiRes',prefix,paramSetNum));
                perturbFlux = temp_data_load.perturbFlux;
                perturbSize = temp_data_load.perturbSize;
                data_single_set = load(sprintf('%sk-%03d_%s',prefix,paramSetNum,suffix));
                experimental_data(param_idx) = struct('timeVec',data_single_set.timeVec,'concMatrix',data_single_set.concMatrix,'perturbFlux',perturbFlux,'perturbSize',perturbSize...
                    ,'nT',data_single_set.nT,'tStart',data_single_set.tStart,'tEnd',data_single_set.tEnd,'fluxTimeVec',data_single_set.fluxTimeVec);
                
            end
    end
        
        

end