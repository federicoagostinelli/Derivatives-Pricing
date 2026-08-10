function optionPrice = AmericanKOCRR(F0,K,KO,B,T,sigma,N)
% AMERICANKOCRR Prices a European call option with American up-and-out barrier.
%   optionPrice = AMERICANKOCRR(F0,K,KO,B,T,sigma,N) computes the
%   price of a European call option with an up-and-out barrier monitored at
%   every tree date, using an N-step Cox-Ross-Rubinstein (CRR) tree under
%   the lognormal model.
%
%   Input arguments:
%     F0    - Forward price of the underlying.
%     K     - Strike price.
%     KO    - Up-and-out barrier level.
%     B     - Discount factor over [0,T].
%     T     - Time to maturity.
%     sigma - Volatility parameter.
%     N     - Number of CRR time steps.
%
%   Output argument:
%     optionPrice - CRR estimate of the barrier option price.

dt=T/N;
u=exp(sqrt(dt)*sigma);
d=1/u;

q = (1-d)/(u-d);

F_T=F0*u.^(N-2*(1:N+1)+2); % d = 1/u.
Tree=max(F_T-K,0).*(F_T < KO);

for j=N:-1:1
  F_t = F0*u.^(j-2*(1:j)+1); % d = 1/u
  Tree = (q*Tree(1:j)+(1-q)*Tree(2:j+1)).*(F_t < KO);
  %Tree = (q*Tree(1:j)+(1-q)*Tree(2:j+1));
end

optionPrice = B*Tree;
end