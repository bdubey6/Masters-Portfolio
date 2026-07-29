# Konys, Inc. — LCD Module Procurement Strategy (Monte Carlo Simulation)

**Course:** DATA 612 – Decision Analytics, University of Calgary (Winter 2026)
**Team:** Bilal Naseem, Bhuvan Dubey, Sergio Almeida

## Problem

Konys, Inc. (a fictional OEM from a Harvard Business School case) needs to procure LCD modules
for its MC20 phone under highly uncertain quarterly demand and volatile spot prices. Two sourcing
options are on the table — a long-term **purchase contract** ($17.00/unit, fully committed) and an
**option contract** ($0.50/unit reservation + $16.75/unit exercise price, only exercised if cheaper than
spot) — and the task is to recommend an order/option strategy that maximizes expected profit while
managing downside risk.

## Approach

- Fit a **Normal distribution** to historical Q3 demand and a **Beta distribution** to historical weekly
  spot prices using Python's `Fitter` library.
- Built two Monte Carlo profit-simulation functions (10,000 iterations each, seeded for
  reproducibility): one for a pure purchase contract, one for a combined purchase + option contract
  (the option is only exercised when the spot price exceeds the $16.75 exercise price).
- **Part A (purchase only):** estimated expected profit at the case's suggested order quantity
  (2,170,000 units), then grid-searched order quantities from 1.0M–3.6M (100K increments) to find the
  profit-maximizing order size, with a 90% confidence interval.
- **Part B (purchase + option):** grid-searched the optimal option quantity first at the fixed 2.17M
  order size, then again at the Part A optimal order size, comparing expected profit, standard
  deviation, and the 10th/25th/50th/75th/90th percentiles of the profit distribution against the
  purchase-only strategy at each step.
- Validated the profit functions against three instructor-provided test scenarios before trusting the
  simulation results.

## Key Results

| Strategy | Order Qty | Option Qty | Expected Profit | 90% CI |
|---|---|---|---|---|
| A3 — Purchase (given) | 2,170,000 | – | $5,869,699 | – |
| A4 — Purchase (optimal) | 1,200,000 | – | $7,065,764 | [$6,701,315, $7,430,212] |
| B2 — Purchase + Option (given order) | 2,170,000 | 1,200,000 | $5,801,416 | [$5,344,885, $6,257,948] |
| **B4 — Purchase + Option (recommended)** | **1,200,000** | **1,900,000** | **$9,251,007** | **[$8,860,444, $9,641,571]** |

- **Recommendation:** purchase 1,200,000 units on the long-term contract and reserve a 1,900,000-unit
  option — a **30.9% expected-profit improvement** over the best purchase-only strategy (A4), and a
  **130% ROI** on the $950,000 option reservation fee.
- The combined strategy pairs a conservative base order (below average demand, limiting overage risk)
  with upside protection: when demand spikes and spot prices are high, exercising the option at $16.75
  instead of buying at spot prices up to $27 saves millions in a single quarter.
- The option strategy's downside is small and bounded (the fixed reservation fee), while its upside is
  large and asymmetric — it outperformed the purchase-only strategy in roughly 75% of simulated
  scenarios, only trailing slightly in low-demand cases.

## Tech Stack

Python (`numpy`, `scipy.stats`, `Fitter`), Monte Carlo simulation.

## Files

- `code/Monte_Carlo_Simulation_Model.ipynb` — distribution fitting, both profit-simulation models, all
  optimization searches, and validation against the provided test cases
- `report/Final_Report.pdf` — full business-format report for the Konys executive board (methodology,
  results tables, risk analysis, implementation plan)
- `Assignment_Questions.pdf` — the instructor's assignment brief (Parts A & B questions and rubric)
- `data/Historical_Demand_And_Spot_Price_Data.xlsx` — the historical Q3 demand and weekly spot-price
  data behind the distribution fits (the same figures are hardcoded as arrays in the notebook, so this
  is a reference copy, not a runtime dependency)

**Note:** the case study PDF itself (Harvard Business School case 9-613-065) isn't included here — it's
licensed for course use only ("Authorized for use only in the course DATA 612 L01... Use outside these
parameters is a copyright violation"), so it can't be redistributed in a public repo.
