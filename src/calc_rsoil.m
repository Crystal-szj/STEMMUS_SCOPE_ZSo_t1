function [psiSoil,Ksoil, rsss,rrr,rxx] = calc_rsoil(Rl,DeltZ,Ks,Theta_s,Theta_r,Theta_LL,bbx,m,n,Alpha, NL)
% calculation of soil water potential and soil, root and xylem resistance.
% Input:
%     Rl      : root length density [m/m3]
%     DeltZ   : thickness of soil layers (bottom - surface) [cm]
%     Ks      : saturated hydraulic conductance [cm/s]
%     Theta_s : saturated soil water contents
%     Theta_r : residual water contents
%     Theta_LL:
%     bbx     : An array indicate if this layer has roots (bottom - surface)
%     m       : empirical parameter
%     n       : empirical parameter
%     Alpha   : empirical parameter
%    
% Output:
%     PSIs    : soil water potential (bottom - surface)
%     Ksoil   : soil hydraulic conductance [cm/s] (bottom - surface)
%     rsss    : soil resistance
%     rrr     : root resistance
%     rxx     : xylem resistance




DeltZ0=DeltZ';
l=0.5;          % empirical parameter
SMC=Theta_LL(1:NL,2);
Se  = (SMC-Theta_r')./(Theta_s'-Theta_r');
Ksoil=Ks'.*Se.^l.*(1-(1-Se.^(1./m')).^(m')).^2;
psiSoil=-((Se.^(-1./m')-1).^(1./n'))./(Alpha*100)'.*bbx;
% -------------------------------------------------
%                        1
%   r_s = -------------------------------- 
%            B * K_soil * L_v * delta d
% 
%                       2 * pi
%   B   =  --------------------------------
%           ln[(pi * L_v)^(-0.5) / r_root]
%         
% 100 is a transfer factor of DeltaZ0 from cm to m.
% bbx indicates the layers that have roots.
% L_v in GMD paper is Rl in the code. It is the root length density in a
%     specific soil layer
% Rl  : units m/m3.
% -------------------------------------------------
rsss          = 1./Ksoil./Rl./DeltZ0/2/pi.*log((pi*Rl).^(-0.5)/(0.5*1e-3))*100.*bbx; % KL_h is the hydraulic conductivity, m s-1;VR is the root length density, m m-3;Ks is saturation conductivty;
rxx           = 1*1e10*DeltZ0/0.5/0.22./Rl/100.*bbx; % Delta_z*j is the depth of the layer
rrr           = 4*1e11*(Theta_s'./SMC)./Rl./(DeltZ0/100).*bbx;

