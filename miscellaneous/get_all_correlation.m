function corr_struct = get_all_correlation(result_struct,request_field_names,field_values)

    if ~exist('request_field_names','var')
        request_field_names = []; 
    end
    if ~exist('field_values','var')
        field_values = []; 
    end

    
% Correlation analysis 
    % For each analysis I'm going to do one for individual noise replicate as
    % well as average of the # unidentifiable models 

    % 1. Correlation with nT 
    [rep_corr_nT_pearson,rep_corr_nT_pearson_pval,avg_corr_nT_pearson,avg_corr_nT_pearson_pval] = ...
        get_correlation(result_struct,[result_struct.nT]','Pearson',request_field_names,field_values); 
    [rep_corr_nT_spearman,rep_corr_nT_spearman_pval,avg_corr_nT_spearman,avg_corr_nT_spearman_pval] = ...
        get_correlation(result_struct,[result_struct.nT]','Spearman',request_field_names,field_values); 

    % 2. Correlation with CoV 
    [rep_corr_cov_pearson,rep_corr_cov_pearson_pval,avg_corr_cov_pearson,avg_corr_cov_pearson_pval] = ...
        get_correlation(result_struct,[result_struct.cov]','Pearson',request_field_names,field_values); 
    [rep_corr_cov_spearman,rep_corr_cov_spearman_pval,avg_corr_cov_spearman,avg_corr_cov_spearman_pval] = ...
        get_correlation(result_struct,[result_struct.cov]','Spearman',request_field_names,field_values);

        % Get the number of parameters from result struct 
    field_names = fieldnames(result_struct);
    param_start_idx = find(strcmp(field_names,'v1_const')); % The first parameter name is always v1_const
    num_parameters = (length(field_names) - param_start_idx + 1) / 2;

    % 3. Correlation with parameter values and parameter sensitivity 
        % Get an array of values and get a corresponding description array 
    rep_corr_param_pearson = nan(3,num_parameters); 
    rep_corr_param_pearson_pval = nan(3,num_parameters); 
    rep_corr_param_spearman= nan(3,num_parameters); 
    rep_corr_param_spearman_pval = nan(3,num_parameters);
    avg_corr_param_pearson = nan(1,num_parameters); 
    avg_corr_param_pearson_pval = nan(1,num_parameters); 
    avg_corr_param_spearman = nan(1,num_parameters); 
    avg_corr_param_spearman_pval = nan(1,num_parameters); 
    rep_corr_param_sensitivity_pearson = nan(3,num_parameters); 
    rep_corr_param_sensitivity_pearson_pval = nan(3,num_parameters); 
    rep_corr_param_sensitivity_spearman = nan(3,num_parameters); 
    rep_corr_param_sensitivity_spearman_pval = nan(3,num_parameters);
    avg_corr_param_sensitivity_pearson = nan(1,num_parameters); 
    avg_corr_param_sensitivity_pearson_pval = nan(1,num_parameters); 
    avg_corr_param_sensitivity_spearman = nan(1,num_parameters); 
    avg_corr_param_sensitivity_spearman_pval = nan(1,num_parameters); 
    for param_idx = 1:num_parameters
        % Get parameter and parameter sensitivity from result struct 
        param_name = field_names{param_start_idx + param_idx - 1};
        eval(sprintf('paramVec = [result_struct.%s];',param_name));
        eval(sprintf('sensitivity_paramVec = [result_struct.%s];',strcat(param_name,'_sensitivity')));

        % Get the correlation 
        [temp_rep_corr_param_pearson,temp_rep_corr_param_pearson_pval,temp_avg_corr_param_pearson,temp_avg_corr_param_pearson_pval] = ...
            get_correlation(result_struct,paramVec','Pearson',request_field_names,field_values);
        [temp_rep_corr_param_spearman,temp_rep_corr_param_spearman_pval,temp_avg_corr_param_spearman,temp_avg_corr_param_spearman_pval] = ...
            get_correlation(result_struct,paramVec','Spearman',request_field_names,field_values);
        [temp_rep_corr_param_sensitivity_pearson,temp_rep_corr_param_sensitivity_pearson_pval,...
            temp_avg_corr_param_sensitivity_pearson,temp_avg_corr_param_sensitivity_pearson_pval] = ...
            get_correlation(result_struct,sensitivity_paramVec','Pearson',request_field_names,field_values);
        [temp_rep_corr_param_sensitivity_spearman,temp_rep_corr_param_sensitivity_spearman_pval,...
            temp_avg_corr_param_sensitivity_spearman,temp_avg_corr_param_sensitivity_spearman_pval] = ...
            get_correlation(result_struct,sensitivity_paramVec','Spearman',request_field_names,field_values);
       
        % Assign parameter value correlations
        rep_corr_param_pearson(:,param_idx) = temp_rep_corr_param_pearson; 
        rep_corr_param_spearman(:,param_idx) = temp_rep_corr_param_spearman; 
        avg_corr_param_pearson(:,param_idx) = temp_avg_corr_param_pearson; 
        avg_corr_param_spearman(:,param_idx) = temp_avg_corr_param_spearman; 

        rep_corr_param_pearson_pval(:,param_idx) = temp_rep_corr_param_pearson_pval; 
        rep_corr_param_spearman_pval(:,param_idx) = temp_rep_corr_param_spearman_pval; 
        avg_corr_param_pearson_pval(:,param_idx) = temp_avg_corr_param_pearson_pval; 
        avg_corr_param_spearman_pval(:,param_idx) = temp_avg_corr_param_spearman_pval;

        % Assign parameter sensitivity correlations 
        rep_corr_param_sensitivity_pearson(:,param_idx) = temp_rep_corr_param_sensitivity_pearson; 
        rep_corr_param_sensitivity_spearman(:,param_idx) = temp_rep_corr_param_sensitivity_spearman; 
        avg_corr_param_sensitivity_pearson(:,param_idx) = temp_avg_corr_param_sensitivity_pearson; 
        avg_corr_param_sensitivity_spearman(:,param_idx) = temp_avg_corr_param_sensitivity_spearman; 

        rep_corr_param_sensitivity_pearson_pval(:,param_idx) = temp_rep_corr_param_sensitivity_pearson_pval; 
        rep_corr_param_sensitivity_spearman_pval(:,param_idx) = temp_rep_corr_param_sensitivity_spearman_pval; 
        avg_corr_param_sensitivity_pearson_pval(:,param_idx) = temp_avg_corr_param_sensitivity_pearson_pval; 
        avg_corr_param_sensitivity_spearman_pval(:,param_idx) = temp_avg_corr_param_sensitivity_spearman_pval; 
    end

    % 4. Correlation with baseline error vs. gs error 
        % Note: won't account the average in this case since variability
        % very large 
    baseline_error_col = [result_struct.baseline_error]';
    gs_error_col = [result_struct.gs_error]';

    % Correlation with baseline error 
    rep_corr_baseline_error_pearson = nan(3,1); 
    rep_corr_baseline_error_spearman = nan(3,1); 
    % Correlation with gs error 
    rep_corr_gs_error_pearson = nan(3,1);
    rep_corr_gs_error_spearman = nan(3,1); 
    % Correlation with difference in error 
    rep_corr_diff_error_pearson = nan(3,1); 
    rep_corr_diff_error_spearman = nan(3,1); 
    % Correlation with which error is larger 
    rep_corr_diff_sign_pearson = nan(3,1);
    rep_corr_diff_sign_spearman = nan(3,1); 

    for rep = 1:3
            % Baseline error 
        [temp_corr_baseline_error_pearson,~] = get_correlation(result_struct,baseline_error_col(:,rep),'Pearson',request_field_names,field_values); 
        [temp_corr_baseline_error_spearman,~] = get_correlation(result_struct,baseline_error_col(:,rep),'Spearman',request_field_names,field_values); 
        rep_corr_baseline_error_pearson(rep,1) = temp_corr_baseline_error_pearson(rep,1); 
        rep_corr_baseline_error_spearman(rep,1) = temp_corr_baseline_error_spearman(rep,1); 

            % gs error 
        [temp_corr_gs_error_pearson,~] = get_correlation(result_struct,gs_error_col(:,rep),'Pearson',request_field_names,field_values); 
        [temp_corr_gs_error_spearman,~] = get_correlation(result_struct,gs_error_col(:,rep),'Spearman',request_field_names,field_values);
        rep_corr_gs_error_pearson(rep,1) = temp_corr_gs_error_pearson(rep,1);
        rep_corr_gs_error_spearman(rep,1) = temp_corr_gs_error_spearman(rep,1); 

            % baseline error - gs error 
        [temp_corr_diff_error_pearson,~] = get_correlation(result_struct,baseline_error_col(:,rep) - gs_error_col(:,rep),'Pearson',request_field_names,field_values); 
        [temp_corr_diff_error_spearman,~] = get_correlation(result_struct,baseline_error_col(:,rep) - gs_error_col(:,rep),'Spearman',request_field_names,field_values); 
        rep_corr_diff_error_pearson(rep,1) = temp_corr_diff_error_pearson(rep,1); 
        rep_corr_diff_error_spearman(rep,1) = temp_corr_diff_error_spearman(rep,1); 

            % baseline error - gs error > 0  % expected
        diff_larger_than_zero = (baseline_error_col(:,rep) - gs_error_col(:,rep) > 0); 
        [temp_corr_diff_sign_pearson,~] = get_correlation(result_struct,diff_larger_than_zero,'Pearson',request_field_names,field_values); 
        [temp_corr_diff_sign_spearman,~] = get_correlation(result_struct,diff_larger_than_zero,'Spearman',request_field_names,field_values); 
        rep_corr_diff_sign_pearson(rep,1) = temp_corr_diff_sign_pearson(rep,1);
        rep_corr_diff_sign_spearman(rep,1) = temp_corr_diff_sign_spearman(rep,1); 

    end

    % Alternative for 4. Concatenating the replicates and have one value
    % for correlation between # unidentifiable models and baseline vs. gs
    % error 
    filtered_result_struct = filter_result_struct(result_struct,request_field_names,field_values);
    baseline_error_col = [filtered_result_struct.baseline_error]';
    gs_error_col = [filtered_result_struct.gs_error]';
    aug_baseline_error = reshape(baseline_error_col,[numel(baseline_error_col),1]); 
    aug_gs_error = reshape(gs_error_col,[numel(gs_error_col),1]); 
    aug_num_unidentifiable = [[filtered_result_struct.num_unidentifiable_rep1]';[filtered_result_struct.num_unidentifiable_rep2]';[filtered_result_struct.num_unidentifiable_rep3]'];

    % Handle nan values 
    nan_value_idx_baseline_error = find(isnan(aug_baseline_error));
    nan_value_idx_gs_error = find(isnan(aug_gs_error)); 
    if ~isempty(nan_value_idx_baseline_error)
        fprintf('%d nan values exist in baseline error',length(nan_value_idx_baseline_error));
        % Replace with zero? 
        aug_baseline_error(nan_value_idx_baseline_error) = 0; 
        aug_num_unidentifiable(nan_value_idx_baseline_error) = 0; 
    end
    if ~isempty(nan_value_idx_gs_error)
        fprintf('%d nan values exist in gs error',length(nan_value_idx_gs_error));
        aug_gs_error(nan_value_idx_gs_error) = 0; 
        aug_num_unidentifiable(nan_value_idx_gs_error) = 0; 
    end
        % baseline error 
    [corr_baseline_error_pearson,corr_baseline_error_pearson_pval] = corr(aug_baseline_error,aug_num_unidentifiable,'Type','Pearson'); 
    [corr_baseline_error_spearman,corr_baseline_error_spearman_pval] = corr(aug_baseline_error,aug_num_unidentifiable,'Type','Spearman');
        % gs error 
    [corr_gs_error_pearson,corr_gs_error_pearson_pval] = corr(aug_gs_error,aug_num_unidentifiable,'Type','Pearson'); 
    [corr_gs_error_spearman,corr_gs_error_spearman_pval] = corr(aug_gs_error,aug_num_unidentifiable,'Type','Spearman');
        % baseline error - gs error
    [corr_diff_error_pearson,corr_diff_error_pearson_pval] = corr(aug_baseline_error - aug_gs_error,aug_num_unidentifiable,'Type','Pearson'); 
    [corr_diff_error_spearman,corr_diff_error_spearman_pval] = corr(aug_baseline_error - aug_gs_error,aug_num_unidentifiable,'Type','Spearman');
        % baseline error - gs error > 0 
    aug_diff_larger_than_zero = (aug_baseline_error - aug_gs_error > 0); 
    [corr_diff_sign_pearson,corr_diff_sign_pearson_pval] = corr(aug_diff_larger_than_zero,aug_num_unidentifiable,'Type','Pearson'); 
    [corr_diff_sign_spearman,corr_diff_sign_spearman_pval] = corr(aug_diff_larger_than_zero,aug_num_unidentifiable,'Type','Spearman');

    corr_struct = struct('rep_corr_nT_pearson',rep_corr_nT_pearson,'rep_corr_nT_spearman',rep_corr_nT_spearman,...
        'rep_corr_cov_pearson',rep_corr_cov_pearson,'rep_corr_cov_spearman',rep_corr_cov_spearman,...
        'avg_corr_nT_pearson',avg_corr_nT_pearson,'avg_corr_nT_spearman',avg_corr_nT_spearman,...
        'avg_corr_cov_pearson',avg_corr_cov_pearson,'avg_corr_cov_spearman',avg_corr_cov_spearman,...
        'rep_corr_param_pearson',rep_corr_param_pearson,'rep_corr_param_spearman',rep_corr_param_spearman,...
        'avg_corr_param_pearson',avg_corr_param_pearson,'avg_corr_param_spearman',avg_corr_param_spearman,...
        'rep_corr_param_sensitivity_pearson',rep_corr_param_sensitivity_pearson,'rep_corr_param_sensitivity_spearman',rep_corr_param_sensitivity_spearman,...
        'avg_corr_param_sensitivity_pearson',avg_corr_param_sensitivity_pearson,'avg_corr_param_sensitivity_spearman',avg_corr_param_sensitivity_spearman,...
        'rep_corr_baseline_error_pearson',rep_corr_baseline_error_pearson,'rep_corr_baseline_error_spearman',rep_corr_baseline_error_spearman,...
        'rep_corr_gs_error_pearson',rep_corr_gs_error_pearson,'rep_corr_gs_error_spearman',rep_corr_gs_error_spearman,...
        'rep_corr_diff_error_pearson',rep_corr_diff_error_pearson,'rep_corr_diff_error_spearman',rep_corr_diff_error_spearman,...
        'rep_corr_diff_sign_pearson',rep_corr_diff_sign_pearson,'rep_corr_diff_sign_spearman',rep_corr_diff_sign_spearman,...
        'corr_baseline_error_pearson',corr_baseline_error_pearson,'corr_baseline_error_spearman',corr_baseline_error_spearman,...
        'corr_gs_error_pearson',corr_gs_error_pearson,'corr_gs_error_spearman',corr_gs_error_spearman,...
        'corr_diff_error_pearson',corr_diff_error_pearson,'corr_diff_error_spearman',corr_diff_error_spearman,...
        'corr_diff_sign_pearson',corr_diff_sign_pearson,'corr_diff_sign_spearman',corr_diff_sign_spearman,...
        'rep_corr_nT_pearson_pval',rep_corr_nT_pearson_pval,'rep_corr_nT_spearman_pval',rep_corr_nT_spearman_pval,...
        'rep_corr_cov_pearson_pval',rep_corr_cov_pearson_pval,'rep_corr_cov_spearman_pval',rep_corr_cov_spearman_pval,...
        'avg_corr_nT_pearson_pval',avg_corr_nT_pearson_pval,'avg_corr_nT_spearman_pval',avg_corr_nT_spearman_pval,...
        'avg_corr_cov_pearson_pval',avg_corr_cov_pearson_pval,'avg_corr_cov_spearman_pval',avg_corr_cov_spearman_pval,...
        'rep_corr_param_pearson_pval',rep_corr_param_pearson_pval,'rep_corr_param_spearman_pval',rep_corr_param_spearman_pval,...
        'avg_corr_param_pearson_pval',avg_corr_param_pearson_pval,'avg_corr_param_spearman_pval',avg_corr_param_spearman_pval,...
        'rep_corr_param_sensitivity_pearson_pval',rep_corr_param_sensitivity_pearson_pval,'rep_corr_param_sensitivity_spearman_pval',rep_corr_param_sensitivity_spearman_pval,...
        'avg_corr_param_sensitivity_pearson_pval',avg_corr_param_sensitivity_pearson_pval,'avg_corr_param_sensitivity_spearman_pval',avg_corr_param_sensitivity_spearman_pval,...
        'corr_baseline_error_pearson_pval',corr_baseline_error_pearson_pval,'corr_baseline_error_spearman_pval',corr_baseline_error_spearman_pval,...
        'corr_gs_error_pearson_pval',corr_gs_error_pearson_pval,'corr_gs_error_spearman_pval',corr_gs_error_spearman_pval,...
        'corr_diff_error_pearson_pval',corr_diff_error_pearson_pval,'corr_diff_error_spearman_pval',corr_diff_error_spearman_pval,...
        'corr_diff_sign_pearson_pval',corr_diff_sign_pearson_pval,'corr_diff_sign_spearman_pval',corr_diff_sign_spearman_pval);


end