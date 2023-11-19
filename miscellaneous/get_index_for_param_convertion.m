function index = get_index_for_param_convertion(stoichMatrix,kineticsMap)
    % Get the list of index for kinetic constant parameters in the parameter vector 

    index = nan(size(stoichMatrix,2),1); % The number of kinetic constant parameters = # fluxes 
    index(1) = 1; 
    for i = 2:size(stoichMatrix,2)
            position = [find(kineticsMap(:,2)==i-1)];
            if ~isempty(position)
                numController = size(position,1);
                index(i) = index(i-1)+numController+1;
            else
                index(i) = index(i-1) + 1; 
            end
    end





end