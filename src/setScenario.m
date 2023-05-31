function [biochemical, gsOption, phwsfMethod] = setScenario(gsOption, phsOption)
%{
    This function is used to set the stomatal conductance scheme and plant
    hydraulic pathway option.

    input:
        gsOption: a string indicate which stomatal conductance will be used
        phsOption: a number indicate whether use plant hydraulic pathway

    output:
        biochemical: a string, indicate which function will be used
        gsOption: a string indicate gs option
        phsOption: a number indicate if open the plant hydraulic pathway.
                   1 for CLM5,
                   2 for ED2,
                   3 for PHS
                   
%}

    %% Set scenario
    if strcmp(gsOption ,'Vc_gs_b')                            % Vc = Vcmax * WSF ; b = BallBerrySlope
        biochemical = @biochemical_Vc_gs_b;
    elseif strcmp(gsOption,'Vcmax_gs_bw')                    % Vcmax = Vcmax    ; bw = BallBerrySlope * WSF
        biochemical = @biochemical_Vcmax_gs_bw;
    elseif strcmp(gsOption, 'Vc_gs_bw')                       % Vc = Vcmax * WSF ; bw = BallBerrySlope * WSF
        biochemical = @biochemical_Vc_gs_bw;
    elseif strcmp(gsOption, 'Vc_gs_m')                        % Vc = Vcmax * WSF ; m = MedlynSlope
        biochemical = @biochemical_Vc_gs_m;
    elseif strcmp(gsOption,'Vcmax_gs_mw')                   % Vcmax = Vcmax    ; mw = MedlynSlope * WSF
        biochemical = @biochemical_Vcmax_gs_mw;
    elseif strcmp(gsOption,'Vc_gs_mw')                       % Vc = Vcmax * WSF ; mw = gs_slope * WSF
        biochemical = @biochemical_Vc_gs_mw;
    else
        gsOption = 'Vc_gs_b';
        biochemical = @biochemical_Vc_gs_b;
    end
    
    %% PHS setting
    if phsOption      % if phsOption is true, PHS open. Set plant water stress method.
        switch phsOption
            case 1
                phwsfMethod = 'CLM5';
            case 2
                phwsfMethod = 'ED2';
            case 3
                phwsfMethod = 'PHS';
            otherwise
                fprintf('Please set phsOption\n');
        end
    else  % if phsOption is false, PHS close.
        phwsfMethod = 'WSF';
        fprintf('PHS close, use soil water stress factor\n')
    end

end