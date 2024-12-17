function inv_mat_jaco = TRANS0_Fake_News2(p, SS, choc, scenario)

% Init
T = p.T ; chocX = 0.001 ; tic 
Erreur_init = [0,0,0,0] ;
density_trans(:,1)   = SS.density.tot  ;
trans_init.VFI(:,T)  = SS.V2.Ve ;
trans_init.m_H(T) = SS.m_H ; 
trans_init.d_H(T) = SS.d_H ; 
list_var = ["Pi","Y","tau","w"] ; 
for var = list_var
    trans_init.(var)(1:T) = SS.(var) ;
end


%% Jacobienne de la dernière période
for var = list_var
    
    % 1) Création des chocs
    trans_Jaco = trans_init ; 
    trans_Jaco.(var)(T-1) = SS.(var) + chocX ;

    % 2) Backward et calcul des matrices de transition
    trans_Jaco = TRANS_BC(p, trans_Jaco, SS, SS, choc) ;
    for t=T-1:-1:1  
        trans_Jaco = TRANS_backward(p, t, trans_Jaco)  ;  
        a(t).mat = f_mat_transition_1asset(p, trans_Jaco.V2(t).fp ) ;
    end 
    
    % 3) Calcul des clearing pour le choc à chaque période
    for s=1:T-1 % Date du choc

        Jaco_tempo = trans_init ;
        % 3.1) Calcul des clearing côté ménages
        for t=1:T-1
            if t > s        % Si on est après le choc, même matrice et rule qu'au SS
                matrice = SS.mat_transition ;
                rule  = SS.V2 ;  
            elseif t <= s   % Si on est avant ou pendant le choc
                X = (T-1) - (s-t) ; % distance au choc 
                matrice = a(X).mat  ;
                rule  = trans_Jaco.V2(X) ;  
            end
            density_trans(:,t+1) = matrice*density_trans(:,t) ;
            Jaco_tempo.d_H(t) = rule.ap'*density_trans(:,t) ;
            Jaco_tempo.N_H(t) = (p.s(:,2).*rule.nS)'*density_trans(:,t) ;
            Jaco_tempo.m_H(t) = rule.mp'*density_trans(:,t) ;
        end 
        
        % 3.2) Valeurs nécessaires firme et gouvernement
        % Choc
        Jaco_tempo.(var)(s) = SS.(var) + chocX ;
        % Valeurs nécessaires
        Jaco_tempo = TRANS_BC(p, Jaco_tempo, SS, SS, choc) ;
        Jaco_tempo = TRANS_Gouv(p, Jaco_tempo, SS, SS, choc, scenario) ;
        
        % 3.3) Calcul des clearing et création de matrice
        Erreur  = TRANS_clearing(p, Jaco_tempo) - Erreur_init ; 
        mat_derivees.(var)(:,s) = Erreur(:)/chocX ; 
        % 
        % dClearD = (Jaco_tempo.demand_D(1:T-1) - Jaco_tempo.supply_D(1:T-1) )' ; 
        % dClearN = (Jaco_tempo.N_H(1:T-1)      - Jaco_tempo.N_demand(1:T-1) )' ;
        % dClearT = (Jaco_tempo.tau(1:T-1)      - Jaco_tempo.tau_implied(1:T-1))' ;
        % dClearW = (Jaco_tempo.w(1:T-1)        - Jaco_tempo.w_implied(1:T-1))' ;
        % mat_derivees.(var)(:,s) = [dClearD ; dClearN ; dClearT ; dClearW]/chocX ; 
    end 
end


%% Creation de la matrice complete
mat_jaco = [] ;
for var = list_var ; mat_jaco = [mat_jaco , mat_derivees.(var)] ; end
inv_mat_jaco = inv(mat_jaco) ;
disp(['Calcul de la Jacobienne : ' num2str(toc,2) ' secondes']) 

end
