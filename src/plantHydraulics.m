%% Initialize all elements

%% Compute conductance attentuation for each segment

%% compute 

%% vulnerablility curve
function f = plc(x,p,c,level,plc_method)
% Output 
%   f             : fraction of maximum conductance 
%
% Input
%   x             : water potential input
%   p             : index for pft
%   c             : index for column
%   plc_method    :
%   plc           : attenuated conductance [0:1] 0 = no flow

f = 2.^((-x / psi50).^ck)
end
%{
Constants:
    RHO_WATER   : the density of water
    G           : gravitational acceleration
Input:
    psiSoil     : Soil water potential
    kSoil       : soil hydraulic conductance
    
Output:
    psiRoot     : Root water potential



%}