%% PCA
% author: yssubhi

% k�r skriptet sektion for sektion, jeg har pr�ve at skrive rigeligt med
% kommentarer, ogs� eksamensrelevant information
% kommentarer om koden er givet ved '%'
% kommentarer om PCA/machine learning er givet ved '% ###'

close all, clear all, clc
%% import data

% load xls data til matlab
% jeg har sat den til fullpath, s� husk at �ndrer den til at matche
% file dir p� eget drive

cdir = fileparts(mfilename('fullpath')); 
[NUMERIC_1, TXT_1, RAW_1] = xlsread(fullfile(cdir,'Anno Patient Data/nn1.xlsx'));
[NUMERIC_2, TXT_2, RAW_2] = xlsread(fullfile(cdir,'Anno Patient Data/nn2.xlsx'));
[NUMERIC_3, TXT_3, RAW_3] = xlsread(fullfile(cdir,'Anno Patient Data/nn3.xlsx'));

%% preprocessering af data
% Vi bruger NUMERIC til data behandling, RAW og TEXT er gode til at holde
% overblik

% ### PCA'en skal vise om der er sammenh�ng mellem de forskellige vital
% ### signs. Derfor er den temporale dimension underordnet.
% ### Her skal du beslutte om du vil unders�ge p� tv�rs af
% ### patientpopulationen eller om du vil holde dig til den enkelte patient
% ### I et st�rre epidimiologisk studie eller hvor man har et h�jt antal
% ### subjects, ville det v�re interessant at unders�ge p� tv�rs af
% ### patienter, da v�rdi forskelle grundet individuelle og kliniske
% ### forskelle ville have mindre betydning.
% ### Da vi kun har tre patienter, og vi ikke ved om de fejler det samme
% ### eller forskelligt patologi, vil det v�re smartest at unders�ge per
% ### patient.
% ### Selv ville jeg til eksamen unders�ge p�tv�rs af alle
% ### patienter, da datam�gnden er lille per patient (kun 4 d�gn / 6000
% ### datapunkter), ogs� p� forh�nd g�re opm�rksom p� fejlkilden.
% ### Jeg laver derfor PCA'en over alle patienter,  men �nsker du kun over
% ### en enkelt patient, skal du kommentere den 'append'-sektionen ud

%% Append
% Concatenation af data

X = [NUMERIC_1; NUMERIC_2; NUMERIC_3];

% RAW_1 har 2 NAN r�kker. De skal fjernes..
RAW_1(:,9:10) = [];

% Concatenation forsat
X_RAW = [RAW_1; RAW_2; RAW_3];
X_TXT = [TXT_1; TXT_2; TXT_3];

%% preproccesering forsat
% ### En PCA er bedst n�r den kun har det absolut, mest n�dvendige data
% Lad os unders�ge hvilket data vi har f�et fra .xls filerne:

X_TXT

% Vi har: Timestamp, HR, RR, Saturation, Puls, sBP, dBP, Puls fra
% BP-apparatur (pBP)
% ### Som n�vnt tidligere, er den temporale dimension i denne PCA underordnet.
% Derfor fjerner vi f�rste kolonne:
X(:,1) = [];


% ### For at f� en god PCA er det vigtigt at der er lige mange data
% punkter.
% Derfor kan der nu laves to forskellige PCA'er. Enten en hvor vi fjerner
% alle kolonner som ikke er kontinuerlige m�linger (sBP, dBP, pBP) eller vi
% fjerner alle r�kker med NaN data.
% Sidstn�vnte er mest interessant, da den unders�ge med flest features, men
% kan v�re en svag analyse, hvis der ikke er nok datapunkter. Vi burde
% kunne arbejde med ca. +70 data punkter.

% Vi fjerner alle r�kker med NaN, i en ny variable, for at unders�ge
% datam�ngden

Y = X;
Y(any(isnan(Y), 2), :) = [];

size(Y)

% ### 567x7; ser godt ud. Ca. 600 b�r kunne klare data processeringen

%% Data processering

% ligesom tidligere, skal vi have fjernet alle fejlm�linger / artefakter

% Kolonner: 1: HR, 2: RR, 3: SAT, 4: Puls, 5: sBP, 6: dBP, 7: pBP
% V�rdier der fjernes:
% HR: >300
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

size(Z)

Z(any(isnan(Z), 2), :) = [];

size(Z)

% ### 447x6. Det b�r give p�ne plots

%% Labels

% Vi henter attribute/feature names fra fil
attributeNames = X_RAW(1, 2:end);

% ### Vi skal have en class label / feature vector: v�rdierne, som PCA'en
% skal predictere
% Det kan v�re interessant at forudsige blodtryksv�rdierne, da de netop er
% dem vi ikke har kontinuerlige m�linger p�. Dvs. med tilstr�kkelig godt
% data, ville man kunne forudsige blodtrykket, baseret p� de kontinuerlige
% data m�l, og derved ogs� have en kontinuerlig (g�t) datav�rdi for
% patientes blodtryk, uden faktisk at foretage m�linger.
% Vi vil predictere sBP (da den er mest relevant klinisk) ::: nu bruger vi ogs� dBP og pBP i predictionen,
% det vil ikke v�re en god ide ifht ovenst�ende eksempel med predictioner;
% men vi har allerede kun seks features, og denne PCA er kun for at vise
% 'at vi kan'

% udv�lg classLabels og classValues

classLabels = Z(1:end,5);
classValues = unique(classLabels);

% vi fjerner vores classVector fra data matricen

Z(:,5) = [];
size(Z)
 
className = attributeNames(:,5);
attributeNames(:,5) = [];

% resterende kolonner er:
attributeNames

% HR, RR, Sat, Puls, dBP, pBP

%% initiel data visualisering

% attribute til kolonne tal
clear HR RR SAT Puls dBP pBP

HR = 1
RR = 2
SAT = 3
Puls = 4
dBP = 5
pBP = 6

% ### den tilbagest�ende data sidder nu i et 6 dimensionelt rum, hvor hver
% dimension svare til en feature. Det g�r visualisering af r� data sv�rt,
% da vi ikke kan plotte data i mere end 2-3 dimensioner (uden vi mister
% overblik)

% vi starter med at plotte de f�rste to kolonner
% scatter plots <3
figure(1)
title('data')
plot(Z(:,HR), Z(:,RR),'o')
axis tight

% fancy plot
figure(2)
title('Classes')
plot(Z(:,HR), Z(:,RR),'o')
C = length(attributeNames);
colors = get(gca, 'colororder');
%for c = 0:C-1
%    h = scatter(X(y==c,i), X(y==c,j), 50, 'o', ...
%                'MarkerFaceColor', colors(c+1,:), ...
%                'MarkerEdgeAlpha', 0, ...
%                'MarkerFaceAlpha', .5);
%end
legend(attributeNames);
axis tight
%xlabel(attributeNames{i});
%ylabel(attributeNames{j});

%% PCA computation
% nu laver vi PCA'en (variance explained), som fort�ller hvor meget hver
% attribute bidrager med i forudsigelsen af vores class feature (sBP).
% samtidig ser det cummulative bidrag, som fort�ller hvor gode vi
% gennemsnitligt kan v�re til at forudsige sBP baseret p� antal
% componenter.

% substraher mean fra data
stm = bsxfun(@minus, Z, mean(Z));

% Find PCA l�sningen ved at udregne singular value decomposition (SVD) af
% stm. SVD <3 (man bruger SVD konstant i EEG data behandling)
% i command window: doc svd

[U, S, V] = svd(stm);

% Comput�r 'variance explained'
% google: var explained
rho = diag(S).^2./sum(diag(S).^2);
threshold = 0.90;

% Plot 'variance explained'
figure(3)
hold on
plot(rho, 'x-')
plot(cumsum(rho), 'o-')
plot([0, length(rho)], [threshold, threshold], 'k--');
legend({'Individual', 'Cumulative', 'Threshold'}, ...
        'Location', 'best');
ylim([0, 1]);
xlim([1, length(rho)]);
grid minor
xlabel('Principal component');
ylabel('Variance explained value');
title('Variance explained by principal components');
hold off



