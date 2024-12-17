function value = partial_VFI(par, value) 

% Valeurs actuelles
V_vec = value.V_init;

% VFI    
vdiff = 1; iters = 0; Nhoward = 30 ;
while vdiff >  par.tolV 
    iters = iters + 1;
    % Solve problem
    v       = f_solve_labor_BC4(par, value, V_vec);
    % Update VF guess
    vdiff = norm(V_vec - v.Ve,1)/norm(V_vec,1) ;
    V_vec = v.Ve;
    
    % Note sur Howard
    for howard = 1:Nhoward %30
        Ve_coeff = reshape(V_vec,par.nf,par.nz);
        V_interp = griddedInterpolant({par.fgrid,par.zgrid},Ve_coeff,'spline');
        V_howard = v.u + par.beta*V_interp([v.fp,par.s(:,2)]);
        V_vec = par.Emat*V_howard;
    end
        
end
value.V2 = v;
value.V_init = v.Ve ;

end

