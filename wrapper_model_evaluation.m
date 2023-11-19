function errorMetrics = wrapper_model_evaluation(experimental_data,current_modelStruct,imputed_missing_idx)

        

    fitted_powerLawKineticsParams = current_modelStruct.fitted_powerLawKineticsParams;
    ODEstruct = current_modelStruct.ODEstruct;
    num_parameters = current_modelStruct.num_fitted_parameters;
    if current_modelStruct.best_fval < 10000
        SSR = 0; 
        MAE = 0;
        MAPE = 0; 
        MASE = 0; 
        RMSD = 0; 
        num_datapoints = 0;
        for dataset_idx = 1:1:length(experimental_data)
            
            adjusted_powerLawKineticsParams = fitted_powerLawKineticsParams;
            adjusted_powerLawKineticsParams(experimental_data(dataset_idx).perturbFlux,1) = experimental_data(dataset_idx).perturbSize * adjusted_powerLawKineticsParams(experimental_data(dataset_idx).perturbFlux,1);
            [~,model_data] = SolveBranchedPathwayBSTODE(adjusted_powerLawKineticsParams,ODEstruct.MBParams,ODEstruct.tStart,ODEstruct.tEnd,ODEstruct.nT,ODEstruct.x0);
            if isempty(imputed_missing_idx)
                predicted_data = model_data;
                observed_data = experimental_data(dataset_idx).concMatrix;
            else
                predicted_data = [model_data(:,1:imputed_missing_idx-1),model_data(:,imputed_missing_idx+1:end)];
                observed_data = [experimental_data(dataset_idx).concMatrix(:,1:imputed_missing_idx-1),...
                    experimental_data(dataset_idx).concMatrix(:,imputed_missing_idx+1:end)];
            end
            num_datapoints = num_datapoints + numel(observed_data);
            if isequal(size(predicted_data,1),ODEstruct.nT + 1) 
                SSR = SSR + calcSSR(predicted_data,observed_data);
                MAE = MAE + calcMAE(predicted_data,observed_data);
                MAPE = MAPE + calcMAPE(predicted_data,observed_data);
                MASE = MASE + calcMASE(predicted_data,observed_data);
                RMSD = RMSD + calcRMSD(predicted_data,observed_data);
            else
                SSR = SSR + 1e08; 
                MAE = MAE + 1e08; 
                MAPE = MAPE + 1e08; 
                MASE = MASE + 1e08; 
                RMSD = RMSD + 1e08; 
            end
        end
        errorMetrics.AIC = calcAIC(SSR,num_datapoints,num_parameters);
        errorMetrics.SSR = SSR;
        errorMetrics.MAE = MAE;
        errorMetrics.MAPE = MAPE;
        errorMetrics.MASE = MASE;
        errorMetrics.RMSD = RMSD;
    else
        errorMetrics.SSR = 1e08;
        errorMetrics.MAE = 1e08;
        errorMetrics.MAPE = 1e08;
        errorMetrics.MASE = 1e08;
        errorMetrics.RMSD = 1e08;
        errorMetrics.AIC = 1000;
    end




                
                
                

end