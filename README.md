# Derivatives Pricing Engine: Vanilla, Barrier & Bermudan Options

## Project Overview
This repository contains a comprehensive MATLAB-based pricing and risk management engine for equity derivatives. The project explores the numerical and analytical methods used to price European, Bermudan, and Barrier (Up-and-Out) options, evaluating the trade-offs between computational efficiency and theoretical precision.

Beyond standard pricing, the framework delves into advanced quantitative analysis, including variance reduction techniques (Antithetic Variables), numerical Greeks estimation via finite-difference schemes, and market-maker delta-hedging dynamics.

Note: This collaborative academic project was developed for the Financial Engineering course at Politecnico di Milano. While the baseline structure was provided by the faculty, our group was responsible for implementing the pricing algorithms, handling exotic barrier features, and conducting the mathematical/empirical analysis.

## Core Methodology & Features
The project is divided into distinct quantitative modules:

1. **Foundational Pricing & Convergence:**
   * Implemented Black-76 (Closed-form), Cox-Ross-Rubinstein (CRR) Binomial Trees, and Monte Carlo (MC) simulations.
   * Verified theoretical convergence rates: $1/M$ for CRR and $1/\sqrt{M}$ for MC.
   * Optimized the number of simulations/steps applying Common Random Numbers (CRN) to evaluate numerical stability.

2. **Exotics & Greeks (Barrier Options):**
   * Priced European Up-and-Out Calls using static replication (Vanilla Call - Call(KO) - Digital(KO)).
   * Handled American Up-and-Out barriers implementing the **Reflection Principle** to account for continuous monitoring.
   * Evaluated Delta ($\Delta$) and Vega ($\nu$) sensitivities via central finite-difference schemes (Bump-and-Revalue), identifying numerical instabilities such as the *Barrier Alignment Problem* in discrete CRR trees.

3. **Advanced Quantitative Extensions:**
   * **Variance Reduction:** Implemented Antithetic Variates in MC simulations.
   * **Bermudan Options:** Analyzed early-exercise boundaries evaluating the impact of varying continuous dividend yields ($q$) against the risk-free rate ($r$).
   * **Alternative Dynamics (Bachelier Model):** Derived option pricing formulas under Arithmetic Brownian Motion (ABM) to account for negative forward scenarios.

## Team Collaboration & Role
Working closely with my peers, we tackled the theoretical and computational challenges as a unified team. My engagement in this project particularly emphasized the mathematical validation and market-implied mechanics:
* **Market-Maker Dynamics:** Conducted the theoretical proof demonstrating that, for a continuously delta-hedged market maker, holding an ATM forward Call or Put yields an identical synthetic straddle payoff and identical higher-order Greeks (Gamma, Vega, Theta).
* **Numerical Debugging:** Analyzed the discrepancies in Delta calculation (Spot Bumping vs. Chain Rule applied to forwards) and diagnosed the downward Vega spikes near the barrier as a discretization artifact of the CRR model.
* **Stochastic Calculus Implementation:** Validated the application of the Reflection Principle for American barriers and the variance reduction efficiency achieved through negative dependence in Antithetic Variables.

## Key Empirical Results
* **Antithetic Efficiency:** The implementation of antithetic variates reduced the Monte Carlo standard error by approximately 34%, exploiting the monotonicity of the Call payoff.
* **American vs. European Sensitivities:** Demonstrated that American barriers exhibit a higher Delta ($\Delta = 0.2241$) compared to their European counterparts ($\Delta = 0.2160$), reflecting the continuous risk of knock-out.
* **Bermudan Exercise Logic:** Proven that for an OTM Call with $r > q$ (2.5% vs 2.0%), early exercise is inherently sub-optimal, aligning the Bermudan price perfectly with the European analytical benchmark (excluding discretization noise).

## Tech Stack
* **Language:** MATLAB
* **Quantitative Techniques:** Monte Carlo Simulation, Binomial Trees (CRR), Finite-Difference Greeks, Antithetic Variables, Static Replication, Reflection Principle.
