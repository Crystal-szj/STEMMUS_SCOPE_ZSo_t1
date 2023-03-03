function f = f_plot_YObsSim_Ybar(obsDateTime, obs, simDateTime, sim, simPlotStyle, ybarDatetime, ybar, legendText, ylabelTextL, ylabelTextR, xlimRange, ylimRangeL, ylimRangeR, outputDir,outputName)
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
    mdl = fitlm(obs, sim);
    RMSE = sqrt(nanmean((obs - sim).^2 ,'all'));
    textFormat = {'FontName','Times New Roman','FontSize',12}; % default textFormat setting
    labelFormat = {'FontWeight','bold','FontName','Times New Roman','FontSize',11};
    %% result visualization
    f = figure('color','white','Units','centimeter','Position',[2,1,20,8]);
    colororder([0,0,0; 0,0,1])
    yyaxis left
    plot(obsDateTime, obs,'k-');   % observation data
    hold on
    plot(simDateTime, sim, simPlotStyle{:})    % simulation data

    xlim(xlimRange)
    ylim(ylimRangeL)
%     datetick('x','mm/dd','keepticks')
    xlabel('DoY',labelFormat{:})
    ylabel(ylabelTextL, labelFormat{:})
    
    yyaxis right
    bar(ybarDatetime, ybar,'FaceColor',[0,0,1])
    ylabel(ylabelTextR, labelFormat{:})
    ylim(ylimRangeR)
    
    set(gca, 'FontName', 'Times New Roman', 'FontSize',12)
    legend(legendText{:},'box','off')
    
    % ------ set text location --------
    tpre1 = [0.05,0.95];           % text location precent
    tpre2 = [0.05,0.85];
    [tx1,ty1] = textloc([xlimRange,ylimRangeR], tpre1);
    [tx2,ty2] = textloc([xlimRange,ylimRangeR], tpre2);
    

    
    text(tx1,ty1,['R^2 = ', num2str(mdl.Rsquared.Adjusted,'%.2f') ],textFormat{:})
    text(tx2,ty2,['RMSE = ', num2str(RMSE,'%.2f')],textFormat{:})
    
    saveas(f, fullfile(outputDir, outputName),'png')
%     close(f)

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
