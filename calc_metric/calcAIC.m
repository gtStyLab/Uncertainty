function AIC = calcAIC(SSR,num_datapoints,num_parameters)

   %factor = 2 * p_m * (p_m + 1) / (N - p_m -1);
    AIC = num_datapoints * log(SSR/num_datapoints) + 2*num_parameters;

end