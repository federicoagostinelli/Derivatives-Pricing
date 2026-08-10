function sigmaHat = EuropeanCallMCSigma(F0,K,B,T,sigma,N)
% EUROPEANCALLMCSIGMA Monte Carlo standard error estimator for a European call price.
%
%   sigmaHat = EUROPEANCALLMCSIGMA(F0,K,B,T,sigma,N) simulates N terminal forward
%   prices under the Black(-76) dynamics and returns the estimated standard error
%   of the discounted call payoff (i.e., std(payoff)/sqrt(N)).
%
%   Input arguments:
%     F0    - Forward price at time 0.
%     K     - Strike price.
%     B     - Discount factor over [0,T].
%     T     - Time to maturity.
%     sigma - Volatility parameter.
%     N     - Number of Monte Carlo simulations.
%
%   Output argument:
%     sigmaHat - Estimated standard error of the Monte Carlo price estimator.

rng(1,'twister')

payoff = @(u) max(u-K,0);
W_T = sqrt(T)*randn(N,1);
F_T = F0.*exp(-0.5*sigma^2*T + sigma*W_T);
disc_payoff = B*payoff(F_T);
sigmaHat = std(disc_payoff, 0)/sqrt(N);
end