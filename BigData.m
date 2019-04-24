clear
clc
close all

%% norm intervaller

% Her fasts�ttes �vre og nedre gr�nser for hvad der er normalt for de
% forskellige m�linger.
HR_lower = 60
HR_upper = 120

RR_lower = 12
RR_upper = 20

SPO2_lower = 93

S_BP_lower = 80
S_BP_upper = 120

%% Ask for patient id

% V�lger hvilken patient vi vil se data fra.
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
% F�rst laves en kopi 
HR_gnnm = HR;

% S� findes indicier for de v�rdier som er over 300
indices = find(abs(HR_gnnm)>300);

% s� angives disse indicier som tomme
HR_gnnm(indices) = [];

% S� findes gennemsnittet af arrayet uden outlayers, da de ellers vil
% p�virke gns. for kraftigt.
HR_gnnm = nanmean(HR_gnnm);

% Her s�ttes de selvsamme indicier i det oprindelig array (alts� outlayers) lig gns.
HR(indices) = [HR_gnnm];

% HR er nu klar til plot, men vi kan ogs� finde de punkter som er over
% eller under normalen

%% Finder alle HR over normen
HR_indices_above = find(abs(HR) > 120);
HR_above = [];

if size(HR_indices_above > 1)

    for ii = 1:length(HR_indices_above);
        HR_above(end+1) = HR(HR_indices_above(ii));
    end

    time_HR_above = tid(HR_indices_above(1))
    time_HR_above = time_HR_above'

    for ii = 2:length(HR_indices_above);
        time_HR_above(end+1) = tid(HR_indices_above(ii));
    end
    
    HR_above_exist = 1
    
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
% plot af patientens data
plot(tid, HR)
% plot af linjer for �vre og nedre gr�nse
line([tid(1) tid(end)], [HR_lower, HR_lower], 'color','r','LineWidth', 1)
line([tid(1) tid(end)], [HR_upper, HR_upper], 'color','r','LineWidth', 1)
% plot af r�de prikker over og under gr�nserne, hvis de findes
if HR_above_exist == 1
plot(time_HR_above,HR_above,'r.')
end
if HR_below_exist == 1
plot(time_HR_below,HR_below,'r.')
end

% Angiver titel og aksenavne
title('Heart Rate')
xlabel('Timeline')
ylabel('Heart rate [BPM]')
ylim([50 160])

hold off
%% 
% Samme kode bliver brugt til at finde v�rdierne over og under gr�nserne for de andre m�linger.
% P� samme m�de som med heart rate findes og plottes alle v�rdier.

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
plot(time_RR_above,RR_above,'r.')
end

if RR_below_exist == 1
plot(time_RR_below,RR_below,'r.')
end

title('Respiration Rate')
xlabel('Timeline')
ylabel('Respiration Rate [breaths/min]')
ylim([9 35])

hold off

%% Saturation SPO2%
SPO2_gnnm = SPO2;

SPO2_indices = find(abs(SPO2_gnnm)<55);
SPO2_gnnm(SPO2_indices) = [];

SPO2_gnnm = nanmean(SPO2_gnnm);

SPO2(SPO2_indices) = [SPO2_gnnm];

%% Finder alle SPO2 under normalen
SPO2_indices_below = find(abs(SPO2) < SPO2_lower);
SPO2_below = [];
SPO2_below_exist = 0

if size(SPO2_indices_below > 1)

    for ii = 1:length(SPO2_indices_below);
            SPO2_below(end+1) = SPO2(SPO2_indices_below(ii));
    end

    time_SPO2_below = tid(SPO2_indices_below(1))
    time_SPO2_below = time_SPO2_below'

    for ii = 2:length(SPO2_indices_below);
        time_SPO2_below(end+1) = tid(SPO2_indices_below(ii));
    end

    SPO2_below_exist = 1
    
end

%% Plot af SPO2

figure(3)
hold on
plot(tid, SPO2)
line([tid(1) tid(end)], [SPO2_lower, SPO2_lower],'color','r', 'LineWidth', 1)

if SPO2_below_exist == 1
plot(time_SPO2_below,SPO2_below,'r.')
end

title('Oxygen Saturation Rate')
xlabel('Timeline')
ylabel('Saturation [%]')
ylim([65 100])

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

%% Finder alle S_BP over normen
S_BP_indices_above = find(abs(S_BP) > S_BP_upper);
S_BP_above = [];
S_BP_above_exist = 0

if size(S_BP_indices_above > 1)

    for ii = 1:length(S_BP_indices_above);
            S_BP_above(end+1) = S_BP(S_BP_indices_above(ii));
    end

    time_S_BP_above = tid(S_BP_indices_above(1))
    time_S_BP_above = time_S_BP_above'

    for ii = 2:length(S_BP_indices_above);
        time_S_BP_above(end+1) = tid(S_BP_indices_above(ii));
    end
    
    S_BP_above_exist = 1
end
    
%% Finder alle S_BP under normalen
S_BP_indices_below = find(abs(S_BP) < S_BP_lower);
S_BP_below = [];
S_BP_below_exist = 0

if size(S_BP_indices_below > 1)

    for ii = 1:length(S_BP_indices_below);
            S_BP_below(end+1) = S_BP(S_BP_indices_below(ii));
    end

    time_S_BP_below = tid(S_BP_indices_below(1))
    time_S_BP_below = time_S_BP_below'

    for ii = 2:length(S_BP_indices_below);
        time_S_BP_below(end+1) = tid(S_BP_indices_below(ii));
    end

    S_BP_below_exist = 1
    
end

%% Plot af Systolic Blood Pressure

figure(4)
hold on
plot(tid, S_BP)
line([tid(1) tid(end)], [S_BP_lower, S_BP_lower],'color','r', 'LineWidth', 1)
line([tid(1) tid(end)], [S_BP_upper, S_BP_upper],'color','r', 'LineWidth', 1)

if S_BP_above_exist == 1
plot(time_S_BP_above,S_BP_above,'r.')
end

if S_BP_below_exist == 1
plot(time_S_BP_below,S_BP_below,'r.')
end

title('Systolic Blood Pressure')
xlabel('Timeline')
ylabel('Blood pressure [mm Hg]')
ylim([75 155])

hold off

%% Statistical methods

% Normalisere vores v�rdier for de enkelte vital signs
normHR = normalize(HR);
normRR = normalize(RR);
normSPO2 = normalize(SPO2);
normS_BP = normalize(S_BP);

% bruger boxplot funktionen til at lave et boxplot
figure(5);
hold on
boxplot([normHR,normRR,normSPO2,normS_BP],'Labels',{'HR','RR','SPO2','S_BP'});
title('Normalized boxplots for each vital sign')
ylabel('Normalized values')

% bruger histogram funktionen til at lave et histogram
figure(6);
histogram(HR);