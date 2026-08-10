% Assignment 01
% Group 01, AA2025-2026

clc; clear; close all
format long
projectRoot = fileparts(which('runAssignment01_Group01.m'));
addpath(genpath(projectRoot));

rng(1,'twister')

%% Pricing parameters
% All model parameters are collected in the struct params and passed to the
% functions of interest when needed.
params.S0    = 1;
params.K     = 1.1;
params.r     = 0.025;
params.TTM   = 1/3;
params.sigma = 0.212;
params.d     = 0.02;
params.flag  = 1;   % 1 = call, -1 = put

%% Quantities of interest
B  = exp(-params.r * params.TTM);                           % Discount factor
F0 = params.S0 * exp(-params.d * params.TTM) / B;          % Forward in G&C model

%% Pricing   
M = 100;           % M = simulations for MC, steps for CRR
OptionPrice.Exact = EuropeanOptionPrice(F0,params.K,B,params.TTM,...
    params.sigma,1,M,params.flag);
OptionPrice.CRR = EuropeanOptionPrice(F0,params.K,B,params.TTM,...
    params.sigma,2,M,params.flag);
OptionPrice.MC = EuropeanOptionPrice(F0,params.K,B,params.TTM,...
    params.sigma,3,M,params.flag);
OptionPrice
%% M selection
tol = 0.5*1e-4;   % Tolerance that ensures the error is <= than 1 bp

price = OptionPrice.Exact;

% CRR
NvecC = 2.^(1:10);
M_CRR = FindM_CRR(NvecC,F0,params.TTM,params.sigma,B,params.K,tol,params.flag);
priceCRR = EuropeanOptionPrice(F0,params.K,B,params.TTM,...
    params.sigma,2,M_CRR,params.flag)

% MC
NvecM = 2.^(1:20);
M_MC = FindM_MC(NvecM,F0,params.TTM,params.sigma,B,params.K,tol);
priceMC = EuropeanOptionPrice(F0,params.K,B,params.TTM,...
    params.sigma,3,M_MC,params.flag)

%% Error rescaling
% Plot errors for CRR varying the number of time steps
[nCRR,errCRR] = PlotErrorCRR(NvecC,F0,params.K,B,params.TTM,params.sigma,params.flag);

% Plot errors for MC varying the number of simulations
[nMC,stdEstim] = PlotErrorMC(NvecM,F0,params.K,B,params.TTM,params.sigma,tol,params.flag);

%% KI Option
params.KO = 1.4;
priceKO_EU = EuropeanKOPrice(F0,params.K,params.KO,B, ...
    params.TTM,params.sigma,M_CRR,M_MC)

%% KI Option Vega
vegaKO_EU = VegaKOAll(F0,params.K,params.KO,B,params.TTM,params.sigma,M_CRR,M_MC)

% Plot
Svec = linspace(0.65,1.45,200);
Fvec = Svec .* exp(-params.d*params.TTM) / B;
[vegaExact,vegaCRR,vegaMC] = PlotVegaKO(Fvec,params.K,params.KO,B, ...
    params.TTM,params.sigma,M_CRR,M_MC);

%% Greeks
priceKO_AM = AmericanKOPrice(F0,params.K,params.KO,B, ...
    params.TTM,params.sigma,M_CRR,M_MC)

% European barrier option Delta: 
% comparison of numerical differentiation methods

[deltaKO_EU_spotBump, deltaKO_EU_chainRule] = DeltaKOEUAll( ...
    params.S0,params.d,params.K,params.KO,B,params.TTM,params.sigma,M_CRR,M_MC);
deltaKO_EU_spotBump
deltaKO_EU_chainRule

% American barrier option Delta
deltaKO_AM = DeltaKOAMAll(params.S0,params.d,params.K,params.KO,B, ...
    params.TTM,params.sigma,M_CRR,M_MC)

% European barrier option vega
vegaKO_EU

% American barrier option vega
vegaKO_AM = VegaKOAMAll(F0,params.K,params.KO,B, ...
    params.TTM,params.sigma,M_CRR,M_MC)

%% Antithetic Variables
sigmaHat = EuropeanCallMCSigma(F0,params.K,B,params.TTM,...
    params.sigma,M_MC);
sigmaHat_AV = EuropeanCallMCSigma_AV(F0,params.K,B,params.TTM,...
    params.sigma,M_MC);
reductionFactor = sigmaHat / sigmaHat_AV;
fprintf('The standard deviation has been reduced by a factor of %.4f using antithetic variables.\n', reductionFactor);

%% Bermudan 
% We compare the price of the Bermudan option with
% the price of the EuropeanOption computed using CRR Tree
priceBerm = BermudanOptionCRR(params.S0,params.K,params.r,params.d,...
    params.TTM,params.sigma,M_CRR);
price = EuropeanOptionCRR(params.S0* exp(-params.d * params.TTM) / B, ...
    params.K,B,params.TTM,params.sigma,M_CRR, params.flag);
fprintf('Bermudan price = %.6f, European price = %.6f, difference = %.6f\n', ...
    priceBerm, price, priceBerm - price);
%% Bermudan - European comparison
divVec = linspace(0,0.05,21);
[priceBerm,priceEU] = PlotBermudanVsEuropeanDividend( ...
    divVec, params.S0, params.K, params.r, B, params.TTM, ...
    params.sigma, M_CRR);