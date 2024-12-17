function SS = SS_mesure_2asset(p, SS)

%% 1) Trouver la matrice de transition avec la decision rule
matrice_transition = f_matrice_transition_2asset(p, SS.V2.ap, SS.V2.mp) ;


%% 2) Trouver la densite stationnaire en iterant la matrice de transition
density_tempo = ones(p.n,1)/p.n ; test=1;
while test > 10^(-8)
    density1 = matrice_transition*density_tempo;
    test = sum(sum(abs(density1-density_tempo))) ;
    density_tempo = density1;
end
SS.density.tot = density_tempo ;


%% 3) Calcul de F_supply 

SS.d_H = SS.V2.ap'*density_tempo  ;
SS.m_H = SS.V2.mp'*density_tempo  ;
z = p.s(:,3) ;
SS.N_H = (z.*SS.V2.nS)'*density_tempo  ;
SS.C_H = SS.V2.C'*density_tempo  ;
SS.Z_H = z'*density_tempo  ;
SS.U_H = SS.V2.u'*density_tempo  ;



%% 4) Calcul des valeurs nécessaires à la clearing

% Remittance banque centrale
[SS.m_supply, SS.m_supply_last] = deal(SS.m_H) ;
SS.Profit_CB  = p.f.Profit_CB(SS)  ;
SS.S          = SS.Profit_CB ;
% Tau implied
SS.dep_gov = SS.R.*SS.d_last + p.G + p.Transfert ;
SS.tau_full = (SS.dep_gov - p.d_steady - SS.S)/(SS.w.*SS.N_demand) ;
SS.tau_implied = SS.tau_full ;
% Clearing d
SS.supply_D = SS.d + SS.X_CB ;  
SS.demand_D = SS.d_H + SS.d_CB ;



end
