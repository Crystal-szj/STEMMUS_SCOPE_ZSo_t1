function [ri,Ztot] = RootDistribution(igbpVegLong,DeltZ_R, ML)
% Calculation of root distribution (ri) refer to CLM5. (Jackson et al. 1996) 
%
% ri = RootDistribution(SiteProperties.igbpVegLong,)
% Input:
%     igbpVegLong : A string of vegetation type (SiteProperties.igbpVegLong)
%     DeltZ_R     : An array contains the thickness of soil layer from surface to bottom [cm]
%     ML          : Number of soil layers, same value with NL
%     
% Output:
%     ri          : Root distribution: root fraction in each soil layers
%     Ztot        : An array contains the depth of soil layers [cm]
%
    
    %% define beta factor refer to CLM5 (Jackson et al. 1996)
    if strcmp(igbpVegLong(1:18), 'Permanent Wetlands')
        beta = 0.993; 
    elseif strcmp(igbpVegLong(1:19)', 'Evergreen Broadleaf') 
           %------test CH-HTC-----
    beta = 0.966;
   % ---original value---------
        beta = 0.993; 
    elseif strcmp(igbpVegLong(1:19)', 'Deciduous Broadleaf') 
        beta = 0.993; 
    elseif strcmp(igbpVegLong(1:13)', 'Mixed Forests') 
        beta = 0.993; 
    elseif strcmp(igbpVegLong(1:20)', 'Evergreen Needleleaf') 
        beta = 0.993; 
    elseif strcmp(igbpVegLong(1:9)', 'Croplands') 
        beta = 0.943; 
    elseif strcmp(igbpVegLong(1:15)', 'Open Shrublands')
        beta = 0.966; 
    elseif strcmp(igbpVegLong(1:17)', 'Closed Shrublands') 
        beta = 0.966; 
    elseif strcmp(igbpVegLong(1:8)', 'Savannas') 
        beta = 0.943; 
    elseif strcmp(igbpVegLong(1:14)', 'Woody Savannas') 
        beta = 0.943; 
    elseif strcmp(igbpVegLong(1:9)', 'Grassland') 
        beta = 0.943; 
    else 
        beta = 0.943; 
        warning('IGBP vegetation name unknown, "%s" is not recognized. Falling back to default value for beta', igbpVegLong)
    end
    
    %% calculate the depth of each soil layer to land surface
    Ztot=cumsum(DeltZ_R',1); 
    
    %% calculate root distribution
    for i=1:ML
        if i==1
            ri(i)=(1-beta.^(Ztot(i)/2)); % root fraction in each soil layer
        else
            ri(i)=beta.^(Ztot(i-1)-(DeltZ_R(i-1)/2))-beta.^(Ztot(i-1)+(DeltZ_R(i)/2));
        end
    end

end