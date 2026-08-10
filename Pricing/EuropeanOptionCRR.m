function optionPrice=EuropeanOptionCRR(F0,K,B,T,sigma,N,flag)
% Option Price with CRR
%
% INPUT:
% F0:    forward price
% B:     discount factor
% K:     strike
% T:     time-to-maturity
% sigma: volatility
% N:     either number of time steps (knots for CRR tree)
% flag:  1 call, -1 put
if flag == 1
    payoff = @(u) max(u-K,0);
elseif flag == -1
    payoff = @(u) max(K-u,0);
else
    fprintf("Error! Unknown option type\n");
    return;
end
dt = T/N;
u = exp(sqrt(dt)*sigma); d = 1/u;
q = (1-d)/(u-d);
Tree = payoff(F0*u.^(N-2*(1:N+1)+2));
for j = N:-1:1
    Tree = (q*Tree(1:j)+(1-q)*Tree(2:j+1));
end
optionPrice = B * Tree(1);
end