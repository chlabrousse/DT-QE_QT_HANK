function graph_Welfare_Distributive(p, debut, trans1, trans2, trans3, trans4)
 
    for i_TR = 1:3
        if i_TR == 1 ; TR = trans2 ; end
        if i_TR == 2 ; TR = trans3 ; end
        if i_TR == 3 ; TR = trans4 ; end
        % Changement welfare
        dU = TR.V2(1).Ve - trans1.V2(1).Ve ;
        % Mise en équivalent conso: log(C(1+x)) - log(C) = dU 
        % donc : log(1+x) = dU
        % donc : x = exp( dU ) - 1
        CE = exp( dU ) - 1 ;
        
        % Creation de la matrice ordonnée
        Z = p.s(:,2) ;
        F = p.s(:,1) ;
        dd = debut.density.tot ;
        LHS = debut.V2.C + debut.V2.mp + debut.V2.ap ;
        classement = LHS ;
        HH = [classement , dd, CE  ] ; 
        HH = sortrows(HH,1) ;
        
        % Trouver les indices
        nQ = 5 ; quantiles = 0/nQ:1/nQ:1 ; 
        for ii = 1:nQ 
            i_q = (cumsum(HH(:,2)) >= quantiles(ii) ) & (cumsum(HH(:,2)) <= quantiles(ii+1) ) ; 
            d_q = HH(i_q,2) ;
            share(ii) = sum( d_q ) ;
            CE_q_main(i_TR,ii) = HH(i_q,3)'*d_q/share(ii) ;
        end
    end
    
    
    %% Same By Z
    
    for i_TR = 1:3
        if i_TR == 1 ; TR = trans2 ; end
        if i_TR == 2 ; TR = trans3 ; end
        if i_TR == 3 ; TR = trans4 ; end
        % Changement welfare
        dU = TR.V2(1).Ve - trans1.V2(1).Ve ;
        % Mise en équivalent conso: log(C(1+x)) - log(C) = dU 
        % donc : log(1+x) = dU
        % donc : x = exp( dU ) - 1
        CE = exp( dU ) - 1 ;
        
        % Creation de la matrice ordonnée
        Z = p.s(:,2) ;
        F = p.s(:,1) ;
        dd = debut.density.tot ; dd = reshape(dd, p.nf, p.nz);
        LHS = debut.V2.C + debut.V2.mp + debut.V2.ap ; LHS  = reshape(LHS , p.nf, p.nz);
        CE = reshape(CE, p.nf, p.nz);
        for z = 1:p.nz
            classement = LHS(:,z) ;
            HH = [classement , dd(:,z)./sum(dd(:,z)), CE(:,z)  ] ; 
            HH = sortrows(HH,1) ;
            
            % Trouver les indices
            nQ = 5 ; quantiles = 0/nQ:1/nQ:1 ; 
            for ii = 1:nQ 
                i_q = (cumsum(HH(:,2)) >= quantiles(ii) ) & (cumsum(HH(:,2)) <= quantiles(ii+1) ) ; 
                d_q = HH(i_q,2) ;
                share(ii) = sum( d_q ) ;
                CE_q(i_TR,ii,z) = HH(i_q,3)'*d_q/share(ii) ;
            end
        end
        
        % Les IRF de conso
        for t=1:40
            dC = 100*(TR.V2(t).C./trans1.V2(t).C -1) ; 
            C1 = TR.density(:,t).*dC ;
            C_agreg(i_TR,t) = sum(C1) ;
            C2 = reshape(C1,p.nf,p.nz) ;
            C_q(t,:,i_TR) = sum(C2)./p.invdist ;     
        end

    end
    
    % Graphique en % :
    figure; set(gcf, 'color', 'w') ; l=5;    
    labels_Z = {'\ Low z', '\ High z', '\ All types'};  
    
    subplot(231) ; 
    X = reshape( [CE_q(2,:,1); CE_q(2,:,end)],2, nQ);
    plot(100*X','LineWidth',l); title('Benchmark: CB securities', 'Interpreter','latex') ;hold on; plot(100*CE_q_main(2,:),'LineWidth',l, 'LineStyle','--','Color',"black") 
    A; hold on; plot(100*CE_q_main(2,:),'LineWidth',l, 'LineStyle','--','Color',"black")
    legend(labels_Z, 'Box', 'off','FontSize', 30, 'Interpreter', 'latex', 'Location','southeast');        

    subplot(232) ; 
    X = reshape( [CE_q(1,:,1); CE_q(1,:,end)],2, nQ); 
    plot(100*X','LineWidth',l) ; title('Permanent QE', 'Interpreter','latex') ; 
    A; hold on; plot(100*CE_q_main(1,:),'LineWidth',l, 'LineStyle','--','Color',"black")
    
    subplot(233) ; 
    X = reshape( [CE_q(3,:,1); CE_q(3,:,end)],2, nQ);
    plot(100*X', 'LineWidth',l); title('QE + complete QT', 'Interpreter','latex') ; 
    A; hold on; plot(100*CE_q_main(3,:),'LineWidth',l, 'LineStyle','--','Color',"black")
    

    % IRF C par Z :
    subplot(234) ; 
    plot([C_q(:,1,2) , C_q(:,end,2) ],'LineWidth',l) ; title('Benchmark: CB securities', 'Interpreter','latex') ; 
    A2; hold on; plot(C_agreg(2,:),'LineWidth',l, 'LineStyle','--','Color',"black")
    subplot(235) ; 
    plot([C_q(:,1,1) , C_q(:,end,1)],'LineWidth',l) ; title('Permanent QE', 'Interpreter','latex') ; 
    A2; hold on; plot(C_agreg(1,:),'LineWidth',l, 'LineStyle','--','Color',"black")
    subplot(236) ; 
    plot([C_q(:,1,3) , C_q(:,end,3) ],'LineWidth',l) ; title('QE + complete QT', 'Interpreter','latex') ; 
    A2; hold on; plot(C_agreg(3,:),'LineWidth',l, 'LineStyle','--','Color',"black")
    
    
     function A
        labels = {'Q1', 'Q2', 'Q3', 'Q4', 'Q5'};  
        ylabel("CE (\%)", "interpreter","latex"); ax1=gca; xticks([1 2 3 4 5]); xticklabels(labels);  
        set(ax1,'TickLabelInterpreter', 'latex', 'Box', 'off', 'TickLength', [0 0], 'Fontsize', 30);
        yline(0) ;
    end
    function A2
        ylabel("C change (\%)", "interpreter","latex"); ax1=gca; xticks([0 10 20 30 40 ]); 
        set(ax1,'TickLabelInterpreter', 'latex', 'Box', 'off', 'TickLength', [0 0], 'Fontsize', 30);    
        yline(0);
    end


end

