function fig_IRF_2_mix(trans_ref1, trans1, trans2)
   
    T = 40 ; l = 5; % linewidth
    figure ; set(gcf, 'color', 'w') ;
        subplot(331) 
    d_H_diff =  ([trans1.d_H;trans2.d_H]'./[trans_ref1.d_H; trans_ref1.d_H]'-1)*100;
    plot(  d_H_diff(1:T,:), 'linewidth',l ), title('Debt held by households', 'Interpreter','latex') ; A ; 
    legend('\ CB securities','\ Treasury Support', 'FontSize', 40, 'Interpreter','latex','Box','off');
    subplot(332) 
    m_diff = [trans1.m_supply; trans2.m_supply]'./[trans_ref1.m_supply;trans_ref1.m_supply]' ;
    plot(  100*(m_diff(1:T,:)-1), 'linewidth',l ), title('Money', 'Interpreter','latex') ; A ;  yline(0,'linewidth',l-3) ; 
        subplot(333)
    tau_diff = [trans1.tau; trans2.tau]'- [trans_ref1.tau;trans_ref1.tau]' ;
    plot(  100*tau_diff(1:T,:), 'linewidth',l ), title('Tax rate', 'Interpreter','latex') ; A; ylabel("\% bp", "interpreter","latex"); yline(0,'linewidth',l-3) ;
        subplot(337)
    C_diff = [trans1.C_H;trans2.C_H]'./[trans_ref1.C_H;trans_ref1.C_H]' ;
    plot(  100*(C_diff(1:T,:)-1), 'linewidth',l ), title('Consumption', 'Interpreter','latex') ; A;   yline(0,'linewidth',l-3) ;
        subplot(338) 
    Pi_diff = [trans1.Pi; trans2.Pi]'- [trans_ref1.Pi;trans_ref1.Pi]' ;
    plot(  100*Pi_diff(1:T,:), 'linewidth',l ), title('Inflation', 'Interpreter','latex') ; A; ylabel("\% bp", "interpreter","latex");  yline(0,'linewidth',l-3) ;
          subplot(334) 
   Phi_diff = [trans1.Profit_CB; trans2.Profit_CB]'-[trans_ref1.Profit_CB;trans_ref1.Profit_CB]' ; 
   plot(  Phi_diff(1:T,:), 'linewidth',l ), title('CB profit', 'Interpreter','latex') ; A;  ylabel('') ; yline(0,'linewidth',l-3) ;   
   subplot(335) 
    X_diff = [trans1.X_CB; trans2.X_CB]' - [trans_ref1.X_CB; trans_ref1.X_CB]';
    plot(  X_diff(1:T,:), 'linewidth', l ), title('CB securities', 'Interpreter','latex') ; A ; ylabel('') ;  yline(0,'linewidth',l-3) ; 
%         subplot(336) 
%     d_H_diff = [trans2.d_H; trans3.d_H; trans4.d_H]' ;
%     plot(  d_H_diff(1:T,:), 'linewidth',3 ), title('Debt held by HH', 'Interpreter','latex') ; A ; ylabel('') ;  yline(debut.d_H) ; 
        subplot(336) 
    d_R_diff = [trans1.R; trans2.R]' - [trans_ref1.R;trans_ref1.R]';
    plot(  100*d_R_diff(1:T,:), 'linewidth',l ), title('Real interest rate', 'Interpreter','latex') ; A ;ylabel("\% bp", "interpreter","latex");  yline(0,'linewidth',l-3) ;   
    
    function A
        ylabel("\%", "interpreter","latex"); 
        ax1=gca; ax1.FontSize = 40 ; 
        set(ax1,'TickLabelInterpreter', 'latex', 'Box', 'off', 'TickLength', [0 0], 'Fontsize', 30);
    end


end

