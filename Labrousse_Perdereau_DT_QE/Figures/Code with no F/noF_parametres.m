function p = f_parametres

%% 1) Households
p.beta  = 0.95;     % discount factor (0.944)
p.sigma = 1. ;      % IES (1 pour log)
p.xi = 0 ;
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
p.T = 60 ;          % Durée transition

% Create grids for A
p.na     = 50 ; % 100
p.amin   = 0 ; 
p.amax   = 15 ; %15
p.agrid  = p.amin + (p.amax-p.amin)*linspace(0,1,p.na).^2.5;
p.agrid  = p.agrid(:); % plot(param.fgrid)

% Create grids for M
p.nm     = 40 ; % 100
p.mmin   = 0 ; 
p.mmax   = p.mbar ; %15
p.mgrid  = p.mmin + (p.mmax-p.mmin)*linspace(0,1,p.nm).^1;
p.mgrid  = p.mgrid(:); % plot(param.fgrid)


% Create grids for Z
p.nz      = 5; 
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
p.n      = p.na*p.nm*p.nz ;
p.dim    = [p.na , p.nm , p.nz] ;

% 2) Create state matrix using simpler code (A évolue puis B puis Z)
[MMM,AAA,ZZZ] = meshgrid( p.mgrid, p.agrid, p.zgrid );
p.s = [ AAA(:) , MMM(:) , ZZZ(:)  ] ;


% create Expectation matrix (lot of diagonal matrixes)
p.Emat   = f_kron(p.P,speye(p.na*p.nm));

% Pour la nouvelle nouvelle mesure
for i=1:p.nz
    p.proba_vecteur( (i-1)*p.n+1 : i*p.n , 1)  = repmat(p.P(i,:)', p.na*p.nm, 1) ;
end



end
