function f_drawSMST(meteObsDateTime, meteObs, TMObsDateTime, TMObs, legendText, ylabelText,xlimRange, ylimRange, outputDir,outputName)
    figure('color','white','Units','centimeter','Position',[2,1,20,8])
    plot(meteObsDateTime, meteObs,'k-');
    hold on
    plot(TMObsDateTime, TMObs,'r-')
    ylabel(ylabelText)
    xlim(xlimRange)
    ylim(ylimRange)
    datetick('x','mm/dd')
    legend(legendText{:},'box','off')
    
    saveas(gcf, fullfile(outputDir, outputName),'png')
end

