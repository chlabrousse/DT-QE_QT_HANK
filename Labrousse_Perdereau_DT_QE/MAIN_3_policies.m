%% 1) Steady states 
clear variables
addpath('Fonctions','Steady state','Transition')    
p = f_parametres ;

% Chocs
size_QE = 0.1 ;
d_CB_debut = 0.1 ; d_CB_final = d_CB_debut + size_QE ; 
d_CB_midle = mean([d_CB_debut,d_CB_final]) ;

% Calcul des SS
debut = SS_convergence2(p,d_CB_debut) ; p.debut = debut ;
midle = SS_convergence2(p,d_CB_midle) ; 
final = SS_convergence2(p,d_CB_final) ;



%% 2) Initialisation des chocs

% Pas de choc (pour les Jacobiennes)
T = p.T ;
[no_choc.beta , no_choc.QE, no_choc.i, no_choc.HM] = deal(zeros(1,p.T)) ; 
no_choc.ZLB_guess(1:T) = false ; 
no_choc.d_target(1:T) = final.d ; 
% 1) Beta NO QE 
choc_no_QE = no_choc ; choc_no_QE.beta(1:10) = -0.1 ; 
duree_ZLB = 5 ; choc_no_QE.ZLB_guess(1:duree_ZLB) = true ;
% 2) QE + QT full
choc_QE_QT = choc_no_QE ; 
choc_QE_QT.QE(1:duree_ZLB) = size_QE/duree_ZLB ; 
duree_QT = 3*duree_ZLB ;
choc_QE_QT.QE(duree_ZLB+1:duree_ZLB+duree_QT) = -size_QE/duree_QT ; 
% 3) QE + QT partiel
choc_QE_midle = choc_no_QE ; 
choc_QE_midle.QE(1:duree_ZLB) = size_QE/duree_ZLB ; 
choc_QE_midle.QE(duree_ZLB+1:duree_ZLB+duree_QT) = -size_QE/2/duree_QT ; 
% 4) QE + QT full
choc_QE = choc_no_QE ; 
choc_QE.QE(1:duree_ZLB) = size_QE/duree_ZLB ; 



%% 3) TRANSITIONS ASYMMETRIC

% Jacobiennes
scenario.S = 'asym' ; 
inv_J_debut_asym = TRANS0_Fake_News2(p, debut, no_choc, scenario);
inv_J_midle_asym = TRANS0_Fake_News2(p, midle, no_choc, scenario);
inv_J_final_asym = TRANS0_Fake_News2(p, final, no_choc, scenario);

% 1) No QE
TR.asym.no_QE = TRANS1_triple(p, choc_no_QE, debut, inv_J_debut_asym, scenario) ;
guess = TR.asym.no_QE ;
% 2) QE + QT total
TR.asym.QE_QT = TRANS1_triple(p, choc_QE_QT, debut, inv_J_debut_asym, scenario, guess) ;
% 3) QE + QT partiel
TR.asym.midle = TRANS1_triple(p, choc_QE_midle, midle, inv_J_midle_asym, scenario, guess) ;
% 4) QE full
TR.asym.QE = TRANS1_triple(p, choc_QE, final, inv_J_final_asym, scenario, guess) ;



%% 4) TRANSITIONS SYMMETRIC

% Jacobiennes
scenario.S = 'sym' ; 
inv_J_debut_sym = TRANS0_Fake_News2(p, debut, no_choc, scenario);
inv_J_midle_sym = TRANS0_Fake_News2(p, midle, no_choc, scenario);
inv_J_final_sym = TRANS0_Fake_News2(p, final, no_choc, scenario);

% 1) No QE
TR.sym.no_QE = TRANS1_triple(p, choc_no_QE, debut, inv_J_debut_sym, scenario) ;
guess = TR.sym.no_QE ;
% 2) QE + QT partiel
TR.sym.midle = TRANS1_triple(p, choc_QE_midle, midle, inv_J_midle_sym, scenario, guess) ;
% 3) QE + QT total
TR.sym.QE_QT = TRANS1_triple(p, choc_QE_QT, debut, inv_J_debut_sym, scenario, guess) ;
% 4) QE full
TR.sym.QE = TRANS1_triple(p, choc_QE, final, inv_J_final_sym, scenario, guess) ;



