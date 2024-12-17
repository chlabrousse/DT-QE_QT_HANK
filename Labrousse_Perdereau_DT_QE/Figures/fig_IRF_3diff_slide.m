function fig_IRF_3diff_slide(trans_ref, trans1, trans2, trans3, N)
  
T = 40 ; l = 5; % linewidth

for n = 1:N

    figure ; set(gcf, 'color', 'w') ;

    subplot(331) 
    d_CB_diff = [trans1.d_CB; trans2.d_CB; trans3.d_CB]' ;
    SET_Off(d_CB_diff , n) ; title('CB balance sheet', 'Interpreter','latex') ; 
    A ; ylabel('') ;
    legend('\ QE','\ QE + partial QT','\ QE + complete QT', 'FontSize', 40, 'Interpreter','latex','Box','off');
    
    subplot(332) 
    m_diff = 100*([trans1.m_supply; trans2.m_supply; trans3.m_supply]'./trans_ref.m_supply' -1) ;
    SET_Off(m_diff , n) ; title('Money', 'Interpreter','latex') ; A ;  yline(0,'linewidth',l-3) ; 
        
    subplot(333)
    tau_diff = 100*([trans1.tau; trans2.tau; trans3.tau]'- trans_ref.tau') ;
    SET_Off(tau_diff , n) ; title('Tax rate', 'Interpreter','latex') ; A; ylabel("\% bp", "interpreter","latex"); yline(0,'linewidth',l-3) ;
    
    subplot(337)
    C_diff = 100*([trans1.C_H; trans2.C_H; trans3.C_H]'./trans_ref.C_H'-1) ;
    SET_Off(C_diff , n) ; title('Consumption', 'Interpreter','latex') ; A;   yline(0,'linewidth',l-3) ;
    
    subplot(338) 
    Pi_diff = 100*([trans1.Pi; trans2.Pi; trans3.Pi]'- trans_ref.Pi') ;
    SET_Off(Pi_diff , n) ; title('Inflation', 'Interpreter','latex') ; A; ylabel("\% bp", "interpreter","latex");  yline(0,'linewidth',l-3) ;
   
    subplot(334) 
    Phi_diff = [trans1.Profit_CB; trans2.Profit_CB; trans3.Profit_CB]'-trans_ref.Profit_CB' ; 
    SET_Off(Phi_diff , n) ; title('CB profit', 'Interpreter','latex') ; A;  ylabel('') ; yline(0,'linewidth',l-3) ;   
    
    subplot(335) 
    X_diff = [trans1.X_CB; trans2.X_CB; trans3.X_CB]' ;
    SET_Off(X_diff, n) ; title('CB securities', 'Interpreter','latex') ; A ; ylabel('') ;  yline(0,'linewidth',l-3) ; 
    
    subplot(336) 
    d_R_diff = 100*([trans1.R; trans2.R; trans3.R]' - trans_ref.R');
    SET_Off(d_R_diff, n) ; title('Real interest rate', 'Interpreter','latex') ; A ;ylabel("\% bp", "interpreter","latex");  yline(0,'linewidth',l-3) ;   

end

    function A  % mettre les parametres graphiques
        ylabel("\%", "interpreter","latex"); 
        ax1=gca; ax1.FontSize = 40 ; 
        set(ax1,'TickLabelInterpreter', 'latex', 'Box', 'off', 'TickLength', [0 0], 'Fontsize', 30);
    end

    function SET_Off(VEC, n) 
        % Tracer les graphes
        h1 = plot(  VEC(1:T,1), 'linewidth',l ) ; 
        hold on ; h2 = plot(  VEC(1:T,2), 'linewidth',l ) ; 
                  h3 = plot(  VEC(1:T,3), 'linewidth',l ) ; 

        % Supprimer certaines lignes
        if n == 1 ; end % tous les graphes pour x=1
        if n == 2 ; set(h2,'visible','off') ; end % pas le midle
        if n == 3 ; set(h2,'visible','off') ; set(h3,'visible','off') ; end % pas le QT
    end


end

