% Ksoil = Ksoil; (Output of calc_rsoil)

function [Ksoil2root, Kroot2stem, Kstem2leaf] = calPlantHydraulicConductance(Ks, Ksoil, ParaPlant, RootProperties, soilDepth)
% Calculation of plant hydraulic conductance among plant components

% Input:
%     Ks : saturated soil hydraulic conductivity [m s-1]
%     Ksoil: unsaturated soil hydraulic conductivity [m s-1]
%     ParaPlant: A structure contains plant parameters
%     RootProperties: A structure contains root properties
%     soilDepth: An array contains soil depth of each soil layer

% Output:
%     Ksoil2root: hydraulic conductance from soil to root
%     Kroot2stem: hydraulic conductance from root to stem
%     Kstem2leaf: hydrualic conductance from stem to leaf

    %% =============== Input variables ================
    Krootmax = ParaPlant.Krootmax;
    Kstemmax = ParaPlant.Kstemmax;
    Kleafmax = ParaPlant.Kleafmax;
    p50Root  = ParaPlant.p50Root;
    p50Stem  = ParaPlant.p50Stem;
    p50Leaf  = ParaPlant.p50Leaf;
    ckRoot = ParaPlant.ckRoot;
    ckStem = ParaPlant.ckStem;
    ckLeaf = ParaPlant.ckLeaf;
    rootLateralLength = ParaPlant.rootLateralLength;
    
    rootSpac = RootProperties.Spac;    
    
    %% =================== reverse soil variables ==============
    KsoilR = flipud(Ksoil);
    KsR = flipud(Ks);
    
    %% =================== soil to root conductance =====================
    soilConductance = min(KsR , KsoilR ./ rootSpac);
    
    phwsfRoot = PlantHydralicsStressFractor(psiSoil,p50Root, ckRoot);
    # rai
    rootConductance = phwsfRoot .* rai .*Krootmax./(rootLateralLength + soilDepth);
    
    soilConductance = max(soilConductance, 1e-16);
    rootConductance = max(rootConductance, 1e-16);
    Ksoil2root = 1./(1./soilConductance + 1./rootConductance);
    
    %% =================== root to stem conductance =====================
    
    
    %% =================== stem to leaf conductance =====================
    
    
    
    
    
end