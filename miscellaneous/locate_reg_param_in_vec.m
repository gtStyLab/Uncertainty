function reg_pair_param_idx = locate_reg_param_in_vec(topology_name,reg_pair,gs_regNetwork)
   % Return the index of the defined regulatory interaction in the
   % parameter vector used to generate the data 

   %% Input 
    % topology_name - a string
    % reg_pair - a 1*2 vector with the first value representing regulating
    % metabolite and second value representing regulated flux
    % gs_regNetwork - n * 2 vector representing the true reg network

    model_info = get_model_info(topology_name); 
    stoichMatrix = model_info.stoichMatrix;

    rest_regNetwork = setdiff(gs_regNetwork,reg_pair,"rows"); 

    regulated_flux = reg_pair(2); 
    
    if strcmp(topology_name,'Branch') % Account for two stoich params 
        reg_pair_param_idx = 2; 
    else
        reg_pair_param_idx = 0;
    end

    for flux = 1:regulated_flux - 1
        % kinetic constant + flux regulated by mass-action + flux regulated
        % by other metabolites 
        reg_pair_param_idx = 1 + reg_pair_param_idx + length(find(stoichMatrix(:,flux)<0)) + length(find(rest_regNetwork(:,2) == flux));
    end

    reg_pair_param_idx = reg_pair_param_idx + 1 +  length(find(stoichMatrix(:,regulated_flux) < 0) & find(stoichMatrix(:,regulated_flux) < 0) < reg_pair(1)) ...
        + length(rest_regNetwork(:,2) == regulated_flux & rest_regNetwork(:,1) < reg_pair(1));
    






end