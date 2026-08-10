function optionPrice = BermudanOptionCRR(S0,K,r,d,T,sigma,N)
% BERMUDANOPTIONCRR Prices a Bermudan option on a dividend-paying stock with the CRR model.
%   optionPrice = BERMUDANOPTIONCRR(S0,K,r,d,T,sigma,N) computes the
%   price of a Bermudan call option written on a stock paying a
%   continuous dividend yield d, using an N-step Cox-Ross-Rubinstein (CRR)
%   tree. Exercise is allowed at the end of every month and at maturity.
%
%   Input arguments:
%     S0    - Spot price of the underlying stock.
%     K     - Strike price.
%     r     - Risk-free interest rate.
%     d     - Continuous dividend yield.
%     T     - Time to maturity.
%     sigma - Volatility parameter.
%     N     - Number of CRR time steps.
%
%   Output argument:
%     optionPrice - CRR estimate of the Bermudan option price.

payoff = @(u) max(u - K, 0);

dt = T / N;
u = exp(sigma * sqrt(dt));
dwn = 1 / u;

% Risk-neutral probability for a dividend-paying stock
q = (exp((r - d) * dt) - dwn) / (u - dwn);

if q < 0 || q > 1
    error('Invalid CRR parameters: risk-neutral probability outside [0,1].')
end

disc = exp(-r * dt);

% Terminal stock prices
S = S0 * u.^(N - 2*(0:N));
Tree = payoff(S);

% Monthly exercise dates:
monthsAtMaturity = round(T * 12);              % = 4
exerciseTimes = (1:(monthsAtMaturity-1)) / 12; % 1m, 2m, 3m
exerciseSteps = round(exerciseTimes / dt);

for j = N:-1:1
    % Continuation value
    Tree = disc * (q * Tree(1:j) + (1 - q) * Tree(2:j+1));

    % Bermudan exercise at month-end dates
    % Step temporale attuale 
    currentStep = j - 1;
    
    % Controllo esercizio anticipato (Bermudiana)
    if any(currentStep == exerciseSteps)
        % Ricalcolo prezzi del sottostante allo step attuale
        S_current = S0 * u.^(currentStep - 2*(0:currentStep));
        % Confronto tra continuazione e esercizio immediato
        Tree = max(Tree, payoff(S_current));
    end
end

optionPrice = Tree(1);
end