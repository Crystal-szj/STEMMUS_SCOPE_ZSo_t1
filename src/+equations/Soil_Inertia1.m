function [GAM] = Soil_Inertia1(SMC)
global theta_s0
% soil inertia method by Murray and Verhoef (2007), and the soil inertial (GAM) is used to calculate the soil heat flux

% Input:
%   SMC: soil moisture [m3 m-3]
% 
% Output:
%   GAM: soil thermal inertia [J m-2 K-1 s-0.5]
% 
% Reference:
%   T. Murray and A. Verhoef, 2007, Agriculture and Forest meteorology
%   Moving towards a more mechanistic approach in the determination of soil heat flux from remote measurements: I. A universal approach to calculate thermal inertia
%   DOI: https://doi.org/10.1016/j.agrformet.2007.07.004


theta_s = theta_s0; % (saturated water content, m3/m3)
Sr = SMC/theta_s;

% fss = 0.54; % (sand fraction at HTC site based on laboratory experiment)
gamma_s = 0.96; % (A soil texture dependent parameter)
                % gamma_s = 0.96 for soils with sand fraction (fs) > 40%,
                % and gamma_s = 0.27 for soils with fs <=40%)
dels = 1.33; % (shape parameter)


ke = exp(gamma_s*(1- power(Sr,(gamma_s - dels))));

phis  = theta_s0; % phis is porosity (phis == theta_s); range from 0.25 to 0.55 for most soils
lambda_0 = -0.56*phis + 0.51;  % thermal conducticity for air-dry soil conditions, lambda_0 range from 0.38 to 0.2.

QC = 0.60; % quartz content, the 0-5cm soil texture at HTC is sandy loam, qc = 0.6 in Murray_2007_AFM Table 1
lambda_qc = 7.7;  % thermal conductivity of quartz, constant [W m-1 K-1]

lambda_o = 2.0; % thermal conductivity of other minerals [W m-1 K-1] (lambda_o = 2 for QC>0.2, lambda_o = 3 otherwise)

lambda_s = (lambda_qc^(QC))*lambda_o^(1-QC);% thermal conductivity for thermal conductivity of the soil solids
lambda_wtr = 0.57;   % thermal conductivity of water, constant [W m-1 K-1]

lambda_w = (lambda_s^(1-phis))*lambda_wtr^(SMC); % saturated thermal conductivity (eq. 17)

lambdas = ke*(lambda_w - lambda_0) + lambda_0; % thermal conductivity (eq. 14)

Hcs = 2.0*10^6; % heat capacity of solid soil minerals [J m-3 K-1]
Hcw = 4.2*10^6; % heat capacity of water [J m-3 K-1]

Hc = (Hcw * SMC)+ (1-theta_s)*Hcs; % heat capacity [J m-3 K-1]

GAM = sqrt(lambdas.*Hc);
