function M_MC = FindM_MC(NvecM,F0,TTM,sigma,B,K,tol)
% FINDM_MC Selects the minimum Monte Carlo sample size satisfying a tolerance criterion.
%   M_MC = FINDM_MC(NvecM,F0,TTM,sigma,B,K,tol) evaluates the estimated pricing
%   error for a European call option over the sample sizes specified in NvecM
%   and returns the first value for which the error remains below tol for all
%   subsequent entries.
%
%   If no such value exists within NvecM, the function tests 3 additional
%   candidate values beyond the last element of NvecM, obtained by doubling
%   the last sample size repeatedly. If one of these satisfies the criterion,
%   it is returned; otherwise, the last tested value is returned.
%
%   Input arguments:
%     NvecM - Vector of candidate Monte Carlo sample sizes.
%     F0    - Initial value of the underlying.
%     TTM   - Time to maturity.
%     sigma - Volatility parameter.
%     B     - Discount factor.
%     K     - Strike price.
%     tol   - Prescribed error tolerance.
%
%   Output argument:
%     M_MC  - Selected Monte Carlo sample size.

    % Ensure row vector
    NvecM = NvecM(:)';

    % Evaluate initial grid
    sdPriceHat = arrayfun(@(N) EuropeanCallMCSigma(F0,K,B,TTM,sigma,N), NvecM);
    validMC = sdPriceHat <= tol;
    suffixMC = arrayfun(@(i) all(validMC(i:end)), 1:numel(validMC));   % stays below
    idx = find(suffixMC, 1, 'first');

    if ~isempty(idx)
        M_MC = NvecM(idx);
        return;
    end

    % If no admissible value is found, extend with 3 doubling values
    lastN = NvecM(end);
    extraN = lastN * 2.^(1:3);

    NvecM_ext = [NvecM, extraN];

    % Re-evaluate on the extended grid
    sdPriceHat_ext = arrayfun(@(N) EuropeanCallMCSigma(F0,K,B,TTM,sigma,N), NvecM_ext);
    validMC_ext = sdPriceHat_ext <= tol;
    suffixMC_ext = arrayfun(@(i) all(validMC_ext(i:end)), 1:numel(validMC_ext));
    idx_ext = find(suffixMC_ext, 1, 'first');

    if isempty(idx_ext)
        M_MC = NvecM_ext(end);
    else
        M_MC = NvecM_ext(idx_ext);
    end
end