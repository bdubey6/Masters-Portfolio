# Landhills Winery — Optimal Wine Blending Plan (Linear & Mixed-Integer Programming)

**Course:** DATA 612 – Decision Analytics, University of Calgary (Winter 2026)
**Type:** Group assignment
**Author (this submission):** Bhuvan Dubey

## Problem

Landhills Winery blends four grape types (three Cabernet Sauvignon lots, one Merlot) into three
wine products (Vintage Cabernet Sauvignon, Non-Vintage Cabernet Sauvignon, Non-Vintage Merlot),
each with its own wholesale price. The blend has to satisfy government labeling regulations
(varietal purity, alcohol range, vintage/viticulture-area content) and the winery's internal quality
specs (acidity, sugar), all while working within limited grape supply at fixed cost per grape lot. The
task: find the production plan that maximizes net profit, then extend the model to handle a
supplier's volume discount offer.

## Approach

- **Question 1 (base model):** built a linear program in Gurobi with decision variables for how many
  bottles of each grape type go into each wine product, subject to supply limits, the regulatory and
  quality constraints (acidity, sugar, alcohol, varietal purity, vintage/area content), and a profit-
  maximization objective.
- Used the model's **shadow prices** to identify which grape supplies were binding (fully used) and
  rank grape types by marginal profit per bottle, informing a procurement-priority recommendation.
- Ran a **sensitivity analysis** on the Cabernet Sauvignon acidity constraint (relaxing it 1%) to
  quantify the profit impact of a small internal-policy change.
- **Question 2 (quantity-discount extension):** reformulated the model as a **mixed-integer linear
  program (MILP)**, adding continuous variables for Merlot procured at each price tier and binary
  variables to enforce an "all-units" discount (an all-or-nothing lower price of $1.10/bottle once the
  order reaches 150,000 bottles, vs. $1.55/bottle below that), then compared the new optimal plan
  against the base model.

## Key Results

| Metric | Base model (Q1) | With Merlot discount (Q2) |
|---|---|---|
| **Total profit** | **$809,911.39** | **$862,387.46** (+6.5%) |
| Total production | 266,917 bottles | 290,000 bottles |
| Merlot procured | 126,917 bottles | 150,000 bottles (discount threshold) |
| Merlot cost | $196,721 | $165,000 |

- **Most valuable grape:** Santa Barbara 2011 Cabernet Sauvignon, at $6.65 marginal profit/bottle —
  more than double any other grape — because it's the only lot that satisfies all three vintage-wine
  requirements (varietal, vintage year, and viticulture area) simultaneously. It's fully utilized
  (binding constraint), so the top procurement recommendation is securing more of this specific
  grape, even at a premium price.
- The optimal base plan **skips both San Luis Obispo vintage-labeled options** entirely — those lots
  are more valuable blended flexibly into non-vintage wines than locked into the stricter vintage
  requirements.
- Relaxing the Cabernet acidity spec by just 1% (0.7 → 0.707 g/100ml — an internal policy, not a
  government rule, and well below the human sensory-detection threshold) frees up more use of the
  higher-acidity San Luis Obispo 2010 grapes, worth an estimated $2,000–$3,000 in additional profit
  at essentially no quality risk.
- The Merlot volume discount is worth taking: the model buys exactly the 150,000-bottle threshold
  (not the full 200,000 available), since cost savings on bottles already being purchased plus
  positive marginal profit on the extra bottles needed to hit the threshold outweigh the diminishing
  returns and tightening quality constraints beyond that point.

## Tech Stack

Python, `gurobipy` (Gurobi Optimizer) — linear programming (Q1) and mixed-integer linear
programming with binary variables (Q2).

## Files

- `code/Optimization_Model.ipynb` — both Gurobi models (base LP and discount MILP), with the
  objective values, constraint setup, and solved production plans
- `report/Final_Report.pdf` — business-format report to the Landhills Winery board (written in
  character as the winery's senior vintner, per the assignment's framing)
- `Assignment_Questions.pdf` — the instructor's assignment brief

**Note:** the case study PDF itself (Ivey Publishing case 9B14E006) isn't included — it's copyrighted
material licensed for course use only ("Authorized for use only in the course DATA 612 L01... Use
outside these parameters is a copyright violation"), so it can't be redistributed here.
