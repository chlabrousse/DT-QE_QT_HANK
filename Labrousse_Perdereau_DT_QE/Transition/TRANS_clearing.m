function Erreur = TRANS_clearing(p, trans)

x = 1:(p.T-1) ;

clearingA = trans.demand_D(x)  - trans.supply_D(x) ; 
clearingN = trans.N_H(x) - trans.N_demand(x) ;
clearingT = trans.tau(x) - trans.tau_implied(x) ;
clearingW = trans.w(x) - trans.w_implied(x) ;
Erreur = [ clearingA ; clearingN ; clearingT ; clearingW]' ;

end

