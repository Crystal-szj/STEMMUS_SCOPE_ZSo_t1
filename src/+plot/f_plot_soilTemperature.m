function f = f_plot_soilMoisture(obsDateTime, obsMatrix, simDateTime, simMatrix, simPlotStyle, legendText, ylabelTextL, xlimRange, ylimRange, outputDir,outputName)
% This function is used to compare two time series results, and calcualted
% statistical proxies including R-squared and RMSE.
% 
% Input
%     obsDateTime  : datetime of observation data
%     obs          : obs data
%     simDateTime  : datetime of simulation data
%     sim          : sim data
%     simPlotStyle : A cell to setting line style e.g.{'color','r','LineStyle','-', 'LineWidth',1}
%     ybarDatetime : datetime of ybar
%     ybar         : ybar data
%     legendText   : A string of legend
%     ylabelTextL  : A string of ylabel left
%     ylabelTextR  : A string of ylabel right
%     xlimRange    : A matrix of xlim
%     ylimRangeL   : A matrix of ylim left
%     ylimRangeR   : A matrix of ylim right
%     outputDir    : A string of output directory
%     outputName   : A string of output figure name
    
    %% statistical proxies
%     obs = obsMatrix(:,1);
%     sim = simMatrix(:,1);
    mdl1 = fitlm(obsMatrix(:,1), simMatrix(:,1));
    mdl2 = fitlm(obsMatrix(:,2), simMatrix(:,2));
    mdl3 = fitlm(obsMatrix(:,3), simMatrix(:,3));
    mdl4 = fitlm(obsMatrix(:,4), simMatrix(:,4));
    mdl5 = fitlm(obsMatrix(:,5), simMatrix(:,5));
    mdl6 = fitlm(obsMatrix(:,6), simMatrix(:,6));

    RMSE1 = sqrt(nanmean((obsMatrix(:,1) - simMatrix(:,1)).^2 ,'all'));
    RMSE2 = sqrt(nanmean((obsMatrix(:,2) - simMatrix(:,2)).^2 ,'all'));
    RMSE3 = sqrt(nanmean((obsMatrix(:,3) - simMatrix(:,3)).^2 ,'all'));
    RMSE4 = sqrt(nanmean((obsMatrix(:,4) - simMatrix(:,4)).^2 ,'all'));
    RMSE5 = sqrt(nanmean((obsMatrix(:,5) - simMatrix(:,5)).^2 ,'all'));
    RMSE6 = sqrt(nanmean((obsMatrix(:,6) - simMatrix(:,6)).^2 ,'all'));

    textFormat = {'FontName','Times New Roman','FontSize',11}; % default textFormat setting
    labelFormat = {'FontWeight','bold','FontName','Times New Roman','FontSize',12};
    %%
    
    % result visualization
    f = figure('color','white','Units','centimeter','Position',[2,-6,20,25]);
    
    t = tiledlayout(6,1);
    
    ax1 = nexttile;
    
    plot(obsDateTime, obsMatrix(:,1),'k-');   % observation data
    hold on
    plot(simDateTime, simMatrix(:,1), simPlotStyle{:})    % simulation data

    xlim(xlimRange)
    ylim(ylimRange)
    xticklabels(ax1,{})

        
    tpre1 = [0.05,0.93];           % text location precent
    tpre2 = [0.05,0.80];
    [tx1,ty1] = textloc([xlimRange,ylimRange], tpre1);
    [tx2,ty2] = textloc([xlimRange,ylimRange], tpre2);
    

    
    text(tx1,ty1,['R^2 = ', num2str(mdl1.Rsquared.Adjusted,'%.2f') ],textFormat{:})
    text(tx2,ty2,['RMSE = ', num2str(RMSE1,'%.2f')],textFormat{:})
       
    set(gca, 'FontName', 'Times New Roman', 'FontSize',12)
    legend(legendText{1, :},'box','off')
    
    % ------ set text location --------

    %%
    ax2 = nexttile;

    plot(obsDateTime, obsMatrix(:,2),'k-');   % observation data
    hold on
    plot(simDateTime, simMatrix(:,2), simPlotStyle{:})    % simulation data

    xlim(xlimRange)
    ylim(ylimRange)
    xticklabels(ax2,{})

    
    set(gca, 'FontName', 'Times New Roman', 'FontSize',12)
    legend(legendText{2, :},'box','off')
    
    % ------ set text location --------
%     tpre1 = [0.05,0.95];           % text location precent
%     tpre2 = [0.05,0.85];
%     [tx1,ty1] = textloc([xlimRange,ylimRangeL], tpre1);
%     [tx2,ty2] = textloc([xlimRange,ylimRangeL], tpre2);
    

    
    text(tx1,ty1,['R^2 = ', num2str(mdl2.Rsquared.Adjusted,'%.2f') ],textFormat{:})
    text(tx2,ty2,['RMSE = ', num2str(RMSE2,'%.2f')],textFormat{:})
    %%
    ax3 = nexttile;

    plot(obsDateTime, obsMatrix(:,3),'k-');   % observation data
    hold on
    plot(simDateTime, simMatrix(:,3), simPlotStyle{:})    % simulation data

    xlim(xlimRange)
    ylim(ylimRange)
    xticklabels(ax3,{})
    
    
    set(gca, 'FontName', 'Times New Roman', 'FontSize',12)
    legend(legendText{3, :},'box','off')
    
%     % ------ set text location --------
%     tpre1 = [0.05,0.95];           % text location precent
%     tpre2 = [0.05,0.85];
%     [tx1,ty1] = textloc([xlimRange,ylimRangeR], tpre1);
%     [tx2,ty2] = textloc([xlimRange,ylimRangeR], tpre2);
%     

    
    text(tx1,ty1,['R^2 = ', num2str(mdl3.Rsquared.Adjusted,'%.2f') ],textFormat{:})
    text(tx2,ty2,['RMSE = ', num2str(RMSE3,'%.2f')],textFormat{:})
    
    %%
    ax4 = nexttile;

    plot(obsDateTime, obsMatrix(:,4),'k-');   % observation data
    hold on
    plot(simDateTime, simMatrix(:,4), simPlotStyle{:})    % simulation data

    xlim(xlimRange)
    ylim(ylimRange)
    xticklabels(ax4,{})
    
    
    set(gca, 'FontName', 'Times New Roman', 'FontSize',12)
    legend(legendText{4, :},'box','off')
    
%     % ------ set text location --------
%     tpre1 = [0.05,0.95];           % text location precent
%     tpre2 = [0.05,0.85];
%     [tx1,ty1] = textloc([xlimRange,ylimRangeR], tpre1);
%     [tx2,ty2] = textloc([xlimRange,ylimRangeR], tpre2);
%     

    
    text(tx1,ty1,['R^2 = ', num2str(mdl4.Rsquared.Adjusted,'%.2f') ],textFormat{:})
    text(tx2,ty2,['RMSE = ', num2str(RMSE4,'%.2f')],textFormat{:})
    
    %%
    ax5 = nexttile;

    plot(obsDateTime, obsMatrix(:,5),'k-');   % observation data
    hold on
    plot(simDateTime, simMatrix(:,5), simPlotStyle{:})    % simulation data

    xlim(xlimRange)
    ylim(ylimRange)
    xticklabels(ax5,{})
    
    
    set(gca, 'FontName', 'Times New Roman', 'FontSize',12)
    legend(legendText{5, :},'box','off')
    
%     % ------ set text location --------
%     tpre1 = [0.05,0.95];           % text location precent
%     tpre2 = [0.05,0.85];
%     [tx1,ty1] = textloc([xlimRange,ylimRangeR], tpre1);
%     [tx2,ty2] = textloc([xlimRange,ylimRangeR], tpre2);
    

    
    text(tx1,ty1,['R^2 = ', num2str(mdl5.Rsquared.Adjusted,'%.2f') ],textFormat{:})
    text(tx2,ty2,['RMSE = ', num2str(RMSE5,'%.2f')],textFormat{:})
    
    %%
    ax6 = nexttile;

    plot(obsDateTime, obsMatrix(:,6),'k-');   % observation data
    hold on
    plot(simDateTime, simMatrix(:,6), simPlotStyle{:})    % simulation data

    xlim(xlimRange)
    ylim(ylimRange)
    
    
    set(gca, 'FontName', 'Times New Roman', 'FontSize',12)
    legend(legendText{6, :},'box','off')
    
%     % ------ set text location --------
%     tpre1 = [0.05,0.95];           % text location precent
%     tpre2 = [0.05,0.85];
%     [tx1,ty1] = textloc([xlimRange,ylimRangeR], tpre1);
%     [tx2,ty2] = textloc([xlimRange,ylimRangeR], tpre2);
%     

    
    text(tx1,ty1,['R^2 = ', num2str(mdl6.Rsquared.Adjusted,'%.2f') ],textFormat{:})
    text(tx2,ty2,['RMSE = ', num2str(RMSE6,'%.2f')],textFormat{:})
    

    xlabel(t, 'DoY',labelFormat{:})
    ylabel(t, ylabelTextL, labelFormat{:})

 
    t.TileSpacing = 'compact';

    saveas(f, fullfile(outputDir, outputName),'png')
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
