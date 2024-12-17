function v = f_solve_labor_BC4(p, SS, V_vec)

% Next value function
Ve_coeff    = reshape(V_vec,p.dim);
V_interp    = griddedInterpolant({p.fgrid,p.zgrid},Ve_coeff,'spline');
% Notations
K = (1+SS.i_nom)/(SS.i_nom + eps) ; nw = SS.net_w ;
Z = p.s(:,2) ; o = ones(size(Z)) ; mbar = p.mbar*o ; Fmax = p.fmax*o ;

%% 1) Sans borrowing constraint

% Value function
fV      = @(C) f_u( C, p.f.mp(C,K,mbar) , p.f.nS(C,Z,nw) , p, SS.Z) + p.beta*V_interp([p.f.fp(C,Fmax,K,SS.Pi_next,SS.RHS,SS.R_next,Z,mbar,nw),Z]);

% Bornes pour avoir ap > 0 
Cmax1 = p.f.C_max1(K,SS.RHS,Z,nw) ; % Bornes sans satiation
Cmax2 = p.f.C_max2(SS.RHS,Z,nw) ;   % Bornes avec satiation
I = (p.f.mp(Cmax1,K,mbar) == p.mbar ) ; % satiation
Cmax = Cmax1 ; Cmax(I) = Cmax2(I) ;  

% Max V par rapport à C
Cmax(Cmax < 0.001) = 0.001 ; % certaines fois, Cmax est en dessous de 0 si le profit est négatif
[v.C,V] = f_goldenx( fV , o*0.001, Cmax ) ;
v.ap = p.f.ap(v.C,K,SS.RHS,Z,mbar,nw) ; v.mp = p.f.mp(v.C,K,mbar) ; 
V_next = V ;  

%% 2) Borrowing constraint

% Pour les gens à la borrowing
BC         = (v.ap <= sqrt(eps) ) ; % la tolérance de la golden
ap_BC      = 0 ; 
if sum(BC) > 0
    % Value function
    fV_BC      = @(C) f_u( C, p.f.mp_BC(C,SS.RHS(BC),Z(BC),ap_BC,mbar(BC),nw) , p.f.nS(C,Z(BC),nw) , p, SS.Z) + p.beta*V_interp([p.f.fp_BC(C,Fmax(BC),SS.Pi_next,SS.RHS(BC),SS.R_next,Z(BC),ap_BC,mbar(BC),nw),Z(BC)]);

    % Bornes pour avoir mp > 0 
    Cmax_BC = p.f.C_max3(SS.RHS(BC),Z(BC),ap_BC,nw) ;

    % Max V par rapport à C
    [C_BC,V_BC] = f_goldenx( fV_BC , ones(sum(BC),1)*0.001, Cmax_BC ) ;
    v.C(BC) = C_BC ; v.mp(BC) = p.f.mp_BC(C_BC,SS.RHS(BC),Z(BC),ap_BC,mbar(BC),nw) ; 
    V_next(BC) = V_BC ;
end


%% Save
v.nS = p.f.nS(v.C,Z,nw) ; 
v.fp = min(SS.R_next*v.ap + v.mp/SS.Pi_next, Fmax) ; 
v.Ve = p.Emat*V_next;
v.u  = f_u( v.C, v.mp , v.nS , p, SS.Z) ;


end
