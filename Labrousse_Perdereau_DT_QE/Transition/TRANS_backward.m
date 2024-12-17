function trans = TRANS_backward(p, t, trans)

% Les valeurs qui intéressent l'agent 
v_tempo.Z       = trans.Z(t) ;
v_tempo.R_next  = trans.R(t+1) ;
v_tempo.Pi_next = trans.Pi(t+1) ;
v_tempo.net_w   = trans.net_w(t) ;
v_tempo.i_nom   = trans.i_nom(t) ;
v_tempo.RHS     = trans.RHS(:,t) ; 

% Maximisation
trans.V2(t) = f_solve_labor_BC4(p, v_tempo, trans.VFI(:,t+1) );

% La sauvegarde du Ve 
trans.VFI(:,t)    = trans.V2(t).Ve ;

end