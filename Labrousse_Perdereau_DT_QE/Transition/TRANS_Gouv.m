function trans = TRANS_Gouv(p, trans, debut, final, choc, scenario)

%% Banque Centrale

% Money supply de la BC
T = p.T ;
trans.m_supply = trans.m_H ;
trans.m_supply(choc.ZLB_guess) = debut.m_H + cumsum(choc.QE(choc.ZLB_guess))  ;
trans.m_supply_last = [debut.m_supply, trans.m_supply(1:T-1)] ; 

% Profit, seignorage et CB securities
trans.d_CB = debut.d_CB + cumsum(choc.QE) ; 
trans.d_CB_last = [debut.d_CB, trans.d_CB(1:T-1)] ;
trans.Profit_CB = p.f.Profit_CB(trans) ;
if scenario.S == "sym"
    trans.S = trans.Profit_CB ;
    trans.X_CB(1:T) = 0 ;
elseif scenario.S == "asym"
    X_CB_last(1) = debut.X_CB ;
    for t = 1:T
        trans.S(t)  = max(0 , trans.Profit_CB(t) - trans.R(t)*X_CB_last(t) ) ; 
        trans.X_CB(t)  = trans.R(t)*X_CB_last(t) +  trans.S(t) - trans.Profit_CB(t) ;
        X_CB_last(t+1) = trans.X_CB(t) ;
    end
end

%% Gouvernement

% Valeurs nécessaires
tau_target(1:10) = linspace(debut.tau,final.tau,10) ; 
tau_target(11:T) = final.tau ; 
d_target(1:10) = linspace(debut.d,final.d,10) ; 
d_target(11:T) = final.d ; 
wN = trans.w.*trans.N_demand ;

% tau_implied et debt_implied
dep_gov(1) = trans.R(1).*debut.d + p.G + p.Transfert ;
trans.tau_implied(1) = tau_target(1) + p.rho_tau*(debut.tau-tau_target(1)) ...
                       + (1-p.rho_tau)*p.gamma*(debut.d-d_target(1) ) ;
trans.d(1) = dep_gov(1) - trans.S(1) - trans.tau_implied(1)*wN(1) ;
for t=2:T
    dep_gov(t) = trans.R(t).*trans.d(t-1) + p.G + p.Transfert ;
    trans.tau_implied(t) = tau_target(t) + p.rho_tau*(trans.tau_implied(t-1)-tau_target(t) ) ...
                           + (1-p.rho_tau)*p.gamma*(trans.d(t-1)-d_target(t) ) ;
    trans.d(t) = dep_gov(t) - trans.S(t) - trans.tau_implied(t)*wN(t) ;
end

% Wage implied
trans.w_implied = (p.epsilon-1)/p.epsilon + p.theta/p.epsilon*p.f.delta_pi(trans)  ;

% Asset clearing
trans.supply_D = trans.d   + trans.X_CB + trans.m_supply ; 
trans.demand_D = trans.d_H + trans.d_CB + trans.m_H ;

end