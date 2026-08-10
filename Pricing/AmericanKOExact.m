function optionPrice = AmericanKOExact(F0,K,KO,B,T,sigma)
% AMERICANKOEXACT Prices an American up-and-out Barrier Call Option in closed form.
%   optionPrice = AMERICANKOEXACT(F0,K,KO,B,T,sigma) returns the
%   closed-form price of a European call option with terminal up-and-out
%   barrier KO under the lognormal model.

callK  = EuropeanOptionClosed((KO^2)/F0,K,B,T,sigma,1);
callKO = EuropeanOptionClosed((KO^2)/F0,KO,B,T,sigma,1);

d2  = (log((KO)/F0) - 0.5 * sigma^2 * T) / (sigma * sqrt(T));
Nd2 = normcdf(d2);

Reflected = callK - callKO - B * (KO - K) * Nd2;
% F0_hat = (KO^2)/F0;
% Reflected = EuropeanKOExact(F0_hat,K,KO,B,T,sigma);
optionPrice = EuropeanKOExact(F0,K,KO,B,T,sigma) - (KO/F0)^(-1)*Reflected;
end