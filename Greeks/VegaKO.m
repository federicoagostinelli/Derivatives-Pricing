function vega = VegaKO(F0,K,KO,B,T,sigma,N,flagNum)
% VEGAKO Computes the Vega of a European up-and-out call option.
%   vega = VEGAKO(F0,K,KO,B,T,sigma,N,flagNum) returns the sensitivity of
%   the barrier option price with respect to volatility, scaled to represent
%   the price change corresponding to a 1% change in sigma. Depending on
%   flagNum, the value is computed by CRR, Monte Carlo, or closed-form formula.
%
%   Input arguments:
%     F0      - Forward price of the underlying.
%     K       - Strike price.
%     KO      - Up-and-out barrier level.
%     B       - Discount factor.
%     T       - Time to maturity.
%     sigma   - Volatility parameter.
%     N       - Number of CRR time steps or Monte Carlo simulations.
%     flagNum - Pricing method indicator:
%               1 = CRR, 2 = Monte Carlo, 3 = closed form.
%
%   Output argument:
%     vega    - Vega of the barrier option, defined as 1% of the derivative
%               of the option price with respect to sigma.

rng(1,'twister')

relBump = 0.01;
h = relBump * sigma;

if h == 0
    h = 1e-4;
end

if flagNum == 1
    % CRR approximation
    price_up   = EuropeanKOCRR(F0,K,KO,B,T,sigma + h,N);
    price_down = EuropeanKOCRR(F0,K,KO,B,T,sigma - h,N);
    vega = 0.01 * (price_up - price_down) / (2*h);

elseif flagNum == 2
    % Monte Carlo approximation
    price_up   = EuropeanKOMC(F0,K,KO,B,T,sigma + h,N);
    price_down = EuropeanKOMC(F0,K,KO,B,T,sigma - h,N);
    vega = 0.01 * (price_up - price_down) / (2*h);

elseif flagNum == 3
    % Closed-form Vega
    d1_K  = (log(F0/K)  + 0.5*sigma^2*T) / (sigma*sqrt(T));
    d1_KO = (log(F0/KO) + 0.5*sigma^2*T) / (sigma*sqrt(T));
    d2_KO = (log(F0/KO) - 0.5*sigma^2*T) / (sigma*sqrt(T));

    phi1_K  = exp(-0.5*d1_K^2)  / sqrt(2*pi);
    phi1_KO = exp(-0.5*d1_KO^2) / sqrt(2*pi);
    phi2_KO = exp(-0.5*d2_KO^2) / sqrt(2*pi);

    dNd2_dsigma = phi2_KO * ( -log(F0/KO)/(sigma^2*sqrt(T)) - 0.5*sqrt(T) );

    vega = 0.01 * (F0 * (phi1_K - phi1_KO) * sqrt(T) ...
         - B * (KO - K) * dNd2_dsigma);

else
    error('Unknown pricing method. Use 1 = CRR, 2 = Monte Carlo, 3 = Exact.');
end

end