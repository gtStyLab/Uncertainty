function [timeVec, concMatrix, fluxMatrix] = solveOdeMm(topology_short_name,kineticsMap,kineticsMap_indicator,tStart,tEnd,nT,x0,paramsVec)
    
    % Extract information from inputs 
    model_info = get_model_info(topology_short_name);
    stoichMatrix = model_info.stoichMatrix;
    if strcmp(topology_short_name,'Branch')
        % 'Use and burn' for stoich coeff
        stoichMatrix(3,5) = -1 * paramsVec(1);
        stoichMatrix(4,5) = -1 * paramsVec(2); 
        paramsVec = paramsVec(3:end); 
    end

    numMet = size(stoichMatrix,1);
    numFlux = size(stoichMatrix,2); 
    num_mass_action_reg = sum(sum(stoichMatrix < 0)); 
    mass_action_kineticsMap = kineticsMap(1:num_mass_action_reg,:); 
    reg_kineticsMap = kineticsMap(num_mass_action_reg+1:end,:); 

    % Convert paramsVec into a structure corresponding to MM equations 
    params_struct = convertOdeParams(topology_short_name,stoichMatrix,paramsVec,reg_kineticsMap,kineticsMap_indicator);

    options=odeset('NonNegative',ones(size(x0')));
    [timeVec,concMatrix] = ode15s_timeLimited(@(t,x)fRHS(t,x,topology_short_name,params_struct,reg_kineticsMap,kineticsMap_indicator),linspace(tStart,tEnd,nT+1),x0',options);
% %     [timeVec,concMatrix] = ode15s(@(t,x)fRHS(t,x,params),linspace(tStart,tEnd,nT+1),x0');
    
    fluxMatrix = zeros(length(timeVec),numFlux + numMet);
    for k = 1:length(timeVec)
        fluxMatrix(k,1:numFlux) = calcFluxes(timeVec(k),concMatrix(k,:)',topology_short_name,params_struct,reg_kineticsMap,kineticsMap_indicator)';
        fluxMatrix(k,numFlux + 1:numFlux + numMet) = fRHS(timeVec(k),concMatrix(k,:)',topology_short_name,params_struct,reg_kineticsMap,kineticsMap_indicator)';
    end
    
end
function v = calcFluxes(~,x,topology_short_name,params,reg_kineticsMap,kineticsMap_indicator)
    for flux = 1:size(params.S,2)
        if isequal(flux,1)
            v(flux,1) = params.v1; 
        else
            % Find the mass-action metabolite
            ma_reg_met = find(params.S(:,flux) < 0); 
            if length(ma_reg_met) > 2 % When involving multiple subtrate, which within the scope of the project, should just be two
                error('Error in stoichiometry matrix. More than two substrates are involved in one reaction')
            else
                if ~ismember(flux,reg_kineticsMap(:,2))% If the flux is not involved in regulatory interactions 
                    if length(ma_reg_met) == 2 % Two substrate reaction without regulation
                        eval(sprintf('v(flux,1) = params.v%dM * x(%d) * x(%d) / (params.v%dK + params.v%d%d*x(%d) + params.v%d%d*x(%d) + x(%d)*x(%d));',...
                        flux,ma_reg_met(1),ma_reg_met(2),flux,flux,ma_reg_met(1),ma_reg_met(1),flux,ma_reg_met(2),ma_reg_met(2),ma_reg_met(1),ma_reg_met(2)))
                    else % One-substrate reaction without regulation
                        eval(sprintf('v(flux,1) = params.v%dM * x(%d) / (params.v%dK + x(%d));',flux,ma_reg_met,flux,ma_reg_met));
                    end
                else
                    % Find corresponding regulating metabolite &
                    % activation/inhibition  
                    reg_met = reg_kineticsMap(reg_kineticsMap(:,2) == flux,1); 
                    reg_effect = kineticsMap_indicator(reg_kineticsMap(:,2) == flux); 
                    if length(ma_reg_met) == 2 % Two-substrate reaction with regulatory interaction 
                        % This should only apply to Branch or MultiS
                        % pathway 
                        % Use the simpler form for activation/inhibition
                        % for this 
                        if reg_effect > 0 % Activation 
                            eval(sprintf('v(flux,1) = params.v%dM * x(%d) * x(%d) / ((params.v%dA + 1/x(%d)) * (params.v%dK + params.v%d%d*x(%d) + params.v%d%d*x(%d) + x(%d)*x(%d))) ;',...
                                flux,ma_reg_met(1),ma_reg_met(2),flux,reg_met,flux,flux,ma_reg_met(1),ma_reg_met(1),flux,ma_reg_met(2),ma_reg_met(2),ma_reg_met(1),ma_reg_met(2)))
                        else % Inhibition 
                            eval(sprintf('v(flux,1) = params.v%dM * x(%d) * x(%d) / ((params.v%dI + x(%d))  * (params.v%dK + params.v%d%d*x(%d) + params.v%d%d*x(%d) + x(%d)*x(%d))) ;',...
                                flux,ma_reg_met(1),ma_reg_met(2),flux,reg_met,flux,flux,ma_reg_met(1),ma_reg_met(1),flux,ma_reg_met(2),ma_reg_met(2),ma_reg_met(1),ma_reg_met(2)))
                        end
                    else % One-substrate reaction with regulation 
                        if reg_effect > 0 
                            % Activation 
                            if strcmp(topology_short_name,'Branch')
                                % Branch topology uses a simpler form 
                                eval(sprintf('v(flux,1) = params.v%dM * x(%d) / ((params.v%dA + 1/x(%d)) * (params.v%dK + x(%d)));',...
                                    flux,ma_reg_met,flux,reg_met,flux,ma_reg_met))
                            else
                                % More complex form 

                                eval(sprintf('v(flux,1) = params.v%dM * x(%d) / (params.v%dK * ((1 + x(%d) / params.v%dA) / (1 + params.v%dbeta * x(%d) / (params.v%dalpha * params.v%dA)))+ x(%d) * ((1 + x(%d) / (params.v%dalpha * params.v%dA)) / (1 + params.v%dbeta * x(%d) / (params.v%dalpha * params.v%dA))));',...
                                    flux,ma_reg_met,flux,reg_met,flux,flux,reg_met,flux,flux,ma_reg_met,reg_met,flux,flux,flux,reg_met,flux,flux))
                            end

                        else
                            % Inhibition 
                            if strcmp(topology_short_name,'UDreg')
                                eval(sprintf('v(flux,1) = params.v%dM * x(%d) / ((1 + x(%d) / params.v%dI) * (params.v%dK + x(%d)));',...
                                    flux,ma_reg_met,reg_met,flux,flux,ma_reg_met))
                            else
                                eval(sprintf('v(flux,1) = params.v%dM * x(%d) / ((params.v%dI + x(%d))   * (params.v%dK + x(%d)));',...
                                    flux,ma_reg_met,flux,reg_met,flux,ma_reg_met))
                            end
                        end
                    end

                end
            end
        end

    end
end

function xdot = fRHS(~,x,topology_short_name,params,reg_kineticsMap,kineticsMap_indicator)

    
    % Bad Things can happen with the math when we allow negative x
    % (Which isn't physically relevant, anyways)
    % xMin = 1e-4;
    % x(x<xMin) = xMin;
    v = calcFluxes([],x,topology_short_name,params,reg_kineticsMap,kineticsMap_indicator); 
    xdot = params.S*v; 

end

    
function params = convertOdeParams(topology_short_name,stoichMatrix,paramsVec,reg_kineticsMap,kineticsMap_indicator)

    params.v1 = 1;
    param_idx = 1;
    for flux = 2:size(stoichMatrix,2)
        eval(sprintf('params.v%dM = paramsVec(param_idx);',flux));
        param_idx = param_idx + 1;
        eval(sprintf('params.v%dK = paramsVec(param_idx);',flux));
        param_idx = param_idx + 1;  
    end
    if strcmp(topology_short_name,'Branch')
        params.v53 = paramsVec(param_idx);
        param_idx = param_idx + 1;
        params.v54 = paramsVec(param_idx); 
        param_idx = param_idx + 1;
        for reg_pair_idx = 1:size(reg_kineticsMap,1)
            reg_flux = reg_kineticsMap(reg_pair_idx,2); 
            reg_indicator = kineticsMap_indicator(reg_pair_idx); 
            if reg_indicator > 0
                eval(sprintf('params.v%dA = paramsVec(param_idx);',reg_flux)); 
            else
                eval(sprintf('params.v%dI = paramsVec(param_idx);',reg_flux));
            end
            param_idx = param_idx + 1;
        end
    else
        for reg_pair_idx = 1:size(reg_kineticsMap,1)
            reg_flux = reg_kineticsMap(reg_pair_idx,2); 
            reg_indicator = kineticsMap_indicator(reg_pair_idx); 
            if reg_indicator > 0
                eval(sprintf('params.v%dA = paramsVec(param_idx);',reg_flux)); 
                param_idx = param_idx + 1;
                eval(sprintf('params.v%dalpha = paramsVec(param_idx);',reg_flux)); 
                param_idx = param_idx + 1;
                eval(sprintf('params.v%dbeta = paramsVec(param_idx);',reg_flux)); 
                
                
            else
                eval(sprintf('params.v%dI = paramsVec(param_idx);',reg_flux));
            end
            param_idx = param_idx + 1;
        end
    end

    params.S = stoichMatrix; 
    
    
end
