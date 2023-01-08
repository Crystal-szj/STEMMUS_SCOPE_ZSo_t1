function [psiAir_m] = air_water_potential(RH, Ta)
% input:
%     RH: relative humidity (-)
%     T:  air temperature (K)
% output:
%     psiAir: air water potential (m)
%   
    RH = RH./100;
    Ta = Ta+273.15; % unit transfer: Celsius degree to K
    R = 8.314; % gas constants (J/mol/K)
    Vw = 18;   % partial molar volume of liquid water (cm^3/mol)
    
    psiAir_MPa = R .* Ta ./ Vw .* log(RH); % unit [MPa]
    psiAir_m = psiAir_MPa .*1e6 ./9810;
    
end