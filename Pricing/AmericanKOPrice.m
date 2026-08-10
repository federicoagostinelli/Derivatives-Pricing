function optionPrice = AmericanKOPrice(F0,K,KO,B,T,sigma,N_CRR,N_MC)
% AMERICANKOPRICE Wrapper returning all American up-and-out call prices.
%   optionPrice = AMERICANKOPRICE(F0,K,KO,B,T,sigma,N_CRR,N_MC)
%   returns a struct with the prices computed by the exact formula, the
%   CRR tree, and Monte Carlo.
%
%   Output fields:
%     optionPrice.Exact - Exact price.
%     optionPrice.CRR   - CRR price with N_CRR time steps.
%     optionPrice.MC    - Monte Carlo price with N_MC simulations.

optionPrice.Exact = AmericanKOExact(F0,K,KO,B,T,sigma);
optionPrice.CRR = AmericanKOCRR(F0,K,KO,B,T,sigma,N_CRR);
optionPrice.MC = AmericanKOMC(F0,K,KO,B,T,sigma,N_MC);
end