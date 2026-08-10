function delta = DeltaKOEU(S0,d,K,KO,B,T,sigma,N,flagNum,deltaMode)
% DELTAKOEU Computes the Delta of a European up-and-out call option with European barrier.
%   delta = DELTAKOEU(S0,d,K,KO,B,T,sigma,N,flagNum,deltaMode) returns the
%   sensitivity of the barrier option price with respect to the spot price.
%   Depending on flagNum, the value is computed by CRR, Monte Carlo, or
%   closed-form formula. Depending on deltaMode, the numerical Delta is
%   computed either by directly bumping the spot price or by bumping the
%   forward price and applying the chain rule.
%
%   Input arguments:
%     S0        - Spot price of the underlying.
%     d         - Dividend yield.
%     K         - Strike price.
%     KO        - Up-and-out barrier level.
%     B         - Discount factor.
%     T         - Time to maturity.
%     sigma     - Volatility parameter.
%     N         - Number of CRR time steps or Monte Carlo simulations.
%     flagNum   - Pricing method indicator:
%                 1 = CRR, 2 = Monte Carlo, 3 = closed form.
%     deltaMode - Delta computation mode:
%                 1 = direct spot bump, 2 = forward bump with chain rule.
%
%   Output argument:
%     delta     - Delta of the barrier option.

rng(1,'twister')

if nargin < 10
    deltaMode = 1;
end

F0 = S0 * exp(-d*T) / B;
dFdS = exp(-d*T) / B;

if flagNum == 3
    % Closed-form Delta
    d1_K  = (log(F0/K)  + 0.5 * sigma^2 * T) / (sigma * sqrt(T));
    d1_KO = (log(F0/KO) + 0.5 * sigma^2 * T) / (sigma * sqrt(T));
    d2_KO = (log(F0/KO) - 0.5 * sigma^2 * T) / (sigma * sqrt(T));

    delta_C1 = exp(-d*T) * normcdf(d1_K);
    delta_C2 = exp(-d*T) * normcdf(d1_KO);

    phi_d2 = exp(-0.5 * d2_KO^2) / sqrt(2*pi);
    delta_term3 = (KO - K) * exp(-d*T) * phi_d2 / (F0 * sigma * sqrt(T));

    delta = delta_C1 - delta_C2 - delta_term3;
    return
end

if deltaMode == 1
    % Direct bump with respect to spot
    h = 0.01 * S0;
    if h == 0
        h = 1e-4;
    end

    F_up   = (S0 + h) * exp(-d*T) / B;
    F_down = (S0 - h) * exp(-d*T) / B;

    if flagNum == 1
        price_up   = EuropeanKOCRR(F_up,K,KO,B,T,sigma,N);
        price_down = EuropeanKOCRR(F_down,K,KO,B,T,sigma,N);
    elseif flagNum == 2
        price_up   = EuropeanKOMC(F_up,K,KO,B,T,sigma,N);
        price_down = EuropeanKOMC(F_down,K,KO,B,T,sigma,N);
    else
        error('Unknown pricing method. Use 1 = CRR, 2 = Monte Carlo, 3 = Exact.');
    end

    delta = (price_up - price_down) / (2*h);

elseif deltaMode == 2
    % Forward bump + chain rule
    h = 0.01 * F0;
    if h == 0
        h = 1e-4;
    end

    if flagNum == 1
        price_up   = EuropeanKOCRR(F0 + h,K,KO,B,T,sigma,N);
        price_down = EuropeanKOCRR(F0 - h,K,KO,B,T,sigma,N);
    elseif flagNum == 2
        price_up   = EuropeanKOMC(F0 + h,K,KO,B,T,sigma,N);
        price_down = EuropeanKOMC(F0 - h,K,KO,B,T,sigma,N);
    else
        error('Unknown pricing method. Use 1 = CRR, 2 = Monte Carlo, 3 = Exact.');
    end

    delta = ((price_up - price_down) / (2*h)) * dFdS;

else
    error('Unknown delta computation mode. Use 1 = direct spot bump, 2 = forward bump with chain rule.');
end

end