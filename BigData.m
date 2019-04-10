clear
clc
close all

%% load dependencies
load count.dat

%% norm intervaller

HR_lower = 60
HR_upper = 120

RR_lower = 12
RR_upper = 20

SPO2_lower = 93

S_BP_lower = 80
S_BP_upper = 120

%% Ask for patient id

ptid = input('Enter patient id: \n')
ptid = num2str(ptid)

% Load the struct into Matlab
load(sprintf('patient_%s.mat', ptid))

%% Hiv Data ud af Patient struct
[HR,RR,SPO2,S_BP] = patient.Value;
[tid] = patient.Time;

%Laver dem fra tabel til arrays
tid = table2array(tid);
HR = table2array(HR);
RR = table2array(RR);
SPO2 = table2array(SPO2);
S_BP = table2array(S_BP);

%% Heart rate

% Laver et array uden outlayers
% Først laves en kopi 
HR_gnnm = HR;

% Så findes indicier for de værdier som er over 300
indices = find(abs(HR_gnnm)>300);

% så angives disse indicier som tomme
HR_gnnm(indices) = [];

% Så findes gennemsnittet af arrayet uden outlayers, da de ellers vil
% påvirke gns. for kraftigt.
HR_gnnm = nanmean(HR_gnnm);

% Her sættes de selvsamme indicier i det oprindelig array (altså outlayers) lig gns.
HR(indices) = [HR_gnnm];

% HR er nu klar til plot, men vi kan også finde de punkter som er over
% eller under normalen

%% Finder alle HR over normen
HR_indices_above = find(abs(HR) > 120);
HR_above = [];

for ii = 1:length(HR_indices_above);
        HR_above(end+1) = HR(HR_indices_above(ii));
end

time_HR_above = tid(HR_indices_above(1))
time_HR_above = time_HR_above'

for ii = 2:length(HR_indices_above);
    time_HR_above(end+1) = tid(HR_indices_above(ii));
end

%% Finder alle HR under normalen
HR_indices_below = find(abs(HR) < 60);
HR_below = [];
HR_below_exist = 0

if size(HR_indices_below > 1)

    for ii = 1:length(HR_indices_below);
            HR_below(end+1) = HR(HR_indices_below(ii));
    end

    time_HR_below = tid(HR_indices_below(1))
    time_HR_below = time_HR_below'

    for ii = 2:length(HR_indices_below);
        time_HR_below(end+1) = tid(HR_indices_below(ii));
    end

    HR_below_exist = 1
    
end

%% Plot af HR
figure(1)
hold on
plot(tid, HR)
line([tid(1) tid(end)], [HR_lower, HR_lower], 'color','r','LineWidth', 1)
line([tid(1) tid(end)], [HR_upper, HR_upper], 'color','r','LineWidth', 1)
plot(time_HR_above,HR_above,'ro')
if HR_below_exist == 1
plot(time_HR_below,HR_below,'ro')
end
hold off

%% Respiration rate
RR_gnnm = RR;

RR_indices = find(abs(RR_gnnm)>35);
RR_gnnm(RR_indices) = [];

RR_gnnm = nanmean(RR_gnnm);

RR_indices = find(abs(RR)>35);
RR(RR_indices) = [RR_gnnm];

%% Finder alle RR over normen
RR_indices_above = find(abs(RR) > RR_upper);
RR_above = [];
RR_above_exist = 0

if size(RR_indices_above > 1)

    for ii = 1:length(RR_indices_above);
            RR_above(end+1) = RR(RR_indices_above(ii));
    end

    time_RR_above = tid(RR_indices_above(1))
    time_RR_above = time_RR_above'

    for ii = 2:length(RR_indices_above);
        time_RR_above(end+1) = tid(RR_indices_above(ii));
    end
    
    RR_above_exist = 1
end
    
    
%% Finder alle RR under normalen
RR_indices_below = find(abs(RR) < RR_lower);
RR_below = [];
RR_below_exist = 0

if size(RR_indices_below > 1)

    for ii = 1:length(RR_indices_below);
            RR_below(end+1) = RR(RR_indices_below(ii));
    end

    time_RR_below = tid(RR_indices_below(1))
    time_RR_below = time_RR_below'

    for ii = 2:length(RR_indices_below);
        time_RR_below(end+1) = tid(RR_indices_below(ii));
    end

    RR_below_exist = 1
    
end

%% Plot af RR
figure(2)
hold on
plot(tid, RR)
line([tid(1) tid(end)], [RR_lower, RR_lower],'color','r', 'LineWidth', 1)
line([tid(1) tid(end)], [RR_upper, RR_upper],'color','r', 'LineWidth', 1)

if RR_above_exist == 1
plot(time_RR_above,RR_above,'ro')
end

if RR_below_exist == 1
plot(time_RR_below,RR_below,'ro')
end
hold off

%% Saturation SPO2%
SPO2_gnnm = SPO2;

SPO2_indices = find(abs(SPO2_gnnm)<55);
SPO2_gnnm(SPO2_indices) = [];

SPO2_gnnm = nanmean(SPO2_gnnm);

SPO2(SPO2_indices) = [SPO2_gnnm];

figure(3)
hold on
plot(tid, SPO2)
line([tid(1) tid(end)], [SPO2_lower, SPO2_lower],'color','r', 'LineWidth', 1)
hold off

%% Systolic Blood Pressure
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
hold on
plot(tid, S_BP)
line([tid(1) tid(end)], [S_BP_lower, S_BP_lower],'color','r', 'LineWidth', 1)
line([tid(1) tid(end)], [S_BP_upper, S_BP_upper],'color','r', 'LineWidth', 1)
hold off

%% Statistical methods

bxp = input('What would you like to boxplot? (HR/RR/SPO2/SBP): \n')

boxplot(bxp)

histogram = input('What would you like to histogram? (HR/RR/SPO2/SBP): \n')

