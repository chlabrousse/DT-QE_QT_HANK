function fig_BC_change

    % Run the code without F
    addpath('Figures/Code with no F')    
    p = noF_parametres ;
    size_QE = 0.1 ;
    d_CB_debut = 0.1 ; d_CB_final = d_CB_debut + size_QE ; 
    d_CB_midle = mean([d_CB_debut,d_CB_final]) ;

    % Calcul des SS
    debut = noF_convergence(p,d_CB_debut) ; p.debut = debut ;
    midle = noF_convergence(p,d_CB_midle) ;




%% Figure

    dens1 = debut.density.tot;
    dens2 = debut.density.tot;
    a = p.s(:,1) ; m = p.s(:,2) ; Z = p.s(:,3) ;

    debut.source = (debut.R-1)*a + m*(1/debut.Pi - 1) ...
               + debut.net_w.*Z.*debut.V2.nS ...
               + debut.Transfert + debut.profit*Z/p.prod_moyenne ; 
    debut.use  = debut.V2.C + debut.V2.mp - m + debut.V2.ap - a;
    % plot(debut.source-debut.use)

    midle.source = (midle.R-1)*a + m*(1/midle.Pi - 1) ...
               + midle.net_w.*Z.*midle.V2.nS ...
               + midle.Transfert + midle.profit*Z/p.prod_moyenne ; 
    midle.use  = midle.V2.C + (midle.V2.mp - m) + (midle.V2.ap - a);
    % plot(midle.source-midle.use)

    % aggregate by Z
    debut.source_Z = sum(reshape(dens1.*debut.source, p.na*p.nm, p.nz)); 
    midle.source_Z = sum(reshape(dens2.*midle.source, p.na*p.nm, p.nz)); 

    debut.m_pi_Z = sum(reshape(dens1.*(m*(1/debut.Pi - 1)), p.na*p.nm, p.nz)); 
    debut.ra_Z = sum(reshape(dens1.*(debut.R-1).*a, p.na*p.nm, p.nz)); 
    debut.li_Z = sum(reshape(dens1.*debut.net_w.*Z.*debut.V2.nS, p.na*p.nm, p.nz)); 
    debut.PI_Z = sum(reshape(dens1.*debut.profit.*Z/p.prod_moyenne, p.na*p.nm, p.nz)); 

    midle.m_pi_Z = sum(reshape(dens2.*(m*(1/midle.Pi - 1)), p.na*p.nm, p.nz)); 
    midle.ra_Z = sum(reshape(dens2.*(midle.R-1).*a, p.na*p.nm, p.nz)); 
    midle.li_Z = sum(reshape(dens2.*midle.net_w.*Z.*midle.V2.nS, p.na*p.nm, p.nz)); 
    midle.PI_Z = sum(reshape(dens2.*midle.profit.*Z/p.prod_moyenne, p.na*p.nm, p.nz)); 

    debut.use_Z = sum(reshape(dens1.*debut.use, p.na*p.nm, p.nz)); 
    midle.use_Z = sum(reshape(dens2.*midle.use, p.na*p.nm, p.nz)); 

    debut.C_Z = sum(reshape(dens1.*debut.V2.C, p.na*p.nm, p.nz)); 
    debut.m_Z = sum(reshape(dens1.*(debut.V2.mp - m), p.na*p.nm, p.nz)); 
    debut.a_Z = sum(reshape(dens1.*(debut.V2.ap - a), p.na*p.nm, p.nz)); 

    midle.C_Z = sum(reshape(dens2.*midle.V2.C, p.na*p.nm, p.nz)); 
    midle.m_Z = sum(reshape(dens2.*(midle.V2.mp - p.s(:,2)), p.na*p.nm, p.nz)); 
    midle.a_Z = sum(reshape(dens2.*(midle.V2.ap - p.s(:,1)), p.na*p.nm, p.nz)); 

   
    SOURCE = vertcat( midle.li_Z./debut.li_Z - 1, midle.ra_Z./debut.ra_Z - 1, midle.m_pi_Z./debut.m_pi_Z - 1, ...
        midle.PI_Z./debut.PI_Z -1).*[debut.li_Z; debut.ra_Z;  debut.m_pi_Z;  debut.PI_Z]./repmat(debut.source_Z,4,1).*100;    
    
    USE = vertcat(midle.C_Z./debut.C_Z - 1, midle.m_Z./debut.m_Z -1, midle.a_Z./debut.a_Z -1).*[debut.C_Z; debut.m_Z ;  debut.a_Z]./repmat(debut.use_Z,3,1).*100;    

    final_source = (midle.source_Z./debut.source_Z-1)*100;
    final_use = (midle.use_Z./debut.use_Z-1)*100;


    %% Define colors
    yellow = [0.9290 0.6940 0.1250];
    green = [0.4660 0.6740 0.1880];    
    red = [0.8500 0.3250 0.0980];
    blue =  [0 0.4470 0.7410];    
    purple = [0.4940 0.1840 0.5560];
    blue_light = [0.3010 0.7450 0.9330];
    red_dark = [0.6350 0.0780 0.1840];
    
    %% Figure by Z
    figure;set(gcf, 'color', 'w');  
    boundZ = [-1.5 1] ; boundQ = [-2 1] ;


    subplot(2,2,1)
    ba = bar( USE' , 'stacked', 'EdgeColor', 'none', 'BarWidth', .8, 'FaceColor', 'flat');
    ba(1).CData = blue; ba(2).CData = red; ba(3).CData = yellow;
    ax1=gca; ax1.FontSize = 30; 
    ylabel('\%', Interpreter='latex');
    ax1.Box = 'off'; % Enlève l'encadrement noir
    ax1.TickLength = [0 0]; % Enlève les tirets noirs de l'axe des abscisses

    hold on ; plot(final_use,'oblack','MarkerFaceColor','black','MarkerSize',20) ;
    title('a. Left-hand side, by Z','FontSize',35 , 'Interpreter', 'latex'); 
    legend({'\ Consumption : $c$', '\ Money saving : $m_{t+1} - m_t$', '\ Asset saving : $a_{t+1} - a_t$', '\ Total'}, ...
        'Box', 'off','FontSize',25, 'Interpreter', 'latex', 'Location','southeast');
    ylim(boundZ);

    subplot(2,2,2)
    ba = bar( SOURCE' , 'stacked', 'EdgeColor', 'none', 'BarWidth', .8, 'FaceColor', 'flat');
    ba(1).CData = purple; ba(2).CData = green; ba(3).CData = blue_light;  ba(4).CData = red_dark; 
    ax2 = gca; ax2.FontSize = 30;   
    ax2.Box = 'off'; % Enlève l'encadrement noir
    ylabel('\%', Interpreter='latex');
    ax2.TickLength = [0 0]; % Enlève les tirets noirs de l'axe des abscisses

    hold on ; plot(final_source,'oblack','MarkerFaceColor','black','MarkerSize',20) ;
    title('b. Right-hand side, by Z' ,'FontSize', 35, 'Interpreter', 'latex'); 
    legend({'\ Labor income : $(1-\tau)wl$', '\ Capital income : $ra$','\ Inflation tax : $m\left(\frac{1}{\pi} - 1\right)$',...
        '\ Profit : $\Pi_i $', '\ Total'},'Box', 'off','FontSize',25, 'Interpreter', 'latex');

    xlabels = {'Z1', 'Z2', 'Z3', 'Z4', 'Z5'};
    set(ax1, 'XTickLabel', xlabels, 'TickLabelInterpreter', 'latex'); 
    set(ax2, 'XTickLabel', xlabels, 'TickLabelInterpreter', 'latex'); 
    ylim(boundZ)


    %% Figure by Q
    Q_debut = f_quantile(p, 5, dens1, debut) ;
    Q_midle = f_quantile(p, 5, dens2, midle) ;

    debut.source_Q = (debut.R-1)*Q_debut.a ...
               + Q_debut.m/debut.Pi - Q_debut.m ...
               + Q_debut.NLI ...
               + Q_debut.Profit ; 
    debut.use_Q  = Q_debut.C + Q_debut.mp - Q_debut.m + Q_debut.ap - Q_debut.a;
    % plot(debut.source-debut.use)

    midle.source_Q = (midle.R-1)*Q_midle.a ...
               + Q_midle.m/midle.Pi - Q_midle.m ...
               + Q_midle.NLI ...
               + Q_midle.Profit ; 
    midle.use_Q  = Q_midle.C + Q_midle.mp - Q_midle.m + Q_midle.ap - Q_midle.a;
    % plot(midle.source-midle.use)
    Q_midle.ra_Q = (midle.R-1)*Q_midle.a;
    Q_debut.ra_Q = (debut.R-1)*Q_debut.a;
    Q_midle.m_pi_Q = Q_midle.m/midle.Pi - Q_midle.m;
    Q_debut.m_pi_Q = Q_debut.m/debut.Pi - Q_debut.m;

    Q_midle.m_Q = Q_midle.mp - Q_midle.m ;
    Q_midle.a_Q = Q_midle.ap - Q_midle.a ;
    Q_debut.m_Q = Q_debut.mp - Q_debut.m ;
    Q_debut.a_Q = Q_debut.ap - Q_debut.a ;

    SOURCE_Q = vertcat( Q_midle.NLI./Q_debut.NLI - 1, Q_midle.ra_Q./Q_debut.ra_Q - 1, Q_midle.m_pi_Q./Q_debut.m_pi_Q  - 1,...
        Q_midle.Profit./Q_debut.Profit -1).*[Q_debut.NLI;  Q_debut.ra_Q;  Q_debut.m_pi_Q;  Q_debut.Profit]./repmat(debut.source_Q,4,1).*100;    
    
    USE_Q = vertcat( Q_midle.C./Q_debut.C - 1, Q_midle.m_Q./Q_debut.m_Q -1, Q_midle.a_Q./Q_debut.a_Q -1).*[Q_debut.C; Q_debut.m_Q ;  Q_debut.a_Q]./repmat(debut.use_Q,3,1).*100;    

    final_source_Q = (midle.source_Q./debut.source_Q-1)*100;
    final_use_Q = (midle.use_Q./debut.use_Q-1)*100;

     %% Figure by Q
    subplot(2,2,3)
    ba = bar( USE_Q' , 'stacked', 'EdgeColor', 'none', 'BarWidth', .8, 'FaceColor', 'flat');
    ba(1).CData = blue; ba(2).CData = red; ba(3).CData = yellow;
    ax1=gca; ax1.FontSize = 30;  
    ylabel('\%', Interpreter='latex');
    ax1.Box = 'off'; % Enlève l'encadrement noir
    ax1.TickLength = [0 0]; % Enlève les tirets noirs de l'axe des abscisses

    hold on ; plot(final_use_Q,'oblack','MarkerFaceColor','black','MarkerSize',20) ;
    title('a. Left-hand side, by quintile','FontSize',35 , 'Interpreter', 'latex'); 
    legend({'\ Consumption : $c$', '\ Money saving : $m_{t+1} - m_t$', '\ Asset saving : $a_{t+1} - a_t$', '\ Total'}, 'Box', 'off','FontSize',25, 'Interpreter', 'latex', 'Location','southeast');
    ylim(boundQ);

    subplot(2,2,4)
    ba = bar( SOURCE_Q' , 'stacked', 'EdgeColor', 'none', 'BarWidth', .8, 'FaceColor', 'flat');
    ba(1).CData = purple; ba(2).CData = green; ba(3).CData = blue_light;  ba(4).CData = red_dark; 
    ax2 = gca; ax2.FontSize = 30; set(gcf, 'color', 'w');   
    ax2.Box = 'off'; % Enlève l'encadrement noir
    ylabel('\%', Interpreter='latex');
    ax2.TickLength = [0 0]; % Enlève les tirets noirs de l'axe des abscisses

    hold on ; plot(final_source_Q,'oblack','MarkerFaceColor','black','MarkerSize',20) ;
    title('b. Right-hand side, by quintile' ,'FontSize', 35, 'Interpreter', 'latex'); 
    legend({'\ Labor income : $(1-\tau)wl$', '\ Capital income : $ra$','\ Inflation tax : $m\left(\frac{1}{\pi} - 1\right)$',...
        '\ Profit : $\Pi_i $', '\ Total'},'Box', 'off','FontSize',25, 'Interpreter', 'latex');

    Qlabels = {'Q1', 'Q2', 'Q3', 'Q4', 'Q5'};
    set(ax1, 'XTickLabel', Qlabels, 'TickLabelInterpreter', 'latex'); 
    set(ax2, 'XTickLabel', Qlabels, 'TickLabelInterpreter', 'latex'); 
    ylim(boundQ)



rmpath('Figures - MAIN/Code with no F')

end