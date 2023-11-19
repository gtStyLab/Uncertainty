function processed_matrix = remove_outlier(matrix,direction)
    z_score = zscore(matrix,0,direction); 
    processed_matrix = matrix; 
    processed_matrix(z_score > 3) = nan; 

end