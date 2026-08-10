function optionPrice=EuropeanOptionMC(F0,K,B,T,sigma,N,flag)   
% Option Price with MC
%
% INPUT:
% F0:    forward price
% B:     discount factor
% K:     strike
% T:     time-to-maturity
% sigma: volatility
% pricingMode: 1 ClosedFormula, 2 CRR, 3 Monte Carlo
% N:     number of simulations in MC   
% flag:  1 call, -1 put

rng(1,'twister')

if flag == 1
    payoff = @(u) max(u-K,0);
elseif flag == -1
    payoff = @(u) max(K-u,0);
else
    fprintf("Error! Unknown option type\n");
    return;
end
W_T = sqrt(T)*randn(N,1);
F_T = F0.*exp(-0.5*sigma^2*T + sigma*W_T);
disc_payoff = B*payoff(F_T);
optionPrice = mean(disc_payoff);