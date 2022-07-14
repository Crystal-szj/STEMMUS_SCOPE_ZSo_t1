%%%%%%% Set paths %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global SoilPropertyPath InputPath OutputPath ForcingPath ForcingFileName DurationSize
global CFG

%% CFG is a path to a config file
if isempty(CFG)
    CFG = '../config_file_linux373.txt';
end
%% Read the CFG file. Due to using MATLAB compiler, we cannot use run(CFG)
disp (['Reading config from ',CFG])
[SoilPropertyPath, InputPath, OutputPath, ForcingPath, ForcingFileName, DurationSize, InitialConditionPath, Scenario] = io.read_config(CFG);

%%%%%%% Prepare input files. %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global DELT IGBP_veg_long latitude longitude reference_height canopy_height  Dur_tot biochemical

% Add the forcing name to forcing path
ForcingFilePath=fullfile(ForcingPath, ForcingFileName);
%prepare input files
sitefullname=dir(ForcingFilePath).name; %read sitename
    sitename=sitefullname(1:6);
    startyear=sitefullname(8:11);
    endyear=sitefullname(13:16);
    startyear=str2double(startyear);
    endyear=str2double(endyear);
%ncdisp(sitefullname,'/','full');

if Scenario == 'Vc_gs_b'                            % Vc = Vcmax * WSF ; b = BallBerrySlope
    biochemical = @biochemical_Vc_gs_b;
elseif Scenario == 'Vcmax_gs_bw'                    % Vcmax = Vcmax    ; bw = BallBerrySlope * WSF
    biochemical = @biochemical_Vcmax_gs_bw;
elseif Scenario == 'Vc_gs_bw'                       % Vc = Vcmax * WSF ; bw = BallBerrySlope * WSF
    biochemical = @biochemical_Vc_gs_bw;
elseif Scenario == 'Vc_gs_m'                        % Vc = Vcmax * WSF ; m = MedlynSlope
    biochemical = @biochemical_Vc_gs_m;
elseif Scenario == 'Vcmax_gs_mw'                    % Vcmax = Vcmax    ; mw = MedlynSlope * WSF
    biochemical = @biochemical_Vcmax_gs_mw;
elseif Scenario == 'Vc_gs_bw'                       % Vc = Vcmax * WSF ; mw = gs_slope * WSF
    biochemical = @biochemical_Vc_gs_mw;
else
    biochemical = @biochemical_backup;
end
fprintf('This is Scenario -- %s for %s\n',Scenario,sitename);

% Read time values from forcing file
time1=ncread(ForcingFilePath,'time');
t1=datenum(startyear,1,1,0,0,0);
DELT=time1(2);

%get  time length of forcing file
time_length=length(time1);

%Set the end time of the main loop in STEMMUS_SCOPE.m
%using config file or time length of forcing file
if isnan(DurationSize)
    Dur_tot=time_length;
else
    if (DurationSize>time_length)
        Dur_tot=time_length;
    else
        Dur_tot=DurationSize;
    end
end

dt=time1(2)/3600/24;
t2=datenum(endyear,12,31,23,30,0);
T=t1:dt:t2;
TL=length(T);
T=T';
T=datestr(T,'yyyy-mm-dd HH:MM:SS');
T0=T(:,1:4);
T01=T0(:,1);
T02=T0(:,2);
T03=T0(:,3);
T04=T0(:,4);
T1=T(:,5:19);
T3=T1(1,:);
T4=T3(ones(TL,1),:);
T5=[T0,T4];
T6=datenum(T);
T7=datenum(T5);
T8=T6-T7;
time=T8;
T10=year(T);

RH=ncread(ForcingFilePath,'RH');                        % Unit: %
RHL=length(RH);
RHa=reshape(RH,RHL,1);

Tair=ncread(ForcingFilePath,'Tair');                    % Unit: K
TairL=length(Tair);
Taira=reshape(Tair,TairL,1)-273.15;                     % Unit: degree C

es= 6.107*10.^(Taira.*7.5./(237.3+Taira));              % Unit: hPa
ea=es.*RHa./100;

SWdown=ncread(ForcingFilePath,'SWdown');                % Unit: W/m2
SWdownL=length(SWdown);
SWdowna=reshape(SWdown,SWdownL,1);


LWdown=ncread(ForcingFilePath,'LWdown');                % Unit: W/m2
LWdownL=length(LWdown);
LWdowna=reshape(LWdown,LWdownL,1);


VPD=ncread(ForcingFilePath,'VPD');                      % Unit: hPa
VPDL=length(VPD);
VPDa=reshape(VPD,VPDL,1);


% Qair=ncread(ForcingFilePath,'Qair');
% QairL=length(Qair);
% Qaira=reshape(Qair,QairL,1);


Psurf=ncread(ForcingFilePath,'Psurf');                  % Unit: Pa
PsurfL=length(Psurf);
Psurfa=reshape(Psurf,PsurfL,1);
Psurfa=Psurfa./100;                                     % Unit: hPa


Precip=ncread(ForcingFilePath,'Precip');                % Unit: mm/s
PrecipL=length(Precip);
Precipa=reshape(Precip,PrecipL,1);
Precipa=Precipa./10;                                    % Unit: cm/s


Wind=ncread(ForcingFilePath,'Wind');                    % Unit: m/s
WindL=length(Wind);
Winda=reshape(Wind,WindL,1);


CO2air=ncread(ForcingFilePath,'CO2air');                % Unit:ppm
CO2airL=length(CO2air);
CO2aira=reshape(CO2air,CO2airL,1);
CO2aira=CO2aira.*44./22.4;                              % Unit: mg/m3


latitude=ncread(ForcingFilePath,'latitude');
longitude=ncread(ForcingFilePath,'longitude');
elevation=ncread(ForcingFilePath,'elevation');

LAI=ncread(ForcingFilePath,'LAI');
LAIL=length(LAI);
LAIa=reshape(LAI,LAIL,1);
LAIa(LAIa<0.01)=0.01;

% LAI_alternative=ncread(ForcingFilePath,'LAI_alternative');
% LAI_alternativeL=length(LAI_alternative);
% LAI_alternativea=reshape(LAI_alternative,LAI_alternativeL,1);

IGBP_veg_long=ncread(ForcingFilePath,'IGBP_veg_long');
reference_height=ncread(ForcingFilePath,'reference_height');
canopy_height=ncread(ForcingFilePath,'canopy_height');
% save .dat files for SCOPE
%save([InputPath, 'LAI_alternative.dat'], '-ascii', LAI_alternative)
save([InputPath, 't_.dat'], '-ascii', 'time')
save([InputPath, 'Ta_.dat'], '-ascii', 'Taira')
save([InputPath, 'Rin_.dat'], '-ascii', 'SWdowna')
save([InputPath, 'Rli_.dat'], '-ascii', 'LWdowna')
%save([InputPath, 'VPDa.dat'], '-ascii', 'VPDa')
%save([InputPath, 'Qaira.dat'], '-ascii', 'Qaira')
save([InputPath, 'p_.dat'], '-ascii', 'Psurfa')
%save([InputPath, 'Precipa.dat'], '-ascii', 'Precipa') 
save([InputPath, 'u_.dat'], '-ascii', 'Winda')
%save([InputPath, 'RHa.dat'], '-ascii', 'RHa') 
save([InputPath, 'CO2_.dat'], '-ascii', 'CO2aira') 
%save([InputPath, 'latitude.dat'], '-ascii', 'latitude')
%save([InputPath, 'longitude.dat'], '-ascii', 'longitude')
%save([InputPath, 'reference_height.dat'], '-ascii', 'reference_height')
%save([InputPath, 'canopy_height.dat'], '-ascii', 'canopy_height')
%save([InputPath, 'elevation.dat'], '-ascii', 'elevation')
save([InputPath, 'ea_.dat'], '-ascii', 'ea')
save([InputPath, 'year_.dat'], '-ascii', 'T10')
LAI=[time'; LAIa']';
save([InputPath, 'LAI_.dat'], '-ascii', 'LAI') %save meteorological data for STEMMUS
Meteodata=[time';Taira';RHa';Winda';Psurfa';Precipa';SWdowna';LWdowna';VPDa';LAIa']'; 
save([InputPath, 'Mdata.txt'], '-ascii', 'Meteodata') %save meteorological data for STEMMUS
%Lacationdata=[latitude;longitude;reference_height;canopy_height;elevation]';
%save([InputPath, 'Lacationdata.txt'], '-ascii', 'Lacationdata')
clearvars -except SoilPropertyPath InputPath OutputPath InitialConditionPath DELT Dur_tot IGBP_veg_long latitude longitude reference_height canopy_height sitename