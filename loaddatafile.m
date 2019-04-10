%% Load data
cdir = fileparts(mfilename('fullpath')); 

% Load the data into Matlab
[NUMERIC, TXT, RAW] = xlsread(fullfile(cdir,'../31502_vitalsigns_analysis/Anno Patient Data/nn1.xlsx'));

%% Heart rate

HR = NUMERIC(1:end,2)
HR_gnnm = HR

indices = find(abs(HR_gnnm)>300);
HR_gnnm(indices) = [];

HR_gnnm = nanmean(HR_gnnm)

indices = find(abs(HR)>300);
HR(indices) = [HR_gnnm];

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


% S_BP_indices = find(abs(S_BP)<50);
% S_BP_gnnm(S_BP_indices) = [];
%
% S_BP_gnnm = nanmean(S_BP);

% S_BP_indices = find(abs(S_BP)<50);
% S_BP(S_BP_indices) = [S_BP_gnnm];
% S_BP(isnan(S_BP)) = S_BP_gnnm

figure(4)
plot(S_BP)

%% Create time (WAAAAAAAUUUUUW)

[Sig, TStr, Raw] = xlsread(cdir, '../Anno Patient Data/nn1.xlsx',1,'A2:A5760');
