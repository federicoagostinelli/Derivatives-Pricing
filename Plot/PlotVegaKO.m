function [vegaExact,vegaCRR,vegaMC] = PlotVegaKO(Fvec,K,KO,B,T,sigma,N_CRR,N_MC)
% PLOTVEGAKO Plots the Vega of a European up-and-out call option versus forward price.
%   [vegaExact,vegaCRR,vegaMC] = PLOTVEGAKO(Fvec,K,KO,B,T,sigma,N_CRR,N_MC)
%   computes the Vega of a European up-and-out call option for each forward
%   price in Fvec using the closed-form formula, the CRR approximation, and
%   the Monte Carlo method. The function also plots the resulting Vega curves.
%
%   Input arguments:
%     Fvec   - Vector of forward prices.
%     K      - Strike price.
%     KO     - Up-and-out barrier level.
%     B      - Discount factor.
%     T      - Time to maturity.
%     sigma  - Volatility parameter.
%     N_CRR  - Number of CRR time steps.
%     N_MC   - Number of Monte Carlo simulations.
%
%   Output arguments:
%     vegaExact - Vector of closed-form Vega values.
%     vegaCRR   - Vector of CRR-based Vega values.
%     vegaMC    - Vector of Monte Carlo Vega values.

vegaCRR   = arrayfun(@(F0) VegaKO(F0,K,KO,B,T,sigma,N_CRR,1), Fvec);
vegaMC    = arrayfun(@(F0) VegaKO(F0,K,KO,B,T,sigma,N_MC,2), Fvec);
vegaExact = arrayfun(@(F0) VegaKO(F0,K,KO,B,T,sigma,0,3), Fvec);

figure();
plot(Fvec, vegaExact, 'k-', 'LineWidth', 1.5); hold on;
plot(Fvec, vegaCRR,   'b--', 'LineWidth', 1.2);
plot(Fvec, vegaMC,    'r-.', 'LineWidth', 1.2);
grid on;
xlabel('Forward price F_0');
ylabel('Vega');
title('Vega of the European up-and-out call option');
legend('Closed form','CRR','Monte Carlo','Location','best');

end