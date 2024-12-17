function trans = TRANS_BC(p, trans, debut, final, choc)

%% Taux nominal et réel avec guess de Pi et Taylor

T = p.T ; 
trans.i_steady(1:10) = linspace(debut.i_nom,final.i_nom,10) ; 
trans.i_steady(1:T)  = final.i_nom ; 
trans.i_nom = max(0, trans.i_steady + p.phi*(trans.Pi - p.pi_steady) + choc.i ) ;
i_last = [debut.i_nom , trans.i_nom(1:T-1)] ;
trans.R   = (1+i_last)./trans.Pi ;


%% Calcul des valeurs nécessaires pour l'agent

% Net wage
trans.R_next = [trans.R(2:T) , final.R] ;
trans.Y_next = [trans.Y(2:T) , final.Y] ;
trans.Pi_next = [trans.Pi(2:T) , final.Pi] ;
trans.net_w  = p.f.net_w(trans) ;

% Transfert
trans.Transfert_CB(1:T) = 0 ;
trans.Transfert = p.Transfert + trans.Transfert_CB ;  

% Profit
trans.N_demand = trans.Y ; 
trans.profit = p.f.profit(trans) ;

% RHS
trans.RHS     = p.s(:,1) + trans.Transfert + trans.profit.*p.s(:,2)/p.prod_moyenne ; 

% Preference shifter
trans.Z = 1 + choc.beta ;


end