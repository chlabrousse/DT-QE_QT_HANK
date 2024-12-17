function matrice_transition = f_mat_transition_1asset(p, ap)

%% CREER LA MATRICE DE TRANSITION A PARTIR DE LA REGLE DE DECISION

% Pour plus de clarte
nz = p.nz ;
na = p.nf ;
n  = p.n  ;


%% Optimal indexes

% Put the rule on the grid
[~,~,index_A_ligne_inf] = histcounts(ap,p.fgrid);
index_A_ligne_sup = min( index_A_ligne_inf + 1, na ) ; % point superieur



%% Find Weights for inferior and superior bounds

% Calculer les poids 
poids_A_sup = ( ap - p.fgrid(index_A_ligne_inf) ) ./ (p.fgrid(index_A_ligne_sup) - p.fgrid(index_A_ligne_inf) ) ;
poids_A_inf = 1 - poids_A_sup ;



%% Transition matrix (les na varient, puis les z) 

% Colonne : 5 fois chaque colonne
Colonne_Vecteur = kron(1:n, ones(1,nz)) ;

% Ligne : Pour chaque colonne, 5 lignes selon la decision rule
Ligne_Vecteur_inf = index_A_ligne_inf' + ([1:nz]'-1)*na ;
Ligne_Vecteur_sup = index_A_ligne_sup' + ([1:nz]'-1)*na ;

% Valeur : Pour chaque colonne, 5 proba: la proba de base fois le poids 
Valeur_Vecteur_inf = kron(poids_A_inf, ones(nz,1)).*p.proba_vecteur ;
Valeur_Vecteur_sup = kron(poids_A_sup, ones(nz,1)).*p.proba_vecteur ;

% Créer la matrice
sparse_Trans_inf = sparse(Ligne_Vecteur_inf(:), Colonne_Vecteur ,Valeur_Vecteur_inf,n,n) ; %Construct the transition matrix
sparse_Trans_sup = sparse(Ligne_Vecteur_sup(:), Colonne_Vecteur ,Valeur_Vecteur_sup,n,n) ; %Construct the transition matrix
matrice_transition =  sparse_Trans_sup + sparse_Trans_inf;


    
 
end
