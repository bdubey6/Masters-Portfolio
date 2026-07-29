# What Makes a Vinho Verde Red Wine High Quality?

**Course:** DATA 602, University of Calgary
**Group 8:** Bhuvan Dubey, Yu Hao, Namya Dimri, Abdalla Elshafey

## Problem

Wine quality is hard to measure directly, so producers combine chemical
tests (acidity, alcohol, pH) with expert sensory scores. This project asks
whether two easily-understood chemical properties — percent alcohol content
and final pH — are associated with the perceived quality of *Vinho Verde*
red wines from northwestern Portugal. The answer helps producers know what
to optimize for, retailers price more accurately, and consumers choose more
confidently.

**Guiding question:** How does the % alcohol content and final pH level
contribute to the quality score of *Vinho Verde* red wines?

## Data

1,599 red wine samples (Kaggle / Cortez et al., 2009), collected 2004–2007
from Portuguese production plants, each with 11 physicochemical measurements
and a quality score (3–8 in this sample) from a panel of three assessors.
Wines were split into **High** quality (score ≥ 6, n = 855) and **Low**
quality (score ≤ 5, n = 744) groups.

## Approach

- **Q1 — Alcohol content:** Right-tailed Welch two-sample t-test (High vs.
  Low mean % alcohol), supported by a 4,999-iteration permutation test and a
  95% CI (student's t) for the mean difference. Normality assumed via CLT
  given n > 25 in both groups.
- **Q2 — pH level:** Wines binned into pH categories two ways — standard
  wine-chemistry cutoffs (< 3.2 / 3.2–3.5 / > 3.5) and quartile-based cutoffs
  (to avoid unbalanced bins) — then tested for independence from quality
  category via Pearson's Chi-squared test on each resulting crosstable.

## Key Results

| Question | Test | Result |
|---|---|---|
| Alcohol % vs. quality | Welch t-test (one-sided) | t = 19.78, p < 2.2e-16 — High quality wines average **~0.93% more alcohol** (95% CI: 0.84–1.02%) |
| Alcohol % vs. quality | Permutation test (N = 4,999) | Empirical p = 0.0002, confirming the t-test result |
| pH vs. quality | χ² test, chemical cutoffs | χ² = 1.68, df = 2, p = 0.432 — fail to reject H₀ |
| pH vs. quality | χ² test, quartile cutoffs | χ² = 1.07, df = 3, p = 0.785 — fail to reject H₀ |

**Bottom line:** Higher alcohol content is a statistically and practically
significant marker of higher-quality *Vinho Verde* red wine, but final pH
shows no significant association with perceived quality under either
binning scheme.

### Limitations

Single dataset (Portuguese *Vinho Verde* red wines only, 2004–2007); no
data on grape variety, vineyard conditions, or fermentation method; quality
scores rest on a panel's subjective sensory judgment; only bivariate methods
(t-test, χ², permutation) were used, so interacting or non-linear effects
across the full set of chemical predictors aren't captured.

### Future Direction

Extend to more predictors (volatile acidity, sulphates, SO₂) via multiple
linear regression, PCA, or machine learning; validate against other regions
and vintages; run controlled fermentation experiments; and explore yeast
strain engineering (breeding, mutagenesis, genetic/metabolic engineering) as
a lever for optimizing alcohol and flavor profile at the production stage.

## Tech Stack

R (`mosaic`, `ggplot2`, `patchwork`, `ggbreak`).

## Files

- `report/Proposal.pdf` — initial project proposal (research questions,
  variables, planned methods)
- `report/Final_Report.pdf` — final write-up (data exploration, hypothesis
  testing, results, conclusion, R appendix)
- `presentation/Presentation.pdf` — term project presentation slides
- `code/Final_Analysis.R` — clean, runnable R script reconstructed from the
  final report's appendix; produces every statistic, table, and figure in
  the report/presentation from `../data/winequality-red.csv`
- `code/drafts/` — earlier individual-member exploration notebooks kept for
  process history (initial linear-regression approach for Q2 before the
  group settled on the Chi-squared/categorical approach in the final report;
  an early full first-draft write-up; and an early Q1 permutation-test
  script). Not required to reproduce the final results — see
  `Final_Analysis.R` for that.
- `data/` — `winequality-red.csv` (used) and `winequality-white.csv`
  (unused companion dataset); see `data/README.md`
