function optionPrice = EuropeanKOCRR(F0,K,KO,B,T,sigma,N)
% EUROPEANKOCRR Prices a European up-and-out call option with the CRR model.
%   optionPrice = EUROPEANKOCRR(F0,K,KO,B,T,sigma,N) computes the price
%   of a European call option with a European up-and-out barrier using an
%   N-step Cox-Ross-Rubinstein (CRR) tree under the lognormal model.
%
%   Input arguments:
%     F0    - Forward price of the underlying.
%     K     - Strike price.
%     KO    - Up-and-out barrier level.
%     B     - Discount factor.
%     T     - Time to maturity.
%     sigma - Volatility parameter.
%     N     - Number of CRR time steps.
%
%   Output argument:
%     optionPrice - CRR estimate of the barrier option price.

payoff = @(u) max(u - K, 0);

dt = T / N;
u = exp(sqrt(dt) * sigma);
d = 1 / u;
q = (1 - d) / (u - d);

F_T = F0 * u.^(N - 2*(0:N));
Tree = payoff(F_T) .* (F_T < KO);

for j = N:-1:1
    Tree = q * Tree(1:j) + (1 - q) * Tree(2:j+1);
end

optionPrice = B * Tree(1);
end