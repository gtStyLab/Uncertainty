function [index,dynamicsParamsOptimal] = fitBstBranch(odeTimeVec,odeConcMatrix,odeFluxMatrix,kineticsMap,weightVector,stoichVars,paramBounds)

    if size(odeFluxMatrix,1) == size(odeConcMatrix,1)-1
        odeConcMatrix(end,:) = [];
        odeTimeVec(end) = [];
    end

    % Set up stuff for the specific problem
    nT = length(odeTimeVec);
    numMet = size(odeConcMatrix,2);
    numFlux = size(odeFluxMatrix,2);
    
    %formulate A matrix. Each block of this matrix contains all controller
    %metabolites for a certain flux
    index = [1]; %index for a_i values that later require exp transform
    for n = 2:1:numFlux
        A{n-1} = [ones(nT,1)];
        position = [find(kineticsMap(:,2)==n)];
        if ~isempty(position)
            numController = size(position,1);
            index = [index (index(end)+numController+1)];
            for j = 1:1:numController
                A{n-1} = [A{n-1},log(odeConcMatrix(1:nT,kineticsMap(position(j,1))))];
            end
        end
    end
   b = reshape(log(odeFluxMatrix(:,2:numFlux)),[numel(odeFluxMatrix(:,2:numFlux)),1]);
   a = blkdiag(A{1}, A{2}, A{3}, A{4});
   x = a\b;
   index = index(1:end-1);
    
   x(index) = exp(x(index));
   
   
   dynamicsParamsOptimal =x;
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
%     % For BST, we can take linearize the system to directly fit the parameters.
%     % X = [log(a2); b21; log(a3); b32; b3r4; log(a4); b41; b4r3; log(a5); b53; b54]
%     
%     
%     % Note: This form assumes the particular BST toy system structure
%     A1 = [ones(nT,1), log(odeConcMatrix(1:nT,1))];
%     A2 = [ones(nT,1), log(odeConcMatrix(1:nT,2)), log(odeConcMatrix(1:nT,4))];
%     A3 = [ones(nT,1), log(odeConcMatrix(1:nT,1)), log(odeConcMatrix(1:nT,3))];
%     A4 = [ones(nT,1), log(odeConcMatrix(1:nT,3)), log(odeConcMatrix(1:nT,4))];
%     A = blkdiag(A1, A2, A3, A4);
%     b = reshape(log(odeFluxMatrix(:,2:5)),[numel(odeFluxMatrix(:,2:5)),1]);
% 
%     % Solve for linearized best fit
%     x = A\b;
%     
%     % Switch a terms out of log-space
%     x([1 3 6 9]) = exp(x([1 3 6 9]));
%     
%     dynamicsParamsOptimal = x;
%  
% end
% 
