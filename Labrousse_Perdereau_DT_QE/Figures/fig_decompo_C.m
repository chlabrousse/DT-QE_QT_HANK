function fig_decompo_C(p, debut, final, no_QE, IRF) 

%% From no_QE, on ajoute tout ce qui compte pour le HH, calcul SS arrivée avec Pi 

QE = IRF ; tic_decompo = tic ;
SS_debut = debut ; T = p.T ;


%% 1) changement de R

% SS avec changement de R
value = debut ; [value.R,value.R_next] = deal(final.R) ;
    value = partial_VFI(p,value) ;
SS_R = value ;

% Transition
trans = no_QE ;
trans.VFI(:,T) = SS_R.V2.Ve ;
trans.R = QE.R ; 
    for t=T-1:-1:1 ;  trans = TRANS_backward(p, t, trans)  ;  end
    for t=1:T-1    ;  trans = TRANS_forward(p, trans , t, SS_debut)   ;  end 
trans_R = trans ;



%% 2) changement de Pi

% SS avec changement de Pi
SS_Pi = debut ;

% Transition
trans = no_QE ;
trans.VFI(:,T) = SS_Pi.V2.Ve ;
trans.Pi = QE.Pi ; 
    for t=T-1:-1:1 ;  trans = TRANS_backward(p, t, trans)  ;  end
    for t=1:T-1    ;  trans = TRANS_forward(p, trans , t, SS_debut)   ;  end 
trans_Pi = trans ;



%% 3) changement de w et de profit

% SS avec changement de w et de profit
value = debut ; 
value.w = final.w ; value.net_w = p.f.net_w(value) ;
value.RHS = final.RHS ; 
    value = partial_VFI(p,value) ;
SS_firm = value ;

% Transition
trans = no_QE ;
trans.VFI(:,T) = SS_firm.V2.Ve ;
trans.w = QE.w ; trans.net_w = p.f.net_w(trans) ;
trans.RHS = QE.RHS ; 
    for t=T-1:-1:1 ;  trans = TRANS_backward(p, t, trans)  ;  end
    for t=1:T-1    ;  trans = TRANS_forward(p, trans , t, SS_debut)   ;  end 
trans_firm = trans ;



%% 4) changement de tau

% SS avec changement de tau
value = debut ; value.tau = final.tau ; value.net_w = p.f.net_w(value) ;
    value = partial_VFI(p,value) ;
SS_tau = value ;

% Transition
trans = no_QE ;
trans.VFI(:,T) = SS_tau.V2.Ve ;
trans.tau = QE.tau ; trans.net_w = p.f.net_w(trans) ;
    for t=T-1:-1:1 ;  trans = TRANS_backward(p, t, trans)  ;  end
    for t=1:T-1    ;  trans = TRANS_forward(p, trans , t, SS_debut)   ;  end 
trans_tau = trans ;
disp(['Calcul de la Transition : ' num2str(toc(tic_decompo),2) ' secondes']) 



%% Plot l'interaction

% Deviations
dev_tot = QE.C_H - no_QE.C_H ;
dev_R = trans_R.C_H - no_QE.C_H ;
dev_Pi = trans_Pi.C_H - no_QE.C_H ;
dev_firm = trans_firm.C_H - no_QE.C_H ;
dev_tau = trans_tau.C_H - no_QE.C_H ;
dev_sum = dev_R + dev_Pi + dev_firm + dev_tau ;
dev_residu = dev_tot - dev_sum ;


% Plot
grey = [64, 64, 64]/255;
yellow = [0.9290 0.6940 0.1250];
green = [0.4660 0.6740 0.1880];    
red = [0.8500 0.3250 0.0980];
blue =  [0 0.4470 0.7410];    

DEC = 100*[dev_R ; dev_Pi ; dev_firm ; dev_tau]./no_QE.C_H ;
TOT = 100*dev_tot./no_QE.C_H ;

figure('Color', 'white');
subplot(2,2,1:2)
ba = bar(DEC(:,1:40)','stacked', 'BarWidth', 1, 'EdgeColor', 'none', 'FaceColor', 'flat') ; 
ba(1).CData = green; ba(2).CData = red; ba(3).CData = yellow; ba(4).CData = blue;
hold on ; plot(TOT(:,1:40)', 'k', 'LineWidth',5 ) ; hold off
yline(0, 'HandleVisibility','off', 'LineWidth',2)
legend('Interest rate','Inflation','Wage and profit','Tax rate','Total change', 'Interpreter', 'latex')
title("Consumption change decomposition",'Fontsize',30, 'Interpreter', 'latex')
ylabel("\% deviation", 'Fontsize', 20, 'Interpreter', 'latex');
xlabel("Time", 'Fontsize', 20, 'Interpreter', 'latex');
set(gca, 'TickLabelInterpreter', 'latex');
set(gca, 'FontSize', 20);




end