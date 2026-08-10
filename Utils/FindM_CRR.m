function M_CRR = FindM_CRR(NvecC,F0,TTM,sigma,B,K,tol,flag)
% FINDM_CRR Selects the minimum CRR grid size satisfying a tolerance criterion.
%   M_CRR = FINDM_CRR(NvecC,F0,TTM,sigma,B,K,tol,flag) evaluates the pricing
%   error of the Cox-Ross-Rubinstein (CRR) approximation for the option values
%   associated with the grid sizes specified in NvecC and returns the first value
%   for which the error remains below tol for all subsequent entries.
%
%   If no such value exists within NvecC, the function tests 3 additional
%   candidate values beyond the last element of NvecC, obtained by doubling
%   the last grid size repeatedly. If one of these satisfies the criterion,
%   it is returned; otherwise, the last tested value is returned.
%
%   Input arguments:
%     NvecC - Vector of candidate CRR grid sizes.
%     F0    - Initial value of the underlying.
%     TTM   - Time to maturity.
%     sigma - Volatility parameter.
%     B     - Discount factor.
%     K     - Strike price.
%     tol   - Prescribed error tolerance.
%     flag  - Option type indicator.
%
%   Output argument:
%     M_CRR - Selected CRR grid size.

    if nargin < 8
        flag = 1; % Default: Call
    end

    % Ensure row vector
    NvecC = NvecC(:)';

    % Closed-form benchmark
    price = EuropeanOptionClosed(F0,K,B,TTM,sigma,flag);

    % Evaluate initial grid
    price_CRR = arrayfun(@(N) EuropeanOptionCRR(F0,K,B,TTM,sigma,N,flag), NvecC);
    errCRR = abs(price - price_CRR);

    validCRR = errCRR <= tol;
    suffixCRR = arrayfun(@(i) all(validCRR(i:end)), 1:numel(validCRR)); % stays below
    idx = find(suffixCRR, 1, 'first');

    if ~isempty(idx)
        M_CRR = NvecC(idx);
        return;
    end

    % If no admissible value is found, extend with 3 doubling values
    lastN = NvecC(end);
    extraN = lastN * 2.^(1:3);

    NvecC_ext = [NvecC, extraN];

    % Re-evaluate on the extended grid
    price_CRR_ext = arrayfun(@(N) EuropeanOptionCRR(F0,K,B,TTM,sigma,N,flag), NvecC_ext);
    errCRR_ext = abs(price - price_CRR_ext);

    validCRR_ext = errCRR_ext <= tol;
    suffixCRR_ext = arrayfun(@(i) all(validCRR_ext(i:end)), 1:numel(validCRR_ext));
    idx_ext = find(suffixCRR_ext, 1, 'first');

    if isempty(idx_ext)
        M_CRR = NvecC_ext(end);
    else
        M_CRR = NvecC_ext(idx_ext);
    end
end