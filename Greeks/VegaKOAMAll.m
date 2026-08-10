function vegaAM = VegaKOAMAll(F0,K,KO,B,T,sigma,N_CRR,N_MC)
% VEGAKOAMALL Wrapper returning all American up-and-out call vegas.
%   vegaAM = VEGAKOAMALL(F0,K,KO,B,T,sigma,N_CRR,N_MC)
%   returns a struct with Vega computed by the exact formula, the
%   CRR tree, and Monte Carlo.
%
%   Output fields:
%     vegaAM.Exact - Exact Vega.
%     vegaAM.CRR   - CRR Vega with N_CRR time steps.
%     vegaAM.MC    - Monte Carlo Vega with N_MC simulations.

vegaAM.Exact = VegaKOAM(F0,K,KO,B,T,sigma,0,3);
vegaAM.CRR = VegaKOAM(F0,K,KO,B,T,sigma,N_CRR,1);
vegaAM.MC = VegaKOAM(F0,K,KO,B,T,sigma,N_MC,2);
end