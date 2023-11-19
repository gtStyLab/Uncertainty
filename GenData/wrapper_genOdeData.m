function datasetFileName = wrapper_genOdeData(paramSetNum,paramsVec,topology_full_name,regNetwork_idx,kineticsMap,stoichMatrix,a_indices,perturb_flux,perturb_size)
% The job of this function is to generate noiseless, hi-res data from the
% ODE model. For our noisy cases, we'll feed the results from this script
% into a second function to generate numReps noisy data at a given
% combination of CoV and lo-res nT values. 
    
    % Eh let's just hardcode the stem for this stuff here
    datasetFileName = sprintf('GenData/BSTData/%s_regNetwork_%d/BST_%s_k-%03d_hiRes.mat',topology_full_name,regNetwork_idx,topology_full_name,paramSetNum);

    % We want hi-res version of our time-courses available:
    nT = 1000;

    % For this function, we're going to just hard code stuff
    tStart = 0;
    tEnd = 10;

    % Initialize our structure
    numMetabs = size(stoichMatrix,1);
    numFlux = size(stoichMatrix,2);
    odeDataset.tStart = tStart;
    odeDataset.tEnd = tEnd;
    odeDataset.nT = nT;
    if length(topology_full_name) >= 6 && strcmp(topology_full_name(1:6),'Branch')
        odeDataset.paramsVec = paramsVec(3:end-numMetabs+1);
        a_indices = a_indices - 2 * ones(size(a_indices));
    else
        odeDataset.paramsVec = paramsVec(1:end-numMetabs+1);
    end
    odeDataset.x0 = paramsVec(end-numMetabs+1:end);
    
        
    powerLawKineticsParams = convertModelKineticsParams(odeDataset.paramsVec,kineticsMap,a_indices,size(stoichMatrix,1));
    [timeVec,concMatrix] = SolveBranchedPathwayBSTODE(powerLawKineticsParams,stoichMatrix,odeDataset.tStart,odeDataset.tEnd,odeDataset.nT,odeDataset.x0); 
    
    fluxMatrix = nan(size(concMatrix,1),numFlux);
    for time_idx = 1:1:length(timeVec)
         fluxMatrix(time_idx,:) = FluxFormulation(concMatrix(time_idx,:),powerLawKineticsParams,stoichMatrix);
    end
    odeDataset.fluxMatrix = fluxMatrix;
    odeDataset.timeVec = timeVec;
    odeDataset.concMatrix = concMatrix;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%        
    odeDataset.fluxMatrix(end,:) = [];
    odeDataset.fluxTimeVec = odeDataset.timeVec(1:end-1)+0.5*diff(odeDataset.timeVec(1:2));

    odeDataset.perturbFlux = perturb_flux;
    odeDataset.perturbSize = perturb_size;
    odeDataset.kineticsMap = kineticsMap;
    % Let's actually export this now
    save(datasetFileName,'-struct','odeDataset');

    % For reference, in case it turns out I want the '-struct' part later
% %         save(sprintf('odeData_k%d.mat',k),'-struct','singleDataStruct')


end