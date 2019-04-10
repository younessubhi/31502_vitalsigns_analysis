%% construct struct
clear
clc

data = readtable('..\31502_vitalsigns_analysis\Anno Patient Data\nn3.xlsx');

patient = struct('Code', {data(:,2).Properties.VariableNames,data(:,3).Properties.VariableNames,data(:,4).Properties.VariableNames,data(:,6).Properties.VariableNames}, 'Time', data(:,1), 'Value', {data(:,2),data(:,3),data(:,4),data(:,6)});