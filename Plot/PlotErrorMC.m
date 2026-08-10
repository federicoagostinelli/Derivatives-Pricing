function [nMC,stdEstim] = PlotErrorMC(NvecM, F0,K,B,TTM,sigma, tol, flag)
% PLOTERRORMC Plots Monte Carlo pricing error and standard error versus sample size.
%   [nMC,stdEstim] = PLOTERRORMC(NvecM,F0,K,B,TTM,sigma,tol,flag) computes the
%   absolute pricing error of the Monte Carlo estimator with respect to the
%   closed-form benchmark and the corresponding estimated standard error for
%   each sample size in NvecM. The function also plots both quantities on a
%   log-log scale together with a 1/sqrt(N) reference line and returns the
%   selected sample size satisfying the tolerance criterion.
%
%   Input arguments:
%     NvecM   - Vector of Monte Carlo sample sizes.
%     F0      - Forward price of the underlying.
%     K       - Strike price.
%     B       - Discount factor.
%     TTM     - Time to maturity.
%     sigma   - Volatility parameter.
%     tol     - Prescribed error tolerance.
%     flag    - Option type indicator.
%
%   Output arguments:
%     nMC      - Selected Monte Carlo sample size.
%     stdEstim - Vector of estimated standard errors of the Monte Carlo price.

if nargin < 8
    flag = 1;
end

priceClosed = EuropeanOptionClosed(F0,K,B,TTM,sigma,flag);
priceMC  = arrayfun(@(N) EuropeanOptionMC(F0,K,B,TTM,sigma,N,flag), NvecM);
stdEstim = arrayfun(@(N) EuropeanCallMCSigma(F0,K,B,TTM,sigma,N), NvecM);
errMC = abs(priceClosed - priceMC);
nMC = FindM_MC(NvecM,F0,TTM,sigma,B,K,tol);

% Reference 1/sqrt(N), scaled to be clearly visible
ratioN = NvecM(1)./NvecM;
yReference =  stdEstim(1) * sqrt(ratioN);

figure;
loglog(NvecM, errMC, '-ok', 'LineWidth', 1.2, 'MarkerSize', 6, ...
    'DisplayName', '|Price_{closed} - Price_{MC}|');
hold on;

loglog(NvecM, stdEstim, '-sr', 'LineWidth', 1.2, 'MarkerSize', 6, ...
    'DisplayName', 'Estimated SD of MC price');

loglog(NvecM, yReference, '--b', 'LineWidth', 2.5, ...
    'DisplayName', 'Reference 1/sqrt(N)');

grid on;
xlabel('N (simulations)');
ylabel('Error / Std estimate');
title('MC error and std estimate vs N');
legend('Location','southwest');
hold off;

end