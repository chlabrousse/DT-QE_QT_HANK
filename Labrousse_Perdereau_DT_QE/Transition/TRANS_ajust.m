function trans = TRANS_ajust(p, trans, inv_J, debut, final)

%% 1) Calcul de l'erreur et nouveau guess
T = p.T ;
Erreur = TRANS_clearing(p , trans) ; 
% 
% clearingA = trans.demand_D  - trans.supply_D ; 
% clearingN = trans.N_H - trans.N_demand ;
% clearingT = trans.tau - trans.tau_implied ;
% clearingW = trans.w - trans.w_implied ;
% Erreur = [ clearingA ; clearingN ; clearingT ; clearingW]' ;



%% Affichage
trans.it = trans.it+1; k = 1:T-1 ;
Erreur_pourcent = 100*Erreur./[ trans.demand_D(k) ; trans.N_H(k) ; trans.tau_implied(k) ; trans.w(k) ]' ;
trans.Erreur_max = max( abs(Erreur_pourcent(k,:) ) ) ; 
disp(['It '  num2str(trans.it) ' -- Diff A: '  num2str(trans.Erreur_max(1),2)   ' -- Diff w: '  num2str(trans.Erreur_max(4),2)  ...
    ' -- Diff N: '  num2str(trans.Erreur_max(3),2) ' -- Diff tau: '  num2str(trans.Erreur_max(4),2) ' -- Time: '  num2str(toc,2)   ]) ;

% Sauvegarde pour IRF
[trans.Pi_save,  trans.Y_save, trans.tau_save, trans.w_save] = deal(trans.Pi, trans.Y, trans.tau, trans.w); 


%% Nouveau guess
trans.dampening = 1; Erreur = Erreur(k,:) ;
trans.x = trans.x - (inv_J*trans.dampening*Erreur(:))';
x2 = reshape(trans.x,T-1,4) ;
trans.Pi(k)  = x2(:,1); 
trans.Y(k)   = x2(:,2); 
trans.tau(k) = x2(:,3); 
trans.w(k)   = x2(:,4); 


end

