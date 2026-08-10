function optionPrice = EuropeanKOMC(F0,K,KO,B,T,sigma,N)
% EUROPEANKOMC Prices a European up-and-out call option by Monte Carlo simulation.
%   optionPrice = EUROPEANKOMC(F0,K,KO,B,T,sigma,N) simulates the
%   discounted payoff of a European call option under the lognormal model
%   and returns the Monte Carlo estimate of the option price with a European
%   up-and-out barrier, monitored only at maturity.
%
%   Input arguments:
%     F0    - Forward price of the underlying.
%     K     - Strike price.
%     KO    - Up-and-out barrier level.
%     B     - Discount factor.
%     T     - Time to maturity.
%     sigma - Volatility parameter.
%     N     - Number of Monte Carlo simulations.
%
%   Output argument:
%     optionPrice - Monte Carlo estimate of the barrier option price.

rng(1,'twister')

payoff = @(u) max(u - K, 0);
W_T = sqrt(T) * randn(N,1);
F_T = F0 .* exp(-0.5 * sigma^2 * T + sigma * W_T);
disc_payoff = B * payoff(F_T);

optionPrice = mean(disc_payoff .* (F_T < KO));
end