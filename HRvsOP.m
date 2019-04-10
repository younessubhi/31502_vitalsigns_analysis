%% Excercise

%% load dependencies
load count.dat

%% Ask for patient id

ptid = input('Enter patient id: \n')
ptid = num2str(ptid)

%% Load data
cdir = fileparts(mfilename('fullpath')); 

% Load the data into Matlab
[NUMERIC, TXT, RAW] = xlsread(fullfile(cdir,'../31502_vitalsigns_analysis/Anno Patient Data/nn1.xlsx'));

data = readtable(sprintf('../31502_vitalsigns_analysis/Anno Patient Data/nn%s.xlsx', ptid));
%% construct struct

patient = struct('Code', {data(:,2).Properties.VariableNames,data(:,3).Properties.VariableNames,data(:,4).Properties.VariableNames,data(:,6).Properties.VariableNames}, 'Time', data(:,1), 'Value', {data(:,2),data(:,3),data(:,4),data(:,6)});
%% Create time (WAAAAAAAUUUUUW)

c1 = readtable('anno patient data/nn1.xlsx');

tid = c1{1:end,1};

%% Heart rate

HR = NUMERIC(1:end,2)
HR_gnnm = HR

indices = find(abs(HR_gnnm)>300);
HR_gnnm(indices) = [];

HR_gnnm = nanmean(HR_gnnm)

indices = find(abs(HR)>300);
HR(indices) = [HR_gnnm];

HR_thresholdabove = find(abs(HR) > 120)
HR_threshold = [];

for ii = 1:length(HR_thresholdabove);
    
    HR_threshold(end+1) = HR(HR_thresholdabove(ii));
    
end

%time_HR_threshold = [];
%
%for ii = 1:length(HR_threshold)
  %  
 %   time_HR_threshold(end+1) = tid(HR_thresholdabove(ii))
%
%end

HR2_thresholdbelow = find(abs(HR) < 60)

figure(11)
plot(HR)
figure(12)
% plot(time_HR_threshold, HR_threshold,'ro')

%% Oximeter Puls

OP = NUMERIC(1:end,5)
OP_gnnm = OP

indices = find(abs(OP_gnnm)<40);
OP_gnnm(indices) = [];

OP_gnnm = nanmean(OP_gnnm)

indices = find(abs(OP)<40);
OP(indices) = [OP_gnnm];

OP_thresholdabove = find(abs(OP) > 120)
OP_threshold = [];

%for ii = 1:length(HR_thresholdabove);
%    
%    OP_threshold(end+1) = OP(OP_thresholdabove(ii));
%    
%end

%time_HR_threshold = [];
%
%for ii = 1:length(HR_threshold)
  %  
 %   time_HR_threshold(end+1) = tid(HR_thresholdabove(ii))
%
%end

% OP2_thresholdbelow = find(abs(OP) < 60)



figure(13)
plot(OP)
figure(14)
% plot(time_OP_threshold, OP_threshold,'ro')