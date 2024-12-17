function inv_newton_matrice = SS_newton(p, SS)

% Calcul des clearing avec des chocs sur chaque guess
choc = 0.0001 ; 
list_var = ["R","Y","tau"] ; 

for var = list_var  
    v_tempo = SS ; 
    v_tempo.(var) = SS.(var) + choc ;

    % Computations
    v_tempo = SS_run_howard(p,v_tempo) ;
    v_tempo = SS_mesure_1asset(p, v_tempo);

    % Clearing
    v_tempo = SS_clearing(v_tempo) ;

    % Matrix
    newton_mat.(var)(:,1) = (v_tempo.Erreur - SS.Erreur)./choc;    

end

%% Creation de la matrice 
mat_jaco = [] ;
for var = list_var ; mat_jaco = [mat_jaco , newton_mat.(var)] ; end
inv_newton_matrice = inv(mat_jaco) ;

end

