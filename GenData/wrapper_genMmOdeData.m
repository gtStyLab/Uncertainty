function datasetFileName = wrapper_genMmOdeData(paramSetNum,paramsVec,topology_full_name,topology_short_name,regNetwork_idx,stoichMatrix)
% The job of this function is to generate noiseless, hi-res data from the
% ODE model. For our noisy cases, we'll feed the results from this script
% into a second function to generate numReps noisy data at a given
% combination of CoV and lo-res nT values. 
    
    % Eh let's just hardcode the stem for this stuff here
    datasetFileName = sprintf('GenData/MMData/%s_regNetwork_%d_MMsampled/MM_%s_k-%03d_hiRes.mat',topology_full_name,regNetwork_idx,topology_full_name,paramSetNum);

    % We want hi-res version of our time-courses available:
    nT = 1000;

    % For this function, we're going to just hard code stuff
    tStart = 0;
    tEnd = 10;

    % Initialize our structure
    numMetabs = size(stoichMatrix,1);
    numFlux = size(stoichMatrix,2);

    
    switch topology_short_name
        case 'Branch'
            [timeVec, concMatrix, fluxMatrix] = solveOdeMmBranch(tStart,tEnd,nT,paramsVec(end-numMetabs + 1:end),paramsVec(1:end-numMetabs)); 
        case 'UDreg'
            [timeVec, concMatrix, fluxMatrix] = solveOdeMmUDreg(tStart,tEnd,nT,paramsVec(end-numMetabs + 1:end),paramsVec(1:end-numMetabs)); 
        case 'Cycle'
            [timeVec, concMatrix, fluxMatrix] = solveOdeMmCycle(tStart,tEnd,nT,paramsVec(end-numMetabs + 1:end),paramsVec(1:end-numMetabs)); 
    end
    
    odeDataset.fluxMatrix = fluxMatrix;
    odeDataset.timeVec = timeVec;
    odeDataset.concMatrix = concMatrix;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%        
    odeDataset.fluxMatrix(end,:) = [];
    odeDataset.fluxTimeVec = odeDataset.timeVec(1:end-1)+0.5*diff(odeDataset.timeVec(1:2));

    % Let's actually export this now
    save(datasetFileName,'-struct','odeDataset');

    % For reference, in case it turns out I want the '-struct' part later
% %         save(sprintf('odeData_k%d.mat',k),'-struct','singleDataStruct')


end