%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Subfunction - Root - Depth       calculate root depth  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%REFERENCES   
function[bbx]=Max_Rootdepth(bbx,NL,KT,TT)
%{
Inputs:
    NL: number of soil layers
Outputs:
    bbx: An array indicate if there are roots in corresponding soil
    layers (index from 1-end means soil layers from bottom to surface)
Todo:
    1. Input bbx, KT and TT can be removed.
    2. Initial value of root length can be set as an input parameters.
%}
    
    global DeltZ Tot_Depth R_depth
    % BR = 10:1:650; %% [gC /m^2 PFT]
    % rroot =  0.5*1e-3 ; % 3.3*1e-4 ;%% [0.5-6 *10^-3] [m] root radius
    %%% OUTPUTS 
      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%% Root lenth distribution %%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    R_depth=350; %inital root length
    Elmn_Lnth=0;   
    for ML=1:NL
        Elmn_Lnth=Elmn_Lnth+DeltZ(ML);
        if Elmn_Lnth<Tot_Depth-R_depth
            bbx(ML)=0;
        elseif Elmn_Lnth>=Tot_Depth-R_depth && Elmn_Lnth<=Tot_Depth-5 %&& TT(ML)>0
            bbx(ML)=1;
        else
            bbx(ML)=0;
        end
    end
end 