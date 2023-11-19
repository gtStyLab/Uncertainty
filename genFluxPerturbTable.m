function AllFluxPerturbTable = genFluxPerturbTable(numFlux,WTparamSetNumInit)
    AllFluxPerturbTable  = cell(20,1);
    for i = 1:1:20
        %total number of possible flux perturbation is 2*(numFlux-1)+1
        %2 difference sizes of perturbation for each of the fluxes except
        %influx plus WT 
        perturbIndex = 1:1:1+2*(numFlux-1);
        %Pre-assign
        perturbedFlux = zeros(size(perturbIndex));
        perturbSize = zeros(size(perturbIndex));
        perturbedParamSetNum = zeros(size(perturbIndex));
        %Assign WT values
        perturbedFlux(1) = 1;
        perturbSize(1) = 1;
        perturbedParamSetNum(1) = WTparamSetNumInit;
        
        
        for j = 2:2:length(perturbIndex)
            perturbedFlux(j) = j/2 + 1;
            perturbedFlux(j+1) = j/2 + 1;
            perturbSize(j) = 2;
            perturbSize(j+1) = 0.5;
            perturbedParamSetNum(j) = (i-1)*8 + j-1;
            perturbedParamSetNum(j+1) = (i-1)*8 + j; 
        end
    
        fluxPerturbTable = table(perturbIndex,perturbedFlux,perturbSize,perturbedParamSetNum);
        AllFluxPerturbTable{i,1} = fluxPerturbTable;
    end
    
%     save('AllFluxPerturbTable_branchNoCrossTalk','AllFluxPerturbTable');
%     save('AllFluxPerturbTable_Cycle','AllFluxPerturbTable');
    save('AllFluxPerturbTable_Determined','AllFluxPerturbTable');
%     save('AllFluxPerturbTable_UDreg','AllFluxPerturbTable');





end