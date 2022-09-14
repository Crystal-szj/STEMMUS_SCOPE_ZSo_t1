function ParaPlant = define_plant_constants()
% define parameters used in plant hydraulic pathway
% Output:
%     ParaPlant: A structure contains all of parameters used in plant hydraulic pathway.

    %% ----------------------- root growth ----------------------------
    ParaPlant.C2B            = 2;         %(g biomass / gC)
    ParaPlant.B2C            = 0.488;     % ratio of biomass to carbon [gC / g biomass]
    ParaPlant.rootRadius     = 2.9e-4;    % root radius [m] (from CLM5), 1.5*1e-3 (0.5-6e-3 m)in STEMMUS_SCOPE_GMD
    ParaPlant.rootDensity    = 250*1000;  % Root density Jackson et al., 1997 [gDM / m^3] 

    %% ----------------------- Plant hydraulics -----------------------
%     ParaPlant.psi50_sunleaf  = ;        % parameter of plant hydraulic pathway [MPa]
%     ParaPlant.psi50_shdleaf  = ;        % parameter of plant hydraulic pathway [MPa]
%     ParaPlant.ck_sunleaf     = ;        % parameter of plant hydraulic pathway [MPa]
%     ParaPlant.ck_shdleaf     = ;        % parameter of plant hydraulic pathway [MPa]
    ParaPlant.psi50Leaf      = 0.5;       % parameter of plant hydraulic pathway [MPa]
    ParaPlant.psi50Stem      = -1.75;     % parameter of plant hydraulic pathway [MPa]
    ParaPlant.psi50Root      = -1.75;     % parameter of plant hydraulic pathway [MPa]
    
    ParaPlant.ckLeaf         = 2.95;      % parameter of plant hydraulic pathway
    ParaPlant.ckStem         = 2.95;      % parameter of plant hydraulic pathway [unitless]
    ParaPlant.ckRoot         = 2.95;      % parameter of plant hydraulic pathway [unitless]

    ParaPlant.Krootmax          =2e-9;       % root conductivity [m s-1]
    ParaPlant.Kstemmax          =2e-8;       % stem conductivity [m s-1]
    ParaPlant.Kleafmax          =2e-7;       % maximum leaf conductance [s-1]
    ParaPlant.rootLateralLength = 0.25;

    
end

