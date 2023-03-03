function f = f_plotObsSim(obsDateTime, obs, simDateTime, sim, simPlotStyle, legendText, ylabelText, xlimRange, ylimRange, outputDir,outputName)
% This function is used to compare two time series results, and calcualted
% statistical proxies including R-squared and RMSE.
% 
% Input
%     obsDateTime  : datetime of observation data
%     obs          : obs data
%     simDateTime  : datetime of simulation data
%     sim          : sim data
%     simPlotStyle : A cell to setting line style e.g.{'color','r','LineStyle','-', 'LineWidth',1}
%     legendText   : A string of legend
%     ylabelText   : A string of ylabel
%     xlimRange    : A matrix of xlim
%     ylimRange    : A matrix of ylim
%     outputDir    : A string of output directory
%     outputName   : A string of output figure name
    %% statistical proxies
    mdl = fitlm(obs, sim);
    RMSE = sqrt(nanmean((obs - sim).^2 ,'all'));
    textFormat = {'FontName','Times New Roman','FontSize',12}; % default textFormat setting
    labelFormat = {'FontWeight','bold','FontName','Times New Roman','FontSize',11};
    %% result visualization
    f = figure('color','white','Units','centimeter','Position',[2,1,20,8]);
    plot(obsDateTime, obs,'k-');   % observation data
    hold on
    plot(simDateTime, sim, simPlotStyle{:})    % simulation data

    xlim(xlimRange)
    ylim(ylimRange)
    set(gca, 'FontName', 'Times New Roman', 'FontSize',12)
%     datetick('x','mm/dd')
    xlabel('DoY',labelFormat{:})
    ylabel(ylabelText,labelFormat{:})
    
    legend(legendText{:},'box','off')
    
    % ------ set text location --------
    tpre1 = [0.05,0.95];           % text location precent
    tpre2 = [0.05,0.85];
    [tx1,ty1] = textloc([xlimRange,ylimRange],tpre1);
    [tx2,ty2] = textloc([xlimRange,ylimRange],tpre2);
    
    text_format = {'FontName','Times New Roman','FontSize',12}; % default textFormat setting
    
    text(tx1,ty1,['R^2 = ', num2str(mdl.Rsquared.Adjusted,'%.2f') ],textFormat{:})
    text(tx2,ty2,['RMSE = ', num2str(RMSE,'%.2f')],textFormat{:})
    
    saveas(f, fullfile(outputDir, outputName),'png')
    saveas(f, fullfile(outputDir, outputName),'fig')
    close(f)

end

%% setting text location
function [tx,ty] = textloc(ax, pre)
% This function is used to set text location.
% Example:
    % ax = axis([xmin,xmax,ymin,ymax])
    % pre = (xpre,ypre) xpre and ypre means precents, eg. pre=[0.1,0.9]
    
    tx = ax(1)+pre(1)*(ax(2)-ax(1));
    ty = ax(3)+pre(2)*(ax(4)-ax(3));
end
