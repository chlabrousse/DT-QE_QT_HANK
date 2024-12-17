
%% Calcul de l'erreur 
SS.it = SS.it + 1 ;
Erreur = [SS.demand_D - SS.supply_D ; SS.N_H - SS.N_demand ; SS.tau - SS.tau_implied ] ;
SS.Erreur_pourcent = 100*Erreur./[ p.d_steady ; SS.N_H ; SS.tau_full ] ;
if 1==1 
    disp(['Diff A: '  num2str(SS.Erreur_pourcent(1),1) ' --- Diff N: '  num2str(SS.Erreur_pourcent(2),1) ...
        ' --- Diff G: ' num2str(SS.Erreur_pourcent(3),1) ' --- It : '  num2str(SS.it)  ]) ;
end


%% Calcul de la Jacobienne 

if mod(SS.it,100) == 1
    choc = 0.001 ;
    for variable = 1:3
        % Choc
        v_tempo = SS ;
        [v_tempo.R,v_tempo.R_next] = deal(SS.R + (variable == 1)*choc) ; 
        [v_tempo.Y,v_tempo.Y_next] = deal(SS.Y + (variable == 2)*choc) ; 
        v_tempo.tau                = SS.tau + (variable == 3)*choc ; 
        % Decision et mesure
        v_tempo = noF_run_howard(p,v_tempo) ;
        v_tempo = SS_mesure_2asset(p, v_tempo);
        % Calcul des erreurs
        Erreur_tempo = [v_tempo.demand_D - v_tempo.supply_D ; v_tempo.N_H - v_tempo.N_demand ; v_tempo.tau - v_tempo.tau_implied ] ;
        newton_matrice(:,variable) = (Erreur_tempo - Erreur)/choc ;
    end
end


%% Ajustement des guess

Old_guess = [SS.R ; SS.Y ; SS.tau] ;
dampening_factor = 1 ;
New_guess = Old_guess - inv(newton_matrice)*Erreur*dampening_factor ;

[SS.R, SS.R_next] = deal(New_guess(1)) ; 
[SS.Y, SS.Y_next] = deal(New_guess(2)) ; 
SS.tau               = New_guess(3) ; 


