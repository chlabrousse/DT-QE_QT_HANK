
addpath('Figures')    

%% 1) Transmission channels of balance sheet expansion
%% 1.2) The fiscal transmission of Central Bank losses
% Figure 1: Net revenue and remittance to the Treasury for Fed and Banque de France

% Losses Fed
data = readtable('data_Fed_Losses.xlsx');
Profit_Fed = table2array(data(3,12:20)) ;
Remittance_Fed = table2array(data(2,12:20)) ;

% Profit BDF 
Profit_BDF = [ 4.5, 5.7, 6, 6.9, 6.2, 4.9, 5.5, 5.7, -12.44];
Remittance_BDF = [ 3.7, 4.2, 4.8, 5.75, 6, 3.8, 2.2, 1,  0];
% GDP
GDP_US = [18295,  18804, 19612, 20656, 21521, 21322, 23594, 25744, 27360 ];
GDP_FR = [2198,2234,2297,2363,2437,2317,2502,2639,2803] ;

% Autre
labels = { '2015', '2016', '2017', '2018', '2019','2020','2021','2022','2023' };
bar_width = 0.35; % Largeur de chaque barre
num_bars = length(labels) ; % Nombre de barres

% Création du graphique à barres
figure;
bar(100*[Profit_Fed; Profit_BDF]'./[GDP_US; GDP_FR]','EdgeColor', 'none', 'BarWidth', 0.8);
hold on;

% Tracer des points pour la remise de la Fed
x_pos = (1:num_bars) - bar_width/2 + 0.03; 
plot(x_pos, 100*Remittance_Fed./GDP_US,'oblack','MarkerFaceColor', 'black','MarkerSize',20);
% Tracer des points pour la remise de la BCE
x_pos_BDF = (1:num_bars) + bar_width/2 - 0.03 ;
plot(x_pos_BDF, 100*Remittance_BDF./GDP_FR,'oblack','MarkerFaceColor', 'black','MarkerSize',20);

% axes X and Y
xticklabels(labels); xticks(1:numel(labels));
ylabel('\% GDP', 'interpreter', 'latex','Fontsize',30) ;

% Legend
[~, objh] = legend({'\ Profits Fed','\ Profits Banque de France','\ Remittances'}, 'interpreter', 'latex', 'Box', 'off', 'Location', 'northwest', 'Fontsize',50) ; 
objhl = findobj(objh, 'type', 'patch');
set(objhl, 'Markersize', 40);    
ax1=gca;   set(gcf, 'color', 'w'); set(ax1, 'Box', 'off', 'TickLength', [0 0], 'XColor', 'black', 'YColor', 'black', 'FontSize', 40, 'XTickLabel', labels, 'TickLabelInterpreter', 'latex');



%% A) Appendix
%% A.2) Data
data_CB = readtable('Data_Schularick_extraction.xlsx');

% Figure 9: Average assets and government debt held by central banks
figure;
set(gcf, 'color', 'w');
plot(data_CB.Year, data_CB.Assets_held, data_CB.Year, data_CB.Public_debt_held,data_CB.Year, data_CB.Ratio_debt_held, 'LineWidth',5);
% Axes 
ax1=gca; ax1.FontSize = 45 ;         
set(ax1,'TickLabelInterpreter', 'latex', 'Box', 'off', 'TickLength', [0 0], 'Fontsize', 45);
ylabel("\% GDP", "interpreter","latex"); 
xlabel("Year", "interpreter","latex"); 
legend("\ Total assets held by CB over GDP","\ Public debt held by CB over GDP", "\ Public debt held by CB other total public debt", "interpreter","latex","Fontsize",45,"box","off"); 




