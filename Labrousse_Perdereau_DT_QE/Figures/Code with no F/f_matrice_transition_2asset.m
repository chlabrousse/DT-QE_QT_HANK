function matrice_transition = f_matrice_transition_2asset(p, ap, mp)

%% CREER LA MATRICE DE TRANSITION A PARTIR DE LA REGLE DE DECISION

% Pour plus de clarte
nz = p.nz ;
na = p.na ;
nm = p.nm ;
n  = p.n  ;


%% Optimal indexes

% Put the rule on the grid
[~,~,index_A_ligne_inf] = histcounts(ap,p.agrid);
[~,~,index_M_ligne_inf] = histcounts(mp,p.mgrid);
index_A_ligne_sup = min( index_A_ligne_inf + 1, na ) ; % point superieur
index_M_ligne_sup = min( index_M_ligne_inf + 1, nm ) ; % point superieur

% Indices généraux de A et M
index_sup_sup = index_A_ligne_sup + (index_M_ligne_sup - 1)*na ;
index_inf_sup = index_A_ligne_inf + (index_M_ligne_sup - 1)*na ;
index_sup_inf = index_A_ligne_sup + (index_M_ligne_inf - 1)*na ;
index_inf_inf = index_A_ligne_inf + (index_M_ligne_inf - 1)*na ;



%% Find Weights for inferior and superior bounds

% Calculer les poids 
poids_A_sup = ( ap - p.agrid(index_A_ligne_inf) ) ./ (p.agrid(index_A_ligne_sup) - p.agrid(index_A_ligne_inf) ) ;
poids_M_sup = ( mp - p.mgrid(index_M_ligne_inf) ) ./ (p.mgrid(index_M_ligne_sup) - p.mgrid(index_M_ligne_inf) ) ;
poids_A_inf = 1 - poids_A_sup ;
poids_M_inf = 1 - poids_M_sup ;



%% Transition matrix (les na varient, puis les z) 

% Colonne : 5 fois chaque colonne
Colonne_Vec = kron(1:n, ones(1,nz)) ;

% Ligne : Pour chaque colonne, 5 lignes selon la decision rule
Ligne_Vec_sup_sup = index_sup_sup' + ([1:nz]'-1)*nm*na ;
Ligne_Vec_inf_sup = index_inf_sup' + ([1:nz]'-1)*nm*na ;
Ligne_Vec_sup_inf = index_sup_inf' + ([1:nz]'-1)*nm*na ;
Ligne_Vec_inf_inf = index_inf_inf' + ([1:nz]'-1)*nm*na ;


% Valeur : Pour chaque colonne, 5 proba: la proba de base fois le poids 
Valeur_Vec_sup_sup = kron(poids_A_sup, ones(nz,1)).*kron(poids_M_sup, ones(nz,1)).*p.proba_vecteur*(1-p.xi) ;
Valeur_Vec_inf_sup = kron(poids_A_inf, ones(nz,1)).*kron(poids_M_sup, ones(nz,1)).*p.proba_vecteur*(1-p.xi) ;
Valeur_Vec_sup_inf = kron(poids_A_sup, ones(nz,1)).*kron(poids_M_inf, ones(nz,1)).*p.proba_vecteur*(1-p.xi) ;
Valeur_Vec_inf_inf = kron(poids_A_inf, ones(nz,1)).*kron(poids_M_inf, ones(nz,1)).*p.proba_vecteur*(1-p.xi) ;

% Créer la matrice
sparse_Trans_inf_inf = sparse(Ligne_Vec_inf_inf(:), Colonne_Vec ,Valeur_Vec_inf_inf,n,n) ; %Construct the transition matrix
sparse_Trans_inf_sup = sparse(Ligne_Vec_inf_sup(:), Colonne_Vec ,Valeur_Vec_inf_sup,n,n) ; %Construct the transition matrix
sparse_Trans_sup_inf = sparse(Ligne_Vec_sup_inf(:), Colonne_Vec ,Valeur_Vec_sup_inf,n,n) ; %Construct the transition matrix
sparse_Trans_sup_sup = sparse(Ligne_Vec_sup_sup(:), Colonne_Vec ,Valeur_Vec_sup_sup,n,n) ; %Construct the transition matrix

matrice_transition = sparse_Trans_sup_sup + sparse_Trans_inf_inf + sparse_Trans_inf_sup + sparse_Trans_sup_inf;


    
 
end
