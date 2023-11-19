function modelInfo = get_model_info(topology_name)
    %Gives stoichMatrix for different topologies 
    %Topology name should be {'Branch','Cycle','UDreg'}
    
    switch topology_name
        case 'Branch'
            modelInfo.stoichMatrix = [1  -1   0  -1   0;
                                      0   1  -1   0   0;
                                      0   0   1   0  -0.6;
                                      0   0   0   1  -0.4;
                                      0   0   0   0   1;];
        case 'Cycle'
            modelInfo.stoichMatrix = [1  -1   0   0   0  0   1   0;
                                      0   1  -1  -1   0  0   0   0;
                                      0   0   1   0  -1  0   0   0;
                                      0   0   0   0   1  -1  0  -1;
                                      0   0   0   0   0  1  -1   0;];
        case 'UDreg'
            modelInfo.stoichMatrix = [ 1 -1 -1  0  0  0  0  0;
                                       0  1  0 -1  0  0  0 -1;
                                       0  0  1  0 -1 -1  0  0;
                                       0  0  0  0  0  1 -1  0;];
           

            
    end
    
    






end
