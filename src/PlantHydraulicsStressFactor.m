% psi50 = ParaPlant.psi50;
% ck = ParaPlant.ck;
function phwsf = PlantHydraulicsStressFactor(psi, psi50, fittingPara, phwsf_method)
% This function is to calculate water stress factor based on plant
% hydraulisc theory.
%     Input:
%         psi: water potential
%         psi50: parameter of plant hydraulic pathway
%         fittingPara: parameter of plant hydraulic pathway
%         phwsf_method : phwsf_method, the default approah is weibull method
% 
%     Output:
%         phwsf: plant hydraulic water stress factor, scale from 0 to 1;
    
    % ========== define phwsf method ===============
    if nargin < 4
        phwsf_method = 'CLM5';
    else
        phwsf_method = phwsf_method;
    end
    
    % ========= calculate phwsf ===================
    switch phwsf_method
        case 'CLM5'
            phwsf = 2.^(-(psi./psi50)).^fittingPara;
            phwsf(phwsf < 5e-5) = 0;
        case 'ED2'
            phwsf = (1+(psi./psi50).^fittingPara).^-1;
%         case ''
        otherwise
            phwsf = NaN;
            fprintf('phwsf method need to be defined.')
    end
end