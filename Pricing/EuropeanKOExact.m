function optionPrice = EuropeanKOExact(F0,K,KO,B,T,sigma)
% EUROPEANKOEXACT Prices a European up-and-out call option in closed form.
%   optionPrice = EUROPEANKOEXACT(F0,K,KO,B,T,sigma) returns the
%   closed-form price of a European call option with terminal up-and-out
%   barrier KO under the lognormal model.

callK  = EuropeanOptionClosed(F0,K,B,T,sigma,1);
callKO = EuropeanOptionClosed(F0,KO,B,T,sigma,1);

d2  = (log(F0/KO) - 0.5 * sigma^2 * T) / (sigma * sqrt(T));
Nd2 = normcdf(d2);

optionPrice = callK - callKO - B * (KO - K) * Nd2;
end