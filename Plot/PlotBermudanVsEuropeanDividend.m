function [priceBerm,priceEU] = PlotBermudanVsEuropeanDividend(divVec,S0,K,r,B,T,sigma,N)
% PLOTBERMUDANVSEUROPEANDIVIDEND Compares Bermudan and European call prices across dividend yields.
%   [priceBerm,priceEU] = PLOTBERMUDANVSEUROPEANDIVIDEND(divVec,S0,K,r,B,T,sigma,N)
%   computes the price of a Bermudan call option on a dividend-paying stock
%   using a CRR tree and compares it with the corresponding European call
%   price for each dividend yield in divVec. The function also plots both
%   price curves.
%
%   Input arguments:
%     divVec - Vector of dividend yields.
%     S0     - Spot price of the underlying stock.
%     K      - Strike price.
%     r      - Risk-free interest rate.
%     B      - Discount factor over [0,T].
%     T      - Time to maturity.
%     sigma  - Volatility parameter.
%     N      - Number of CRR time steps for the Bermudan tree.
%
%   Output arguments:
%     priceBerm - Vector of Bermudan call prices.
%     priceEU   - Vector of European call prices.

flag = 1;   % hardcoded: call option

priceBerm = arrayfun(@(d) BermudanOptionCRR(S0,K,r,d,T,sigma,N), divVec);

priceEU = arrayfun(@(d) ...
    EuropeanOptionCRR(S0 * exp(-d*T) / B, K, B, T, sigma, N,flag), ...
    divVec);

figure();
plot(100*divVec, priceBerm, 'b-', 'LineWidth', 1.5); hold on;
plot(100*divVec, priceEU, 'r--', 'LineWidth', 1.5);
grid on;
xlabel('Dividend yield (%)');
ylabel('Option price');
title('Bermudan vs European call price across dividend yields');
legend('Bermudan (CRR)','European (closed form)','Location','best');

end