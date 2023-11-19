clear
clc
%This script aims to store base parameters (kinetic parameters for
%mass-action regulatory interactions) in a separate place. 



topology_full_names = {'BranchCrossTalk','BranchNoCrossTalk','Cycle','UDregCrossTalk','UDregNoCrossTalk'};
topology_short_names = {'Branch','Branch','Cycle','UDreg','UDreg'};
regNetworks = {[3,4;4,3;],[3,4;4,2],[3,4;5,2];[3,3;4,4;],[3,2;4,4;],[3,3;5,4;];[2,2;5,3;],[3,2;2,6;],[5,5;4,2;];[2,3;4,8;],[2,3;4,2;],[2,6;4,8;];[2,2;4,3;],[2,2;3,3;],[2,2;4,6;];};

for topo_idx = 1:1:length(topology_full_names) 
    topology_full_name = topology_full_names{topo_idx};
    topology_short_name = topology_short_names{topo_idx};
    for reg_idx = 1:1:size(regNetworks,2)
        regNetwork = regNetworks{topo_idx,reg_idx}; %Extract gold standard non-mass-action regulatory pairs - remove these parameters to get base parameters later
        %load paramsList 
        paramsList_fileName = sprintf('paramsList/paramsList%s_regNetwork_%d.mat',topology_full_name,reg_idx);
        paramsList = load(paramsList_fileName); 
        paramsList = paramsList.paramsList; 
        
        baseParametersList = cell(size(paramsList));
        for i = 1:1:size(paramsList,2) 
            paramsVec = paramsList{1,i};
            baseParameters_matrix = genBaseParameters_matrixForm(paramsVec,topology_short_name,regNetwork);
            baseParametersList{1,i} = baseParameters_matrix;
        end
        save(sprintf('paramsList/baseParametersList%s_regNetwork_%d.mat',topology_full_name,reg_idx),'baseParametersList');
    
    
    end
end






