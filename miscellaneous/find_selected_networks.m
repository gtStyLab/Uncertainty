function [selected_kineticsMaps,selected_AICs] = find_selected_networks(fileName)
    results = load(fileName);
    models = results.temp_storage_baseline_models;
    %     AICs = results.temp_storage_AICs;
    kineticsMap_baseline = results.kineticsMap_baseline;

    for depth_idx = 1:1:length(models)
        stored_models_atDepth = models{depth_idx,1};
        if ~isempty(stored_models_atDepth)
            for chosen_model_idx = 1:1:length(stored_models_atDepth)
                chosen_model = stored_models_atDepth(chosen_model_idx);
                selected_kineticsMaps{depth_idx,chosen_model_idx} = chosen_model.kineticsMap(size(kineticsMap_baseline,1)+1:end,:);
                selected_AICs{depth_idx,chosen_model_idx} = chosen_model.AIC;
            end
        end
    end
    
end