function [raw_data_for_heatmap_all,average_raw_all,sd_raw_all] = plot_heatmap(topology_short_name,crossTalk_name,nT_list,cov_list,rep_list)
    
    
    kineticsMap_file = load(sprintf('kineticMaps/%s_allMaps.mat',topology_short_name));
    kineticsMap = kineticsMap_file.allMaps;
    num_reg_networks = length(kineticsMap); 
    
    
    raw_data_for_heatmap_all = cell(1,3); 
    average_raw_all = cell(1,3); 
    sd_raw_all = cell(1,3); 
    for reg_topo_num = 1:3
        figure(reg_topo_num) 
        sgtitle(sprintf('%s%s topology #%d',topology_short_name,crossTalk_name,reg_topo_num))
        figure_save_path = sprintf('plots/%s%s_reg_topo%d.png',topology_short_name,crossTalk_name,reg_topo_num);
        raw_data_for_heatmap = nan(20,length(nT_list) * length(cov_list));
        noise_description = nan(length(nT_list) * length(cov_list),2); 

        for paramSetNum = 161:180 
            count = 1; 
            for nT = nT_list
                for cov = cov_list
                    [~,number_unidentifiable_regNetwork] = count_number_unidentifiable_regNetwork_v2(topology_short_name,crossTalk_name,reg_topo_num,paramSetNum,nT,cov,rep_list);
                    
                    raw_data_for_heatmap(paramSetNum - 160,count) = min(number_unidentifiable_regNetwork); 
                    noise_description(count,:) = [nT,cov];
                    count = count + 1; 
                end
            end
        end

        xlabels = {};
        ylabels = {}; 
        for nT = nT_list
            ylabels{end + 1} = sprintf('nT = %d',nT);
        end
        for cov = cov_list
            xlabels{end + 1} = sprintf('cov = %.2f',cov/100);
        end
        z_score = zscore(raw_data_for_heatmap);
        filtered_raw_data_for_heatmap = raw_data_for_heatmap;
        filtered_raw_data_for_heatmap(~(abs(z_score)<3)) = nan; 
        average_raw_data = mean(filtered_raw_data_for_heatmap,1,'omitnan'); 
        sd_raw_data = std(filtered_raw_data_for_heatmap,0,1,'omitnan');
%         cov_raw_data = sd_raw_data ./ average_raw_data; 
        average_raw_data = reshape(average_raw_data,[length(nT_list),length(cov_list)]);
        sd_raw_data = reshape(sd_raw_data,[length(nT_list),length(cov_list)]);
        h = heatmap(xlabels,ylabels,average_raw_data);
        h.Title = sprintf('ranking with %s',ranking_metric_name);
        h.XLabel = 'Noise Level';
        h.YLabel = 'Sampling Rate';
        raw_data_for_heatmap_all{1,reg_topo_num} = raw_data_for_heatmap;
        average_raw_all{1,reg_topo_num} = average_raw_data;
        sd_raw_all{1,reg_topo_num} = sd_raw_data; 
%         saveas(gcf,figure_save_path)
    end


end