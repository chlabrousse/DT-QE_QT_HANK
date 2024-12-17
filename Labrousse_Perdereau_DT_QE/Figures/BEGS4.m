function X = BEGS4(p, TR_A, TR_B, debut)

T=p.T ;
uC  = @(Z,c) Z*c.^(-p.sigma) ; 
uN  = @(Z,n) Z*(-p.nu)*n.^(p.psi) ; 
uM  = @(Z,m) Z*p.chi*m.^(-p.mu) ; 
uCC = @(Z,c) Z*(-p.sigma)*c.^(-p.sigma-1) ;
uNN = @(Z,n) Z*(-p.nu)*p.psi*n.^(p.psi-1) ;
uMM = @(Z,m) Z*p.chi*(-p.mu)*m.^(-p.mu-1) ;

%!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
%! Economy A et B: Transition
%!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

    for i_TR = 1:2
        if i_TR == 1 ; TR = TR_A ; end
        if i_TR == 2 ; TR = TR_B ; end

        %! Policy: consumption, labor, log consumption, log labor, log c squared, log h squared
        for t = 1:T-1
            matu(:,1,t) = TR.V2(t).C ;
            matu(:,2,t) = TR.V2(t).nS ;
            matu(:,3,t) = TR.V2(t).mp ;
            matu(:,4,t) = log(TR.V2(t).C) ;
            matu(:,5,t) = log(TR.V2(t).nS) ;
            matu(:,6,t) = log(TR.V2(t).mp) ;
            matu(:,7,t) = log(TR.V2(t).C).^2 ;
            matu(:,8,t) = log(TR.V2(t).nS).^2 ;
            matu(:,9,t) = log(TR.V2(t).mp).^2 ;
            matu(:,10,t)= TR.V2(t).u ;
        end
        x = size(matu) ; n_iter = x(2) ;

        %! Compute multiplicative transition matrix 
        H(1).mat = TR.mat(1).mat ;
        for t = 2:T-1
            H(t).mat = H(t-1).mat*TR.mat(t).mat ;
        end

        % Remplir MOM
        for iter = 1:n_iter ; MOM(:,iter,1,i_TR) = matu(:,iter,1) ; end
        for t = 2:T-1
            for iter = 1:n_iter
                MOM(:,iter,t,i_TR) = H(t-1).mat'*matu(:,iter,t) ;
            end
        end

    end


%!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
%! Compute efficiency, redistribution, and insurance terms
%!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

    mu_init   = debut.density.tot ;
    MOM_A = MOM(:,:,:,1) ;
    MOM_B = MOM(:,:,:,2) ;
    for t = 1:T-1

        CaggZ(t) = sqrt(TR_A.C_H(t)*TR_B.C_H(t)) ;          %! C_t^Z in notes
        NaggZ(t) = sqrt(TR_A.l_H(t)*TR_B.l_H(t)) ;          %! N_t^Z in notes
        MaggZ(t) = sqrt(TR_A.m_H(t)*TR_B.m_H(t)) ;          %! N_t^Z in notes
        Z = TR.Z(t) ;

        % Share at midpoints
        wA(:,1,t) =  MOM_A(:,1,t)/(mu_init'* MOM_A(:,1,t) ) ;   %! w_{x,t}^j with x = consumption, j = steady state
        wA(:,2,t) =  MOM_A(:,2,t)/(mu_init'* MOM_A(:,2,t) ) ;   %! w_{x,t}^j with x = labor, j = steady state
        wA(:,3,t) =  MOM_A(:,3,t)/(mu_init'* MOM_A(:,3,t) ) ;   %! w_{x,t}^j with x = m, j = steady state
        wB(:,1,t) =  MOM_B(:,1,t)/(mu_init'* MOM_B(:,1,t) ) ;   %! w_{x,t}^j with x = consumption, j = transition
        wB(:,2,t) =  MOM_B(:,2,t)/(mu_init'* MOM_B(:,2,t) ) ;   %! w_{x,t}^j with x = labor, j = transition
        wB(:,3,t) =  MOM_B(:,3,t)/(mu_init'* MOM_B(:,3,t) ) ;   %! w_{x,t}^j with x = m, j = transition
        wZ(:,1,t)  = sqrt( wA(:,1,t).* wB(:,1,t) ) ;            %! w_{x,t}^Z with x = consumption
        wZ(:,2,t)  = sqrt( wA(:,2,t).* wB(:,2,t) )          ;   %! w_{x,t}^Z with x = labor
        wZ(:,3,t)  = sqrt( wA(:,3,t).* wB(:,3,t) )          ;   %! w_{x,t}^Z with x = m

        % Midpoints
        c_i_Z = CaggZ(t)*wZ(:,1,t) ;                            %! c_t^z
        n_i_Z = NaggZ(t)*wZ(:,2,t) ;                            %! n_t^z
        m_i_Z = MaggZ(t)*wZ(:,3,t) ;                            %! m_t^z

        % Les phi 
        CEphi(:,1,t) = (p.beta^(t-1))*uC(Z,c_i_Z).*c_i_Z ;   %! phi_{c,t}
        CEphi(:,2,t) = (p.beta^(t-1))*uN(Z,n_i_Z).*n_i_Z ;  %! phi_{m,t}   
        CEphi(:,3,t) = (p.beta^(t-1))*uM(Z,m_i_Z).*m_i_Z ;  %! phi_{m,t}   
        
        % Gamma
        CEgamma(:,1,t) = log( mu_init'* MOM_B(:,1,t) )-log( mu_init'* MOM_A(:,1,t) ) ;  %! Gamma_{c,t}
        CEgamma(:,2,t) = log( mu_init'* MOM_B(:,2,t) )-log( mu_init'* MOM_A(:,2,t) ) ;  %! Gamma_{n,t}
        CEgamma(:,3,t) = log( mu_init'* MOM_B(:,3,t) )-log( mu_init'* MOM_A(:,3,t) ) ;  %! Gamma_{m,t}

        % Delta
        CEDelta(:,1,t) = log(wB(:,1,t))-log(wA(:,1,t)) ;  %! Delta_{x,t} with x = consumption
        CEDelta(:,2,t) = log(wB(:,2,t))-log(wA(:,2,t)) ;  %! Delta_{x,t} with x = labor
        CEDelta(:,3,t) = log(wB(:,3,t))-log(wA(:,3,t)) ;  %! Delta_{x,t} with x = m

        % Lambda
        var_ln_cA = MOM_A(:,7,t) - (MOM_A(:,4,t).^2) ;
        var_ln_nA = MOM_A(:,8,t) - (MOM_A(:,5,t).^2) ;
        var_ln_mA = MOM_A(:,9,t) - (MOM_A(:,6,t).^2) ;
        var_ln_cB = MOM_B(:,7,t) - (MOM_B(:,4,t).^2) ; 
        var_ln_nB = MOM_B(:,8,t) - (MOM_B(:,5,t).^2) ; 
        var_ln_mB = MOM_B(:,9,t) - (MOM_B(:,6,t).^2) ; 
        CELambda(:,1,t) = -0.5*( var_ln_cB - var_ln_cA ) ; %! Lambda_{x,t} with x = consumption
        CELambda(:,2,t) = -0.5*( var_ln_nB - var_ln_nA ) ; %! Lambda_{x,t} with x = labor
        CELambda(:,3,t) = -0.5*( var_ln_mB - var_ln_mA ) ; %! Lambda_{x,t} with x = m

        % Calcul de eff, red et ins
        X.eff(1,t) = mu_init'* (CEphi(:,1,t).*CEgamma(:,1,t) ) ; %! efficiency consumption
        X.eff(2,t) = mu_init'* (CEphi(:,2,t).*CEgamma(:,2,t) ) ; %! efficiency labor
        X.eff(3,t) = mu_init'* (CEphi(:,3,t).*CEgamma(:,3,t) ) ; %! efficiency m

        X.red(1,t) = mu_init'* (CEphi(:,1,t).*CEDelta(:,1,t) ) ; %! redistribution consumption
        X.red(2,t) = mu_init'* (CEphi(:,2,t).*CEDelta(:,2,t) ) ; %! redistribution labor
        X.red(3,t) = mu_init'* (CEphi(:,3,t).*CEDelta(:,3,t) ) ; %! redistribution m

        gamma_C_i = - uCC(Z,c_i_Z).*c_i_Z./uC(Z,c_i_Z) ;
        gamma_N_i = - uNN(Z,n_i_Z).*n_i_Z./uN(Z,n_i_Z) ;
        gamma_M_i = - uMM(Z,m_i_Z).*m_i_Z./uM(Z,m_i_Z) ;
        X.ins(1,t) = mu_init'*(CEphi(:,1,t).*gamma_C_i.*CELambda(:,1,t) ) ; %! insurance consumption
        X.ins(2,t) = mu_init'*(CEphi(:,2,t).*gamma_N_i.*CELambda(:,2,t) ) ; %! insurance labor
        X.ins(3,t) = mu_init'*(CEphi(:,3,t).*gamma_M_i.*CELambda(:,3,t) ) ; %! insurance m
    end

    % plot( [sum(X.eff) ; sum(X.red); sum(X.ins)]' ) ; legend('eff','red','ins')



% Welfare
% Somme pas ponderee
X.effT = sum(X.eff) ; 
X.redT = sum(X.red) ; 
X.insT = sum(X.ins) ; 
X.sumT = sum([X.effT ; X.redT ;X.insT]) ;
X.SUM_tot = sum(X.sumT);
% Difference des W
X.W_A = sum( mu_init'*(p.beta.^((1:T-1) - 1).*reshape(MOM_A(:,10,:), p.n, T-1) ) );
X.W_B = sum( mu_init'*(p.beta.^((1:T-1) - 1).*reshape(MOM_B(:,10,:), p.n, T-1) ) );

X.SUM_target = X.W_B - X.W_A;
X.diff = (X.SUM_tot./X.SUM_target-1)*100 ;
disp(['Sum tot : ' num2str(X.SUM_tot,3) ' - Target : ' num2str(X.SUM_target,2) ' - Diff : ' num2str(X.diff,3) ]) 

% Affichage table
Eff_x = sum(X.eff,2)' ; EffS = 100*sum(Eff_x)/X.SUM_tot ;
Red_x = sum(X.red,2)' ; RedS = 100*sum(Red_x)/X.SUM_tot ;
Ins_x = sum(X.ins,2)' ; InsS = 100*sum(Ins_x)/X.SUM_tot ;
disp(['               C        N        M        ---  Total']) 
disp(['Efficiency : ' num2str(Eff_x,2) '      ---  ' num2str(EffS,3)  '% ']) 
disp(['Redistribu : ' num2str(Red_x,2) '    ---  ' num2str(RedS,3)  '% ']) 
disp(['Insurance  : ' num2str(Ins_x,2) '     ---  ' num2str(InsS,3)  '% ']) 


end