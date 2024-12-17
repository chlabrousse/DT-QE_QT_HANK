function SS = noF_convergence(p, d_CB_SS)

SS = noF_V_guess_f(p, d_CB_SS) ;
while max(abs(SS.Erreur_pourcent)) > 1e-4
    SS = noF_run_howard(p,SS) ;
    SS = SS_mesure_2asset(p, SS);
    noF_ajustement_newton ;
end


%% Calcul des valeurs non nécessaires 

SS.Rotemberg = p.f.Rotemberg(SS) ;
SS.diff_Y = 100*(SS.Y / (SS.C_H + p.G + SS.Rotemberg) - 1) ;
disp(['Ra :  '  num2str(100*(SS.R -1),3  )     '%  -- Taxe: '  num2str(100*SS.tau,3) '%  -- m: '  num2str(SS.m_H,2) ...
    '-- Y: '  num2str(SS.Y,3)  ' -- Time: '  num2str(toc,2) ' -- Clearing Y: '  num2str(SS.diff_Y,3) ' --- It : '  num2str(SS.it)]) ; 


%% Calibration

% Satiation et borrowing constraint 
density_reshape = reshape(SS.density.tot, p.dim) ;
SS.density.A = sum(density_reshape,[2 3]) ;
SS.density.M = sum(density_reshape,[1 3]) ;
SS.density.Z = sum(density_reshape,[1 2]) ;
SS.pourcent_satiation = 100*SS.density.M(end) ;
SS.pourcent_BC        = 100*SS.density.A(1) ;
% Ratio m/c et semi-élasticité
semi_elas = - 1/(SS.i_nom*(1+SS.i_nom))/p.mu ;
disp(['m/C :  '  num2str(100*SS.m_H/SS.C_H,3  )   ...
    '%  -- Satiation (%): '  num2str(SS.pourcent_satiation,3) '%  -- Borrowing (%): '  num2str(SS.pourcent_BC,3) ]) ; 




%% Calcul MPC (changement de 1 de F)
MPC        = zeros(p.dim) ;
reshape_c  = reshape(SS.V2.C  , p.dim) ;
reshape_a  = reshape(p.s(:,1) , p.dim) ;
for A = 1:p.na-1
    for M = 1:p.nm-1
        for Z = 1:p.nz
            change_C  = reshape_c(A+1,M,Z) - reshape_c(A,M,Z) ;
            change_A  = (reshape_a(A+1,M,Z) - reshape_a(A,M,Z))*SS.R ;
            MPC(A,M,Z) = 100*change_C/change_A ;
        end
    end
end
MPC(p.na,:,:) = MPC(p.na-1,:,:) ; SS.MPC = MPC(:) ; 
SS.MPC_moyenne = sum(density_reshape.*MPC,'all') ;



end






