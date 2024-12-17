function SS = noF_V_guess_f(p, d_CB_SS)

% Banque centrale
[SS.d    , SS.d_last]    = deal(p.d_steady) ; 
[SS.d_CB , SS.d_CB_last] = deal(d_CB_SS) ; 
[SS.Pi   , SS.Pi_next]   = deal(p.pi_steady) ;
[SS.Transfert_CB, SS.X_CB] = deal(0) ; % CB securities and Helicopter transfer

% Guess initiaux
[SS.R, SS.R_next] = deal(1.01) ; 
[SS.Y, SS.Y_next] = deal(1)  ;  
SS.tau = 0.3 ; 

% Les valeurs qui intéressent l'agent
SS.Z = 1 ;
SS.Transfert = p.Transfert + SS.Transfert_CB ;
SS.w        = (p.epsilon-1)/p.epsilon + p.theta/p.epsilon*p.f.delta_pi(SS)  ;
net_w_guess    = p.f.net_w(SS) ;
SS.N_demand = SS.Y ;
profit_guess   = p.f.profit(SS) ;
z = p.s(:,3) ; 
other_guess    = SS.Transfert + profit_guess*z/p.prod_moyenne ;
i_nom          = max( 0, SS.R_next*SS.Pi_next - 1 ) ;
K              = (1+i_nom)/(i_nom + eps) ;

% On suppose: C = (R-1)*F + net_wage*z*1 + Other income
%C_init  = (SS.R-1)*p.s(:,1) + (1/SS.Pi-1)*p.s(:,2)  + net_w_guess.*z.*1 + other_guess  ;
% Le guess du dessus ne converge pas, car penalite à avoir du M? 
C_init  = (SS.R-1)*p.s(:,1)   + net_w_guess.*z.*1 + other_guess  ;

% On calcule m, N, U et V = u + b*E*V
N_init  = (net_w_guess.*z/p.nu.*C_init.^(-p.sigma)).^(1/p.psi) ;
m_init  = (K*p.chi*C_init.^(p.sigma) ).^(1/p.mu)  ;
U_init  = f_u( C_init , m_init , N_init, p, SS.Z) ;
V = U_init/(1-p.beta)  ;
for ii = 1:1000 ; V = U_init + p.beta*p.Emat*V ; end
SS.V_init = V ; 

% Initialisation des erreurs
tic; SS.it = 0 ; 
SS.Erreur_pourcent = 10; 

end

