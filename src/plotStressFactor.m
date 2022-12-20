function plotStressFactor(t, sfactorTot, phwsfTot)
    figure('color','white','Units','centimeter','Position',[2,2,20,8]);
    plot(t, sfactorTot,'LineWidth',1)
    hold on
    plot(t, phwsfTot,'LineWidth',1)
    xlabel('DoY')
    ylabel('water stress factor')
    legend('sfactot','phwsf','box','off','location','best')
    
end