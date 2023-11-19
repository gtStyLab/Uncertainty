clear
clc
% 
% topology_names = {'Branch','Cycle','UDreg'};
% Branch_CrossTalk_regNetworks = {[3,4;4,3;],[3,4;4,2],[3,4;5,2]};
% Branch_noCrossTalk_regNetworks = {[3,3;4,4;],[3,2;4,4;],[3,3;5,4;]};
% Cycle_regNetworks = {[2,2;5,3;],[3,2;2,6;],[5,5;4,2;]};
% UDreg_CrossTalk_regNetworks = {[2,3;4,8;],[2,3;4,2;],[2,6;4,8;]};
% UDreg_noCrossTalk_regNetworks = {[2,2;4,3;],[2,2;3,3;],[2,2;4,6;]};

topology_full_names = {'BranchCrossTalk','BranchNoCrossTalk','Cycle','UDregCrossTalk','UDregNoCrossTalk'};
topology_short_names = {'Branch','Branch','Cycle','UDreg','UDreg'};
regNetworks = {[3,4;4,3;],[3,4;4,2],[3,4;5,2];[3,3;4,4;],[3,2;4,4;],[3,3;5,4;];[2,2;5,3;],[3,2;2,6;],[5,5;4,2;];[2,3;4,8;],[2,3;4,2;],[2,6;4,8;];[2,2;4,3;],[2,2;3,3;],[2,2;4,6;];};

%%%%%%%%%%select a topology
% topology_name = topology_names{2};
% %%%%%%%%%select regulatory network cell
% reg_networks = Cycle_regNetworks;
% topology_full_name = 'Cycle';
% %%%%%%%%%Select regulatory network numbers 
% regNetwork_label = 3; 
% %%%%%%%%%%

for topology_idx = 1:1:5
    topology_full_name = topology_full_names{topology_idx};
    topology_short_name = topology_short_names{topology_idx};
    for reg_network_idx = 2:3
        reg_networks = regNetworks{topology_idx,reg_network_idx};
        wrapper_genRandParams(topology_full_name,topology_short_name,...
            reg_networks,reg_network_idx)
    
    
    
    end
end



% save(sprintf('paramsList/paramsList%s_regNetwork_%d.mat',topology_full_name,regNetwork_label),'paramsList');







