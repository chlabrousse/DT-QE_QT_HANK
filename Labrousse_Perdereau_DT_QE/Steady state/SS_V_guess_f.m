function SS = SS_V_guess_f(p, d_CB_SS)

% Banque centrale
[SS.d    , SS.d_last]    = deal(p.d_steady) ; 
[SS.d_CB , SS.d_CB_last] = deal(d_CB_SS) ; 
[SS.Pi   , SS.Pi_next]   = deal(p.pi_steady) ;
[SS.Transfert_CB, SS.X_CB] = deal(0) ; % CB securities and Helicopter transfer

% Guess initiaux
[SS.R, SS.R_next] = deal(1.01) ; 
[SS.Y, SS.Y_next] = deal(1)  ;  
SS.tau = 0.3 ; 
SS.guess = [SS.R ; SS.Y; SS.tau] ;

% Les valeurs qui intéressent l'agent
SS.Z = 1 ;
SS.Transfert = p.Transfert + SS.Transfert_CB ;
SS.w        = (p.epsilon-1)/p.epsilon + p.theta/p.epsilon*p.f.delta_pi(SS)  ;
net_w_guess    = p.f.net_w(SS) ;
SS.N_demand = SS.Y ;
profit_guess   = p.f.profit(SS) ;
other_guess    = SS.Transfert + profit_guess*p.s(:,2)/p.prod_moyenne ;
i_nom          = max( 0, SS.R_next*SS.Pi_next - 1 ) ;
K              = (1+i_nom)/(i_nom + eps) ;

% On suppose: C = (R-1)*F + net_wage*z*1 + Other income
C_init  = (SS.R-1)*p.s(:,1)  + net_w_guess.*p.s(:,2).*1 + other_guess  ;

% On calcule m, N, U et V = u + b*E*V
N_init  = (net_w_guess.*p.s(:,2)/p.nu.*C_init.^(-p.sigma)).^(1/p.psi) ;
m_init  = (K*p.chi*C_init.^(p.sigma) ).^(1/p.mu)  ;
U_init  = f_u( C_init , m_init , N_init, p, SS.Z) ;
SS.V_init = (eye(p.n) - p.beta*p.Emat)\U_init ; 

% Initialisation des erreurs
tic; SS.it = 0 ; 
SS.Erreur_pourcent = 10; 

end

