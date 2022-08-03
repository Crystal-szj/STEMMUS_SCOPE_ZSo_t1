function [PSIs,rsss,rrr,rxx] = calc_rsoil(Rl,DeltZ,Ks,Theta_s,Theta_r,Theta_LL,bbx,m,n,Alpha)
DeltZ0=DeltZ';
l=0.5;
SMC=Theta_LL(1:54,2);
Se  = (SMC-Theta_r')./(Theta_s'-Theta_r');
Ksoil=Ks'.*Se.^l.*(1-(1-Se.^(1./m')).^(m')).^2;
PSIs=-((Se.^(-1./m')-1).^(1./n'))./(Alpha*100)'.*bbx;
% -------------------------------------------------
%                    1
%   r_s = ------------------ * delta d
%            B * K_soil * L_v
% 
%                       2 * pi
%   B   =  --------------------------------
%           ln[(pi * R_D)^(-0.5) / r_{root}]
%         
% 100 is a transfer factor from m to cm.
% bbx indicates the layers that have roots.
% L_v in GMD paper is Rl in the code. It is the root length density in a
%     specific soil layer
% Rl  : units cm.
% -------------------------------------------------
rsss          = 1./Ksoil./Rl./DeltZ0/2/pi.*log((pi*Rl).^(-0.5)/(0.5*1e-3))*100.*bbx; % KL_h is the hydraulic conductivity, m s-1;VR is the root length density, m m-3;Ks is saturation conductivty;
rxx           = 1*1e10*DeltZ0/0.5/0.22./Rl/100.*bbx; % Delta_z*j is the depth of the layer
rrr           = 4*1e11*(Theta_s'./SMC)./Rl./(DeltZ0/100).*bbx;

