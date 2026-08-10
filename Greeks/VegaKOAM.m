function vegaAM = VegaKOAM(F0,K,KO,B,T,sigma,N,flagNum)
% VEGAKOAM Computes the Vega of a European call option with American up-and-out barrier.
%   vegaAM = VEGAKOAM(F0,K,KO,B,T,sigma,N,flagNum) returns the sensitivity
%   of the barrier option price with respect to volatility, scaled to represent
%   the price change corresponding to a 1% change in sigma. Depending on
%   flagNum, the value is computed by CRR or Monte Carlo approximation.
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
%               1 = CRR, 2 = Monte Carlo.
%
%   Output argument:
%     vegaAM  - Vega of the barrier option, defined as 1% of the derivative
%               of the option price with respect to sigma.

rng(1,'twister')

relBump = 0.01;
h = relBump * sigma;

if h == 0
    h = 1e-4;
end

if flagNum == 1
    % CRR approximation
    price_up   = AmericanKOCRR(F0,K,KO,B,T,sigma + h,N);
    price_down = AmericanKOCRR(F0,K,KO,B,T,sigma - h,N);
    vegaAM = 0.01 * (price_up - price_down) / (2*h);

elseif flagNum == 2
    % Monte Carlo approximation
    price_up   = AmericanKOMC(F0,K,KO,B,T,sigma + h,N);
    price_down = AmericanKOMC(F0,K,KO,B,T,sigma - h,N);
    vegaAM = 0.01 * (price_up - price_down) / (2*h);


elseif flagNum == 3
    % Closed-form Vega
    vega1 = VegaKO(F0,K,KO,B,T,sigma,N,3);

    F0_hat = (KO^2)/F0;

    vega2 = VegaKO(F0_hat,K,KO,B,T,sigma,N,3);

    vegaAM = vega1 - (KO/F0)^(-1)*vega2;


else
    error('Unknown pricing method. Use 1 = CRR, 2 = Monte Carlo.');
end

end