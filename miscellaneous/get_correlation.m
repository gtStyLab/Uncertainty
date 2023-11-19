function [rep_corr,rep_corr_pval,corr_avg,corr_avg_pval] = get_correlation(result_struct,field,corr_type,field_names,field_values)
    % Get correlation between # unidentifiable structures (both from
    % individual replicates and average of 3 replicates) and a specific
    % array.

    % * Array should have same length as height of the result struct 

    % filter data based on provided conditional statements
    % currently only allow filed_names = field_values, cannot do
    % e.g.field_names > some_value. Also assume that all conditions
    % specified need to be satisfied (i.e. connected by AND) 
        % First check whether field_names and field_values have the same
        % size
    if ~isequal(length(field_names),length(field_values))
        error('Mismatch in fields and field values in conditional statement')
    end
    for cond_state_idx = 1:length(field_names)
        field_name = field_names{cond_state_idx}; 
        field_value = field_values{cond_state_idx}; 
        if isa(field_value,'char')
            eval(sprintf('keep_idx_list = find(strcmp({result_struct.%s},field_value));',field_name))
        elseif isa(field_value,'double')
            eval(sprintf('keep_idx_list = find([result_struct.%s]==field_value);',field_name))
        end
        result_struct = result_struct(keep_idx_list); 
        field = field(keep_idx_list); 
    end


    [corr_field_rep1,pval_field_rep1] = corr(field,[result_struct.num_unidentifiable_rep1]','Type',corr_type);
    [corr_field_rep2,pval_field_rep2] = corr(field,[result_struct.num_unidentifiable_rep2]','Type',corr_type);
    [corr_field_rep3,pval_field_rep3] = corr(field,[result_struct.num_unidentifiable_rep3]','Type',corr_type);

    rep_corr = [corr_field_rep1;corr_field_rep2;corr_field_rep3];
    rep_corr_pval = [pval_field_rep1;pval_field_rep2;pval_field_rep3];

    all_num_unidentifiable = [[result_struct.num_unidentifiable_rep1],[result_struct.num_unidentifiable_rep2],...
        [result_struct.num_unidentifiable_rep3]]; 
    all_field = repmat(field',1,3);
    [corr_avg,corr_avg_pval] = corr(all_field',all_num_unidentifiable','Type',corr_type); 
    


end