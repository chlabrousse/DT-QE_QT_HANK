function p = f_parametres

%% 1) Households
p.beta  = 0.95;     % discount factor (0.944)
p.sigma = 1. ;      % IES (1 pour log)
% Money
p.chi   = 0.07 ;  % taste for money (0.07, scale m/c)
p.mu    = 1. ;    % scale money semi-elasticity to i (1)
p.mbar  = 1.2 ;     % niveau de satiété (1.1)
% Labor
p.psi   = 1 ;     % inverse Frisch elasticity (1)
p.nu    = 1.3 ;     % scale labor disutility to have N=Y=1  (0.76)


%% 2) FIRM
p.epsilon = 7   ; % elasticité substitution
p.theta = 150 ;   % rigidité des prix (200 chez Axelle, ici on compte en annuel donc 50)

% Fonction pour trouver mu dans la PC
p.f.delta_pi = @(value) value.Pi.*(value.Pi-1) - (1./value.R_next).*(value.Y_next./value.Y).*value.Pi_next .* (value.Pi_next - 1 );

% Rotemberg cost
p.f.Rotemberg = @(value) p.theta/2 * (value.Pi - 1).^2 .* value.Y ; 
% Profit function
p.f.profit = @(value) value.Y - value.N_demand.*value.w - p.f.Rotemberg(value) ; % equal to : (1-firm.mu)* firm.output - firm.Rotemberg


%% 3) Banque centrale
p.pi_steady = 1.02^0.25 ; % inflation de SS (1.02)
p.phi       = 1.5  ; % Taylor rule

% Profit CB
p.f.Profit_CB = @(value) value.R.*value.d_CB_last + value.m_supply - value.d_CB - value.m_supply_last./value.Pi  ;


%% 4) Government
p.Transfert = 0.0 ; % transfert à tout le monde
p.G         = 0.28 ; % Depense publique
p.d_steady  = 1   ; % Dette totale (environ 120% PIB)
p.rho_tau   = 0.8 ;   % persistence tax rate
p.gamma     = 0.1 ;   % fiscal reactivity to debt deviation


%% 4) Net wage
p.f.net_w     = @(value) (1-value.tau).*value.w ;


%% Algorithm and grids

p.tolV  = 1e-8;     % tolerance for the VFI , 1e-6
p.tolconv  = 1e-4;  % tolerance for the Steady state (%)
p.T = 60 ;          % Durée transition

% Create grids for F = (1+r)a + m/pi
p.nf     = 150 ; % 100
p.fmin   = 0 ; 
p.fmax   = 25 ; %15
p.fgrid  = p.fmin + (p.fmax-p.fmin)*linspace(0,1,p.nf).^2.5;
p.fgrid  = p.fgrid(:); % plot(param.fgrid)

% Create grids for Z
p.nz    = 5; 
rho       = 0.92;  % persistence of the shock (0.92)
sigma     = 0.25;  % variance of the shock (0.25)
meanZ     = 0;
numStdZ   = 2; % 3 dans le code Aiyagari de Axelle
[logZ,p.P] = f_tauchen(p.nz, meanZ, rho, sigma, numStdZ); 
p.zgrid = exp(logZ);
% Compute invariant distribution
invdist_tempo = ones(1,p.nz)/p.nz;    
p.invdist = invdist_tempo*p.P^500;
p.prod_moyenne = p.invdist*p.zgrid ;

% Number of state points in total
p.n      = p.nf*p.nz ;
p.dim    = [p.nf , p.nz] ;

% 2) Create state matrix using simpler code (B évolue puis M puis Z)
[ZZZ,FFF] = meshgrid( p.zgrid , p.fgrid );
p.s = [ FFF(:) , ZZZ(:)  ] ;

% create Expectation matrix (lot of diagonal matrixes)
p.Emat   = f_kron(p.P,speye(p.nf));

% Pour la nouvelle nouvelle mesure
for i=1:p.nz
    p.proba_vecteur( (i-1)*p.n+1 : i*p.n , 1)  = repmat(p.P(i,:)', p.nf, 1) ;
end


%% Fonctions pré-calculées pour agent non contraint
syms C nw Z K RHS mbar R_next Pi_next Fmax

% N from FOC Intra
N = (nw.*Z/p.nu.*C.^(-p.sigma)).^(1/p.psi) ;
p.f.nS = matlabFunction(N) ;

% m from FOC intra
M = min(mbar,(K*p.chi*C.^(p.sigma) ).^(1/p.mu)) ;
p.f.mp = matlabFunction(M) ;

% ap from BC
A = RHS + nw.*Z.*N - C - M ;
p.f.ap = matlabFunction(A) ;

% F = R*a + m/pi
F = min(R_next*A + M/Pi_next, Fmax) ;
p.f.fp = matlabFunction(F) ;

% Borne pour A > 0 pour les gens pas a la satiation
M = (K*p.chi*C.^(p.sigma)).^(1/p.mu) ; 
eqn = C + M == RHS + nw.*Z.*N ;
X = solve(eqn, C) ;
p.f.C_max1 = matlabFunction(X(1)) ; % regarder l'équation positive

% Borne pour A > 0 pour les gens a la satiation
M = p.mbar ; 
eqn = C + M == RHS + nw.*Z.*N ;
X = solve(eqn, C) ;
p.f.C_max2 = matlabFunction(X(2)) ; % regarder l'équation positive


%% Fonctions pré-calculées pour agent contraint
syms ap_BC

% m from Budget constraint
M = min(mbar, RHS + nw.*Z.*N - C - ap_BC) ;
p.f.mp_BC = matlabFunction(M) ;

% F = R*a + M/pi
F = min(R_next*ap_BC + M/Pi_next, Fmax) ;
p.f.fp_BC = matlabFunction(F) ;

% Borne pour avoir M > 0, sans satiation
M = RHS + nw.*Z.*N - C - ap_BC ;
eqn = M == 0 ;
X = solve(eqn, C) ;
p.f.C_max3 = matlabFunction(X(2)) ; % regarder l'équation positive



end
