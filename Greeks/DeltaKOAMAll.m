function deltaAM = DeltaKOAMAll(S0,d,K,KO,B,T,sigma,N_CRR,N_MC)
% DELTAKOAMALL Wrapper returning all American up-and-out call deltas.
%   deltaAM = DELTAKOAMALL(S0,d,K,KO,B,T,sigma,N_CRR,N_MC)
%   returns a struct with Delta computed by the exact formula, the
%   CRR tree, and Monte Carlo.
%
%   Output fields:
%     deltaAM.Exact - Exact Delta.
%     deltaAM.CRR   - CRR Delta with N_CRR time steps.
%     deltaAM.MC    - Monte Carlo Delta with N_MC simulations.

deltaAM.Exact = DeltaKOAM(S0,d,K,KO,B,T,sigma,0,3);
deltaAM.CRR = DeltaKOAM(S0,d,K,KO,B,T,sigma,N_CRR,1);
deltaAM.MC = DeltaKOAM(S0,d,K,KO,B,T,sigma,N_MC,2);
end