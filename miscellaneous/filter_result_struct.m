function filtered_result_struct = filter_result_struct(result_struct,field_names,field_values)
    % Return a pruned result struct with specified field values in field
    % names (e.g. reg_topo = 1, crosstalk = 'CrossTalk') 

    % Currently only allow filed_names = field_values, cannot do
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
    end
    filtered_result_struct = result_struct; 


end 