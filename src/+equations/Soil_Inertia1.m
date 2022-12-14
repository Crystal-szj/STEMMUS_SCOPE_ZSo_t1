function [GAM] = Soil_Inertia1(SMC)
global theta_s0
% soil inertia method by Murray and Verhoef (2007) AFM;

% Input:
%   SMC: soil moisture
% Output:
%   GAM: soil thermal inertia


theta_s = theta_s0; %(saturated water content, m3/m3)
Sr = SMC/theta_s;

%fss = 0.58; %(sand fraction)
gamma_s = 0.95; %(A soil texture dependent parameter)
                % gamma_s = 0.95 for soils with sand fraction (fs) > 40%,
                % and gamma_s = 0.27 for soils with fs <=40%
dels = 1.33; %(shape parameter)


ke = exp(gamma_s*(1- power(Sr,(gamma_s - dels))));

phis  = theta_s0; % phis is porosity (phis == theta_s); 
lambda_d = -0.56*phis + 0.51;  % thermal conducticity for air-dry soil conditions

QC = 0.90; %(quartz content)
lambda_qc = 7.7;  %(thermal conductivity of quartz, constant, unit: W m^-1 K^-1)

lambda_s = (lambda_qc^(QC))*lambda_d^(1-QC);% thermal conductivity for saturated soil
lambda_wtr = 0.57;   %(thermal conductivity of water, W/m.K, constant)

lambda_w = (lambda_s^(1-phis))*lambda_wtr^(phis);

lambdas = ke*(lambda_w - lambda_d) + lambda_d;

Hcs = 2.0*10^6; % heat capacity of water
Hcw = 4.2*10^6; % heat capacity of solid soil minerals

Hc = (Hcw * SMC)+ (1-theta_s)*Hcs; % heat capacity

GAM = sqrt(lambdas.*Hc);
