% Ksoil = Ksoil; (Output of calc_rsoil)

function [kSoil2Root, sai, rai] = calPlantHydraulicConductance(Ks, Ksoil, ParaPlant, RootProperties, soilDepth, lai, sfactor)
%function [kSoil2Root, Kroot2stem, Kstem2leaf] = calPlantHydraulicConductance(Ks, Ksoil, ParaPlant, RootProperties, soilDepth, lai, sfactor)
% Calculation of plant hydraulic conductance among plant components

% Input:
%     Ks : saturated soil hydraulic conductivity [m s-1]
%     Ksoil: unsaturated soil hydraulic conductivity [m s-1]
%     ParaPlant: A structure contains plant parameters
%     RootProperties: A structure contains root properties
%     soilDepth: An array contains soil depth of each soil layer
%     lai: An array contains LAI
%     sfactor: soil water stress factor, WSF

% Output:
%     kSoil2Root: hydraulic conductance from soil to root
%     sai       : stem area index [m2/m2]
%     rai       : root area index [m2/m2]

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
    rootFrac = RootProperties.frac;
    
    %% =================== reverse soil variables ==============
    KsoilR = flipud(Ksoil);
    KsR = flipud(Ks);
    %% =================== root area index =====================
    % new fine-root carbon to new foliage carbon ratio
    froot2leaf=0.3*3*exp(-0.15*lai)/(exp(-0.15*lai)+2*sfactor);
    if froot2leaf<0.15
        froot2leaf=0.15;
    end
    froot2leaf=max(0.001, froot2leaf);
    
    % stem area index
    sai = 0.1./lai;  
    
    % root area index
    % rai = (sai + lai) * f_{root-shoot} * r_i (Kennedy et al. 2019 JAMES)
    rai = (sai + lai).* rootFrac .* froot2leaf;
    
    %% =================== soil to root conductance =====================
    soilConductance = min(KsR , KsoilR ./ rootSpac);
    
    phwsfRoot = PlantHydralicsStressFractor(psiSoil,p50Root, ckRoot);
    
    rootConductance = phwsfRoot .* rai .*Krootmax./(rootLateralLength + soilDepth);
    
    soilConductance = max(soilConductance, 1e-16);
    rootConductance = max(rootConductance, 1e-16);
    kSoil2Root = 1./(1./soilConductance + 1./rootConductance);
    
%     %% =================== root to stem conductance =====================
%     
%     phwsfStem = PlantHydraulicsStressFractor(psiRoot, p50Stem, ckStem);
%     stemConductance = 
%     %% =================== stem to leaf conductance =====================
    
    
    
    
    
end