function result_analysis(result_struct_fileName,option)
    % Given an organized result file with number of unidentifiable
    % structures, perform various analysis and visualization 

    % result_struct_fileName: string for organized result file 
    % option:
        % remove_outlier: whether to remove outliers using z-score > 3 whenever taking average

    %% Result organization
    result_struct_file = load(result_struct_fileName); 
    nT_list = result_struct_file.nT_list;
    cov_list = result_struct_file.cov_list; 
    result_struct = result_struct_file.param_correlation_struct; 
    result_cell = result_struct_file.all_cells; 
    parameter_labels = result_struct_file.parameter_labels;
    num_parameters = length(parameter_labels);
    num_unidentifiable_structures = cell2mat(result_struct_file.num_unidentifiable_array); 
    nT_array = cell2mat(result_struct_file.nT_array);
    cov_array = cell2mat(result_struct_file.cov_array); 
    % metadata information 
    topology_short_name = result_struct_file.topology_short_name; 
    crossTalk_name = result_struct_file.crossTalk_name; 

        %% Correlation with nT and cov 
        % for all 20 parameters sets
    if contains(result_struct_fileName,'Cycle') || contains(result_struct_fileName,'missing')
        num_reg_topo = 3;
    else
        num_reg_topo = 6;
    end
    num_parameter_set = 20; 
    num_noise_set = length(nT_list) * length(cov_list); 
        % #unidentifiable vs. nT within each parameter set 
    nT_correlation_mat = nan(num_parameter_set,num_reg_topo);
    cov_correlation_mat = nan(num_parameter_set,num_reg_topo);
    topo_nT_correlation_mat = nan(1,num_reg_topo); 
    topo_cov_correlation_mat = nan(1,num_reg_topo); 
    for i = 1:num_reg_topo
        topo_start_idx = num_noise_set * num_parameter_set * (i - 1) + 1; 
        topo_end_idx = num_noise_set * num_parameter_set * i;
        filtered_topo_num_unidentifiable_structures = num_unidentifiable_structures(topo_start_idx:topo_end_idx); 
        filtered_topo_nT = nT_array(topo_start_idx:topo_end_idx); 
        filtered_topo_cov = cov_array(topo_start_idx:topo_end_idx); 
        topo_nT_correlation_mat(1,i) = corr(filtered_topo_nT,filtered_topo_num_unidentifiable_structures,'Type','Spearman');
        topo_cov_correlation_mat(1,i) = corr(filtered_topo_cov,filtered_topo_num_unidentifiable_structures,'Type','Spearman');
        for j = 1:num_parameter_set
            start_idx = num_noise_set * num_parameter_set * (i - 1) + num_noise_set * (j - 1) + 1; 
            end_idx = num_noise_set * num_parameter_set * (i - 1) + num_noise_set * j; 
            filtered_num_unidentifiable_structures = num_unidentifiable_structures(start_idx:end_idx); 
            filtered_nT = nT_array(start_idx:end_idx); 
            filtered_cov = cov_array(start_idx:end_idx); 
            nT_correlation_mat(j,i) = corr(filtered_nT,filtered_num_unidentifiable_structures,'Type','Spearman');
            cov_correlation_mat(j,i) = corr(filtered_cov,filtered_num_unidentifiable_structures,'Type','Spearman');
        end
    end

    ylabels_12 = cell(num_parameter_set,1); 
    for paramSetNum = 1:num_parameter_set
        ylabels_12{paramSetNum,1} = sprintf('ParamSet #%d',paramSetNum);
    end
    xlabels_cov = cell(length(nT_list),1); 
    xlabels_nT = cell(length(cov_list),1); 
    xlabels_topo_12 = cell(num_reg_topo,1);
    for nT_idx = 1:length(nT_list)
        xlabels_nT{nT_idx,1} = sprintf('nT = %d',nT_list(nT_idx));
    end
    for cov_idx = 1:length(cov_list)
        xlabels_cov{cov_idx,1} = sprintf('cov = %.2f',cov_list(cov_idx)/100);
    end
    for topo_idx = 1:num_reg_topo
        xlabels_topo_12{topo_idx,1} = sprintf('topology #%d',topo_idx);
    end

    f1 = figure(1); % plot correlation matrix for cov to parameter set 
    h_cov_correlation = heatmap(xlabels_topo_12,ylabels_12,cov_correlation_mat);
    h_cov_correlation.Title = 'Spearman correlation between # unidentifiable structures and cov for each parameter set';
    h_cov_correlation.Colormap = colormap(jet);
    
    f2 = figure(2); % plot correlation matrix for nT to parameter set 
    h_nT_correlation = heatmap(xlabels_topo_12,ylabels_12,nT_correlation_mat);
    h_nT_correlation.Title = 'Spearman correlation between # unidentifiable structures and nT for each parameter set';
    h_nT_correlation.Colormap = colormap(jet);
    
    % breakdown for each parameter set
    f3 = figure(3); % plot correlation matrix for nT and CoV to topology 
    h_topo_correlation = heatmap(xlabels_topo_12,{'nT','cov'},[topo_nT_correlation_mat;topo_cov_correlation_mat]);
    h_topo_correlation.Title = 'Spearman correlation between # unidentifiable structures and cov for each regulatory topology';
    h_topo_correlation.Colormap = colormap(jet);


    %% Noise heatmap (Averaged across 20 parameter sets, one for each regulatory network)
    % 
    raw_data_for_heatmap_all = cell(num_reg_topo,1);
    %%%%%% For incomplete branch result file (won't need this if
    %have missing metbaolite data result for BranchNoCrossTalk%%%%%%%
    if contains(result_struct_fileName,'missing')
        noise_heatmap_raw_data_length = length(result_struct)/2; 
    else
        noise_heatmap_raw_data_length = length(result_struct);
    end
    %%%%%%%%%%%%%%
    for noise_heatmap_idx = 1:noise_heatmap_raw_data_length
        reg_topo_idx = ceil(noise_heatmap_idx./240); 
        if isempty(raw_data_for_heatmap_all{reg_topo_idx,1})
            raw_data_for_heatmap_all{reg_topo_idx,1} = nan(20,length(nT_list) * length(cov_list));
        end
        noise_heatmap_nT = result_struct(noise_heatmap_idx).nT; 
        noise_heatmap_cov = result_struct(noise_heatmap_idx).cov; 
        noise_heatmap_nT_idx = find(nT_list==noise_heatmap_nT);
        noise_heatmap_cov_idx = find(cov_list==noise_heatmap_cov); 
        noise_heatmap_num_unidentifiable = result_struct(noise_heatmap_idx).num_unidentifiable; 
        noise_heatmap_paramSetNum = result_struct(noise_heatmap_idx).paramSetNum; 
        raw_data_for_heatmap_all{reg_topo_idx,1}(noise_heatmap_paramSetNum-160,(noise_heatmap_nT_idx-1) * length(cov_list)...
            + noise_heatmap_cov_idx) = noise_heatmap_num_unidentifiable; 
    end

    xlabels = {};
    ylabels = {}; 
    for nT = nT_list
        ylabels{end + 1} = sprintf('nT = %d',nT);
    end
    for cov = cov_list
        xlabels{end + 1} = sprintf('cov = %.2f',cov/100);
    end

    for noise_heatmap_j = 1:num_reg_topo
        figure(3 + noise_heatmap_j) 
        raw_data_for_heatmap = raw_data_for_heatmap_all{noise_heatmap_j,1}; 
        sgtitle(sprintf('%s%s topology #%d',topology_short_name,crossTalk_name,noise_heatmap_j))
        if option.remove_outlier
            processed_raw_data_for_heatmap = remove_outlier(raw_data_for_heatmap,1); 
        else 
            processed_raw_data_for_heatmap = raw_data_for_heatmap; 
        end
        average_raw_data = mean(processed_raw_data_for_heatmap,1,'omitnan'); 
        average_raw_data = reshape(average_raw_data,[length(nT_list),length(cov_list)]);
        h = heatmap(xlabels,ylabels,average_raw_data);
    
        h.XLabel = 'Noise Level';
        h.YLabel = 'Sampling Rate';
    end

    %% Correlation with parameter values 
    correlation_matrix = nan(length(nT_list) * length(cov_list),num_parameters);
    number_unidentifiable = [result_struct.num_unidentifiable]'; 
    param_idx_count = 1; 
    
    for column_idx = (size(result_cell,2)-num_parameters+1):size(result_cell,2) 
        selected_parameter = result_cell(:,column_idx);
        for noise_idx = 1:length(nT_list) * length(cov_list)
            % extract only data relevant to the speicific noise level 
            filtered_structureNumber = number_unidentifiable(noise_idx:length(nT_list) * length(cov_list):end);
            filtered_parameters = cell2mat(selected_parameter(noise_idx:length(nT_list) * length(cov_list):end));
            %%%%%%%
            filtered_parameters = filtered_parameters(~isnan(filtered_parameters)); 
            %%%%%%%
            if ~(all(filtered_parameters==0) || all(filtered_parameters==1))
                remove_idx = find(filtered_parameters==0); 
                keep_idx = setdiff(1:length(filtered_parameters),remove_idx);
                filtered_parameters = filtered_parameters(keep_idx); 
                %%%%%%Hardcode for missing metabolite for now (without
                %%%%%%nocrosstalk result 
                structure_keep_idx = keep_idx(keep_idx <= 60); 
                %%%%%%%%%%%%%%
                filtered_structureNumber = filtered_structureNumber(structure_keep_idx); 
                correlation_matrix(noise_idx,param_idx_count) = corr(abs(filtered_parameters),filtered_structureNumber,'Type','Spearman');
            end
        end
        param_idx_count = param_idx_count + 1; 
    end

    noise_labels = cell(length(nT_list) * length(cov_list),1); 
    noise_count = 1; 
    for nT = nT_list
        for cov = cov_list
            noise_labels{noise_count,1} = sprintf('nT=%d,cov=%.2f',nT,cov/100);
            noise_count = noise_count + 1; 
        end
    end
    figure(3 + num_reg_topo + 1)
    xlabels = parameter_labels;
    h = heatmap(xlabels,noise_labels,correlation_matrix);
    h.Colormap = colormap(jet);
    h.Title = 'Spearman correlation: #unidentifiable models';


    %% Other correlations 




    

    
end