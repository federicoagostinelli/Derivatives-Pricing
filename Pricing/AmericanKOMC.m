function optionPrice= AmericanKOMC(F0,K,KO,B,T,sigma,Nsim)
% AMERICANKOMC Prices a European call option with weekly monitored up-and-out barrier.
%   [optionPrice,CI] = AMERICANKOMC(F0,K,KO,B,T,sigma,Nsim) computes the
%   Monte Carlo estimate of a European call option price under the lognormal
%   model with an up-and-out barrier monitored weekly along the path.
%
%   Input arguments:
%     F0     - Forward price of the underlying.
%     K      - Strike price.
%     KO     - Up-and-out barrier level.
%     B      - Discount factor.
%     T      - Time to maturity.
%     sigma  - Volatility parameter.
%     Nsim   - Number of Monte Carlo simulations.
%
%   Output arguments:
%     optionPrice - Monte Carlo estimate of the barrier option price.

rng(1,'twister')

payoff = @(u) max(u - K, 0);

M  = round(52*T);      % Weekly monitoring
dt = T/M;
dXt = -0.5*sigma^2*dt + sigma*sqrt(dt)*randn(Nsim,M);
F = F0 * exp([zeros(Nsim,1), cumsum(dXt,2)]);

disc_payoff = B * payoff(F(:,end)) .* (max(F,[],2) < KO);
optionPrice = mean(disc_payoff);