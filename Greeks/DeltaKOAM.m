function deltaAM = DeltaKOAM(S0,d,K,KO,B,T,sigma,N,flagNum)
% DELTAKOAM Computes the Delta of a European call option with American up-and-out barrier.
%   deltaAM = DELTAKOAM(S0,d,K,KO,B,T,sigma,N,flagNum) returns the sensitivity
%   of the barrier option price with respect to the spot price. Depending on
%   flagNum, the value is computed by CRR or Monte Carlo approximation.
%
%   Input arguments:
%     S0      - Spot price of the underlying.
%     d       - Dividend yield.
%     K       - Strike price.
%     KO      - Up-and-out barrier level.
%     B       - Discount factor.
%     T       - Time to maturity.
%     sigma   - Volatility parameter.
%     N       - Number of CRR time steps or Monte Carlo simulations.
%     flagNum - Pricing method indicator:
%               1 = CRR, 2 = Monte Carlo.
%
%   Output argument:
%     deltaAM - Delta of the barrier option.

rng(1,'twister')

h = 0.01 * S0;
if h == 0
    h = 1e-4;
end

F0 = S0 * exp(-d*T) / B;

F0_up   = (S0 + h) * exp(-d*T) / B;
F0_down = (S0 - h) * exp(-d*T) / B;

if flagNum == 1
    % CRR approximation
    price_up   = AmericanKOCRR(F0_up,K,KO,B,T,sigma,N);
    price_down = AmericanKOCRR(F0_down,K,KO,B,T,sigma,N);
    deltaAM = (price_up - price_down) / (2*h);

elseif flagNum == 2
    % Monte Carlo approximation
    price_up   = AmericanKOMC(F0_up,K,KO,B,T,sigma,N);
    price_down = AmericanKOMC(F0_down,K,KO,B,T,sigma,N);
    deltaAM = (price_up - price_down) / (2*h);

elseif flagNum == 3 
    % Exact Formula
    delta1 = DeltaKOEU(S0,d,K,KO,B,T,sigma,N,3);

    F0_hat = (KO^2)/F0;

    d1_K  = (log(F0_hat/K)  + 0.5 * sigma^2 * T) / (sigma * sqrt(T));
    d1_KO = (log(F0_hat/KO) + 0.5 * sigma^2 * T) / (sigma * sqrt(T));
    d2_KO = (log(F0_hat/KO) - 0.5 * sigma^2 * T) / (sigma * sqrt(T));

    delta_C1 = exp(-d*T) * normcdf(d1_K);
    delta_C2 = exp(-d*T) * normcdf(d1_KO);

    phi_d2 = exp(-0.5 * d2_KO^2) / sqrt(2*pi);
    delta_term3 = (KO - K) * exp(-d*T) * phi_d2 / (F0_hat * sigma * sqrt(T));

    delta2 = delta_C1 - delta_C2 - delta_term3;

    deltaAM = delta1 - (KO/F0)^(-1)*delta2;

else
    error('Unknown pricing method. Use 1 = CRR, 2 = Monte Carlo.');
end

end