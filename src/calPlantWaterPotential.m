% Ksoil = Ksoil; (Output of calc_rsoil)

function [psiLeaf, psiStem, psiRoot] = calPlantWaterPotential(Trans,Ks, Ksoil, ParaPlant, RootProperties, DeltZ, lai, sfactor, psiSoil, canopyHeight)
% Calculation of plant hydraulic conductance among plant components

% Input:
%     Trans: Transpiration [m/s]
%     Ks : saturated soil hydraulic conductivity [m s-1]
%     Ksoil: unsaturated soil hydraulic conductivity [m s-1]
%     ParaPlant: A structure contains plant parameters
%     RootProperties: A structure contains root properties
%     DeltZ: An array contains soil thickness of each soil layer from
%            bottom to surface.
%     lai: An array contains LAI
%     sfactor: soil water stress factor, WSF

% Output:
%     kSoil2Root: hydraulic conductance from soil to root
%     sai       : stem area index [m2/m2]
%     rai       : root area index [m2/m2]

    %% +++++++++++++++++++++++++ PHS ++++++++++++++++++++++++++++++++
    % ----------------------------------------------------------------
    % qSoil2Root = kSoil2Root * (psiSoil - psiRoot - DeltaZ)
    %                                 qSoil2Root          
    % psiRoot = psiSoil - DeltaZ -  ---------------
    %                                 kSoil2Root
    %

    % qRoot2Stem = kRoot2Stem * SAI * (psiRoot - psiStem - canopyHeight)
    %                                         qRoot2Stem          
    % psiStem = psiRoot - canopyHeight -  -----------------
    %                                       kRoot2Stem * SAI
    %        

    % qStem2Leaf = kStem2Leaf * LAI * (psiLeaf - psiStem)
    %                           qStem2Leaf        
    % psiLeaf = psiStem  -  ---------------------
    %                           kStem2Leaf *LAI
    %        
    % ---------------------------------------------------------------- 
    
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
    
    rootSpac = RootProperties.spac;    
    rootFrac = RootProperties.frac;
    
    % Q_soil2root = Q_root2stem = Q_stem2leaf = Transpiration
    qSoil2Root = Trans;  % unit [m/s]
    qRoot2Stem = Trans;
    qStem2Leaf = Trans;    
    
    numSoilLayer = length(Ksoil);
%     %% =================== reverse soil variables ==============
%     KsoilR = flipud(Ksoil);
%     KsR = flipud(Ks);
    %% =================== root area index =====================
    % new fine-root carbon to new foliage carbon ratio
    froot2leaf=0.3*3*exp(-0.15*lai)/(exp(-0.15*lai)+2*sfactor);
    if froot2leaf<0.15
        froot2leaf=0.15;
    end
    froot2leaf=max(0.001, froot2leaf);
    
    % stem area index
    sai = 0.1.*lai;  
    
    % root area index
    % rai = (sai + lai) * f_{root-shoot} * r_i (Kennedy et al. 2019 JAMES)
    rai = (sai + lai).* rootFrac .* froot2leaf;
    
    %% =================== soil to root conductance =====================
    soilConductance = min(Ks' , Ksoil) ./100 ./ rootSpac ; % 100 is a transfer factor from [cm/s] to [m/s]
    
    phwsfRoot = PlantHydraulicsStressFactor(psiSoil, p50Root, ckRoot);
    
    rootConductance = phwsfRoot .* rai .* Krootmax./(rootLateralLength + DeltZ./100); % unit [m/s]
    
    soilConductance = max(soilConductance, 1e-16);
    rootConductance = max(rootConductance, 1e-16);
    kSoil2Root = 1./(1./soilConductance + 1./rootConductance); % unit [m/s]
    
    %% =================== root water potential ========================
    % Q_soil2root = Q_root2stem = Q_stem2leaf = Transpiration
    if (abs(sum(kSoil2Root,1)) == 0)
        % for saturated condition
        psiRoot = sum((psiSoil - DeltZ./100)) / numSoilLayer;
    else
        % for unsaturated condition
        psiRoot = sum( ((psiSoil - DeltZ./100) - qSoil2Root)) / sum(kSoil2Root);
    end

    %% =================== stem water potential ========================
    phwsfStem = PlantHydraulicsStressFactor(psiRoot, p50Stem, ckStem);

    if ( sai>0 && phwsfStem >0 ) 
        % stem hydraulic conductance
        kRoot2Stem = ParaPlant.Kstemmax ./ canopyHeight .* phwsfStem; 
        psiStem = psiRoot - canopyHeight - qRoot2Stem ./sai ./ kRoot2Stem;
    else
        psiStem = psiRoot - canopyHeight; 
    end
    
    %% ===================== leaf water potential ====================
    phwsfLeaf = PlantHydraulicsStressFactor(psiStem, p50Leaf, ckLeaf);
    if (lai>0 && phwsfLeaf>0)
        % leaf hydraulic conductance
        kStem2Leaf = ParaPlant.Kleafmax .* phwsfLeaf;

        % leaf water potential
        psiLeaf = psiStem - qStem2Leaf ./ lai ./kStem2Leaf;
    else
        psiLeaf = psiStem;
    end
end