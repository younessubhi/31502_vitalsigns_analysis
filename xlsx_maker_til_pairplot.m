close all, clear all, clc

cdir = fileparts(mfilename('fullpath')); 
[NUMERIC, TXT, RAW] = xlsread(fullfile(cdir,'Anno Patient Data/nn1.xlsx'));
X = NUMERIC;
X(:,1) = [];
Y = X;

HR = Y(:,1);
indices = find(abs(Y(:,1))>300);
HR(indices) = NaN;
% RR: >35
RR = Y(:,2);
indices = find(abs(Y(:,2))>35);
RR(indices) = NaN;
% SAT: <55
SAT = Y(:,3);
indices = find(abs(Y(:,3))<55);
SAT(indices) = NaN;
% Puls: >300
Puls = Y(:,4);
indices = find(abs(Y(:,4))>300);
Puls(indices) = NaN;
% sBP: <50
sBP = Y(:,5);
indices = find(abs(Y(:,5))<50);
sBP(indices) = NaN;
% dBP: <20
dBP = Y(:,6);
indices = find(abs(Y(:,6))<20);
dBP(indices) = NaN;
% pBP: >300
pBP = Y(:,7);
indices = find(abs(Y(:,7))>300);
pBP(indices) = NaN;


% fjern alle nye NaNs
Z = [HR, RR, SAT, Puls, sBP, dBP, pBP];
Z = [TXT; Z]

%filename = 'nn1_corr.xlsx';
%writematrix(Z, filename, 'sheet', 1, 'Range', 'D1')



