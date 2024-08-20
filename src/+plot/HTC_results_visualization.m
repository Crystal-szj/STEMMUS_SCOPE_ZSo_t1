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
data_obs_dir = '../../CH_HTC_2022/Processed/08_CH-HTC_2022_0101_0809_v5.xlsx';
psiLeaf_obs_dir = '../../CH_HTC_2022/Observed/plant_water_potential.xlsx';
sif_obs_dir = '../../CH_HTC_2022/Observed/2022_SIF.xlsx';

% ---------- output directionary -------------
figure_dir = fullfile(Output_dir, 'figures2/');
if ~exist (figure_dir,'dir')
    mkdir(figure_dir)
end

% ---------- sim directionary -------------
flux_sim_dir = fullfile(Output_dir,'fluxes.csv');
surfTemp = fullfile(Output_dir, 'surftemp.csv');  % surface soil temperature

sm_sim_dir = fullfile(Output_dir, 'Sim_Theta.csv'); % all layers of sm
st_sim_dir = fullfile(Output_dir,'Sim_Temp.csv');   % all layers of st   

sif_sim_dir = fullfile(Output_dir, 'fluorescence.csv');

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
opts_sim_flux = detectImportOptions(flux_sim_dir);
opts_sim_flux.VariableNamesLine = 1;
opts_sim_flux.VariableUnitsLine = 2;
flux_sim = readtable(flux_sim_dir, opts_sim_flux);

% sim fluorescence
opts_sim_sif = detectImportOptions(sif_sim_dir);
opts_sim_sif.VariableNamesLine = 1;
opts_sim_sif.VariableUnitsLine = 2;
sif_sim = readtable(sif_sim_dir, opts_sim_sif);

% obs
opts_data_obs = detectImportOptions(data_obs_dir);
% opts_data_obs.VariableNamesLine = 1;
opts_data_obs.VariableTypes{75} = 'double';
opts_data_obs.VariableTypes{76} = 'double';
% opts_data_obs.DataLines = [2,10609];
data_obs = readtable(data_obs_dir, opts_data_obs);

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

opts_sif_obs = detectImportOptions(sif_obs_dir);
opts_sif_obs.VariableNames = {'V1','V2','Date','SIF'};
opts_sif_obs.VariableUnitsRange = 'A2';
sif_obs = readtable(sif_obs_dir, opts_sif_obs);

sif_data = table;
sif_data.dateStr = datestr(data_obs.dateTime);
sif_data.dateTime = datetime(datenum(sif_data.dateStr),'ConvertFrom','datenum');
sif_obs.dateStr = datestr(sif_obs.Date, 'dd-mmm-yyyy HH:MM:SS');
sif_obs.dateTime = datetime(datenum(sif_obs.dateStr),'ConvertFrom','datenum');

sif_data= outerjoin(sif_data, sif_obs,'LeftKeys', 2,'RightKeys',6, 'MergeKeys',true); % check missing data    
sif_data = sif_data(1:10608,[2,6]);
% sif_data.SIF(find(isnan(sif_data.SIF))) =0;
  

%%
lsf1 = data_obs.lst;
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
% % data_obs_sm = [data_obs.Ms_5cm_Avg, data_obs.Ms_10cm_Avg, data_obs.Ms_20cm_Avg, data_obs.Ms_40cm_Avg, data_obs.Ms_60cm_Avg, data_obs.Ms_80cm_Avg]./100;
% % data_sim_sm = [sm_sim.x5, sm_sim.x10, sm_sim.x20,sm_sim.x40,sm_sim.x60,sm_sim.x80];
% % legendText = {'Obs\_5cm','Sim\_5cm';
% %               'Obs\_10cm','Sim\_10cm';
% %               'Obs\_20cm','Sim\_20cm';
% %               'Obs\_40cm','Sim\_40cm';
% %               'Obs\_60cm','Sim\_60cm';
% %               'Obs\_80cm','Sim\_80cm'};
% % %%
% % f = plot.f_plot_soilMoisture_precipitation(doy, data_obs_sm, doy, data_sim_sm, plotStyleLine.SM_sim, doy, data_obs.Precip .*1800, ...
% %                        legendText, 'Soil moisture (m^3 m^{-3})', 'Precipitation (mm)',xlimRange, [0.1,0.55], [0,20],figure_dir,'SM' );
% % %%                   
% % data_obs_st = [data_obs.Ts_5cm_Avg,data_obs.Ts_10cm_Avg,data_obs.Ts_20cm_Avg,data_obs.Ts_40cm_Avg,data_obs.Ts_60cm_Avg,data_obs.Ts_80cm_Avg];
% % data_sim_st = [st_sim.x5, st_sim.x10, st_sim.x20,st_sim.x40,st_sim.x60,st_sim.x80];                   
% % legendText = {'Obs\_5cm','Sim\_5cm';
% %               'Obs\_10cm','Sim\_10cm';
% %               'Obs\_20cm','Sim\_20cm';
% %               'Obs\_40cm','Sim\_40cm';
% %               'Obs\_60cm','Sim\_60cm';
% %               'Obs\_80cm','Sim\_80cm'};              
% % f = plot.f_plot_soilTemperature(doy, data_obs_st, doy, data_sim_st, plotStyleLine.ST_sim,  ...
% %                        legendText, 'Soil temperature (^\circC)',xlimRange, [0, 55],figure_dir,'ST' );
% % 					   
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
fp_st2 = plot.f_plotObsSim(doy, lsf1, doy, st_sim.x2, plotStyleLine.ST_sim, {'Retrived LST','ST\_2cm', 'box','off'}, 'Temperture (^\circC)', xlimRange, [0,55], figure_dir,'LST_ST2cm');
%%
fp_st2  = plot.f_plotObsSim(doy, data_obs.Ts_2cm_Avg,  doy, st_sim.x2,  plotStyleLine.ST_sim, {'Obs\_2cm', 'Sim\_2cm',  'box','off'}, 'Temperture (^\circC)', xlimRange, [0,55], figure_dir,'ST 2cm');
fp_st5  = plot.f_plotObsSim(doy, data_obs.Ts_5cm_Avg,  doy, st_sim.x5,  plotStyleLine.ST_sim, {'Obs\_5cm', 'Sim\_5cm',  'box','off'}, 'Temperture (^\circC)', xlimRange, [0,55], figure_dir,'ST 5cm');
fp_st10 = plot.f_plotObsSim(doy, data_obs.Ts_10cm_Avg, doy, st_sim.x10, plotStyleLine.ST_sim, {'Obs\_10cm','Sim\_10cm', 'box','off'}, 'Temperture (^\circC)', xlimRange, [0,55], figure_dir,'ST 10cm');
fp_st20 = plot.f_plotObsSim(doy, data_obs.Ts_20cm_Avg, doy, st_sim.x20, plotStyleLine.ST_sim, {'Obs\_20cm','Sim\_20cm', 'box','off'}, 'Temperture (^\circC)', xlimRange, [0,55], figure_dir,'ST 20cm');
fp_st40 = plot.f_plotObsSim(doy, data_obs.Ts_40cm_Avg, doy, st_sim.x40, plotStyleLine.ST_sim, {'Obs\_40cm','Sim\_40cm', 'box','off'}, 'Temperture (^\circC)', xlimRange, [0,55], figure_dir,'ST 40cm');
fp_st60 = plot.f_plotObsSim(doy, data_obs.Ts_60cm_Avg, doy, st_sim.x60, plotStyleLine.ST_sim, {'Obs\_60cm','Sim\_60cm', 'box','off'}, 'Temperture (^\circC)', xlimRange, [0,55], figure_dir,'ST 60cm');
fp_st80 = plot.f_plotObsSim(doy, data_obs.Ts_80cm_Avg, doy, st_sim.x80, plotStyleLine.ST_sim, {'Obs\_80cm','Sim\_80cm', 'box','off'}, 'Temperture (^\circC)', xlimRange, [0,55], figure_dir,'ST 80cm');  																																																  

%% =====================================================================================
%% scatter 30 min Rn
fp_Rn = plot.f_scatterObsSim(data_obs.Rn, flux_sim.Rntot,[-500,1500,-500,1500], plotStyleScatter.Rn_sim,'Rn\_obs (W m^{-2})','Rn\_sim (W m^{-2})', figure_dir, 'Scatter_Rn');

%% scatter 30 min LE
fs_LE = plot.f_scatterObsSim(data_obs.LE, flux_sim.lEtot,[-100,800,-100,800], plotStyleScatter.LE_sim, 'LE\_obs (W m^{-2})','LE\_sim (W m^{-2})', figure_dir, 'Scatter_LE');
fs_LE2 = plot.f_scatterObsSim(data_obs.LE_cor_redi, flux_sim.lEtot,[-100,800,-100,800], plotStyleScatter.LE_sim, 'LE\_obs (W m^{-2})','LE\_sim (W m^{-2})', figure_dir, 'Scatter_LE_cor_redi');
fs_LE3 = plot.f_scatterObsSim(data_obs.LE_cor, flux_sim.lEtot,[-100,800,-100,800], plotStyleScatter.LE_sim, 'LE\_obs (W m^{-2})','LE\_sim (W m^{-2})', figure_dir, 'Scatter_LE_cor');

fs_LE = plot.f_scatterObsSim(data_obs.LE_fall, flux_sim.lEtot,[-100,800,-100,800], plotStyleScatter.LE_sim, 'LE\_obs (W m^{-2})','LE\_sim (W m^{-2})', figure_dir, 'Scatter_LE_fall');
fs_LE2 = plot.f_scatterObsSim(data_obs.LE_fall_cor_redi, flux_sim.lEtot,[-100,800,-100,800], plotStyleScatter.LE_sim, 'LE\_obs (W m^{-2})','LE\_sim (W m^{-2})', figure_dir, 'Scatter_LE_fall_cor_redi');
fs_LE3 = plot.f_scatterObsSim(data_obs.LE_fall_cor, flux_sim.lEtot,[-100,800,-100,800], plotStyleScatter.LE_sim, 'LE\_obs (W m^{-2})','LE\_sim (W m^{-2})', figure_dir, 'Scatter_LE_fall_cor');
%% scatter 30 min H
fs_H  = plot.f_scatterObsSim(data_obs.H,  flux_sim.Htot, [-500,1500,-500,1500], plotStyleScatter.H_sim,'H\_obs (W m^{-2})','H\_sim (W m^{-2})', figure_dir, 'Scatter_H');
fs_H3  = plot.f_scatterObsSim(data_obs.H_cor,  flux_sim.Htot, [-500,1500,-500,1500], plotStyleScatter.H_sim,'H\_obs (W m^{-2})','H\_sim (W m^{-2})', figure_dir, 'Scatter_H_cor');

fs_H  = plot.f_scatterObsSim(data_obs.H_fall,  flux_sim.Htot, [-500,1500,-500,1500], plotStyleScatter.H_sim,'H\_obs (W m^{-2})','H\_sim (W m^{-2})', figure_dir, 'Scatter_H_fall');
fs_H3  = plot.f_scatterObsSim(data_obs.H_fall_cor,  flux_sim.Htot, [-500,1500,-500,1500], plotStyleScatter.H_sim,'H\_obs (W m^{-2})','H\_sim (W m^{-2})', figure_dir, 'Scatter_H_fall_cor');
%% scatter 30 min G
fs_G  = plot.f_scatterObsSim(data_obs.G_cor_avg, flux_sim.Gtot,[-100,300,-100,300], plotStyleScatter.G_sim,'G\_obs (W m^{-2})','G\_sim (W m^{-2})', figure_dir, 'Scatter_G');

%% scatter 30 min NEE
fs_NEE = plot.f_scatterObsSim(data_obs.NEE_U05_fall.*(-1), flux_sim.NEE.*1e9./12,[-10,50, -10,50], plotStyleScatter.NEE_sim,'NEE\_obs (umol m^{-2} s^{-1})','NEE\_sim (umol m^{-2} s^{-1})', figure_dir, 'Scatter_NEEU05');
fs_NEE = plot.f_scatterObsSim(data_obs.NEE_U50_fall.*(-1), flux_sim.NEE.*1e9./12,[-10,50, -10,50], plotStyleScatter.NEE_sim,'NEE\_obs (umol m^{-2} s^{-1})','NEE\_sim (umol m^{-2} s^{-1})', figure_dir, 'Scatter_NEEU50');
fs_NEE = plot.f_scatterObsSim(data_obs.NEE_U95_fall.*(-1), flux_sim.NEE.*1e9./12,[-10,50, -10,50], plotStyleScatter.NEE_sim,'NEE\_obs (umol m^{-2} s^{-1})','NEE\_sim (umol m^{-2} s^{-1})', figure_dir, 'Scatter_NEEU95');
%% scatter 30 min GPP
flux_sim.GPP_umol = flux_sim.GPP .* 1e9 ./12;  % units tansfer from Kg m-2 s-1 to umol m-2 s-1
fs_GPP = plot.f_scatterObsSim(data_obs.GPP_U05_f, flux_sim.GPP_umol,[-10,50, -10,50], plotStyleScatter.GPP_sim,'GPP\_obs (umol m^{-2} s^{-1})','GPP\_sim (umol m^{-2} s^{-1})', figure_dir, 'Scatter_GPPU05');
fs_GPP = plot.f_scatterObsSim(data_obs.GPP_U50_f, flux_sim.GPP_umol,[-10,50, -10,50], plotStyleScatter.GPP_sim,'GPP\_obs (umol m^{-2} s^{-1})','GPP\_sim (umol m^{-2} s^{-1})', figure_dir, 'Scatter_GPPU50');
fs_GPP = plot.f_scatterObsSim(data_obs.GPP_U95_f, flux_sim.GPP_umol,[-10,50, -10,50], plotStyleScatter.GPP_sim,'GPP\_obs (umol m^{-2} s^{-1})','GPP\_sim (umol m^{-2} s^{-1})', figure_dir, 'Scatter_GPPU95');

%% ======================================================================================
%% plot 30 min Rn, LE, H, G, GPP, H
fp_Rn = plot.f_plotObsSim(doy, data_obs.Rn, doy, flux_sim.Rntot, plotStyleLine.Rn_sim, {'Obs Rn','Sim Rn','box','off'}, 'Rn (W m^{-2})', xlimRange, [-500,1500], figure_dir, 'plot_Rn');
fp_LE = plot.f_plotObsSim(doy, data_obs.LE, doy, flux_sim.lEtot, plotStyleLine.LE_sim, {'Obs LE','Sim LE','box','off'}, 'LE (W m^{-2})', xlimRange, [-1000,1500], figure_dir, 'plot_LE');
fp_LE = plot.f_plotObsSim(doy, data_obs.LE_cor_redi, doy, flux_sim.lEtot, plotStyleLine.LE_sim, {'Obs LE','Sim LE','box','off'}, 'LE (W m^{-2})', xlimRange, [-1000,1500], figure_dir, 'plot_LE_cor_redi');
fp_LE = plot.f_plotObsSim(doy, data_obs.LE_cor, doy, flux_sim.lEtot, plotStyleLine.LE_sim, {'Obs LE','Sim LE','box','off'}, 'LE (W m^{-2})', xlimRange, [-1000,1500], figure_dir, 'plot_LE_cor');

fp_LE = plot.f_plotObsSim(doy, data_obs.LE_fall, doy, flux_sim.lEtot, plotStyleLine.LE_sim, {'Obs LE','Sim LE','box','off'}, 'LE (W m^{-2})', xlimRange, [-1000,1500], figure_dir, 'plot_LE_fall');
fp_LE = plot.f_plotObsSim(doy, data_obs.LE_fall_cor_redi, doy, flux_sim.lEtot, plotStyleLine.LE_sim, {'Obs LE','Sim LE','box','off'}, 'LE (W m^{-2})', xlimRange, [-1000,1500], figure_dir, 'plot_LE_fall_cor_redi');
fp_LE = plot.f_plotObsSim(doy, data_obs.LE_fall_cor, doy, flux_sim.lEtot, plotStyleLine.LE_sim, {'Obs LE','Sim LE','box','off'}, 'LE (W m^{-2})', xlimRange, [-1000,1500], figure_dir, 'plot_LE_fall_cor');

fp_H = plot.f_plotObsSim(doy, data_obs.H, doy, flux_sim.Htot, plotStyleLine.H_sim, {'Obs H','Sim H','box','off'}, 'H (W m^{-2})', xlimRange, [-500,1500], figure_dir, 'plot_H');
fp_H = plot.f_plotObsSim(doy, data_obs.H_cor, doy, flux_sim.Htot, plotStyleLine.H_sim, {'Obs H','Sim H','box','off'}, 'H (W m^{-2})', xlimRange, [-500,1500], figure_dir, 'plot_H_cor');

fp_H = plot.f_plotObsSim(doy, data_obs.H_fall, doy, flux_sim.Htot, plotStyleLine.H_sim, {'Obs H','Sim H','box','off'}, 'H (W m^{-2})', xlimRange, [-500,1500], figure_dir, 'plot_H_fall');
fp_H = plot.f_plotObsSim(doy, data_obs.H_fall_cor, doy, flux_sim.Htot, plotStyleLine.H_sim, {'Obs H','Sim H','box','off'}, 'H (W m^{-2})', xlimRange, [-500,1500], figure_dir, 'plot_H_fall_cor');

fp_G = plot.f_plotObsSim(doy, data_obs.G_cor_avg, doy, flux_sim.Gtot, plotStyleLine.G_sim, {'Obs G','Sim G','box','off'}, 'G (W m^{-2})', xlimRange, [-100,300], figure_dir, 'plot_G');

fp_GPP = plot.f_plotObsSim(doy, data_obs.GPP_U05_f, doy, flux_sim.GPP_umol, plotStyleLine.GPP_sim, {'Obs GPP','Sim GPP','box','off'}, 'GPP (umol m^{-2} s^{-1})', xlimRange, [-10,50], figure_dir, 'plot_GPPU05');
fp_GPP = plot.f_plotObsSim(doy, data_obs.GPP_U50_f, doy, flux_sim.GPP_umol, plotStyleLine.GPP_sim, {'Obs GPP','Sim GPP','box','off'}, 'GPP (umol m^{-2} s^{-1})', xlimRange, [-10,50], figure_dir, 'plot_GPPU50');
fp_GPP = plot.f_plotObsSim(doy, data_obs.GPP_U95_f, doy, flux_sim.GPP_umol, plotStyleLine.GPP_sim, {'Obs GPP','Sim GPP','box','off'}, 'GPP (umol m^{-2} s^{-1})', xlimRange, [-10,50], figure_dir, 'plot_GPPU95');

fp_NEE = plot.f_plotObsSim(doy, data_obs.NEE_U05_fall.*(-1), doy, flux_sim.NEE.*1e9./12, plotStyleLine.NEE_sim, {'Obs NEE','Sim NEE','box','off'}, 'NEE (umol m^{-2} s^{-1})', xlimRange, [-20,50], figure_dir, 'plot_NEEU05');
fp_NEE = plot.f_plotObsSim(doy, data_obs.NEE_U50_fall.*(-1), doy, flux_sim.NEE.*1e9./12, plotStyleLine.NEE_sim, {'Obs NEE','Sim NEE','box','off'}, 'NEE (umol m^{-2} s^{-1})', xlimRange, [-20,50], figure_dir, 'plot_NEEU50');
fp_NEE = plot.f_plotObsSim(doy, data_obs.NEE_U95_fall.*(-1), doy, flux_sim.NEE.*1e9./12, plotStyleLine.NEE_sim, {'Obs NEE','Sim NEE','box','off'}, 'NEE (umol m^{-2} s^{-1})', xlimRange, [-20,50], figure_dir, 'plot_NEEU95');
%% SIF
index = find(isnan(sif_data.SIF));
sif_sim{index, 121} = NaN;
fp_sif = plot.f_plotObsSim(doy, sif_data.SIF, doy, sif_sim{:,121}, plotStyleLine.NEE_sim, {'Obs SIF','Sim SIF','box','off'}, 'SIF (W m^{-2} nm^{-1} sr^{-1})', xlimRange, [0,3], figure_dir, 'plot_SIF');

%% daily ET
daily = table;
daily.DoY = (0:1:220)';
lambda = 2.453*1e6;
data_obs.ET = data_obs.LE_fall./lambda;

daily.obsET = nansum(reshape(data_obs.ET,48,[]),1)' .* 3600;    % unit: mm/d
daily.simET = nansum(reshape(flux_sim.lEtot ./ lambda, 48, []),1)' .* 3600;  % unit: mm/d
daily.obsPrec = nansum(reshape(data_obs.Precip .*1800, 48, []),1)'./10;    % unit cm/d

plot.f_plot_YObsSim_Ybar(daily.DoY, daily.obsET, daily.DoY, daily.simET, plotStyleLine.LE_sim, daily.DoY, daily.obsPrec,{'Obs ET','Sim ET','Prec','box','off'}, 'ET (mm d^{-1})', 'Prec (cm d^{-1})', xlimRange, [0,15], [0,15], figure_dir, 'plot_ET_Prec');

%% water potential gradient
ind = find(bbx==1);
% find root zone soil water potential range
[maxV, minV] = fun_boundaries(TestPHS.psiSoilTot(ind, :));
lineStyle = {'LineStyle','-','LineWidth',1};

f1 =  figure('color','white','Units','centimeter','Position',[2,2,16,10])
% set default color order of axes
leftColor  = [0,0,0];
rightColor = [0 0.4470 0.7410];
set(f1, 'defaultAxesColorOrder',[leftColor; rightColor]);

% axis left
yyaxis left
fill([xyt.t',fliplr(xyt.t')], [maxV, fliplr(minV)], [170,93,37]./256, 'FaceAlpha', 0.3, 'EdgeColor', 'none')
hold on
plot(xyt.t, TestPHS.psiSoilTotMean, 'color',[170,93,37]./256, lineStyle{:})
plot(xyt.t, TestPHS.psiRootTot, 'color',[0.9290 0.6940 0.1250], lineStyle{:})
plot(xyt.t, TestPHS.psiStemTot, 'color',[0.3010 0.7450 0.9330], lineStyle{:})
plot(xyt.t, TestPHS.psiLeafTot,'-', 'color',[0.4660 0.6740 0.1880] , lineStyle{:})
% plot(xyt.t, TestPHS.psiAirTot , 'color', [0.3010 0.7450 0.9330], lineStyle{:})
% plot(psiLeaf_obs.DoY, psiLeaf_obs.PSY50K_m)
plot(psiLeaf_obs.DoY, psiLeaf_obs.PSY50H_m,'k-^','MarkerIndices',1:10:length(psiLeaf_obs.PSY50K_m), 'MarkerFaceColor',[0,0,0], 'Markersize',2)
ylim([-1000,0])
ylabel('Soil and plant water potential (m)')

yyaxis right
plot(xyt.t, TestPHS.psiAirTot,'color', [0 0.4470 0.7410], lineStyle{:})
ylim([-3e4,2e4])
legend('psiSoilTot','psiSoilMean','psiRoot','psiStem','psiLeaf','psiStem-obs','psiAir', 'box','off','NumColumns',3,'Location','Southwest')

xlabel('DoY')
ylabel('Air water potential (m)')

xlim([208,221])
set(gca,'FontName','Times New Roman','FontSize',12)
saveas(f1, fullfile(figure_dir,'WaterPotentialGradients'),'fig');
saveas(f1, fullfile(figure_dir,'WaterPotentialGradients'),'png');

%% water potential gradient v2
ind = find(bbx==1);
% find root zone soil water potential range
[maxV, minV] = fun_boundaries(TestPHS.psiSoilTot(ind, :));
lineStyle = {'LineStyle','-','LineWidth',1};

f1 =  figure('color','white','Units','centimeter','Position',[2,2,16,10])
[ax,hlines] = plot.plotyyy(xyt.t,TestPHS.psiSoilTotMean,xyt.t,TestPHS.psiLeafTot,xyt.t,TestPHS.psiAirTot, {'Soil Water Potential','Leaf','Air'})
hold on
plot(ax(2), xyt.t, TestPHS.psiStemTot)
linkaxes(ax,'x')
% % set default color order of axes
% leftColor  = [0,0,0];
% rightColor = [0 0.4470 0.7410];
% set(f1, 'defaultAxesColorOrder',[leftColor; rightColor]);
% 
% % axis left
% yyaxis left
% fill([xyt.t',fliplr(xyt.t')], [maxV, fliplr(minV)], [170,93,37]./256, 'FaceAlpha', 0.3, 'EdgeColor', 'none')
% hold on
% plot(xyt.t, TestPHS.psiSoilTotMean, 'color',[170,93,37]./256, lineStyle{:})
% plot(xyt.t, TestPHS.psiRootTot, 'color',[0.9290 0.6940 0.1250], lineStyle{:})
% plot(xyt.t, TestPHS.psiStemTot, 'color',[0.3010 0.7450 0.9330], lineStyle{:})
% plot(xyt.t, TestPHS.psiLeafTot,'-', 'color',[0.4660 0.6740 0.1880] , lineStyle{:})
% % plot(xyt.t, TestPHS.psiAirTot , 'color', [0.3010 0.7450 0.9330], lineStyle{:})
% % plot(psiLeaf_obs.DoY, psiLeaf_obs.PSY50K_m)
% plot(psiLeaf_obs.DoY, psiLeaf_obs.PSY50H_m,'k-^','MarkerIndices',1:10:length(psiLeaf_obs.PSY50K_m), 'MarkerFaceColor',[0,0,0], 'Markersize',2)
% ylim([-1000,0])
% ylabel('Soil and plant water potential (m)')
% 
% yyaxis right
% plot(xyt.t, TestPHS.psiAirTot,'color', [0 0.4470 0.7410], lineStyle{:})
% ylim([-3e4,2e4])
% legend('psiSoilTot','psiSoilMean','psiRoot','psiStem','psiLeaf','psiStem-obs','psiAir', 'box','off','NumColumns',3,'Location','Southwest')
% 
% xlabel('DoY')
% ylabel('Air water potential (m)')
% 
% xlim([208,221])
% set(gca,'FontName','Times New Roman','FontSize',12)
% saveas(f1, fullfile(figure_dir,'WaterPotentialGradients'),'fig');
% saveas(f1, fullfile(figure_dir,'WaterPotentialGradients'),'png');
%% ---------------- root zone water redistribution
color_custom = [autumn; flipud(summer)];
f2 = figure('color','white','Units','centimeter','Position',[2,2,18,8])
% alphaData = ~isnan(RWUtot);
waterRedis = NaN(size(RWUtot));
waterRedis = (RWUtot<0) .* RWUtot;
alphaData = ~(flipud(RWUtot)==0);
% imagesc(xyt.t,flipud(soilDepth), RWUtot,'AlphaData', alphaData)
% imagesc(xyt.t,soilDepth, flipud(RWUtot))%,'AlphaData', alphaData)
imagesc(xyt.t,[1:29]', flipud(RWUtot),'AlphaData', alphaData)
yticks([1.5:2:30])
ylabels ={'1','2','3','4','5','6','8','10','12'...
    '14','16','18','20','22.5','25','27.5','30','32.5','35',...
    '37.5','40','45','50','55','60','70','80','90','100'}
yticklabels(ylabels(1:2:29))

colormap(color_custom)
caxis([-0.5e-9, 0.5e-9]);
colorbar
xlim([200,221])
xlabel('DoY')
ylabel('Soil Depth (cm)')
set(gca,'FontName','Times New Roman','FontSize',12)
saveas(f2, fullfile(figure_dir,'WaterRedistribution'),'fig');
saveas(f2, fullfile(figure_dir,'WaterRedistribution'),'png');
%%
% plot plant water potential of components
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
plot(doy, TestPHS.psiSoilTot(24,:),'b-')
% plot(doy, TestPHS.psiAirTot, 'c-')


ylabel('water potential (m)',labelFormat{:})
xlim([193,225])
legend('obs1','obs2','psiLeaf','psiStem','psiRoot','psiSoil','box','off', 'Location','best')
% legend('obs1','obs2','psiStem','psiRoot','psiSoil','box','off', 'Location','best')

set(gca,'FontName','Times New Roman','FontSize',12)

subplot(3,1,3)
plot(doy, TestPHS.psiSoilTotMean,'b-')
xlabel('DoY',labelFormat{:})
ylabel('water potential (m)',labelFormat{:})
legend('psiSoil','box','off')
xlim([193,225])
set(gca,'FontName','Times New Roman','FontSize',12)
% saveas(f_lwp,fullfile(figure_dir,'plant_water_potential'),'png')
% saveas(f_lwp,fullfile(figure_dir,'plant_water_potential'),'fig')
%%
% psiAirTot_MPa = TestPHS.psiAirTot.*9810./1e6;
% psiLeafTot_MPa = TestPHS.psiLeafTot.*9810./1e6;
% psiStemTot_MPa = TestPHS.psiStemTot.*9810./1e6;
% psiRootTot_MPa = TestPHS.psiRootTot.*9810./1e6;
% psiSoilTotMean_MPa = TestPHS.psiSoilTotMean.*9810./1e6;
lineStyle = {'LineWidth',1};
f_lwp2 = figure('color','white','Units','centimeter','Position',[2,2,15,10]);

semilogy(doy,TestPHS.psiAirTot,lineStyle{:})
hold on
semilogy(doy,TestPHS.psiLeafTot,lineStyle{:})
semilogy(doy,TestPHS.psiStemTot,lineStyle{:})
semilogy(doy,TestPHS.psiRootTot,lineStyle{:})
semilogy(doy,TestPHS.psiSoilTotMean,lineStyle{:})
semilogy(psiLeaf_obs.DoY,psiLeaf_obs.PSY50K_m,'k-^','MarkerIndices',1:10:length(psiLeaf_obs.PSY50K_m), 'MarkerFaceColor',[0,0,0], 'Markersize',2);
% semilogy(psiLeaf_obs.DoY, psiLeaf_obs.PSY50H_m,'k-o','MarkerIndices',1:10:length(psiLeaf_obs.PSY50H_m), 'MarkerFaceColor',[0,0,0], 'Markersize',2 );



% legend('air','leaf','stem','root','soil', 'obs stem1','obs stem2','box','off','NumColumns',2)
legend('\psi_{air}','\psi_{leaf}','\psi_{stem}','\psi_{root}','\psi_{soil}', 'Observed \psi_{stem}','box','off','NumColumns',2)
ylim([-1e5,-1e-0])
xlabel('DoY',labelFormat{:})
ylabel('Water potantial (m)',labelFormat{:})
set(gca,'FontName','Times New Roman','FontSize',12)

% saveas(f_lwp2,fullfile(figure_dir,'plant_water_potential_gradients_8month'),'png')
% saveas(f_lwp2,fullfile(figure_dir,'plant_water_potential_gradients_8month'),'fig')

xlim([208,221])
saveas(f_lwp2,fullfile(figure_dir,'plant_water_potential_gradients_July'),'png')
saveas(f_lwp2,fullfile(figure_dir,'plant_water_potential_gradients_July'),'fig')

% close(f_lwp2)
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
set(gca,'FontName','Times New Roman','FontSize',12)

saveas(f_wsf,fullfile(figure_dir,'waterStressFactors'),'png')
saveas(f_wsf,fullfile(figure_dir,'waterStressFactors'),'fig')

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
plot(doy, 1./TestPHS.rcwTot);
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
% %%
% f_psi_phwsf = figure
% subplot(3,3,1)
% plot(xyt.t, TestPHS.psiRootTot)
% ylabel('psiRoot')
% 
% subplot(3,3,2)
% plot(xyt.t, TestPHS.psiStemTot)
% ylabel('psiStem')
% 
% subplot(3,3,3)
% plot(xyt.t, TestPHS.psiLeafTot)
% ylabel('psiLeaf')
% 
% subplot(3,3,4)
% plot(xyt.t, TestPHS.phwsfRootTot)
% ylabel('phwsfRoot')
% 
% subplot(3,3,5)
% % plot(xyt.t, TestPHS.phwsfStemTot)
% ylabel('phwsfStem')
% 
% subplot(3,3,6)
% plot(xyt.t, TestPHS.phwsfTot)
% ylabel('phwsfLeaf')
% 
% subplot(3,3,7)
% scatter(TestPHS.psiRootTot, TestPHS.phwsfStemTot, '.')
% xlim([-800,0])
% ylim([0,1])
% xlabel('psiRoot')
% ylabel('phwsfStem')
% 
% subplot(3,3,8)
% scatter(TestPHS.psiStemTot, TestPHS.phwsfTot, '.')
% xlim([-800,0])
% ylim([0,1])
% xlabel('psiStem')
% ylabel('phwsf')
% 
% subplot(3,3,9)
% scatter(TestPHS.psiLeafTot, TestPHS.phwsfTot, '.')
% xlim([-800,0])
% ylim([0,1])
% xlabel('psiLeaf')
% ylabel('phwsf')
% saveas(f_psi_phwsf,fullfile(Output_dir, 'figures','psi_phwsf'),'png');
% saveas(f_psi_phwsf,fullfile(Output_dir, 'figures','psi_phwsf'),'fig');


%% fun_boundaries
function [maxV, minV] = fun_boundaries(array)
% Find the max and min value of the array as the upper and lower
% boundaries.
    maxV = max(array, [], 1);
    minV = min(array, [], 1);
end
























