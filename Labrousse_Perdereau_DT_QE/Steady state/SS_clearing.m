function SS = SS_clearing(SS) 

% Capital Market
SS.Erreur(1) = SS.demand_D - SS.supply_D ;        
SS.diff(1)   = SS.Erreur(1)./SS.demand_D*100 ;

% Labor market
SS.Erreur(2) =  SS.N_H - SS.N_demand ;
SS.diff(2)   = SS.Erreur(2)./SS.N_demand*100 ;

% Clearing government
SS.Erreur(3) = SS.tau - SS.tau_implied ;
SS.diff(3)   = SS.Erreur(3)./SS.tau*100 ;

end 