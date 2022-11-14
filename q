[1mdiff --git a/config_file_crib.txt b/config_file_crib.txt[m
[1mindex 68105e4..9af8ff7 100644[m
[1m--- a/config_file_crib.txt[m
[1m+++ b/config_file_crib.txt[m
[36m@@ -1,11 +1,11 @@[m
 SoilPropertyPath=/data/shared/EcoExtreML/STEMMUS_SCOPEv1.0.0/input/SoilProperty/[m
[31m-InputPath=../../CH_YLS_2017/Yangling_input/[m
[31m-OutputPath=../../CH_YLS_2017/Yangling_output/CH_YLS_Ballberry_output/[m
[31m-ForcingPath=../../CH_YLS_2017/Yangling_input/[m
[31m-ForcingFileName=CH-YLS_2017-2017_Met.nc[m
[32m+[m[32mInputPath=../../CH_HTC_2022/CH_HTC_input/[m[41m[m
[32m+[m[32mOutputPath=../../CH_HTC_2022/CH_HTC_output/[m[41m[m
[32m+[m[32mForcingPath=../../CH_HTC_2022/CH_HTC_input/[m[41m[m
[32m+[m[32mForcingFileName=CH-HTC_2022-2022_Met_shrublands.nc[m[41m[m
 InitialConditionPath=/data/shared/EcoExtreML/STEMMUS_SCOPEv1.0.0/input/Initial_condition/[m
 DurationSize=NA[m
[31m-StartDate=2004-01-01_00:00:00[m
[31m-EndDate=2004-12-31_23:30:00[m
[32m+[m[32mStartDate=2022-07-13_00:00:00[m[41m[m
[32m+[m[32mEndDate=2022-08-09_23:30:00[m[41m[m
 Scenario=Vc_gs_b[m
[31m-RunningMessages=TurningSoilProperties[m
\ No newline at end of file[m
[32m+[m[32mRunningMessages=HTC_shrublands_v_default[m
\ No newline at end of file[m
[1mdiff --git a/src/Constants.m b/src/Constants.m[m
[1mindex 0e6e6c5..dc621a9 100644[m
[1m--- a/src/Constants.m[m
[1m+++ b/src/Constants.m[m
[36m@@ -422,7 +422,7 @@[m [mGsc=1360;                         % The solar constant (1360 Wï¿½ï¿½m^-2)[m
 Sigma_E=4.90*10^(-9);       % The stefan-Boltzman constant.(=4.90*10^(-9) MJï¿½ï¿½m^-2ï¿½ï¿½Cels^-4ï¿½ï¿½d^-1)[m
 P_g0=95197.850;%951978.50;               % The mean atmospheric pressure (Should be given in new simulation period subroutine.)[m
 rroot=1.5*1e-3; [m
[31m-RTB=1000;                    %initial root total biomass (g m-2)[m
[32m+[m[32mRTB=300;                    %initial root total biomass (g m-2)[m
 Precipp=0;[m
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%[m
 % Input for producing initial soil moisture and soil temperature profile[m
[36m@@ -454,7 +454,7 @@[m [mPrecip_msr=Precip_msr.*(1-fmax.*exp(-0.5*0.5*Tot_Depth/100));[m
 Initial_path=dir(fullfile(InitialConditionPath,[sitename,'*.nc']));[m
 [m
 % set different initial conditions for different sites [m
[31m-if isequal(sitename1,{'CH-HTC'})[m
[32m+[m[32mif isequal(sitename,'CH-HTC')[m
     InitND1=20;    % Unit of it is cm. These variables are used to indicated the depth corresponding to the measurement.[m
     InitND2=40;[m
     InitND3=80;[m
[36m@@ -480,7 +480,7 @@[m [mif isequal(sitename1,{'CH-HTC'})[m
     InitX6=	0.31;%ncread([InitialConditionPath,Initial_path(9).name],'swvl4');[m
     BtmX  = 0.31;%ncread([InitialConditionPath,Initial_path(9).name],'swvl4');%0.05;    % The initial moisture content at the bottom of the column.[m
 [m
[31m-elseif isequal(sitename1,{'CH-YLS'}) [m
[32m+[m[32melseif isequal(sitename,'CH-YLS')[m[41m [m
     InitND1=5;    % Unit of it is cm. These variables are used to indicated the depth corresponding to the measurement.[m
     InitND2=30;[m
     InitND3=60;[m
[36m@@ -514,66 +514,69 @@[m [melse[m
     InitND4=100;[m
     InitND5=200;[m
     InitND6=300;[m
[31m-end[m
 [m
[31m-if SWCC==0  [m
[31m-    InitT0=	-1.762;  %-1.75estimated soil surface temperature-1.762[m
[31m-    InitT1=	-0.662;[m
[31m-    InitT2=	0.264;[m
[31m-    InitT3=	0.905;[m
[31m-    InitT4=	4.29;[m
[31m-    InitT5=	3.657;%;[m
[31m-    InitT6=	6.033;[m
[31m-    BtmT=6.62;  %9 8.1[m
[31m-    InitX0=	0.088;  [m
[31m-    InitX1=	0.095; % Measured soil liquid moisture content[m
[31m-    InitX2=	0.180; %0.169[m
[31m-    InitX3=	0.213; %0.205[m
[31m-    InitX4=	0.184; %0.114[m
[31m-    InitX5=	0.0845;[m
[31m-    InitX6=	0.078;[m
[31m-    BtmX=0.078;%0.078 0.05;    % The initial moisture content at the bottom of the column.[m
[31m-else[m
[31m-    InitT0=   ncread([InitialConditionPath,Initial_path(1).name],'skt')-273.15;  %-1.75estimated soil surface temperature-1.762[m
[31m-    InitT1=   ncread([InitialConditionPath,Initial_path(1).name],'skt')-273.15;  %-1.75estimated soil surface temperature-1.762[m
[31m-    InitT2=   ncread([InitialConditionPath,Initial_path(2).name],'stl1')-273.15;[m
[31m-    InitT3=	ncread([InitialConditionPath,Initial_path(3).name],'stl2')-273.15;[m
[31m-    InitT4=	ncread([InitialConditionPath,Initial_path(4).name],'stl3')-273.15;[m
[31m-    InitT5=	ncread([InitialConditionPath,Initial_path(5).name],'stl4')-273.15;[m
[31m-    InitT6=	ncread([InitialConditionPath,Initial_path(5).name],'stl4')-273.15;[m
[31m-    Tss = InitT0;[m
[31m-    if InitT0 < 0 || InitT1 < 0 || InitT2 < 0 || InitT3 < 0 || InitT4 < 0 || InitT5 < 0 || InitT6 < 0 [m
[31m-        InitT0=   0;[m
[31m-        InitT1=	0;[m
[31m-        InitT2=	0;[m
[31m-        InitT3=	0;[m
[31m-        InitT4=	0;[m
[31m-        InitT5=	0;[m
[31m-        InitT6=	0;[m
[31m-        Tss = InitT0;[m
[31m-    end[m
[31m-    if nanmean(Ta_msr)<0[m
[31m-        BtmT  = 0;  %9 8.1[m
[32m+[m
[32m+[m[32m    if SWCC==0[m[41m  [m
[32m+[m[32m        InitT0=	-1.762;  %-1.75estimated soil surface temperature-1.762[m
[32m+[m[32m        InitT1=	-0.662;[m
[32m+[m[32m        InitT2=	0.264;[m
[32m+[m[32m        InitT3=	0.905;[m
[32m+[m[32m        InitT4=	4.29;[m
[32m+[m[32m        InitT5=	3.657;%;[m
[32m+[m[32m        InitT6=	6.033;[m
[32m+[m[32m        BtmT=6.62;  %9 8.1[m
[32m+[m[32m        InitX0=	0.088;[m[41m  [m
[32m+[m[32m        InitX1=	0.095; % Measured soil liquid moisture content[m
[32m+[m[32m        InitX2=	0.180; %0.169[m
[32m+[m[32m        InitX3=	0.213; %0.205[m
[32m+[m[32m        InitX4=	0.184; %0.114[m
[32m+[m[32m        InitX5=	0.0845;[m
[32m+[m[32m        InitX6=	0.078;[m
[32m+[m[32m        BtmX=0.078;%0.078 0.05;    % The initial moisture content at the bottom of the column.[m
     else[m
[31m-        BtmT  =  nanmean(Ta_msr);[m
[31m-    end[m
[31m-    InitX0=	ncread([InitialConditionPath,Initial_path(6).name],'swvl1');  %0.0793[m
[31m-    InitX1=	ncread([InitialConditionPath,Initial_path(6).name],'swvl1'); % Measured soil liquid moisture content[m
[31m-    InitX2=	ncread([InitialConditionPath,Initial_path(7).name],'swvl2'); %0.182[m
[31m-    InitX3=	ncread([InitialConditionPath,Initial_path(8).name],'swvl3');[m
[31m-    InitX4= ncread([InitialConditionPath,Initial_path(9).name],'swvl4'); %0.14335[m
[31m-    InitX5=	ncread([InitialConditionPath,Initial_path(9).name],'swvl4');[m
[31m-    InitX6=	ncread([InitialConditionPath,Initial_path(9).name],'swvl4');[m
[31m-    BtmX  = ncread([InitialConditionPath,Initial_path(9).name],'swvl4');%0.05;    % The initial moisture content at the bottom of the column.[m
[31m-    if InitX0 > SaturatedMC(1) || InitX1 > SaturatedMC(1) ||InitX2 > SaturatedMC(2) ||...[m
[31m-    InitX3 > SaturatedMC(3) || InitX4 > SaturatedMC(4) || InitX5 > SaturatedMC(5) || InitX6 > SaturatedMC(6)[m
[31m-        InitX0=	fieldMC(1);  %0.0793[m
[31m-        InitX1=	fieldMC(1); % Measured soil liquid moisture content[m
[31m-        InitX2=	fieldMC(2); %0.182[m
[31m-        InitX3=	fieldMC(3);[m
[31m-        InitX4= fieldMC(4); %0.14335[m
[31m-        InitX5=	fieldMC(5);[m
[31m-        InitX6=	fieldMC(6);[m
[31m-        BtmX  = fieldMC(6);    [m
[32m+[m[32m        InitT0=   ncread([InitialConditionPath,Initial_path(1).name],'skt')-273.15;  %-1.75estimated soil surface temperature-1.762[m
[32m+[m[32m        InitT1=   ncread([InitialConditionPath,Initial_path(1).name],'skt')-273.15;  %-1.75estimated soil surface temperature-1.762[m
[32m+[m[32m        InitT2=   ncread([InitialConditionPath,Initial_path(2).name],'stl1')-273.15;[m
[32m+[m[32m        InitT3=	ncread([InitialConditionPath,Initial_path(3).name],'stl2')-273.15;[m
[32m+[m[32m        InitT4=	ncread([InitialConditionPath,Initial_path(4).name],'stl3')-273.15;[m
[32m+[m[32m        InitT5=	ncread([InitialConditionPath,Initial_path(5).name],'stl4')-273.15;[m
[32m+[m[32m        InitT6=	ncread([InitialConditionPath,Initial_path(5).name],'stl4')-273.15;[m
[32m+[m[32m        Tss = InitT0;[m
[32m+[m[32m        if InitT0 < 0 || InitT1 < 0 || InitT2 < 0 || InitT3 < 0 || InitT4 < 0 || InitT5 < 0 || InitT6 < 0[m[41m [m
[32m+[m[32m            InitT0=   0;[m
[32m+[m[32m            InitT1=	0;[m
[32m+[m[32m            InitT2=	0;[m
[32m+[m[32m            InitT3=	0;[m
[32m+[m[32m            InitT4=	0;[m
[32m+[m[32m            InitT5=	0;[m
[32m+[m[32m            InitT6=	0;[m
[32m+[m[32m            Tss = InitT0;[m
[32m+[m[32m        end[m
[32m+[m
[32m+[m[32m        InitX0=	ncread([InitialConditionPath,Initial_path(6).name],'swvl1');  %0.0793[m
[32m+[m[32m        InitX1=	ncread([InitialConditionPath,Initial_path(6).name],'swvl1'); % Measured soil liquid moisture content[m
[32m+[m[32m        InitX2=	ncread([InitialConditionPath,Initial_path(7).name],'swvl2'); %0.182[m
[32m+[m[32m        InitX3=	ncread([InitialConditionPath,Initial_path(8).name],'swvl3');[m
[32m+[m[32m        InitX4= ncread([InitialConditionPath,Initial_path(9).name],'swvl4'); %0.14335[m
[32m+[m[32m        InitX5=	ncread([InitialConditionPath,Initial_path(9).name],'swvl4');[m
[32m+[m[32m        InitX6=	ncread([InitialConditionPath,Initial_path(9).name],'swvl4');[m
[32m+[m[32m        BtmX  = ncread([InitialConditionPath,Initial_path(9).name],'swvl4');%0.05;    % The initial moisture content at the bottom of the column.[m
[32m+[m[32m        if InitX0 > SaturatedMC(1) || InitX1 > SaturatedMC(1) ||InitX2 > SaturatedMC(2) ||...[m
[32m+[m[32m        InitX3 > SaturatedMC(3) || InitX4 > SaturatedMC(4) || InitX5 > SaturatedMC(5) || InitX6 > SaturatedMC(6)[m
[32m+[m[32m            InitX0=	fieldMC(1);  %0.0793[m
[32m+[m[32m            InitX1=	fieldMC(1); % Measured soil liquid moisture content[m
[32m+[m[32m            InitX2=	fieldMC(2); %0.182[m
[32m+[m[32m            InitX3=	fieldMC(3);[m
[32m+[m[32m            InitX4= fieldMC(4); %0.14335[m
[32m+[m[32m            InitX5=	fieldMC(5);[m
[32m+[m[32m            InitX6=	fieldMC(6);[m
[32m+[m[32m            BtmX  = fieldMC(6);[m[41m    [m
[32m+[m[32m        end[m
     end[m
[32m+[m[32mend[m
[32m+[m
[32m+[m[32mif nanmean(Ta_msr)<0[m
[32m+[m[32m    BtmT  = 0;  %9 8.1[m
[32m+[m[32melse[m
[32m+[m[32m    BtmT  =  nanmean(Ta_msr);[m
 end[m
\ No newline at end of file[m
[1mdiff --git a/src/Initial_root_biomass.m b/src/Initial_root_biomass.m[m
[1mindex adeb4a5..c7e3670 100644[m
[1m--- a/src/Initial_root_biomass.m[m
[1m+++ b/src/Initial_root_biomass.m[m
[36m@@ -18,7 +18,8 @@[m [melseif strcmp(IGBP_veg_long(1:20)', 'Evergreen Needleleaf')[m
 elseif strcmp(IGBP_veg_long(1:9)', 'Croplands') [m
     beta = 0.943; [m
 elseif strcmp(IGBP_veg_long(1:15)', 'Open Shrublands')[m
[31m-    beta = 0.966; [m
[32m+[m[32m%     beta = 0.966;[m[41m [m
[32m+[m[32m    beta = 0.943;[m[41m[m
 elseif strcmp(IGBP_veg_long(1:17)', 'Closed Shrublands') [m
     beta = 0.966; [m
 elseif strcmp(IGBP_veg_long(1:8)', 'Savannas') [m
[1mdiff --git a/src/STEMMUS_SCOPE.m b/src/STEMMUS_SCOPE.m[m
[1mindex cc91445..255d4d6 100644[m
[1m--- a/src/STEMMUS_SCOPE.m[m
[1m+++ b/src/STEMMUS_SCOPE.m[m
[36m@@ -34,7 +34,7 @@[m [mif isempty(CFG)[m
 end[m
 disp (['Reading config from ',CFG])[m
 [m
[31m-[DataPaths, forcingFileName, numberOfTimeSteps, startDate, endDateScenario, RunningMessages] = io.read_config(CFG);[m
[32m+[m[32m[DataPaths, forcingFileName, numberOfTimeSteps, startDate, endDate, Scenario, RunningMessages] = io.read_config(CFG);[m
 [m
 % Prepare forcing data[m
 global IGBP_veg_long latitude longitude reference_height canopy_height sitename DELT Dur_tot[m
[36m@@ -109,7 +109,7 @@[m [mif useXLSX == 0[m
 %     options = io.setOptions(parameter_file,path_input); [m
     warning("the current stemmus-scope does not support useXLSX=0");[m
 else[m
[31m-    parameter_file            = {'input_data.xlsx'}; [m
[32m+[m[32m    parameter_file            = {'input_data_BallBerry_gs.xlsx'};[m[41m [m
     options = io.readStructFromExcel([path_input char(parameter_file)], 'options', 3, 1);[m
 end  [m
 [m
