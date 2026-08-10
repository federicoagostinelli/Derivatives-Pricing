function optionPrice = EuropeanKOPrice(F0,K,KO,B,T,sigma,N_CRR,N_MC)
% EuropeanKOPrice Wrapper returning pricing of the European call with
%   up-and-out barrier for every pricing method considered.
%   optionPrice = EuropeanKOPrice(F0,K,KO,B,T,sigma,N_CRR,N_MC)
%   returns a struct with the prices computed by the exact formula, the
%   CRR tree, and Monte Carlo.
%
%   Output fields:
%     optionPrice.Exact - Exact price.
%     optionPrice.CRR   - CRR price with N_CRR time steps.
%     optionPrice.MC    - Monte Carlo price with N_MC simulations.

optionPrice.Exact = EuropeanKOExact(F0,K,KO,B,T,sigma);
optionPrice.CRR = EuropeanKOCRR(F0,K,KO,B,T,sigma,N_CRR);
optionPrice.MC = EuropeanKOMC(F0,K,KO,B,T,sigma,N_MC);
end