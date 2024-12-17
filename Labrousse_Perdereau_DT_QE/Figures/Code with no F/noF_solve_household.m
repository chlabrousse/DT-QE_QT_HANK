function v = noF_solve_household(p, SS, V_vec)

%% Valeurs
Ve_coeff    = reshape(V_vec,p.dim);
V_interp    = griddedInterpolant({p.agrid,p.mgrid,p.zgrid},Ve_coeff,'spline');
K           = (1+SS.i_nom)/(SS.i_nom + eps) ;
z           = p.s(:,3) ; X = 1:100 ;

%% 1) Sans borrowing constraint

% Value function
fmp     = @(C) min(p.mbar, (K*p.chi*C.^(p.sigma) ).^(1/p.mu) )  ;
fnS     = @(C) (SS.net_w.*z/p.nu.*C.^(-p.sigma)).^(1/p.psi) ;
%fap     = @(C) SS.RHS + SS.net_w.*z.*fnS(C) - C - fmp(C)   ; 
fap     = @(C) min(p.amax, SS.RHS + SS.net_w.*z.*fnS(C) - C - fmp(C) )  ; 
fV      = @(C) f_u( C, fmp(C) , fnS(C) , p, SS.Z) + p.beta*V_interp([fap(C),fmp(C),z]);

% Bornes pour avoir ap > amin
ap_zero = @(C) - (fap(C) - p.amin).^2 ;
[Cmax,a_valeur] = f_goldenx( ap_zero , ones(p.n,1)*0.001, SS.RHS + SS.net_w.*z ) ;

% Max V par rapport à C
Cmax(Cmax < 0.001) = 0.001 ; % certaines fois, Cmax est en dessous de 0 si le profit est négatif
[v.C,V] = f_goldenx( fV , ones(p.n,1)*0.001, Cmax ) ;
v.ap = fap(v.C) ; v.mp = fmp(v.C) ; v.nS = fnS(v.C) ; V_next = V ;  


%% 2) Borrowing constraint

% Pour les gens à la borrowing
BC         = (v.ap <= sqrt(eps) ) ; % la tolérance de la golden
v.ap      = max(0 , v.ap) ;
ap_BC      = zeros(sum(BC),1) ;

if sum(BC) > 0
    % Value function
    fnS_BC     = @(C) (SS.net_w.*z(BC)/p.nu.*C.^(-p.sigma) ).^(1/p.psi) ;
    fmp_BC     = @(C) min(p.mbar, SS.RHS(BC) + SS.net_w.*z(BC).*fnS_BC(C) - C - ap_BC )   ; 
    fV_BC      = @(C) f_u( C, fmp_BC(C) , fnS_BC(C) , p, SS.Z) + p.beta*V_interp([ap_BC,fmp_BC(C),z(BC)]);

    % Bornes pour avoir mp > 0 
    mp_zero = @(C) - fmp_BC(C).^2 ;
    [Cmax_BC,m_valeur] = f_goldenx( mp_zero , ones(sum(BC),1)*0.001, SS.RHS(BC) + SS.net_w.*z(BC)  ) ;

    % Max V par rapport à C
    [C_BC,V_BC] = f_goldenx( fV_BC , ones(sum(BC),1)*0.001, Cmax_BC ) ;
    v.C(BC) = C_BC ; v.mp(BC) = fmp_BC(C_BC) ; v.nS(BC) = fnS_BC(C_BC) ; V_next(BC) = V_BC ;
end


%% Save
v.Ve    = p.Emat*V_next;
v.u     = f_u( v.C, v.mp , v.nS , p, SS.Z) ;


end
