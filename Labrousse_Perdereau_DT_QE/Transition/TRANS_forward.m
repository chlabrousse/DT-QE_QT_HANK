function trans= TRANS_forward(p, trans , t, debut)

%% 0) Corriger la densité initiale
if t == 1
    fp1 = min(trans.R(1)*debut.V2.ap + debut.V2.mp/trans.Pi(1), p.fmax) ;
    mat_tempo = f_mat_transition_1asset(p, fp1) ;
    trans.density(:,1) = mat_tempo*debut.density.tot ;
end

%% 1) Trouver la matrice de transition avec la decision rule
matrice_transition = f_mat_transition_1asset(p, trans.V2(t).fp) ;
trans.mat(t).mat = matrice_transition ;

%% 2) Trouver la densite suivante avec la matrice de transition
trans.density(:,t+1) = matrice_transition*trans.density(:,t) ;


%% 3) Calcul des agrégats

% Valeurs pour la clearing
pop = trans.density(:,t) ;
A_rule = trans.V2(t).ap ; trans.d_H(t) = A_rule'*pop  ;
m_rule = trans.V2(t).mp ; trans.m_H(t) = m_rule'*pop  ;
N_rule = trans.V2(t).nS ; trans.N_H(t) = (p.s(:,2).*N_rule)'*pop ;



%% 4) Valeurs pour IRF

trans.l_H(t) = N_rule'*pop ;
% M
satiation_index   = (m_rule == p.mbar) ;
trans.satiation(t) = 100*sum(pop(satiation_index)) ;
trans.giniM(t) = f_gini(pop,m_rule) ;
% C 
C_rule = trans.V2(t).C ; trans.C_H(t) = C_rule'*pop  ;
trans.giniC(t) = f_gini(pop,C_rule) ;
% U
U_rule = trans.V2(t).u ; trans.U_H(t) = U_rule'*pop ;
trans.giniU(t) = f_gini(pop, U_rule - min(U_rule) ) ;
% F
F_rule = trans.V2(t).fp ; trans.F_H(t) = F_rule'*pop  ;
trans.giniF(t) = f_gini(pop,F_rule) ;
% A
borrowing_index = (A_rule <= 0.05) ;
trans.borrowing(t) = 100*sum( pop(borrowing_index)) ;
trans.giniA(t) = f_gini(pop,A_rule) ;


end




