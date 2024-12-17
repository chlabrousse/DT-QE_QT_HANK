
addpath('Figures')  

%% 4) NUMERICAL RESULTS
%% 4.1) Negative demand shock and ZLB
% Figure 3: Our reference simulation
fig_IRF_1(TR.asym.no_QE, debut)


%% 4.2) Balance sheet policies’ effects
% Figure 4: IRF with different QT scenarios (vs counterfactual)
fig_IRF_3diff_slide2(TR.asym.no_QE, TR.asym.QE, TR.asym.midle, TR.asym.QE_QT,3)
 
% Figure 5: Decomposition of consumption change
fig_decompo_C_U(p, debut, final, TR.asym.no_QE, TR.asym.midle)


%% 4.3) Welfare and distributive effects
% Figure 6: Breakdown of the changes in the budget constraint, by productivity
fig_BC_change

% Bhandari (text)
X = BEGS4(p, TR.asym.no_QE, TR.asym.midle, debut) ; 

% Figure 7: Welfare change by productivity
graph_Welfare_Distributive(p, debut, TR.asym.no_QE, TR.asym.midle, TR.asym.QE, TR.asym.QE_QT)



%% 4.4) Addressing Central Bank losses: the fiscal-monetary mix
% Figure 8: CB securities vs. Treasury support
fig_IRF_2_mix(TR.asym.no_QE, TR.asym.midle, TR.sym.midle)




%% A.3) Additional results
%% A.3.1) Fiscal and monetary interaction
% Figure 11: QE + complete QT
fig_IRF_2_mix(TR.asym.no_QE, TR.asym.QE_QT, TR.sym.QE_QT)


% Figure 12: Permanent QE
fig_IRF_2_mix(TR.asym.no_QE, TR.asym.QE_QT, TR.sym.QE_QT)

