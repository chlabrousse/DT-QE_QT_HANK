function SS = SS_convergence2(p, d_CB_SS)

% Initial guess and first run
SS = SS_V_guess_f(p, d_CB_SS) ;
SS = ffA(p,SS) ;
fjacinv = SS_newton(p, SS) ;

while max(abs(SS.diff) ) >  p.tolconv
    % Adjustment of guesses with the Jacobian matrix
    d = -(fjacinv*SS.Erreur(:));
    SS.guess = SS.guess + d ;
    Old_Error = SS.Erreur(:) ; 
    % New run
    SS = ffA(p,SS) ;
    disp(['Difference:   ' num2str(SS.diff) ]);
    % Change of the Jacobian matrix with Broyden
    u = fjacinv*(SS.Erreur(:)-Old_Error);
    fjacinv = fjacinv + ((d-u)*(d'*fjacinv))/(d'*u);

end



%% Calcul des valeurs non nécessaires 

SS.Rotemberg = p.f.Rotemberg(SS) ;
SS.diff_Y = 100*(SS.Y / (SS.C_H + p.G + SS.Rotemberg) - 1) ;
disp(['Ra :  '  num2str(100*(SS.R -1),3  )     '%  -- Taxe: '  num2str(100*SS.tau,3) '%  -- m: '  num2str(SS.m_H,2) ...
'-- Y: '  num2str(SS.Y,3)  ' -- Time: '  num2str(toc,2) ' -- Clearing Y: '  num2str(SS.diff_Y,3) ' --- It : '  num2str(SS.it)]) ; 


%% Calibration

% Satiation et borrowing constraint 
density_reshape = reshape(SS.density.tot, p.dim) ;
SS.density.F = sum(density_reshape,2) ;
SS.density.Z = sum(density_reshape,1) ;
satiation_index = (SS.V2.mp == p.mbar) ;
BC_index        = (SS.V2.ap < 0.05) ;
SS.pourcent_satiation = 100*sum(SS.density.tot(satiation_index)) ;
SS.pourcent_BC        = 100*sum(SS.density.tot(BC_index)) ;
% Ratio m/c et semi-élasticité
semi_elas = - 1/(SS.i_nom*(1+SS.i_nom))/p.mu ;
disp(['m/C :  '  num2str(100*SS.m_H/SS.C_H,3  )   ...
'%  -- Satiation (%): '  num2str(SS.pourcent_satiation,3) '%  -- Borrowing (%): '  num2str(SS.pourcent_BC,3) ]) ; 

% Calcul MPC after a change of (1+r)a
f = p.s(:,1) ; C = SS.V2.C ; 
change_K_income = f(2:p.n) - f(1:p.n-1) ;
change_C        = C(2:p.n) - C(1:p.n-1) ;
SS.MPC = 100*change_C./change_K_income ;
SS.MPC(p.n) = 1000000 ; 
SS.MPC( f == p.fgrid(end) ) = SS.MPC( f == p.fgrid(end-1) ) ;


%% MAIN FUNCTION TO COMPUTE THE ERROR GIVEN THE GUESSES
function SS = ffA(p,SS)
    SS.it =  SS.it +1; 
    [SS.R,SS.Y,SS.tau] = deal(SS.guess(1),SS.guess(2),SS.guess(3)) ;
    SS = SS_run_howard(p,SS) ;
    SS = SS_mesure_1asset(p, SS);
    SS = SS_clearing(SS);
end


end






