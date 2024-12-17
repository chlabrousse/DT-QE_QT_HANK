function vec = f_quantile(p, n_quantile, density, SS)

    %% 1) Graphs per quantile
    size_quantile        = 1/n_quantile ;
    liste_quantile    = size_quantile:size_quantile:1 ;
    index_quantile(1)  = 0 ; 

    % Variables
    a = p.s(:,1); m = p.s(:,2); z = p.s(:,3); V = SS.V2 ;
    NLI       = (1-SS.tau).*SS.w.*z.*V.nS ;
    ProfitI   = SS.profit*z/p.prod_moyenne ;
    RHS = NLI + SS.R*a + m/SS.Pi + ProfitI ;
    LHS = V.C + V.mp + V.ap ;
    saveA = a - V.ap ; saveM = m - V.mp ; 
    LHS_alter = V.C + saveA + saveM ;
    % Creation de la liste
    nom1 = ["L","ap","mp","z","Profit","NLI","a","m"] ;
    liste1 = [V.nS, V.ap, V.mp, z, ProfitI, NLI, a, m] ;
    nom2 = ["LHS", "RHS","C","u","saveA","saveM","LHS_alter"] ;
    liste2 = [LHS, RHS, V.C, V.u, saveA , saveM , LHS_alter] ;
    liste = [liste1 , liste2] ; 
    nom = [nom1 , nom2] ;
    
    % Creer grille
    classement = RHS ;
    M  = [density, classement, liste] ; 
    M  = sortrows(M,2); 
    
    for i_q = 1:n_quantile    
        quantile = liste_quantile(i_q) ;
        index_quantile(i_q+1) = find( cumsum( M(:,1) ) < quantile, 1, 'last' ) ;
        range = (index_quantile(i_q)+1):index_quantile(i_q+1) ;

        if i_q < n_quantile
            % Calcul de l'erreur pour avoir un quantile parfait
            erreur = size_quantile - sum(M( range, 1 )) ; 
            % Derniere ligne du quantile et valeur initiale 
            last_line = M( index_quantile(i_q+1),:) ; 
            init = last_line(2:end)*last_line(1) ;
            % Premiere ligne du quantile suivant et target
            next_line = M( index_quantile(i_q+1)+1,:) ;
            target = init + next_line(2:end)*erreur ;
            % Remplacement des proba :
            M( index_quantile(i_q+1),1)   = M( index_quantile(i_q+1),1)   + erreur ;
            M( index_quantile(i_q+1)+1,1) = M( index_quantile(i_q+1)+1,1) - erreur ;
            % Creation d'une nouvelle ligne de valeurs
            new_values = target/M( index_quantile(i_q+1),1) ;
            M( index_quantile(i_q+1),2:end)  = new_values ;
        end      
        sum_decile(i_q) = sum(M( range, 1 )) ;
        share = M(range,1)/sum_decile(i_q);
        [~,n_liste] = size(liste) ; 
        for n = 1:n_liste
            vec.(nom(n))(i_q) = M(range,2+n)'*share ;
        end
    end



  
end