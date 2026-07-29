# R Programming: Financial Data Exploration, Decision Support Tools, Simulation & Predictive/Prescriptive Modeling

**Course:** DATA 613 – Data Analytics, University of Calgary
**Author:** Bhuvan Dubey

## Problem

Four linked assignments building up core applied-analytics skills in R, from exploratory data
analysis through to production-style decision-support tools: exploring and comparing financial
time series, writing generic user-defined functions, building Monte Carlo simulation models for
operational decisions, and combining predictive regression with prescriptive price optimization.
Beyond HW1, each was built and tested to work generically on any input dataset, not just the example
data provided — the standard expected of a decision-support tool that a business would actually
deploy.

## Approach

**1. Exploring Financial Data** (`Assignment-1-Crypto-Portfolio-Analysis/code/HW1_Crypto_Portfolio_Analysis.R`)
- Compared 7 cryptocurrencies (BTC, ETH, BNB, SOL, XRP, ADA, DOGE) over a one-year window (Jan 17,
  2025 – Jan 16, 2026) on long-run ROI, mean daily return, and daily-return volatility.
- Built three hypothetical portfolios (Portfolio 1 = BTC only; Portfolio 2 = ETH + BNB;
  Portfolio 3 = SOL + XRP + ADA + DOGE) from fixed dollar allocations, tracked their daily value
  over the full year, and found each portfolio's all-time-high value and when it occurred
  programmatically (not by manual inspection).
- Computed the correlation between each multi-asset portfolio's daily % change and Bitcoin's, and
  built a running "drawdown from all-time-high" measure (via a for-loop) to quantify each
  portfolio's worst peak-to-trough decline — a standard risk metric for volatile assets.
- Simulated a $1/day dollar-cost-averaging (DCA) strategy into Dogecoin across the full year and
  computed the ending value of that position.

**2. Decision Support Functions** (`Assignment-2-Decision-Support-Functions/code/HW2_Decision_Support_Functions.R`)
- A configurable exam-retake policy function (`post_retake_score`) plus a search routine
(`find_P_B`) that grid-searches policy parameters to hit a target post-retake class average while
matching pre-retake score variance as closely as possible, with fallback rules when no exact match
exists.
- A generic train/test data-splitting function (`split_data`) built from scratch (no `caret`/`rsample`).
- A random team-builder (`create_teams`) that partitions any class roster of ≥12 students into teams
of 4–5, with an internal correctness check verifying every student is assigned to exactly one team.
- A minimum-expected-loss guessing game solved by simulation, then generalized into a function
(`find_optimal_number`) that returns the loss-minimizing guess for *any* input vector.

**3. Simulation Models** (`Assignment-3-Simulation-Models/code/HW3_Simulation_Models.R`)
- Monte Carlo inventory simulation for a newsvendor-style stocking problem (donut shop): simulates
demand from a fitted Normal distribution, sweeps stocking levels to find the profit-maximizing
quantity, and derives the critical fractile / service level at the optimum.
- Cross-checks the simulation result against the closed-form theoretical optimum (marginal
revenue = marginal cost), confirming the two approaches agree.
- Large-scale EDA and revenue analysis on Citi Bike NYC trip data: pulls and merges a live data
export, computes overage charges under two different billing policies (continuous per-second vs.
per-minute), and compares total revenue to make a pricing-policy recommendation.
- Closed-form and simulation-based probability analysis of a large-scale lottery/raffle system
(binomial approximation, expected value, and simulated waiting-time-between-wins).

**4. Predictive & Prescriptive Modeling** (`Assignment-4-Predictive-Prescriptive-Models/code/HW4_Predictive_Prescriptive_Models.R`)
- Multiple linear regression predicting course final scores from project/exam/homework performance;
tests for a group-level effect and a group × predictor interaction, and compares a log-log
specification to the linear one.
- Closed-form profit-maximizing price derivation from a linear demand curve, with sensitivity
analysis on both the demand intercept and the price-sensitivity slope.
- A general-purpose pricing function (`find_optimal_price`) that fits a quadratic profit-vs-price
model to *any* price/quantity dataset and returns the recommended optimal price — a reusable
decision-support tool rather than a one-off analysis.

## Key Results

**HW1 — Crypto portfolio exploration** (one year, Jan 17 2025 – Jan 16 2026):

| Question | Result |
|---|---|
| Highest long-run ROI | **BNB, +25%** (only coin with a positive return; BTC −12%, ETH −9%, SOL −37%, XRP −40%, ADA −67%, DOGE −68%) |
| Highest mean daily return | **BNB, 0.10%/day** |
| Lowest daily-return volatility (SD) | **BTC, 2.11%/day** |
| Portfolio values, Jan 16 2026 | Portfolio 1 (BTC): **$4,400** · Portfolio 2 (ETH+BNB): **$5,400** · Portfolio 3 (SOL+XRP+ADA+DOGE): **$2,400** |
| All-time-high value & month | Portfolio 1: **$5,800** (Oct 2025) · Portfolio 2: **$7,500** (Oct 2025) · Portfolio 3: **$5,100** (Jan 2025, i.e. it was never worth more than its starting value) |
| Correlation with Bitcoin's daily % change | Portfolio 2: **0.79** · Portfolio 3: **0.85** |
| Worst drawdown from all-time high | Portfolio 1: **32.4%** · Portfolio 2: **41.5%** · Portfolio 3: **60.9%** |
| $1/day DOGE DCA, ending value | **$266** (on ~$365 invested — a loss, consistent with DOGE's −68% ROI) |

Bottom line for the "which portfolio should my friend take" framing: **Portfolio 2 (ETH+BNB)** ends
the year with the highest value and the smallest drawdown of the two multi-asset portfolios, while
**Portfolio 1 (BTC-only)** is the least volatile and has the shallowest worst-case drawdown overall —
Portfolio 3 is dominated on every metric (lowest ending value, worst drawdown, still hasn't beaten
its starting value).

**HW3/HW4:**
- Inventory simulation optimum matched the theoretical newsvendor solution derived from the
critical-fractile condition, validating the simulation approach against closed-form theory.
- Citi Bike overage-fee analysis quantified how total platform revenue differs between a
continuous per-second billing model and the actual per-minute billing model, informing a
pricing-policy recommendation.
- Apple-juice pricing model: closed-form optimal price under a known linear demand curve, with a
sensitivity analysis showing how the recommended price shifts as the demand intercept and slope
are perturbed — directly relevant to real-world pricing decisions made under model uncertainty.

## Tech Stack

R (`dplyr` for HW1; base R + `ggplot2` for HW2–4 — no external ML/optimization packages there, since
the search, regression, and simulation routines were built from scratch to demonstrate
first-principles understanding).

## Files

- `Assignment-1-Crypto-Portfolio-Analysis/code/HW1_Crypto_Portfolio_Analysis.R` — data merge,
ROI/return/volatility comparison, portfolio construction, correlation, drawdown, and DCA analysis
- `Assignment-1-Crypto-Portfolio-Analysis/data/HW1_data.RData` — daily CoinGecko price series (CAD)
for all 7 cryptocurrencies
- `Assignment-1-Crypto-Portfolio-Analysis/Assignment_Questions.pdf` — the instructor's assignment brief
- `Assignment-2-Decision-Support-Functions/code/HW2_Decision_Support_Functions.R` — retake-policy
optimizer, train/test splitter, team builder, minimum-expected-loss solver
- `Assignment-2-Decision-Support-Functions/data/` — the exam-score and guessing-game datasets the
script loads
- `Assignment-3-Simulation-Models/code/HW3_Simulation_Models.R` — inventory simulation, Citi Bike
EDA/pricing analysis, lottery probability model (data pulled live or course-provided, not
redistributed here)
- `Assignment-4-Predictive-Prescriptive-Models/code/HW4_Predictive_Prescriptive_Models.R` —
regression modeling, closed-form and data-driven price optimization (course-provided data, not
redistributed here)

