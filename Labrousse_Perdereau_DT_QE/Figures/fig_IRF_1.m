function fig_IRF_1(trans1, debut)
   
    T = 40 ;
    l = 5;
    figure ; set(gcf, 'color', 'w') ;
    subplot(331) 
    plot(  trans1.Z(1:T), 'linewidth',l ), title('Shifter Z', 'Interpreter','latex') ; A ; ylabel('') ; yline(debut.Z,'linewidth',l-3) ; 
        subplot(332) 
    plot(  100*trans1.i_nom(1:T), 'linewidth',l ), title('Nominal interest rate (\%)', 'Interpreter','latex') ; A;  yline(100*debut.i_nom,'linewidth',l-3) ; 
    subplot(333) 
    plot(  100*(trans1.m_supply(1:T)./debut.m_supply-1), 'linewidth',l ), title('Money (\% w.r.t. SS)', 'Interpreter','latex') ; A ;  ylabel("\%", "interpreter","latex");  yline(0,'linewidth',l-3) ; 
        subplot(334)
    plot(  100*trans1.tau(1:T), 'linewidth',l ), title('Tax rate (\%)', 'Interpreter','latex') ; A;   yline(100*debut.tau,'linewidth',l-3) ;
        subplot(335)
    plot(  100*(trans1.C_H(1:T)./debut.C_H-1), 'linewidth',l ), title('Consumption (\% w.r.t. SS)', 'Interpreter','latex') ; A;   ylabel("\%", "interpreter","latex");  yline(0,'linewidth',l-3) ;
        subplot(336) 
    plot(  100*(trans1.Pi(1:T)-1), 'linewidth',l ), title('Inflation (\%)', 'Interpreter','latex') ; A;   yline(100*(debut.Pi-1),'linewidth',l-3) ;
      subplot(337) 
    plot(  trans1.Profit_CB(1:T), 'linewidth',l ), title('CB profit', 'Interpreter','latex') ; A;   ylabel('') ; yline(debut.Profit_CB,'linewidth',l-3) ;   
   subplot(338) 
    plot(  trans1.X_CB(1:T), 'linewidth',l ), title('CB securities', 'Interpreter','latex') ; A ; ylabel('') ;  yline(0,'linewidth',l-3) ; 
        subplot(339) 
    plot(  100*(trans1.R(1:T)-1), 'linewidth',l ), title('Real interest rate (\%)', 'Interpreter','latex') ; A ; ylabel('') ;  yline(100*(debut.R-1),'linewidth',l-3) ; 
        
    
    function A
        %ylabel("\%", "interpreter","latex"); 
        ax1=gca; ax1.FontSize = 40 ;         
        set(ax1,'TickLabelInterpreter', 'latex', 'Box', 'off', 'TickLength', [0 0], 'Fontsize', 30);
    end


end

