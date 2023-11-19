clear
clc


% wrapper_fitAllMaps(topology_idx,crossTalk_idx,reg_topo_num,paramSetNum,noise_idx)
topology_name_list = {'Branch','UDreg','Cycle'};
crossTalk_list = {'CrossTalk','NoCrossTalk',''};
% nT_list = [50,20,10];
% cov_list = [5,15,25];
% missing_metabolite_idx_list_all = {[0,2,4],[0,2,3],0};
% noise_string_list = {'noiseless','low','medium','high'};
missing_metabolite_idx_list = [1,4]; 
nT = 100; 
cov = 5; 
% 
% % %Generate individual job submission files 
% for topology_idx = 2:2
%     topology_name = topology_name_list{topology_idx};
%     % missing_metabolite_idx_list = missing_metabolite_idx_list_all{topology_idx};
%     if isequal(topology_idx,3)
%         crossTalk_idx_range = [3,3];
%     else 
%         crossTalk_idx_range = [1,2];
%     end
%     for crossTalk_idx = crossTalk_idx_range(1):crossTalk_idx_range(2)
%         crossTalk_name = crossTalk_list{crossTalk_idx};
%         for missing_metabolite_idx = missing_metabolite_idx_list
%             for reg_topo_num = 1:1:3
%                 for paramSetNum = 161:180
%                     % for nT = nT_list
%                     %     for cov = cov_list
%                             for rep = 1:3
%                                 command = fopen(sprintf('jobSubmission/fitAllModels_%s%s_regNetwork_%d_paramSetNum-%d_nT-%d_cov-%03d_rep-%03d_missing_met-%d.txt',topology_name,crossTalk_name,reg_topo_num,paramSetNum,nT,cov,rep,missing_metabolite_idx),'w');
%                                 fprintf(command,'#!/bin/bash \n #SBATCH -JfitAllModels \n #SBATCH --account=gts-mstyczynski6-joe \n #SBATCH -N1 -n1 \n #SBATCH -t720 \n #SBATCH -qinferno #SBATCH -oReport-%%j.out \n cd $SLURM_SUBMIT_DIR \n module load matlab');
%                                 fprintf(command,'\n srun matlab -nosplash -nodisplay -singleCompThread -r " wrapper_fitAllMaps(%d,%d,%d,%d,%d,%d,%d,%d)"',topology_idx,crossTalk_idx,reg_topo_num,paramSetNum,nT,cov,rep,missing_metabolite_idx);
%                                 fclose('all');
%                             end
%                     %     end
%                     % end
%                 end
%             end
%         end
%     end
% end

%Generate master job submission files (for copy-paste into terminal) 
% close all
for topology_idx = 2:2
    topology_name = topology_name_list{topology_idx};
    % missing_metabolite_idx_list = missing_metabolite_idx_list_all{topology_idx};
    if isequal(topology_idx,3)
        crossTalk_idx_range = [3,3];
    else 
        crossTalk_idx_range = [1,2];
    end
    for crossTalk_idx = crossTalk_idx_range(1):crossTalk_idx_range(2)
        crossTalk_name = crossTalk_list{crossTalk_idx};
        command = fopen(sprintf('masterJobSubmission/masterJobSubmission_%s%s_more_missing_lowNoise_final_round.txt',topology_name,crossTalk_name),'w');
        for missing_metabolite_idx = missing_metabolite_idx_list
            for reg_topo_num = 1:1:3
                for paramSetNum = 161:180
                    % for nT = nT_list
                    %     for cov = cov_list
                            for rep = 1:3
                                result_fileName = sprintf('partial_fitting_results/%s%s_regNetwork_%d_paramSetNum-%d_nT-%d_cov-%03d_rep-%03d_missing_met-%d.mat',topology_name,crossTalk_name,reg_topo_num,paramSetNum,nT,cov,rep,missing_metabolite_idx);
                                damage_flag = 0; 
                                try 
                                    load(result_fileName);
                                catch
                                    damage_flag = 1;
                                end
                                if ~isfile(result_fileName) || damage_flag
                                    fprintf(command,'\n sbatch -A gts-mstyczynski6 -q inferno -N1 --ntasks-per-node=1 --mem-per-cpu=5G -t 48:00:00 jobSubmission/fitAllModels_%s%s_regNetwork_%d_paramSetNum-%d_nT-%d_cov-%03d_rep-%03d_missing_met-%d.txt',topology_name,crossTalk_name,reg_topo_num,paramSetNum,nT,cov,rep,missing_metabolite_idx);
                                end
                            end
                    %     end
                    % end
                end
            end
        end
    end


end













