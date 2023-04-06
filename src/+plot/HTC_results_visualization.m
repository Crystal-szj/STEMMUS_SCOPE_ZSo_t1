% This script is used to visualize common reasons. 
% Including:
%     plot   : 30 min of SM and ST
%     scatter: 30 min of Rn, LE, H, G, GPP, NEE
%     plot   : 30 min of Rn, LE, H, G, GPP, NEE
%     plot   : daily ET, GPP
%     plot   : plant water potential of components
%     plot   : WSF and phwsf

% Some detail results can be drawn in other script.

%%
close all;
%% directionary and data
% ---------- obs directionary -------------
data_obs_dir = '../../CH_HTC_2022/Processed/Forcing_data_template_for_STEMMUS_SCOPE_CH-HTC_2022_0101_0809_v4.xlsx';
psiLeaf_obs_dir = '../../CH_HTC_2022/Observed/plant_water_potential.xlsx';

% ---------- output directionary -------------
figure_dir = fullfile(Output_dir, 'figures/');
if ~exist (figure_dir,'dir')
    mkdir(figure_dir)
end

% ---------- sim directionary -------------
flux_sim_dir = fullfile(Output_dir,'fluxes.csv');
surfTemp = fullfile(Output_dir, 'surftemp.csv');  % surface soil temperature

sm_sim_dir = fullfile(Output_dir, 'Sim_Theta.csv'); % all layers of sm
st_sim_dir = fullfile(Output_dir,'Sim_Temp.csv');   % all layers of st   


% ----------- read data ----------------------
% sim st
opts_sim_st = detectImportOptions(st_sim_dir);
opts_sim_st.VariableNamesLine = 1;
opts_sim_st.DataLines = [4,10611];
% st_sim0 = readtable(st_sim0_dir,opts_sim_st);
st_sim = readtable(st_sim_dir,opts_sim_st);
st = readtable(surfTemp);

% sim sm
opts_sim_sm = detectImportOptions(sm_sim_dir);
opts_sim_sm.VariableNamesLine = 1;
opts_sim_sm.DataLines = [4,10611];
sm_sim  = readtable(sm_sim_dir,opts_sim_sm);

% sim flux
flux_sim = readtable(flux_sim_dir);

% obs
data_obs = readtable(data_obs_dir);

opts_psiLeaf = detectImportOptions(psiLeaf_obs_dir);
opts_psiLeaf.VariableNamesRange = 1;
opts_psiLeaf.DataRange = '45:1916';
psiLeaf_obs = readtable(psiLeaf_obs_dir,opts_psiLeaf);
psiLeaf_obs = psiLeaf_obs(1:3:end,:);
startTime = datetime(2022,7,28,0,0,0);
endTime = datetime(2022,8,9,23,30,0);
dateTimeNum = (datenum(startTime):1/48:datenum(endTime))';
psiLeaf_obs.Datetime = datetime(dateTimeNum,'ConvertFrom','datenum');
psiLeaf_obs.DoY = dateTimeNum - datenum(datetime(2022,1,1,0,0,0));
psiLeaf_obs.PSY50K_m = psiLeaf_obs.PSY1M50K_cor_psiLeaf .* 1000000 ./9810;
psiLeaf_obs.PSY50H_m = psiLeaf_obs.PSY1M50H_cor_psiLeaf .* 1000000 ./9810;

GPPDir = '../../CH_HTC_2022/Processed/REddyResults_CH-HTC_20221219_852810190_Tair/output.txt';
gpp = readtable(GPPDir);
gpp.GPP_uStar_f(gpp.GPP_uStar_fqc ==0) = NaN;
%%
lsf1 = f_land_surface_temperature(data_obs.LWup, data_obs.LWdown, 0.96)-273.15;
dateTimeNum = (datenum(datetime(2022,1,1,0,0,0)):1/48:datenum(datetime(2022,8,9,23,30,0)))';
dateTime = datetime(dateTimeNum,'ConvertFrom','datenum');
% doy = dateTimeNum - datenum(datetime(2022,1,1,0,0,0));
doy = xyt.t;
% xlimRange = [datetime(2022,7,13),datetime(2022,8,10)];
xlimRange = [0, 221];
% xticksRange = [datetime(2022,7,13):3:datetime(2022,8,10)];

%% plot style setting
[plotColor, plotStyleLine, plotStyleScatter] = plot.f_plot_style();

%% plot 30 min SM
data_obs_sm = [data_obs.Ms_5cm_Avg, data_obs.Ms_10cm_Avg, data_obs.Ms_20cm_Avg, data_obs.Ms_40cm_Avg, data_obs.Ms_60cm_Avg, data_obs.Ms_80cm_Avg]./100;
data_sim_sm = [sm_sim.x5, sm_sim.x10, sm_sim.x20,sm_sim.x40,sm_sim.x60,sm_sim.x80];
legendText = {'Obs\_5cm','Sim\_5cm';
              'Obs\_10cm','Sim\_10cm';
              'Obs\_20cm','Sim\_20cm';
              'Obs\_40cm','Sim\_40cm';
              'Obs\_60cm','Sim\_60cm';
              'Obs\_80cm','Sim\_80cm'};
%%
f = f_plot_soilMoisture_precipitation(doy, data_obs_sm, doy, data_sim_sm, plotStyleLine.SM_sim, doy, data_obs.Precip .*1800, ...
                       legendText, 'Soil moisture (m^3 m^{-3})', 'Precipitation (mm)',xlimRange, [0.1,0.55], [0,20],figure_dir,'SM' );
%%                   
data_obs_st = [data_obs.Ts_5cm_Avg,data_obs.Ts_10cm_Avg,data_obs.Ts_20cm_Avg,data_obs.Ts_40cm_Avg,data_obs.Ts_60cm_Avg,data_obs.Ts_80cm_Avg];
data_sim_st = [st_sim.x5, st_sim.x10, st_sim.x20,st_sim.x40,st_sim.x60,st_sim.x80];                   
legendText = {'Obs\_5cm','Sim\_5cm';
              'Obs\_10cm','Sim\_10cm';
              'Obs\_20cm','Sim\_20cm';
              'Obs\_40cm','Sim\_40cm';
              'Obs\_60cm','Sim\_60cm';
              'Obs\_80cm','Sim\_80cm'};              
f = f_plot_soilTemperature(doy, data_obs_st, doy, data_sim_st, plotStyleLine.ST_sim,  ...
                       legendText, 'Soil temperature (^\circC)',xlimRange, [0, 55],figure_dir,'ST' );
					   
% f = f_plot_YObsSim_Ybar(obsDateTime, obs, 
%                           simDateTime, sim, simPlotStyle, 
%                           ybarDatetime, ybar, 
%                           legendText, 
%                           ylabelTextL, ylabelTextR, 
%                           xlimRange, ylimRangeL, ylimRangeR, 
%                           outputDir,outputName)

f_sm2 = plot.f_plot_YObsSim_Ybar(doy, data_obs.Ms_2cm_Avg./100, ...
                        doy, sm_sim.x2, plotStyleLine.SM_sim, ...
                        doy, data_obs.Precip .*1800, ...
                        {'Obs\_2cm','Sim\_2cm','Precipitation','box','off'}, ...
                        'Soil moisture (m^3 m^{-3})', 'Precipitation (mm 30min^{-1})', ...
                        xlimRange, [0.1,0.5], [0,20], ...
                        figure_dir,'SM 2cm' );
f_sm5 = plot.f_plot_YObsSim_Ybar(doy, data_obs.Ms_5cm_Avg./100, ...
                        doy, sm_sim.x5, plotStyleLine.SM_sim, ...
                        doy, data_obs.Precip .*1800, ...
                        {'Obs\_5cm','Sim\_5cm','Precipitation','box','off'}, ...
                        'Soil moisture (m^3 m^{-3})', 'Precipitation (mm 30min^{-1})', ...
                        xlimRange, [0.1,0.5], [0,20], ...
                        figure_dir,'SM 5cm' );
f_sm10 = plot.f_plot_YObsSim_Ybar(doy, data_obs.Ms_10cm_Avg./100, ...
                        doy, sm_sim.x10, plotStyleLine.SM_sim, ...
                        doy, data_obs.Precip .*1800, ...
                        {'Obs\_10cm','Sim\_10cm','Precipitation','box','off'}, ...
                        'Soil moisture (m^3 m^{-3})', 'Precipitation (mm 30min^{-1})', ...
                        xlimRange, [0.1,0.5], [0,20], ...
                        figure_dir,'SM 10cm' );
f_sm20 = plot.f_plot_YObsSim_Ybar(doy, data_obs.Ms_20cm_Avg./100, ...
                        doy, sm_sim.x20, plotStyleLine.SM_sim, ...
                        doy, data_obs.Precip .*1800, ...
                        {'Obs\_20cm','Sim\_20cm','Precipitation','box','off'}, ...
                        'Soil moisture (m^3 m^{-3})', 'Precipitation (mm 30min^{-1})', ...
                        xlimRange, [0.1,0.5], [0,20], ...
                        figure_dir,'SM 20cm' );
f_sm40 = plot.f_plot_YObsSim_Ybar(doy, data_obs.Ms_40cm_Avg./100, ...
                        doy, sm_sim.x40, plotStyleLine.SM_sim, ...
                        doy, data_obs.Precip .*1800, ...
                        {'Obs\_40cm','Sim\_40cm','Precipitation','box','off'}, ...
                        'Soil moisture (m^3 m^{-3})', 'Precipitation (mm 30min^{-1})', ...
                        xlimRange, [0.1,0.5], [0,20], ...
                        figure_dir,'SM 40cm' ) ;
f_sm60 = plot.f_plot_YObsSim_Ybar(doy, data_obs.Ms_60cm_Avg./100, ...
                        doy, sm_sim.x60, plotStyleLine.SM_sim, ...
                        doy, data_obs.Precip .*1800, ...
                        {'Obs\_60cm','Sim\_60cm','Precipitation','box','off'}, ...
                        'Soil moisture (m^3 m^{-3})', 'Precipitation (mm 30min^{-1})', ...
                        xlimRange, [0.1,0.5], [0,20], ...
                        figure_dir,'SM 60cm' );
f_sm80 = plot.f_plot_YObsSim_Ybar(doy, data_obs.Ms_80cm_Avg./100, ...
                        doy, sm_sim.x80, plotStyleLine.SM_sim, ...
                        doy, data_obs.Precip .*1800, ...
                        {'Obs\_80cm','Sim\_80cm','Precipitation','box','off'}, ...
                        'Soil moisture (m^3 m^{-3})', 'Precipitation (mm 30min^{-1})', ...
                        xlimRange, [0.1,0.5], [0,20], ...
                        figure_dir,'SM 80cm' );                    
%% plot 30 min ST
fp_st2 = plot.f_plotObsSim(doy, lsf1, doy, st_sim.x2, plotStyleLine.ST_sim, {'Retrived LST','ST\_2cm', 'box','off'}, 'Temperture (^\circC)', xlimRange, [0,55], figure_dir,'ST 2cm');
%%
fp_st2 = f_plotObsSim(doy, data_obs.Ts_2cm_Avg,  doy, st_sim.x2,  plotStyleLine.ST_sim, {'Obs\_2cm','Sim\_2cm',   'box','off'}, 'Temperture (^\circC)', xlimRange, [0,55], figure_dir,'ST 2cm');
fp_st5 = f_plotObsSim(doy, data_obs.Ts_5cm_Avg,  doy, st_sim.x5,  plotStyleLine.ST_sim, {'Obs\_5cm','Sim\_5cm', '  box','off'}, 'Temperture (^\circC)', xlimRange, [0,55], figure_dir,'ST 5cm');
fp_st10 = f_plotObsSim(doy, data_obs.Ts_10cm_Avg, doy, st_sim.x10, plotStyleLine.ST_sim, {'Obs\_10cm','Sim\_10cm', 'box','off'}, 'Temperture (^\circC)', xlimRange, [0,55], figure_dir,'ST 10cm');
fp_st20 = f_plotObsSim(doy, data_obs.Ts_20cm_Avg, doy, st_sim.x20, plotStyleLine.ST_sim, {'Obs\_20cm','Sim\_20cm', 'box','off'}, 'Temperture (^\circC)', xlimRange, [0,55], figure_dir,'ST 20cm');
fp_st40 = f_plotObsSim(doy, data_obs.Ts_40cm_Avg, doy, st_sim.x40, plotStyleLine.ST_sim, {'Obs\_40cm','Sim\_40cm', 'box','off'}, 'Temperture (^\circC)', xlimRange, [0,55], figure_dir,'ST 40cm');
fp_st60 = f_plotObsSim(doy, data_obs.Ts_60cm_Avg, doy, st_sim.x60, plotStyleLine.ST_sim, {'Obs\_60cm','Sim\_60cm', 'box','off'}, 'Temperture (^\circC)', xlimRange, [0,55], figure_dir,'ST 60cm');
fp_st80 = f_plotObsSim(doy, data_obs.Ts_80cm_Avg, doy, st_sim.x80, plotStyleLine.ST_sim, {'Obs\_80cm','Sim\_80cm', 'box','off'}, 'Temperture (^\circC)', xlimRange, [0,55], figure_dir,'ST 80cm');  																																																  

%% =====================================================================================
%% scatter 30 min Rn
fp_Rn = plot.f_scatterObsSim(data_obs.Rn, flux_sim.Rntot,[-500,1500,-500,1500], plotStyleScatter.Rn_sim,'Rn\_obs (W m^{-2})','Rn\_sim (W m^{-2})', figure_dir, 'Scatter_Rn');

%% scatter 30 min LE
fs_LE = plot.f_scatterObsSim(data_obs.LE, flux_sim.lEtot,[-1000,1500,-1000,1500], plotStyleScatter.LE_sim, 'LE\_obs (W m^{-2})','LE\_sim (W m^{-2})', figure_dir, 'Scatter_LE');
fs_LE2 = plot.f_scatterObsSim(data_obs.LE_cor_redi, flux_sim.lEtot,[-1000,1500,-1000,1500], plotStyleScatter.LE_sim, 'LE\_obs (W m^{-2})','LE\_sim (W m^{-2})', figure_dir, 'Scatter_LE_cor_redi');
fs_LE3 = plot.f_scatterObsSim(data_obs.LE_cor, flux_sim.lEtot,[-1000,1500,-1000,1500], plotStyleScatter.LE_sim, 'LE\_obs (W m^{-2})','LE\_sim (W m^{-2})', figure_dir, 'Scatter_LE_cor');

%% scatter 30 min H
fs_H  = plot.f_scatterObsSim(data_obs.H,  flux_sim.Htot, [-500,1500,-500,1500], plotStyleScatter.H_sim,'H\_obs (W m^{-2})','H\_sim (W m^{-2})', figure_dir, 'Scatter_H');
fs_H3  = plot.f_scatterObsSim(data_obs.H_cor,  flux_sim.Htot, [-500,1500,-500,1500], plotStyleScatter.H_sim,'H\_obs (W m^{-2})','H\_sim (W m^{-2})', figure_dir, 'Scatter_H_cor');

%% scatter 30 min G
fs_G  = plot.f_scatterObsSim(data_obs.G_cor_avg, flux_sim.Gtot,[-500,1500,-500,1500], plotStyleScatter.G_sim,'G\_obs (W m^{-2})','G\_sim (W m^{-2})', figure_dir, 'Scatter_G');

%% scatter 30 min NEE
fs_NEE = plot.f_scatterObsSim(data_obs.NEE.*(-1), flux_sim.NEE.*1e9./12,[-50,100, -50,100], plotStyleScatter.NEE_sim,'NEE\_obs (umol m^{-2} s^{-1})','NEE\_sim (umol m^{-2} s^{-1})', figure_dir, 'Scatter_NEE');

%% scatter 30 min GPP
flux_sim.GPP_umol = flux_sim.GPP .* 1e9 ./12;  % units tansfer from Kg m-2 s-1 to umol m-2 s-1
fs_GPP = plot.f_scatterObsSim(gpp.GPP_uStar_f, flux_sim.GPP_umol,[-50,100, -50,100], plotStyleScatter.GPP_sim,'GPP\_obs (umol m^{-2} s^{-1})','GPP\_sim (umol m^{-2} s^{-1})', figure_dir, 'Scatter_GPP');

%% ======================================================================================
%% plot 30 min Rn, LE, H, G, GPP, H
fp_Rn = plot.f_plotObsSim(doy, data_obs.Rn, doy, flux_sim.Rntot, plotStyleLine.Rn_sim, {'Obs Rn','Sim Rn','box','off'}, 'Rn (W m^{-2})', xlimRange, [-500,1500], figure_dir, 'plot_Rn');
fp_LE = plot.f_plotObsSim(doy, data_obs.LE, doy, flux_sim.lEtot, plotStyleLine.LE_sim, {'Obs LE','Sim LE','box','off'}, 'LE (W m^{-2})', xlimRange, [-1000,1500], figure_dir, 'plot_LE');
fp_H = plot.f_plotObsSim(doy, data_obs.H, doy, flux_sim.Htot, plotStyleLine.H_sim, {'Obs H','Sim H','box','off'}, 'H (W m^{-2})', xlimRange, [-500,1500], figure_dir, 'plot_H');
fp_G = plot.f_plotObsSim(doy, data_obs.G_cor_avg, doy, flux_sim.Gtot, plotStyleLine.G_sim, {'Obs G','Sim G','box','off'}, 'G (W m^{-2})', xlimRange, [-500,1500], figure_dir, 'plot_G');
fp_GPP = plot.f_plotObsSim(doy, gpp.GPP_uStar_f, doy, flux_sim.GPP_umol, plotStyleLine.GPP_sim, {'Obs GPP','Sim GPP','box','off'}, 'GPP (umol m^{-2} s^{-1})', xlimRange, [-50,100], figure_dir, 'plot_GPP');
fp_NEE = plot.f_plotObsSim(doy, data_obs.NEE, doy, flux_sim.NEE, plotStyleLine.NEE_sim, {'Obs NEE','Sim NEE','box','off'}, 'NEE (umol m^{-2} s^{-1})', xlimRange, [-50,100], figure_dir, 'plot_NEE');

%% plot plant water potential of components
labelFormat = {'FontWeight','bold'};
f_lwp = figure('color','white','Units','centimeter','Position',[2,2,20,13]);

subplot(3,1,[1,2])
plot(psiLeaf_obs.DoY,psiLeaf_obs.PSY50K_m,'k-^','MarkerIndices',1:10:length(psiLeaf_obs.PSY50K_m), 'MarkerFaceColor',[0,0,0], 'Markersize',2);
hold on
plot(psiLeaf_obs.DoY, psiLeaf_obs.PSY50H_m,'k-o','MarkerIndices',1:10:length(psiLeaf_obs.PSY50H_m), 'MarkerFaceColor',[0,0,0], 'Markersize',2 );
% plot(psiLeaf_table.Datetime, psiLeaf_table.sim0,'r-','LineWidth',1)
plot(doy, TestPHS.psiLeafTot,'r-');
plot(doy, TestPHS.psiStemTot,'g-');
plot(doy, TestPHS.psiRootTot,'m-');
plot(doy, TestPHS.psiSoilTotMean,'b-')
plot(doy, TestPHS.psiAirTot, 'c-')


ylabel('water potential (m)',labelFormat{:})
xlim([193,225])
legend('obs1','obs2','psiLeaf','psiStem','psiRoot','psiSoil','psiLeaf','box','off', 'Location','best')
set(gca,'FontName','Times New Roman','FontSize',12)

subplot(3,1,3)
plot(doy, TestPHS.psiSoilTotMean,'b-')
xlabel('DoY',labelFormat{:})
ylabel('water potential (m)',labelFormat{:})
legend('psiSoil','box','off')
xlim([193,225])
set(gca,'FontName','Times New Roman','FontSize',12)
saveas(f_lwp,fullfile(figure_dir,'plant_water_potential'),'png')

%%
% psiAirTot_MPa = TestPHS.psiAirTot.*9810./1e6;
% psiLeafTot_MPa = TestPHS.psiLeafTot.*9810./1e6;
% psiStemTot_MPa = TestPHS.psiStemTot.*9810./1e6;
% psiRootTot_MPa = TestPHS.psiRootTot.*9810./1e6;
% psiSoilTotMean_MPa = TestPHS.psiSoilTotMean.*9810./1e6;
lineStyle = {'LineWidth',1};
f_lwp2 = figure('color','white','Units','centimeter','Position',[2,2,20,13]);

semilogy(doy,TestPHS.psiAirTot,lineStyle{:})
hold on
semilogy(doy,TestPHS.psiLeafTot,lineStyle{:})
semilogy(doy,TestPHS.psiStemTot,lineStyle{:})
semilogy(doy,TestPHS.psiRootTot,lineStyle{:})
semilogy(doy,TestPHS.psiSoilTotMean,lineStyle{:})
semilogy(psiLeaf_obs.DoY,psiLeaf_obs.PSY50K_m,'k-^','MarkerIndices',1:10:length(psiLeaf_obs.PSY50K_m), 'MarkerFaceColor',[0,0,0], 'Markersize',2);
semilogy(psiLeaf_obs.DoY, psiLeaf_obs.PSY50H_m,'k-o','MarkerIndices',1:10:length(psiLeaf_obs.PSY50H_m), 'MarkerFaceColor',[0,0,0], 'Markersize',2 );



legend('air','leaf','stem','root','soil', 'obs stem1','obs stem2','box','off','NumColumns',2)
ylim([-1e5,-1e-2])
xlabel('DoY',labelFormat{:})
ylabel('Water potantial (m)',labelFormat{:})
set(gca,'FontName','Times New Roman','FontSize',12)

saveas(f_lwp2,fullfile(figure_dir,'plant_water_potential_gradients_8month'),'png')

xlim([193,225])
saveas(f_lwp2,fullfile(figure_dir,'plant_water_potential_gradients_July'),'png')

close(f_lwp2)
%% plant hydraulic conductance
f_k = figure('color','white','Units','centimeter','Position',[2,1,20,8]);
plot(doy, TestPHS.kSoil2RootTotMean)
hold on
plot(doy, TestPHS.kRoot2StemTot)
plot(doy, TestPHS.kStem2LeafTot)

xlabel('DoY',labelFormat{:})
ylabel('hydraulic conductance (s/m)',labelFormat{:})
legend('kSoil2Root','kRoot2Stem','kStem2Leaf','box','off')
set(gca,'FontName','Times New Roman','FontSize',12)
saveas(f_k,fullfile(figure_dir,'platHydraulicConductance'),'png')
%% plot   : WSF and phwsf
f_wsf = figure('color','white','Units','centimeter','Position',[2,2,20,8]);
% yyaxis left
plot(doy, sfactortot,'LineWidth',1)
hold on
% ylabel('sfactor')

% yyaxis right
plot(doy, TestPHS.phwsfTot,'LineWidth',1)
xlabel('DoY')
ylabel('Water stress')
xlim([0,225])
legend('sfactor','phwsf', 'box','off','location','best')
saveas(f_wsf,fullfile(figure_dir,'waterStressFactors'),'png')

%% resistance

f_rac = figure('color','white','units', 'centimeter','position',[2,2,20,7]);
plot(doy, TestPHS.racTot);
ylabel('rac (s/m)')
title('aerodynamic resistance in canopy')
xlabel('DoY')

f_ras = figure('color','white','units', 'centimeter','position',[2,2,20,7]);
plot(doy, TestPHS.rasTot);
ylabel('ras (s/m)')
title('aerodynamic resistance in soil')
xlabel('DoY')

f_rcw = figure('color','white','units', 'centimeter','position',[2,2,20,7]);
plot(doy, TestPHS.rcwTot);
ylabel('rcw (s/m)')
title('stomatal conductance in canopy')
xlabel('DoY')

f_rss = figure('color','white','units', 'centimeter','position',[2,2,20,7]);
plot(doy, TestPHS.rssTot);
ylabel('rss (s/m)')
title('vapor transport resistance of soil')
xlabel('DoY')

%% soil inertial
f_gam = figure('color','white','units', 'centimeter','position',[2,2,20,7]);
plot(doy, TestPHS.gamTot);
ylabel('soil inertial (J/m^2/K/s^{0.5})')
xlabel('DoY')

%% gradients
hPa2m = 100/9810;
f_ec = figure('color','white','units', 'centimeter','position',[2,2,20,7]);
plot(doy, TestPHS.delta_ecTot.* hPa2m);
ylabel('eci-eca (m)')
xlabel('DoY')


f_es = figure('color','white','units', 'centimeter','position',[2,2,20,7]);
plot(doy, TestPHS.delta_esTot.* hPa2m);
ylabel('esi - esa (m)')
xlabel('DoY')

f_tc = figure('color','white','units', 'centimeter','position',[2,2,20,7]);
plot(doy, TestPHS.delta_tcTot);
ylabel('temperature (^\circC)')
title('Tleaf - Tair')
xlabel('DoY')

f_ts = figure('color','white','units', 'centimeter','position',[2,2,20,7]);
plot(doy, TestPHS.delta_tsTot);
ylabel('temperature (^\circC)')
title('Tsoil - Tair')
xlabel('DoY')


psiAir_MPa = air_water_potential(data_obs.RH./100, data_obs.Tair);
psiSoil_MPa = TestPHS.psiSoilTotMean .* 9810 ./1e6;
f_wp = figure('color','white','units', 'centimeter','position',[2,2,20,7]);
plot(doy, psiSoil_MPa,'LineWidth',1);
hold on 
plot(doy, psiAir_MPa,'LineWidth',1)
ylabel('water potential (MPa)')
legend('psiSoil','psiAir', 'box','off','Location','best')
xlabel('DoY')

% -------------------------------------------
e2q = 18./28./(data_obs.Psurf'./100);
qLeaf2Air = TestPHS.kLeaf2AirTot.*(TestPHS.psiLeafTot - TestPHS.psiAirTot);
transpiration = 1./(TestPHS.racTot+ TestPHS.rcwTot) .* TestPHS.delta_esTot.* e2q .* 1.2047.*1e-3 .*V(22).Val';

g_leaf2air = TestPHS.transTot ./(TestPHS.delta_esTot .* e2q .*1.2047 .*1e-3);
r_leaf2air = TestPHS.racTot+ TestPHS.rcwTot;
k_leaf2air = TestPHS.kLeaf2AirTot'./V(22).Val';

n_r_inverse = normalize(1./r_leaf2air./data_obs.Psurf'./100);
n_k = normalize(k_leaf2air);

% f_rcw = figure('color','white','units', 'centimeter','position',[2,2,20,10]);
% subplot(3,1,1)
% plot(doy, 1./r_leaf2air); % 1./resistance = conductance
% ylabel('1/r\_leaf2air (m/s)')
% 
% subplot(3,1,2)
% plot(doy, k_leaf2air)
% ylabel('k\_leaf2air (m/s)')
% 
% 
% subplot(3,1,3)
% plot(doy, 1./r_leaf2air - k_leaf2air);
ylabel('difference (m/s)')
% -------------------------------------------

%% radiation
% define color order
lineColors = jet(4);

f_rad = figure('color','white','Units','centimeter','Position',[2,1,20,12]);
plot(doy, data_obs.SWdown,'LineWidth',1)
hold on
plot(doy, data_obs.LWdown,'LineWidth',1)
plot(doy, data_obs.SWup,'LineWidth',1)
plot(doy, data_obs.LWup,'LineWidth',1)

xlabel('DoY',labelFormat{:})
ylabel('Radiation (W/m^2)',labelFormat{:})
legend('SWdown','LWdown','SWup','LWup','box','off')
set(gca,'FontName','Times New Roman','FontSize',12)

saveas(f_rad,[figure_dir,'radiation',],'png')
close(f_rad)


%% daily ET
daily = table;
daily.DoY = (0:1:220)';
lambda = 2.453*1e6;
data_obs.ET = data_obs.LE./lambda;

daily.obsET = nansum(reshape(data_obs.ET,48,[]),1)' .* 3600;    % unit: mm/d
daily.simET = nansum(reshape(flux_sim.lEtot ./ lambda, 48, []),1)' .* 3600;  % unit: mm/d

plot.f_plotObsSim(daily.DoY, daily.obsET, daily.DoY, daily.simET, plotStyleLine.LE_sim, {'Obs ET','Sim ET','box','off'}, 'ET (mm d^{-1})', xlimRange, [0,15], figure_dir, 'plot_ET');
plot.f_plotObsSim(daily.DoY, daily.obsET, daily.DoY, daily.simET, plotStyleLine.LE_sim, {'Obs ET','Sim ET','box','off'}, 'ET (mm d^{-1})', xlimRange, [0,15], figure_dir, 'plot_ET');




















