function f = f_scatterObsSim(obs, sim, ax, scatterStyle, xlabelText, ylabelText, outputDir, outputName)
% This function can be used to draw scatter plot with 1:1 line and
% satistically proxies of RMSE and R-squared.
% 
% Input:
%     obs: a matrix of observed data
%     sim: a matrix of simulated data
%     ax : [minX, maxX, minY, maxY]
%     xlabel: A string eg. xlabel('Rn\_obs (W m^{-2})')
%     ylabel: A string
    

%% calculated satistics proxy
mdl = fitlm(obs, sim);
RMSE = sqrt(nanmean((obs - sim).^2 ,'all'));
textFormat = {'FontName','Times New Roman','FontSize',12}; % default textFormat setting
labelFormat = {'FontWeight','bold'};
%% figure setting

f = figure('color','white','units','centimeter','position',[2,2,8,8]);
ax = ax;

tpre1 = [0.05,0.95];           % text location precent
tpre2 = [0.05,0.85]; 
tpre3 = [0.05,0.75];
[tx1,ty1] = textloc(ax,tpre1);
[tx2,ty2] = textloc(ax,tpre2);
[tx3,ty3] = textloc(ax,tpre3);

% ================== scatter density plot ===========================
scatter(obs, sim,scatterStyle{:})  % density scatter

box on
hold on

% ====================== trend line =====================================
% ------------------ original method -------------------------------------
% plot(obs, mdl.Coefficients.Estimate(1)+obs * mdl.Coefficients.Estimate(2),'r-')
% -------------------------------------------------------------------------

% refline(m,b) add a reference line with slope m and intercept b to the
% current axes.
hline = refline(mdl.Coefficients.Estimate(2), mdl.Coefficients.Estimate(1));
hline.Color = [0,0,0];
hline.LineWidth = 1;

% ======================= 1:1 Line =================================
plot([ax(1),ax(2)],[ax(3),ax(4)],'color',[0.5,0.5,0.5])

% ====================== axis setting =============================
axis(ax)
axis square

set(gca, 'FontName','Times New Roman','FontSize',12);
xlabel(xlabelText,labelFormat{:});
ylabel(ylabelText, labelFormat{:});

text(tx1,ty1,['R^2 = ', num2str(mdl.Rsquared.Adjusted,'%.2f') ],textFormat{:})
text(tx2,ty2,['RMSE = ', num2str(RMSE,'%.2f')],textFormat{:})
text(tx3,ty3,['Slope = ', num2str(mdl.Coefficients.Estimate(2),'%.2f')],textFormat{:})

%% save figure

saveas(f, [outputDir,'/', outputName], 'png')
saveas(f, [outputDir,'/', outputName], 'fig')

close(f)
end


%%
function [tx,ty] = textloc(ax, pre)
    % ax = axis([xmin,xmax,ymin,ymax])
    % pre = (xpre,ypre) xpre and ypre means precents, eg. pre=[0.1,0.9]
    
    tx = ax(1)+pre(1)*(ax(2)-ax(1));
    ty = ax(3)+pre(2)*(ax(4)-ax(3));
end
