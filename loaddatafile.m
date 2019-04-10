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
%% Heart rate

HR = NUMERIC(1:end,2)
HR_gnnm = HR

indices = find(abs(HR_gnnm)>300);
HR_gnnm(indices) = [];

HR_gnnm = nanmean(HR_gnnm)

indices = find(abs(HR)>300);
HR(indices) = [HR_gnnm];

HR1_thresholdabove = find(abs(HR) > 120)
HRthreshold = [];

for ii = 1:length(HRthreshold)
    
    HR_above(end+1) = HR(HR_thresholdabove(ii))
    
end



HR2_thresholdbelow = find(abs(HR) < 60)

figure(1)
plot(HR)

%% Respiration rate

RR = NUMERIC(1:end,3);
RR_gnnm = RR;

RR_indices = find(abs(RR_gnnm)>35);
RR_gnnm(RR_indices) = [];

RR_gnnm = nanmean(RR_gnnm);

RR_indices = find(abs(RR)>35);
RR(RR_indices) = [RR_gnnm];

figure(2)
plot(RR)

%% Saturation SPO2%

SPO2 = NUMERIC(1:end,4);
SPO2_gnnm = SPO2;

SPO2_indices = find(abs(SPO2_gnnm)<55);
SPO2_gnnm(SPO2_indices) = [];

SPO2_gnnm = nanmean(SPO2_gnnm);

SPO2_indices = find(abs(SPO2)<50);
SPO2(SPO2_indices) = [SPO2_gnnm];

figure(3)
plot(SPO2)

%% Systolic BP

S_BP = NUMERIC(1:end,6)
S_BP_gnnm = S_BP;

S_BP_indices = find(abs(S_BP)<50);
S_BP_gnnm(S_BP_indices) = [];

S_BP_gnnm = nanmean(S_BP);

S_BP(1) = S_BP_gnnm;

for i = 2:length(S_BP);
    c = isnan(S_BP(i));
    if c == true;
        S_BP(i) = S_BP(i-1);
    end
end

figure(4)
plot(S_BP)

%% Create time (WAAAAAAAUUUUUW)

c1 = readtable('anno patient data/nn1.xlsx');

tid = c1{1:end,1};

%% norm intervaller

y1_HR = 60
y2_HR = 120

y1_RR = 12
y2_RR = 20

y1_SPO2 = 93

y1_S_BP = 80
y1_S_BP = 120

figure(5)
hold on
plot(tid, HR)
line([tid(1) tid(end)], [y1_HR, y1_HR], 'LineWidth', 1)
line([tid(1) tid(end)], [y2_HR, y2_HR], 'LineWidth', 1)
hold off

figure(6)
hold on
plot(tid, RR)
line([tid(1) tid(end)], [y1_RR, y1_RR], 'LineWidth', 1)
line([tid(1) tid(end)], [y2_RR, y2_RR], 'LineWidth', 1)
hold off

figure(7)
hold on
plot(tid, SPO2)
line([tid(1) tid(end)], [y1_SPO2, y1_SPO2], 'LineWidth', 1)
hold off

figure(8)
hold on
plot(tid, S_BP)
line([tid(1) tid(end)], [y1_S_BP, y1_S_BP], 'LineWidth', 1)
line([tid(1) tid(end)], [y2_S_BP, y2_S_BP], 'LineWidth', 1)
hold off

%% Statistical methods

bxp = input('What would you like to boxplot? (HR/RR/SPO2/SBP): \n')

boxplot(bxp)

histogram = input('What would you like to histogram? (HR/RR/SPO2/SBP): \n')

