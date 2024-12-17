function u = f_u(C, m, N, p, Z)

% Conso
if p.sigma == 1 ; uC = log(C) ;
else              ; uC = C.^(1-p.sigma)/(1-p.sigma) ; 
end
% Money
if p.mu == 1 ; uM = p.chi*log(min(m,p.mbar)) ;
else           ; uM = p.chi*min(m,p.mbar).^(1-p.mu)/(1-p.mu) ; 
end
% Labor
uN = - p.nu*(N.^(1+p.psi))./(1+p.psi) ;
% Utilité avec préférence shifter
u = Z.*(uC + uM + uN) ;

end
 