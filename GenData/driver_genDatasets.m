clc; clear; close all;

topology_full_names = {'BranchCrossTalk','BranchNoCrossTalk','Cycle','UDregCrossTalk','UDregNoCrossTalk'};
topology_short_names = {'Branch','Branch','Cycle','UDreg','UDreg'};
regNetworks = {[3,4;4,3;],[3,4;4,2],[3,4;5,2];[3,3;4,4;],[3,2;4,4;],[3,3;5,4;];[2,2;5,3;],[3,2;2,6;],[5,5;4,2;];[2,3;4,8;],[2,3;4,2;],[2,6;4,8;];[2,2;4,3;],[2,2;3,3;],[2,2;4,6;];};

params_load_prefix = 'paramsList/paramsList';
params_load_suffix = {'','_fluxPerturbed','_randIC'};
%                161-180  1-80
% 81-160 


% for topology_idx = 1:1:length(topology_full_names)
%     topology_full_name = topology_full_names{topology_idx};
%     topology_short_name = topology_short_names{topology_idx};
%     
%     model_info = get_model_info(topology_short_name);
%     stoichMatrix = model_info.stoichMatrix;
%     numFlux = size(stoichMatrix,2);
%     numMet = size(stoichMatrix,1);
%     kineticsMap_baseline = genMassActionKineticsMap(stoichMatrix);
% 
%     for suffix_idx = 2:2%1:1:length(params_load_suffix)
%         suffix = params_load_suffix{suffix_idx};
%         
%         %hardcode paramSetNum assignment 
%         if strcmp(suffix,'')
%             starting_paramSetNum = 160;
%         elseif strcmp(suffix,'_fluxPerturbed')
%             starting_paramSetNum = 0;
%         elseif strcmp(suffix,'_randIC')
%             starting_paramSetNum = 80;
%         end
%         
%         for regNetwork_idx = 1:1:3
%             % 1) generate my hi-res datasets
%             %Get the parameters 
%             paramsList_storage = load(sprintf('%s%s_regNetwork_%d%s',params_load_prefix,topology_full_name,regNetwork_idx,suffix));
%             paramsList = paramsList_storage.paramsList;
%                 %if flux perturbed, we need to also load WT params so we
%                 %know the perturbed flux and the peturbation size
%             if strcmp(suffix,'_fluxPerturbed')
%                 paramsList_WT_storage = load(sprintf('%s%s_regNetwork_%d',params_load_prefix,topology_full_name,regNetwork_idx));
%                 paramsList_WT = paramsList_WT_storage.paramsList;
%             end
% 
%             %Construct full kineticsMap 
%             kineticsMap = [kineticsMap_baseline;regNetworks{topology_idx,regNetwork_idx}];
%             
%             %Get the indices for each a, correspond to flux
%             a_indices = nan(numFlux,1);
%             for a_index_idx = 1:1:numFlux
%                 if isequal(a_index_idx,1) && strcmp(topology_short_name,'Branch')
%                     a_indices(1) = 3;
%                 elseif isequal(a_index_idx,1) && ~strcmp(topology_short_name,'Branch')
%                     a_indices(1) = 1;
%                 else
%                     regulator_mets = find(kineticsMap(:,2)==a_index_idx-1);
%                     a_indices(a_index_idx) = a_indices(a_index_idx-1) + 1 + length(regulator_mets);
%                 end
%             end
%             
%             %generate data
%             for i = 1:1:size(paramsList,1)
%                 for j = 1:1:size(paramsList,2)
%                     paramsVec = paramsList{i,j};
%                     if strcmp(suffix,'_fluxPerturbed')
%                         paramsVec_WT = paramsList_WT{1,j};
%                         perturbSizes_allFlux = paramsVec ./ paramsVec_WT;
%                         perturb_param_idx = find(~(perturbSizes_allFlux==1));
%                         perturb_size = perturbSizes_allFlux(perturb_param_idx);
%                         perturb_flux = find(a_indices == perturb_param_idx);
%                     else
%                         perturb_size = 1;
%                         perturb_flux = 1;
%                     end
%                     if strcmp(topology_short_name,'Branch')
%                             stoichMatrix(3,5) = -paramsVec(1);
%                             stoichMatrix(4,5) = -paramsVec(2);
%                             kinetic_paramsVec = paramsVec(3:end); 
%                     end
%           
%                     paramSetNum = starting_paramSetNum + (i-1) * size(paramsList,2) + j;
%                     dataSetFileNames{paramSetNum} = wrapper_genOdeData(paramSetNum,paramsVec,topology_full_name,regNetwork_idx,kineticsMap,stoichMatrix,a_indices,perturb_flux,perturb_size);
%                 end
%             end
% 
%         end
%     end
% end
            % % break
            % 2) Generate my noisy datasets, over various nT and CoV combinations
            % nTList = [100,200,500,1000];
            nTList = [10,20,50];
            covList = [0.05 0.15 0.25];
            numSets = 3;

            % % nTList = [15 50];
            % % covList = [0.05 0.15 0.25];
            % % numSets = 2;
for topology_idx = 1:length(topology_full_names)
    topology_full_name = topology_full_names{topology_idx};
    topology_short_name = topology_short_names{topology_idx};
    for regNetwork_idx = 1:1:3
        % a. Get the hi-res dataset file name
        for i = 161:1:180
            hiResDataFileName = sprintf('BSTData/%s_regNetwork_%d/BST_%s_k-%03d_hiRes.mat',topology_full_name,regNetwork_idx,topology_full_name,i);
        % hiResDataFileName = [sprintf('branchNoCrossTalk/branchNoCrossTalkMM/branch_k-%02d_hiRes.mat',i)];

        % b. Loop nT values
            for nT = nTList

                % c. Loop CoV Values
                for cov = covList
                    % Generate my noisy datasets
                    wrapper_genNoisyData(hiResDataFileName,nT,cov,numSets);
                end
            end
        end
    end
end