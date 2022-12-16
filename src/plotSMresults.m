
Sim_Theta = Sim_Theta(1:5808,:);
% define directory
S12Dir = '../../CH_HTC_2022/Observed/QMG_Hydro_S12.xlsx';
S12 = readtable(S12Dir);

% select date period
ind = find(S12.S12>=datetime(2022,1,1) & S12.S12<=datetime(2022,4,15));
S12 = S12(ind,:);

% comparison
% create variable name
variableNames = string(SoilLayer.depth);
for i = 1:length(variableNames)
   variableNames(i) = {['SM_'+ variableNames(i)+'cm']}; 
end


simSMTable = array2table(Sim_Theta,'VariableNames',variableNames);
startTime = datenum(datetime(2022,1,1,0,0,0));
endTime = datenum(datetime(2022,5,1,23,59,0));
timeStep = datenum(datetime(2022,1,1,0,30,0)) - datenum(datetime(2022,1,1,0,0,0));
datePeriod = (startTime: timeStep : endTime)';
simSMTable.dateTime = datetime(datePeriod,'ConvertFrom','datenum');
simSMTable.SM_10cm = 0.5.*(simSMTable.SM_9cm + simSMTable.SM_11cm);
simSMTable.SM_20cm = 0.5.*(simSMTable.SM_19cm + simSMTable.SM_21cm);

f_drawSMST(simSMTable.dateTime, simSMTable.SM_5cm,  S12.S12, S12.SM_0_5cm,{'Sim 5cm','S12 5cm'},   'soil moisture(m^3/m^3)',[datetime(2022,1,1), datetime(2022,5,1)],[0.1,0.5],Output_dir,'SM_5cm')
f_drawSMST(simSMTable.dateTime, simSMTable.SM_10cm, S12.S12, S12.SM_10cm,{'Sim 10cm','S12 10cm'}, 'soil moisture(m^3/m^3)', [datetime(2022,1,1), datetime(2022,5,1)],[0.1,0.5],Output_dir,'SM_10cm')
f_drawSMST(simSMTable.dateTime, simSMTable.SM_20cm, S12.S12, S12.SM_20cm,{'Sim 20cm','S12 20cm'}, 'soil moisture(m^3/m^3)', [datetime(2022,1,1), datetime(2022,5,1)],[0.1,0.5],Output_dir,'SM_20cm')
f_drawSMST(simSMTable.dateTime, simSMTable.SM_40cm, S12.S12, S12.SM_40cm,{'Sim 40cm','S12 40cm'}, 'soil moisture(m^3/m^3)', [datetime(2022,1,1), datetime(2022,5,1)],[0.1,0.5],Output_dir,'SM_40cm')
f_drawSMST(simSMTable.dateTime, simSMTable.SM_60cm, S12.S12, S12.SM_60cm,{'Sim 60cm','S12 60cm'}, 'soil moisture(m^3/m^3)', [datetime(2022,1,1), datetime(2022,5,1)],[0.1,0.5],Output_dir,'SM_60cm')
