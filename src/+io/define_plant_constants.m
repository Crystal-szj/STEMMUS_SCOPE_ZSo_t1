git function ParaPlant = define_plant_constants()
% define parameters used in plant hydraulic pathway
% Output:
%     ParaPlant: A structure contains all of parameters used in plant hydraulic pathway.

    %% ----------------------- root growth ----------------------------
    ParaPlant.C2B            = 2;         %(g biomass / gC)
    ParaPlant.B2C            = 0.488;     % ratio of biomass to carbon [gC / g biomass]
    ParaPlant.rootRadius     = 1.5*1e-3;  % root radius [m] (2.9e-4 in CLM5),  (0.5-6e-3 m)in STEMMUS_SCOPE_GMD
    ParaPlant.rootDensity    = 250*1000;  % Root density Jackson et al., 1997 [gDM / m^3] 
    pa2m                     = 1/9810;    % 1Pa = rho g h = 1000 kg/m3 * 9.81 m/s2 * m = 9810 m
    %% ----------------------- Plant hydraulics -----------------------
%     ParaPlant.psi50_sunleaf  = ;        % parameter of plant hydraulic pathway [MPa]
%     ParaPlant.psi50_shdleaf  = ;        % parameter of plant hydraulic pathway [MPa]
%     ParaPlant.ck_sunleaf     = ;        % parameter of plant hydraulic pathway [MPa]
%     ParaPlant.ck_shdleaf     = ;        % parameter of plant hydraulic pathway [MPa]

    ParaPlant.p50Leaf        = 5.0968e-11;  % 0.5./1e6*pa2m;       % parameter of plant hydraulic pathway [m] 0.5MPa refer to Kennedy 2019.
    ParaPlant.p50Stem        = -1.7839e-10; % -1.75./1e6*pa2m;     % parameter of plant hydraulic pathway [m] -1.75MPa refer to Kennedy 2019.
    ParaPlant.p50Root        = -1.7839e-10; % -1.75./1e6*pa2m;     % parameter of plant hydraulic pathway [m] -1.75MPa refer to Kennedy 2019.
    
    ParaPlant.ckLeaf         = 2.95;      % parameter of plant hydraulic pathway
    ParaPlant.ckStem         = 2.95;      % parameter of plant hydraulic pathway [unitless]
    ParaPlant.ckRoot         = 2.95;      % parameter of plant hydraulic pathway [unitless]

    ParaPlant.Krootmax          =2e-9;       % root conductivity [m s-1]
    ParaPlant.Kstemmax          =2e-8;       % stem conductivity [m s-1]
    ParaPlant.Kleafmax          =2e-7;       % maximum leaf conductance [s-1]
    ParaPlant.rootLateralLength = 0.25;      % average coarse root length [m]

    
end

