function vegaKO = VegaKOAll(F0,K,KO,B,T,sigma,N_CRR,N_MC)
% VEGAKOALL Wrapper returning all European up-and-out call vegas.
%   vegaKO = VEGAKOALL(F0,K,KO,B,T,sigma,N_CRR,N_MC)
%   returns a struct with the vegas computed by the exact formula, the
%   CRR tree, and Monte Carlo.
%
%   Output fields:
%     vegaKO.Exact - Exact vega.
%     vegaKO.CRR   - CRR vega with N_CRR time steps.
%     vegaKO.MC    - Monte Carlo vega with N_MC simulations.

vegaKO.Exact = VegaKO(F0,K,KO,B,T,sigma,N_CRR,3);
vegaKO.CRR = VegaKO(F0,K,KO,B,T,sigma,N_CRR,1);
vegaKO.MC = VegaKO(F0,K,KO,B,T,sigma,N_MC,2);
end