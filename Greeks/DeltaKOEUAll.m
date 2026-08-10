function [deltaSpotBump, deltaChainRule] = DeltaKOEUAll(S0,d,K,KO,B,T,sigma,N_CRR,N_MC)
% DELTAKOEUALL Wrapper returning European up-and-out call deltas.
%   [deltaSpotBump, deltaChainRule] = DELTAKOEUALL(S0,d,K,KO,B,T,sigma,N_CRR,N_MC)
%   returns two structs, one for each differentiation method:
%   direct spot bumping and forward bumping with chain rule.
%
%   Output fields in each struct:
%     .CRR   - Delta computed with the CRR method.
%     .MC    - Delta computed with the Monte Carlo method.
%     .Exact - Closed-form Delta.

deltaSpotBump.CRR = DeltaKOEU(S0,d,K,KO,B,T,sigma,N_CRR,1,1);
deltaSpotBump.MC = DeltaKOEU(S0,d,K,KO,B,T,sigma,N_MC,2,1);
deltaSpotBump.Exact = DeltaKOEU(S0,d,K,KO,B,T,sigma,0,3,1);

deltaChainRule.CRR = DeltaKOEU(S0,d,K,KO,B,T,sigma,N_CRR,1,2);
deltaChainRule.MC = DeltaKOEU(S0,d,K,KO,B,T,sigma,N_MC,2,2);
deltaChainRule.Exact = DeltaKOEU(S0,d,K,KO,B,T,sigma,0,3,1);
end