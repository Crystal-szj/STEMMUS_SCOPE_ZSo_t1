function [SiteProperties, timeStep, forcingTimeLength] = prepareForcingData(DataPaths, forcingFileName, startDate, endDate)
%{ 
This function is used to read forcing data and site properties.

Input:
    DataPaths: A construct contains paths of data.
    forcingFileName: A string of the name of forcing NetCDF data. 

Output:
    SiteProperties： A structure containing site properties variables.
    timeStep: Time interval in seconds, normal is 1800 s in STEMMUS-SCOPE.
    timeLength: The total number of time steps in forcing data.
%}
%%
% Add the forcing name to forcing path
ForcingFilePath=fullfile(DataPaths.forcingPath, forcingFileName);
% Prepare input files
sitefullname=dir(ForcingFilePath).name; %read sitename
SiteProperties.siteName=sitefullname(1:6);
% startyear=sitefullname(8:11);
% endyear=sitefullname(13:16);
startyear = str2double(startDate(1:4));
startMonth = str2double(startDate(6:7));
startDay = str2double(startDate(9:10));
startHH = str2double(startDate(12:13));
startMM = str2double(startDate(15:16));
startSS = str2double(startDate(18:19));
endyear = str2double(endDate(1:4));
endMonth = str2double(endDate(6:7));
endDay = str2double(endDate(9:10));
endHH = str2double(endDate(12:13));
endMM = str2double(endDate(15:16));
endSS = str2double(endDate(18:19));

SiteProperties.startyear = startyear;
SiteProperties.endyear = endyear;

% Read time values from forcing file
time1=ncread(ForcingFilePath,'time');
t1=datenum(startyear,startMonth,startDay,startHH,startMM,startSS);            % start time point
timeStep=1800; % default time step [s]

% %get time length of forcing file
% forcingTimeLength=length(time1);

dt=time1(2)/3600/24;        % real time steps in day, e.g timeStep == 1800, then dt is 0.0208 day. 
t2=datenum(endyear,12,31,23,30,0);          % end time point
T=t1:dt:t2;
forcingTimeLength = length(T);
TL=length(T);
T=T';
T=datestr(T,'yyyy-mm-dd HH:MM:SS'); % transfer datenum to datestr
T0=T(:,1:4);    % 'yyyy'
T1=T(:,5:19);   % '-mm-dd HH:MM:SS'
T3=T1(1,:);     % first time point: e.g. '-01-01 00:00:00'
T4=T3(ones(TL,1),:);
T5=[T0,T4];     %'yyyy-01-01 00:00:00'
T6=datenum(T);
T7=datenum(T5);
T8=T6-T7;       % DOY 
time=T8;        % DOY
T10=year(T);    % year

startLoc = [1 1 1];
readNcCount = [1 1 forcingTimeLength];

RH=ncread(ForcingFilePath,'RH', startLoc, readNcCount);            % Unit: %
RHL=length(RH);
RHa=reshape(RH,RHL,1);

Tair=ncread(ForcingFilePath,'Tair', startLoc, readNcCount);        % Unit: K
TairL=length(Tair);
Taira=reshape(Tair,TairL,1)-273.15;                                % Unit: degree C

es= 6.107*10.^(Taira.*7.5./(237.3+Taira));                         % Unit: hPa
ea=es.*RHa./100;

SWdown=ncread(ForcingFilePath,'SWdown', startLoc, readNcCount);    % Unit: W/m2
SWdownL=length(SWdown);
SWdowna=reshape(SWdown,SWdownL,1);


LWdown=ncread(ForcingFilePath,'LWdown', startLoc, readNcCount);    % Unit: W/m2
LWdownL=length(LWdown);
LWdowna=reshape(LWdown,LWdownL,1);


VPD=ncread(ForcingFilePath,'VPD', startLoc, readNcCount);          % Unit: hPa
VPDL=length(VPD);
VPDa=reshape(VPD,VPDL,1);


Psurf=ncread(ForcingFilePath,'Psurf', startLoc, readNcCount);      % Unit: Pa
PsurfL=length(Psurf);
Psurfa=reshape(Psurf,PsurfL,1);
Psurfa=Psurfa./100;                                                % Unit: hPa


Precip=ncread(ForcingFilePath,'Precip', startLoc, readNcCount);    % Unit: mm/s
PrecipL=length(Precip);
Precipa=reshape(Precip,PrecipL,1);
Precipa=Precipa./10;                                               % Unit: cm/s


Wind=ncread(ForcingFilePath,'Wind', startLoc, readNcCount);        % Unit: m/s
WindL=length(Wind);
Winda=reshape(Wind,WindL,1);


CO2air=ncread(ForcingFilePath,'CO2air', startLoc, readNcCount);    % Unit: ppm
CO2airL=length(CO2air);
CO2aira=reshape(CO2air,CO2airL,1);
CO2aira=CO2aira.*44./22.4;                                         % Unit: mg/m3


SiteProperties.latitude=ncread(ForcingFilePath,'latitude');
SiteProperties.longitude=ncread(ForcingFilePath,'longitude');
SiteProperties.elevation=ncread(ForcingFilePath,'elevation');

LAI=ncread(ForcingFilePath,'LAI');
LAIL=length(LAI);
LAIa=reshape(LAI,LAIL,1);
LAIa(LAIa<0.01)=0.01;


SiteProperties.igbpVegLong=ncread(ForcingFilePath,'IGBP_veg_long');
SiteProperties.referenceHeight=ncread(ForcingFilePath,'reference_height');

canopyHeightSize = ncinfo(ForcingFilePath,'canopy_height').Size;
if length(canopyHeightSize) == 2
    % if the canopyHeight is a constant
    SiteProperties.canopyHeight=ncread(ForcingFilePath,'canopy_height');
else 
    % if the canopyHeight is time series data
    SiteProperties.canopyHeight = ncread(ForcingFilePath,'canopy_height', startLoc, readNcCount);
end

save([DataPaths.input, 't_.dat'], '-ascii', 'time')
save([DataPaths.input, 'Ta_.dat'], '-ascii', 'Taira')
save([DataPaths.input, 'Rin_.dat'], '-ascii', 'SWdowna')
save([DataPaths.input, 'Rli_.dat'], '-ascii', 'LWdowna')
%save([DataPaths.input, 'VPDa.dat'], '-ascii', 'VPDa')
%save([DataPaths.input, 'Qaira.dat'], '-ascii', 'Qaira')
save([DataPaths.input, 'p_.dat'], '-ascii', 'Psurfa')
%save([DataPaths.input, 'Precipa.dat'], '-ascii', 'Precipa') 
save([DataPaths.input, 'u_.dat'], '-ascii', 'Winda')
%save([DataPaths.input, 'RHa.dat'], '-ascii', 'RHa') 
save([DataPaths.input, 'CO2_.dat'], '-ascii', 'CO2aira') 
%save([DataPaths.input, 'latitude.dat'], '-ascii', 'latitude')
%save([DataPaths.input, 'longitude.dat'], '-ascii', 'longitude')
%save([DataPaths.input, 'reference_height.dat'], '-ascii', 'reference_height')
%save([DataPaths.input, 'canopy_height.dat'], '-ascii', 'canopy_height')
%save([DataPaths.input, 'elevation.dat'], '-ascii', 'elevation')
save([DataPaths.input, 'ea_.dat'], '-ascii', 'ea')
save([DataPaths.input, 'year_.dat'], '-ascii', 'T10')
LAI=[time'; LAIa']';
save([DataPaths.input, 'LAI_.dat'], '-ascii', 'LAI') %save meteorological data for STEMMUS
Meteodata=[time';Taira';RHa';Winda';Psurfa';Precipa';SWdowna';LWdowna';VPDa';LAIa']'; 
save([DataPaths.input, 'Mdata.txt'], '-ascii', 'Meteodata') %save meteorological data for STEMMUS
end