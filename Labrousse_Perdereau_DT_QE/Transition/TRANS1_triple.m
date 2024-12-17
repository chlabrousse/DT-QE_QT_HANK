function trans = TRANS1_triple(p, choc, SS_final, inv_J, scenario, varargin)

% Valeurs necessaires 
SS_debut = p.debut ;
T = p.T ; tic_transition = tic ;
trans.density = repmat(SS_debut.density.tot, 1, T) ; % pour le C
trans.d_H(T)  = SS_final.d_H ; 
trans.m_H(T)  = SS_final.m_H ; 
trans.N_H(T)  = SS_final.N_H ; 
trans.VFI(:,T) = SS_final.V2.Ve ;

% Guess
list_var = ["Pi","Y","tau","w"] ; 
for var = list_var ; trans.(var)(1:T) = SS_final.(var) ; end
if ~isempty(varargin) % S'il y a un guess
    for var = list_var ; trans.(var)(1:T-1) = varargin{1}.(var)(1:T-1) ; end
end
trans.x = [] ; 
for var = list_var ; trans.x = [trans.x , trans.(var)(1:T-1)] ; end


%% Transition choc en t = 1
trans.it = 0; trans.Erreur_max = 10 ; 
while max(trans.Erreur_max) > 1e-2 ; tic
    trans = TRANS_BC(p, trans, SS_debut, SS_final, choc) ;
    for t=T-1:-1:1 ;  trans = TRANS_backward(p, t, trans)  ;  end
    for t=1:T-1    ;  trans = TRANS_forward(p, trans , t, SS_debut)   ;  end 
    trans = TRANS_Gouv(p, trans, SS_debut, SS_final, choc, scenario) ;
    trans = TRANS_ajust(p, trans, inv_J, SS_debut, SS_final) ;
end
disp(['Calcul de la Transition : ' num2str(toc(tic_transition),2) ' secondes']) 


%% IRF
trans.C_H(T) = SS_final.V2.C'*trans.density(:,T)  ;
trans.Rotemberg = p.f.Rotemberg(trans);
clearing_Y = trans.Y - trans.C_H - trans.Rotemberg - p.G ;
trans.clearing_Y = 100*clearing_Y./trans.Y ;
%graph_IRF_1(trans, SS_debut, final)


end
