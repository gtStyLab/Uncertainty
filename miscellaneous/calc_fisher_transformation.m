function fisher_transformed = calc_fisher_transformation(x)
    fisher_transformed = 0.5 * log((1 + x) ./ (1 - x)); 


end