function [Rl, ri, Ztot] = InitialRootBiomass(RTB,DeltZ_R,rroot,ML,SiteProperties)
% This function is used to calculate initial root length density (Rl) and
% root distribution (ri).
%
% Input:
%     RTB:       A parameter of root to biomass [g m-2]
%     DeltZ_R:   An array of soil layer depth, from soil surface to bottom [m]
%     rroot:     A parameter of root radius [m]
%     ML:        Number of soil layers, same value with NL.
% Output:
%     Rl:        An array of root length density for each soil layer from bottom to surface [m m-3].
%     ri:        Root distribution: root fraction in each soil layers.
%

    % define variable and parameters
    igbpVegLong = SiteProperties.igbpVegLong;
    
    root_den = 250*1000; % [gDM / m^3] Root density  Jackson et al., 1997 
    R_C = 0.488; % [gC/gDM] Ratio Carbon-Dry Matter in root   Jackson et al.,  1997 

    % total root length density
    Rltot = RTB/R_C/root_den/(pi*(rroot^2)); % root length index [m root / m^2 PFT]

    % root fraction in each soil layers
    [ri,Ztot] = RootDistribution(igbpVegLong,DeltZ_R,ML)

    % root length density in each soil layers [m root / m^3 PFT]
    Rl=(ri.*Rltot./(DeltZ_R./100))'; 

    % filp root length density to the direction: bottom to surface
    Rl=flipud(Rl);
end