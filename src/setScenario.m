function biochemical = setScenario(Scenario)

    % Set scenario
    if strcmp(Scenario ,'Vc_gs_b')                            % Vc = Vcmax * WSF ; b = BallBerrySlope
        biochemical = @biochemical_Vc_gs_b;
    elseif strcmp(Scenario,'Vcmax_gs_bw')                    % Vcmax = Vcmax    ; bw = BallBerrySlope * WSF
        biochemical = @biochemical_Vcmax_gs_bw;
    elseif strcmp(Scenario, 'Vc_gs_bw')                       % Vc = Vcmax * WSF ; bw = BallBerrySlope * WSF
        biochemical = @biochemical_Vc_gs_bw;
    elseif strcmp(Scenario, 'Vc_gs_m')                        % Vc = Vcmax * WSF ; m = MedlynSlope
        biochemical = @biochemical_Vc_gs_m;
    elseif strcmp(Scenario,'Vcmax_gs_mw')                   % Vcmax = Vcmax    ; mw = MedlynSlope * WSF
        biochemical = @biochemical_Vcmax_gs_mw;
    elseif strcmp(Scenario,'Vc_gs_mw')                       % Vc = Vcmax * WSF ; mw = gs_slope * WSF
        biochemical = @biochemical_Vc_gs_mw;
    else
        Scenario = 'Vc_gs_b';
        biochemical = @biochemical_Vc_gs_b;
    end
end