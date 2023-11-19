function [param_related_feature_names,param_related_feature_mat] = get_param_corr_related_features(result_struct,topology_name)

    load('true_regulatory_network_structure.mat');
    % extract all paramter-related features 
    all_field_names = fieldnames(result_struct);
    keep_field_names = all_field_names(contains(all_field_names,'_const') | (contains(all_field_names,'reg')) & ~contains(all_field_names,'topo'));
    keep_field_names = [keep_field_names;{'num_unidentifiable'}]; 
    rm_field_names = setdiff(all_field_names,keep_field_names); 
        % Remove columns with same values 
    for feat_idx = 1:length(keep_field_names)
        keep_field_name = keep_field_names{feat_idx}; 
        eval(sprintf('col_val = [result_struct.%s]'';',keep_field_name));
        first_val = col_val(1);
        if all(col_val == first_val) || all(isnan(col_val))
            rm_field_names = [rm_field_names;{keep_field_name}];
        end

    end
    trimmed_result_struct = rmfield(result_struct,rm_field_names); 
    trimmed_field_names = fieldnames(trimmed_result_struct); 

    eval(sprintf('all_reg_network = %s_reg_network;',topology_name));
    added_feature_mat = nan(length(trimmed_result_struct),size(all_reg_network,1));
    added_feature_names = cell(size(all_reg_network,1),1); 
    for reg_pair_idx = 1:size(all_reg_network,1)
        reg_pair = all_reg_network(reg_pair_idx,:); 
        reg_param_name = sprintf('reg_%d_%d',reg_pair(1),reg_pair(2));
        abs_reg_param_name = strcat(reg_param_name,'_abs');
        added_feature_names{reg_pair_idx,1} = abs_reg_param_name;
        eval(sprintf('feature_vec = [trimmed_result_struct.%s]'';',reg_param_name));
        added_feature_mat(:,reg_pair_idx) = abs(feature_vec); 
    end

    feature_cell = struct2cell(trimmed_result_struct);
    feature_mat = cell2mat(feature_cell); 
    feature_mat = feature_mat'; 
    
    param_related_feature_names = [trimmed_field_names;added_feature_names];
    param_related_feature_mat = [feature_mat,added_feature_mat];
end