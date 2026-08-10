function [nCRR, errCRR] = PlotErrorCRR(NvecC,F0,K,B,TTM,sigma,flag)
% PLOTERRORCRR Plots the CRR pricing error versus the number of time steps.
%   [nCRR,errCRR] = PLOTERRORCRR(NvecC,F0,K,B,TTM,sigma,flag) computes the
%   absolute pricing error of the Cox-Ross-Rubinstein (CRR) approximation
%   with respect to the closed-form benchmark for each grid size in NvecC.
%   The function also plots the error on a log-log scale together with a
%   1/N reference line and returns the corresponding grid sizes and errors.
%
%   Input arguments:
%     NvecC  - Vector of candidate CRR grid sizes.
%     F0     - Forward price of the underlying.
%     K      - Strike price.
%     B      - Discount factor.
%     TTM    - Time to maturity.
%     sigma  - Volatility parameter.
%     flag   - Option type indicator.
%
%   Output arguments:
%     nCRR   - Vector of CRR grid sizes.
%     errCRR - Vector of absolute pricing errors.

if nargin < 7
    flag = 1;
end

priceClosed = EuropeanOptionClosed(F0,K,B,TTM,sigma,flag);
priceCRR = arrayfun(@(N) EuropeanOptionCRR(F0,K,B,TTM,sigma,N,flag), NvecC);

errCRR = abs(priceClosed - priceCRR);
nCRR = NvecC;

% 1/N reference line, anchored at the first point
yReference = errCRR(1) * (NvecC(1) ./ NvecC);

figure();
loglog(NvecC, errCRR, '-ob', 'LineWidth', 1.2, ...
    'MarkerSize', 6, 'DisplayName', '|Price_{closed} - Price_{CRR}|');
hold on;
loglog(NvecC, yReference, '--r', 'LineWidth', 1.2, ...
    'DisplayName', 'Benchmark 1/N');

grid on;
xlabel('N (time steps)');
ylabel('Absolute error');
title('CRR error vs N');
legend('Location','northeast');
hold off;

end