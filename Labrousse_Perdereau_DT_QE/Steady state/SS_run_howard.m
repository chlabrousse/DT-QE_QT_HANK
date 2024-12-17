function SS = SS_run_howard(p, SS) 

% Valeurs actuelles
V_vec = SS.V_init;
SS.R_next   = SS.R ; SS.Y_next = SS.Y ;  
SS.w        = (p.epsilon-1)/p.epsilon + p.theta/p.epsilon*p.f.delta_pi(SS)  ;
SS.net_w    = p.f.net_w(SS) ;
SS.N_demand = SS.Y ;
SS.profit   = p.f.profit(SS) ;
SS.RHS      = p.s(:,1) + SS.Transfert + SS.profit*p.s(:,2)/p.prod_moyenne ; % RHS sans labor income
SS.i_nom    = max( 0, SS.R_next*SS.Pi_next - 1 ) ;

% VFI    
vdiff = 1; iters = 0; Nhoward = 30 ;
while vdiff >  p.tolV 
    iters = iters + 1;
    % Solve problem
    v       = f_solve_labor_BC4(p, SS, V_vec);
    % Update VF guess
    vdiff = norm(V_vec - v.Ve,1)/norm(V_vec,1) ;
    V_vec = v.Ve;
    
    % Note sur Howard
    for howard = 1:Nhoward %30
        Ve_coeff = reshape(V_vec,p.dim);
        V_interp = griddedInterpolant({p.fgrid,p.zgrid},Ve_coeff,'spline');
        V_howard = v.u + p.beta*V_interp([v.fp,p.s(:,2)]);
        V_vec = p.Emat*V_howard;
    end
        
end
SS.V2 = v;
SS.V_init = v.Ve ;

end

