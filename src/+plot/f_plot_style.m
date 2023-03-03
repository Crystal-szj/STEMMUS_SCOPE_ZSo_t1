function [plotColor, plotStyleLine, plotStyleScatter] = f_plot_style()
    % ----------------------- color -------------------------------
    plotColor.Rn_sim = [0.635, 0.078, 0.184];
    plotColor.LE_sim = [0.466, 0.674, 0.188];
    plotColor.H_sim  = [0,     0.447, 0.741];
    plotColor.G_sim  = [0.733, 0.592, 0.153];     %[187,151,39]./255

    plotColor.SM_sim = [0.537, 0.514, 0.749];
    plotColor.ST_sim = [0.959, 0.475, 0.439];

    plotColor.LeafWP_sim = [0.133, 0.545, 0.133];    %[34,139,34]./255
    plotColor.StemWP_sim = [0.557, 0.812, 0.788];       %[142,207,201]./255
    plotColor.RootWP_sim = [1,     0.745, 0.471];    %[255,190,120]./255
    plotColor.SoilWP_sim = [0.541, 0.212, 0.059];    %[138,54,15]./255
    plotColor.AirWP_sim =  [0,     0.447, 0.741];

    plotColor.GPP_sim = [0.557, 0.812, 0.788];    %[142,207,201]./255
    plotColor.NEE_sim = [0.509, 0.690, 0.824];    %[130,176,210]./255



    % ---------------------- plot style line -----------------------
    plotStyleLine = struct;
    plotStyleLine.Rn_sim = {'color',plotColor.Rn_sim,'LineStyle','-', 'LineWidth',1};
    plotStyleLine.LE_sim = {'color',plotColor.LE_sim,'LineStyle','-', 'LineWidth',1};
    plotStyleLine.H_sim  = {'color',plotColor.H_sim, 'LineStyle','-', 'LineWidth',1};
    plotStyleLine.G_sim  = {'color',plotColor.G_sim, 'LineStyle','-', 'LineWidth',1};     %[187,151,39]./255

    plotStyleLine.SM_sim = {'color',plotColor.SM_sim,'LineStyle','-', 'LineWidth',1};
    plotStyleLine.ST_sim = {'color',plotColor.ST_sim,'LineStyle','-', 'LineWidth',1};

    plotStyleLine.LeafWP_sim = {'color',plotColor.LeafWP_sim, 'LineStyle','-', 'LineWidth',1};    %[34,139,34]./255
    plotStyleLine.StemWP_sim = {'color',plotColor.StemWP_sim, 'LineStyle','-', 'LineWidth',1};
    plotStyleLine.RootWP_sim = {'color',plotColor.RootWP_sim, 'LineStyle','-', 'LineWidth',1};
    plotStyleLine.SoilWP_sim = {'color',plotColor.SoilWP_sim,'LineStyle','-', 'LineWidth',1};    %[138,54,15]./255
    plotStyleLine.AirWP_sim  = {'color',plotColor.AirWP_sim,'LineStyle','-', 'LineWidth',1};

    plotStyleLine.GPP_sim = {'color',plotColor.GPP_sim,'LineStyle','-', 'LineWidth',1};    %[142,207,201]./255
    plotStyleLine.NEE_sim = {'color',plotColor.NEE_sim,'LineStyle','-', 'LineWidth',1};    %[130,176,210]./255

    plotStyleLine.StemWP_obs1 = {'color',[0,0,0],'LineStyle','-^','MarkerIndices',1:10:624, 'MarkerFaceColor',[0,0,0], 'Markersize',2};
    plotStyleLine.StemWP_obs2 = {'color',[0,0,0],'LineStyle','-o','MarkerIndices',1:10:624, 'MarkerFaceColor',[0,0,0], 'Markersize',2};
    
    
    % ---------------- plot style scatter ----------------------------
    plotStyleScatter = struct;
    plotStyleScatter.Rn_sim = {10,[0.635, 0.078, 0.184],'.'};
    plotStyleScatter.LE_sim = {10,[0.466, 0.674, 0.188],'.'};
    plotStyleScatter.H_sim  = {10,[0,     0.447, 0.741],'.'};
    plotStyleScatter.G_sim  = {10,[0.733, 0.592, 0.153],'.'};
    plotStyleScatter.GPP_sim = {10, [0.557, 0.812, 0.788],'.'};
    plotStyleScatter.NEE_sim = {10, [0.509, 0.690, 0.824],'.'};
end