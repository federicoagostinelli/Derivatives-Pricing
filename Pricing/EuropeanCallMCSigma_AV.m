function stdHat_AV = EuropeanCallMCSigma_AV(F0,K,B,T,sigma,N)
% EUROPEANCALLMCSIGMA_AV Estimates the Monte Carlo standard error using antithetic variables.
%   stdHat_AV = EUROPEANCALLMCSIGMA_AV(F0,K,B,T,sigma,N) computes the
%   estimated standard error of the Monte Carlo price estimator for a
%   European call option under the lognormal model, using N antithetic
%   simulation pairs.
%
%   Input arguments:
%     F0    - Forward price of the underlying.
%     K     - Strike price.
%     B     - Discount factor.
%     T     - Time to maturity.
%     sigma - Volatility parameter.
%     N     - Number of antithetic Monte Carlo pairs.
%
%   Output argument:
%     stdHat_AV - Estimated standard error of the antithetic Monte Carlo estimator.

rng(1,'twister')

payoff = @(u) max(u - K, 0);

W_T  = sqrt(T) * randn(N,1);
F_T1 = F0 .* exp(-0.5 * sigma^2 * T + sigma * W_T);
F_T2 = F0 .* exp(-0.5 * sigma^2 * T - sigma * W_T);

disc_payoff1 = B * payoff(F_T1);
disc_payoff2 = B * payoff(F_T2);

antithetic_payoff = 0.5 * (disc_payoff1 + disc_payoff2);
stdHat_AV = std(antithetic_payoff,0) / sqrt(N);

end