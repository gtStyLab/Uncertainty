function experimental_data = load_single_dataset_v2(topology_name,crossTalk_name,reg_topo_num,WTparamSetNum,noise,rep)


    prefix = sprintf('GenData/BSTData/v2_%s%s_regNetwork_%d/BST_%s%s_',topology_name,crossTalk_name,reg_topo_num,topology_name,crossTalk_name);
    
    %obtain the suffix 
    if isempty(noise)
        suffix = 'hiRes.mat';
    else
        nT = noise(1);
        cov = noise(2);
        suffix = sprintf('nT-%03d_cov-%02d_rep-%03d.mat',nT,cov,rep);
    end

    experimental_data = load(sprintf('%sk-%03d_%s',prefix,WTparamSetNum,suffix));
end