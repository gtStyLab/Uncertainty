function [t,xData] = SolveBranchedPathwayBSTODE(powerLawKineticsParams,MBParams,tStart,tEnd,nT,InitialCondition) 
%The function takes in system of power law kinetics parameters, branched
%pathway model mass action topology, timespan which involves step size
    timeStep = (tEnd - tStart)/nT;
    tspan = tStart:timeStep:tEnd;
    options=odeset('NonNegative',ones(size(InitialCondition)));
    [t,xData] = ode15s_timeLimited(@(t,x) odefcn(t,x,powerLawKineticsParams,MBParams), tspan, InitialCondition,options);

    function dxdt = odefcn(t,x,powerLawKineticsParams,MBParams)
    %set up ODE using power law kinetics
        v = FluxFormulation(x,powerLawKineticsParams,MBParams);
        dxdt = MBParams * v;
    end
end
%  powerLawKineticsParams = [1    0    0    0    0    0;
%                              0.8   0.5  0    0    0    0;
%                              1     0    0.8  0    0.2  0;
%                              0.5   0.4  0    -0.8 0    0;
%                              0.5   0    0    0.5  0.8  0;];
% MBParams = [1 -1  0 -1 0;
%                0  1 -1  0 0;
%                0  0  1  0 -0.6;
%                0  0  0  1 -0.4;
%                0  0  0  0  1;];  
