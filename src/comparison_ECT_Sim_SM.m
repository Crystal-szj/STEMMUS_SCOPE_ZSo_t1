% Compare ECT soil moisture and simulated soil moisture
% read data
obsDir = '../../CH_HTC_2022/Processed/Forcing_data_template_for_STEMMUS_SCOPE_CH-HTC_2022_0101_0809_v2.xlsx';
obsSM = readtable(obsDir);

% set simualtion depth of soil moisture
variableNames = string(SoilLayer.depth);
for i = 1:length(variableNames)
   variableNamesSM(i) = cellstr(['SM_'+ variableNames(i)+'cm']); 
   variableNamesST(i) = cellstr(['ST_'+ variableNames(i)+'cm']); 
end

% set simulated time 
simSMTable = array2table(Sim_Theta,'VariableNames',variableNamesSM);
startTime = datenum(datetime(2022,1,1,0,0,0));
endTime = datenum(datetime(2022,8,9,23,59,0));
timeStep = datenum(datetime(2022,1,1,0,30,0)) - datenum(datetime(2022,1,1,0,0,0));
datePeriod = (startTime: timeStep : endTime)';

simSMTable.dateTime = datetime(datePeriod,'ConvertFrom','datenum');
simSMTable.SM_10cm = 0.5.*(simSMTable.SM_9cm+simSMTable.SM_11cm);
simSMTable.SM_20cm = 0.5.*(simSMTable.SM_19cm+simSMTable.SM_21cm);
%%
f_drawSM(obsSM.dateTime, obsSM.Ms_5cm_Avg./100, simSMTable.dateTime, simSMTable.SM_5cm, obsSM.Precip, {'obs 5cm','sim 5cm','Precip'},  'Soil moisture(m^3/m^3)', [datetime(2022,1,1), datetime(2022,5,1)],[0.1,0.5],Output_dir,'ECT_sim_SM_5cm')
f_drawSM(obsSM.dateTime, obsSM.Ms_10cm_Avg./100,simSMTable.dateTime, simSMTable.SM_10cm, obsSM.Precip,   {'obs 10cm','sim 10cm','Precip'},  'Soil moisture(m^3/m^3)', [datetime(2022,1,1), datetime(2022,5,1)],[0.1,0.5],Output_dir,'ECT_sim_SM_10cm')
f_drawSM(obsSM.dateTime, obsSM.Ms_20cm_Avg./100,simSMTable.dateTime, simSMTable.SM_20cm,  obsSM.Precip,  {'obs 20cm','sim 20cm','Precip'},  'Soil moisture(m^3/m^3)', [datetime(2022,1,1), datetime(2022,5,1)],[0.1,0.5],Output_dir,'ECT_sim_SM_20cm')
f_drawSM(obsSM.dateTime, obsSM.Ms_40cm_Avg./100,simSMTable.dateTime, simSMTable.SM_40cm,  obsSM.Precip,  {'obs 40cm','sim 40cm','Precip'},  'Soil moisture(m^3/m^3)', [datetime(2022,1,1), datetime(2022,5,1)],[0.1,0.5],Output_dir,'ECT_sim_SM_40cm')
f_drawSM(obsSM.dateTime, obsSM.Ms_60cm_Avg./100,simSMTable.dateTime, simSMTable.SM_60cm,  obsSM.Precip,  {'obs 60cm','sim 60cm','Precip'},  'Soil moisture(m^3/m^3)', [datetime(2022,1,1), datetime(2022,5,1)],[0.1,0.5],Output_dir,'ECT_sim_SM_60cm')
f_drawSM(obsSM.dateTime, obsSM.Ms_80cm_Avg./100,simSMTable.dateTime, simSMTable.SM_80cm,  obsSM.Precip,  {'obs 80cm','sim 80cm','Precip'},  'Soil moisture(m^3/m^3)', [datetime(2022,1,1), datetime(2022,5,1)],[0.1,0.5],Output_dir,'ECT_sim_SM_80cm')

function f_drawSM(obsDateTime, obs, comDateTime, com,precip, legendText, ylabelText,xlimRange, ylimRange, outputDir,outputName)
    figure('color','white','Units','centimeter','Position',[2,1,20,8])
    colororder([0,0,0; 0,0,1])
    yyaxis left
    plot(obsDateTime, obs,'k-');
    hold on
    plot(comDateTime, com,'r-')
    ylabel(ylabelText)
    xlim(xlimRange)
    ylim(ylimRange)
    
    yyaxis right
    bar(obsDateTime, precip.*1800)
    ylabel('Preci(mm/30min)')
    datetick('x','mm/dd')
    legend(legendText{:},'box','off')
    
    saveas(gcf, fullfile(outputDir, outputName),'png')
end