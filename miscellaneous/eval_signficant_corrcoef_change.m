function [p_val_mat,sig_change_mat] = eval_signficant_corrcoef_change(corrcoef_mat,sample_size,num_test)
    % INPUT
    % corrcoef_mat: m * n matrix of spearman correlation coefficients;
    % assumes that first row is the baseline 
    % OUTPUT
    % sig_change_mat: m * n matrix representing whether the change in
    % correlation coefficient is significant 

    fisher_transformed_corrcoef = calc_fisher_transformation(corrcoef_mat); 
    % stat_sig_difference = 2 * 1.96 /sqrt(sample_size - 3); % Using 95% CI
    p_val_mat = nan(size(corrcoef_mat,1) - 1,size(corrcoef_mat,2));
    for row_idx = 2:size(corrcoef_mat,1)
        for col_idx = 1:size(corrcoef_mat,2)
            difference_z = (fisher_transformed_corrcoef(row_idx,col_idx) - fisher_transformed_corrcoef(1,col_idx)) / sqrt((1/(sample_size(1,col_idx)-3)+(1/(sample_size(1,col_idx)-3))));
            p_val_mat(row_idx - 1,col_idx) = 2 * (1 - normcdf(abs(difference_z))); 
        end
    end
    
    % Decide statistical significance using alpha = 0.05 & Bonferroni correction 
    sig_change_mat = p_val_mat <= 0.05/num_test; 

end