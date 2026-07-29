# Probability, Distributions & Bootstrap Inference Assignments

**Course:** DATA 602, University of Calgary
**Author:** Bhuvan Dubey

## Problem

Individual assignments covering the foundational probability, distribution
theory, and statistical inference workflow in R. Assignment 1 covers
classical probability rules, combinatorics, Bayes' theorem, discrete and
continuous random variables (pmf/pdf, expectation, variance), and
simulation-based probability estimation. Assignment 2 moves into sampling
distributions and interval estimation: the Central Limit Theorem, the
chi-squared distribution for sample variance, bootstrap resampling, and
comparing bootstrap vs. classical (t / normal-approximation / Agresti-Coull)
confidence intervals. Assignment 3 covers hypothesis testing end-to-end:
two-sample bootstrap inference, exact binomial tests (bypassing the CLT),
Type I/Type II error and power analysis, one-sample and paired t-tests, and
deriving a custom hypothesis test from a non-standard likelihood/pdf.
Assignment 4 (two parts) covers permutation testing, chi-squared tests
(independence and goodness-of-fit), and simple linear regression: model
estimation, condition-checking, inference on the slope, and both classical
and bootstrap prediction/confidence intervals.

## Approach

### Assignment 4, Part II — `Assignment-4-Part-2-Regression-Chi-Square-Goodness-Of-Fit/`
- **Simple linear regression (CAPM model, Suncor vs. TSE Index):** visualized
  and estimated `Suncor ~ TSE.Index` (n=59 months), interpreted the intercept
  (risk-free rate proxy) and slope (beta/systematic risk), checked normality
  and homoscedasticity of residuals, tested H0: β1 = 0 vs. H1: β1 > 0,
  derived a 95% CI for the slope, then compared a classical 95% CI and
  prediction interval against a 1,000-replicate case-resampling bootstrap CI
  for the mean response at TSE = 3%.
  b. Both estimated the slope with a t-test and by a bootstrap CI.
- **Simple linear regression + prediction extrapolation (Barry Bonds HR
  rate vs. season):** removed the 2001 season as a holdout, fit
  `hrat ~ season` on the remaining 15 seasons, checked residual diagnostics
  (residuals-vs-fitted, QQ-plot), derived a 95% prediction interval for the
  2001 home-run rate, converted it to expected home-run counts using the
  actual 2001 at-bats, and compared the model's prediction against the
  actual record-setting total to reason (statistically, not conclusively)
  about the 2001 season being an outlier.
- **Chi-squared goodness-of-fit test (Palmer penguins species distribution):**
  tested whether the three penguin species (Adélie, Chinstrap, Gentoo) occur
  with equal frequency in the 2007 survey, computing expected counts under
  equal proportions and interpreting the resulting chi-squared statistic and
  p-value.

### Assignment 4, Part I — `Assignment-4-Part-1-Permutation-Tests-Chi-Square/`
- **Permutation test vs. two-sample t-test (Vitamin D & sleep quality):**
  tested whether high-dose vitamin D supplementation improves sleep quality
  (lower PSQI) relative to placebo using a 2,999-iteration permutation test,
  then cross-validated with a Welch two-sample t-test after checking
  normality via QQ-plots and a boxplot.
- **Permutation test + bootstrap CI for a proportion difference (McCleskey
  v. Zant death-penalty data):** visualized death-sentence rates by victim
  race with a bar graph, computed the observed difference in proportions,
  tested it against a 1,999-iteration permutation null, and derived a
  1,999-replicate bootstrap 95% CI for the true difference in death-sentence
  probability by victim race.
- **Chi-squared test of independence (GSS 2002 — gun laws & science
  spending; education & race):** tested two 2-way contingency tables for
  independence, reporting test statistics, p-values, and a bar graph
  (education level by race) to support the conclusion.
- **Chi-squared test of independence with simulated p-value (generation vs.
  four-day workweek support):** built a 4×5 contingency table from Ipsos
  poll summary data and used a Monte Carlo-simulated p-value
  (`chisq.test(..., simulate.p.value = TRUE)`) given the sparse cell counts.
- **Permutation test vs. t-test, with a methodological critique (chocolate
  and student evaluations):** tested for a "chocolate" treatment effect on
  both an ordinal item (Q9) via permutation test and a continuous composite
  score (Overall) via a two-sample t-test, then explained why a t-test is
  inappropriate for ordinal rating data even though it's commonly misused
  for that purpose.

### Assignment 3 — `Assignment-3-Hypothesis-Testing/`
- **Bootstrap two-sample mean comparison (NC birth weights):** built a
  5,000-replicate bootstrap distribution of the difference in mean birth
  weight between non-smoking and smoking mothers, derived the 95% bootstrap
  percentile CI, and compared it against the classical two-sample t-interval
  (Welch), concluding non-smoking mothers' babies weigh more on average.
- **Bootstrap distribution of a ratio of standard deviations:** bootstrapped
  the ratio S(Smoker)/S(NonSmoker) over 1,000 replicates, checked normality
  with a QQ-plot, and derived the 95% bootstrap percentile CI to test whether
  the two groups' variability in birth weight differs.
- **One-sample t-test against a regulatory threshold (mercury in walleye):**
  stated the hypotheses and Type I/Type II errors in context, visualized
  the n=30 mercury-ppm sample with a boxplot, then ran a one-sided one-sample
  t-test against Health Canada's 0.5 ppm action level and interpreted the
  p-value and resulting one-sided CI.
- **Exact binomial test without the CLT (French-speaking Albertans):** used
  `binom.test`/`pbinom` directly on n=900, x=42 to test for a decrease from a
  reported 6.1% baseline, avoiding the normal approximation as instructed.
- **Exact binomial test with p-value interpretation (AI sentiment poll):**
  tested whether the share of Canadians viewing AI development positively
  had increased from a 30% baseline (n=350, x=123), with an explicit
  frequentist interpretation of the resulting p-value.
- **Power/Type II error curve for a polling decision rule (MP candidacy):**
  derived a decision rule (reject H0 if X ≥ 15 of n=38), computed the
  Type I error rate, then computed and plotted P(Type II error) across a
  range of true support values (p = 0.30–0.41) to evaluate and critique the
  test's power.
- **Two-proportion CI from summary statistics (single-use plastics ban):**
  computed a 95% CI for the change in support for a plastics ban between a
  2019 poll (n=1,000) and a 2024 poll (n=1,200) using only reported summary
  counts/percentages.
- **One-sample t-test for a labeled net-weight claim (cereal boxes):**
  tested whether Count Chocula boxes were underfilled relative to the
  340g label (n=9), checking the normality assumption with a QQ-plot
  before interpreting the one-sided p-value.
- **Custom hypothesis test derived from a shifted-exponential pdf:**
  derived the rejection-region cutoff for the minimum-order-statistic test
  statistic from first principles (analytic integration, not CLT-based),
  computed the test's actual Type I error, its Type II error at a specific
  alternative, and solved for a new cutoff at a target Type I error of 0.20.
- **Paired t-test (used textbook prices, U of C bookstore vs. Amazon):**
  computed within-pair differences for a matched-pairs design (n=15), tested
  whether bookstore prices exceeded Amazon prices, verified the normality
  of the differences with a QQ-plot, and derived the one-sided 95% CI for
  the mean price difference.

### Assignment 2 — `Assignment-2-Bootstrap-Confidence-Intervals/`
- **Sampling distribution of the mean & sample variance:** using the
  delivery-time data from Assignment 1, computed P(sample mean ≥ observed)
  under the Normal sampling-distribution model, and P(sample sd between two
  bounds) using the chi-squared distribution of `(n-1)S²/σ²`.
- **Sampling distribution of a proportion:** described the shape, mean, and
  standard error of a sample proportion (n = 1,000) under CLT, computed
  P(p̂ ≥ 0.24) analytically via `pnorm`, then validated it with a 1,000-trial
  `rbinom` simulation of the sampling distribution.
- **Hypergeometric claim check (lottery matches):** used the hypergeometric
  pmf for 6-49 lottery matches to test a friend's claim about "average
  matches ≥ 2 per week over 26 weeks," applying the CLT to the mean number
  of matches and computing how (im)plausible the claim is.
- **Bootstrap vs. t-interval for a mean (LC50 toxicity data, n=12):** built a
  2,000-replicate bootstrap distribution of the sample mean, derived the 95%
  bootstrap percentile CI, compared it against the classical t-interval, and
  justified which is more appropriate for a small, possibly-skewed sample.
- **Bootstrap difference-in-proportions (political survey):** built separate
  bootstrap distributions for two independent group proportions (CPC vs.
  Liberal respondents), then bootstrapped the *difference* between them to
  get a 95% CI and determine whether one group's rate was significantly
  higher.
- **Classical vs. bootstrap CI for a proportion (Agresti-Coull / plus-4):**
  compared a Wald/plus-4 interval against a 1,000-replicate bootstrap
  interval for the proportion of Canadians citing inflation as a top
  concern, then used both intervals to test whether the rate had shifted
  from a prior benchmark.
- **Bootstrap CI for median and standard deviation:** reused the LC50 data
  to bootstrap a 98% CI for the population median and a 95% CI for the
  population standard deviation.
- **Bootstrap-t vs. percentile vs. classical-t (Alberta county incomes):**
  read in a real 100-county sample of median household income, built the
  bootstrap-*t* pivotal statistic distribution, derived a bootstrap-*t* CI,
  and compared it against both the bootstrap percentile CI and the
  classical Student's-t CI for the population mean.

### Assignment 1 — `Assignment-1-Probability-Distributions/`
- **Union/complement probability:** computed P(at least one of two people
  supports a policy) and the complementary "neither" probability from a
  reported population proportion, then solved for the minimum sample size
  needed so that P(at least one success) ≥ 0.95, using the log-transform of
  a repeated-independence expression.
- **Monte Carlo simulation:** simulated 3,000 trials of summing three
  fair-die tosses to estimate P(Sum ≥ 14) via a `for`-loop and empirical
  proportion, cross-checked visually with a histogram of the simulated
  outcomes.
- **Combinatorics on a reduced card deck:** computed exact probabilities
  of a same-suit "straight," a full house, and a two-Aces-and-two-spades
  hand from a 20-card deck using `choose()`-based counting arguments.
- **Bayes' theorem:** derived unknown prior probabilities from a stated
  ratio constraint (three airline connection options), then applied the
  law of total probability and Bayes' rule to find the probability of
  having flown a specific route given that a connection was missed.
- **Discrete random variable (geometric-family pmf):** built and plotted
  a custom pmf `P(X=x) = 4/5^(x+1)`, then computed a tail probability,
  the mean/variance via direct summation over a large support, and a
  one-standard-deviation coverage probability.
- **Binomial distribution:** evaluated `P(X=35)` under a reported 47%
  population proportion (n=50) to assess whether the stated statistic is
  plausible, then solved a negative-binomial-style "10th success on trial
  30" probability.
- **Geometric distribution:** modeled the number of coin-toss rounds until
  an "odd person out" occurs in a 6-person game, comparing an observed
  value against the theoretical mean and using the geometric survival
  function to judge whether the observed value was unusual.
- **Normal distribution:** computed interval, percentile, and overflow
  probabilities for a bottle-filling process, then combined the Normal and
  Binomial models to find the probability that a count of underfilled
  bottles (out of 50) fell within a given range.
- **Categorical data visualization (GSS 2002 survey):** built stacked and
  dodged bar graphs to explore relationships between education and race,
  education and marital status, and gender and political affiliation.
- **`iris` data set exploration:** scatterplot of petal length vs. petal
  width by species, side-by-side boxplots of petal length by species, and
  full summary statistics (mean, median, sd, 5th/95th percentiles) by
  group.
- **Sampling distribution & percentiles:** read in a small delivery-time
  sample, used a violin plot to visually assess the Normal-distribution
  assumption, computed sample summary statistics, and derived a
  99th-percentile "refund threshold" for a service-level marketing claim.

## Key Results

- Minimum sample size for ≥95% chance of at least one supporter: **n = 6**
  (Assignment 1).
- P(observing 35/50 supporters if the true rate is 47%) ≈ **0.00055** —
  strong evidence the reported 47% figure doesn't match the observed sample
  (Assignment 1).
- P(next sample mean ≥ 5.6875 hrs, the Assignment-1 delivery-time mean) ≈
  **0.0562** (Assignment 2, Q1a).
- 95% bootstrap percentile CI for mean LC50 toxicity: **[5.58, 13.17] ppm**,
  versus the classical t-interval **[4.92, 13.08] ppm** — bootstrap
  preferred given the small, potentially skewed sample (Assignment 2, Q4).
- 95% bootstrap CI for the gap between Liberal and CPC disagreement rates
  on the measles statement: **[18.7%, 27.0%]**, entirely above zero — strong
  evidence Liberal respondents disagreed at a higher rate (Assignment 2,
  Q5).
- 95% bootstrap-*t* CI for mean Alberta county median household income:
  **[$82,970, $91,905]**, compared against classical t **[$82,915, $91,960]**
  and bootstrap percentile **[$82,550, $91,759]** (Assignment 2, Q9).
- 95% bootstrap CI for the non-smoker/smoker birth-weight gap: **[109.8g,
  314.6g]**, entirely positive and consistent with the classical t-interval
  **[112.3g, 317.7g]** (Assignment 3, Q1).
- One-sample t-test: mean walleye mercury level of **0.539 ppm** significantly
  exceeds Health Canada's 0.5 ppm action level (p = **0.0042**), 95% one-sided
  CI **[0.515, ∞) ppm** (Assignment 3, Q3).
- Exact binomial test: proportion of French-speaking Albertans (42/900 ≈
  4.7%) is significantly below the 2021 baseline of 6.1% (exact p = **0.0381**)
  (Assignment 3, Q4).
- Custom shifted-exponential test: derived rejection cutoff x_min < **3.018**
  for a nominal Type I error of 13.4%; recomputed cutoff **3.028** for a
  target Type I error of 0.20 (Assignment 3, Q9).
- Paired t-test: used textbooks at the U of C bookstore cost on average
  **$25.47 more** than the same titles on Amazon.ca (p = **0.0044**), 95% CI
  for the mean difference **[$10.69, ∞)** (Assignment 3, Q10).
- Permutation test (2,999 iterations): Vitamin D group's mean PSQI (8.60) is
  significantly lower than placebo's (9.94), empirical p ≈ **0.0013**,
  consistent with a Welch t-test (t = -3.53, p = **0.0007**) (Assignment 4
  Part I, Q1).
- Death-penalty sentencing gap by victim race: observed proportion
  difference of **28.6 percentage points** (34.6% vs. 6.0%), permutation
  p ≈ **0**, bootstrap 95% CI **[20.2%, 37.2%]** (Assignment 4 Part I, Q2).
- CAPM regression (Suncor vs. TSE Index): estimated beta of **0.539** (95%
  CI **[0.155, 0.923]**), significant positive slope (p = **0.0068**);
  bootstrap 95% CI for mean return at TSE = 3% **[1.1%, 5.5%]**, close to the
  classical CI **[0.8%, 5.8%]** (Assignment 4 Part II, Q1).
- Barry Bonds HR-rate model (excl. 2001): predicted **~49 HRs** for 2001
  (95% PI **[34, 64]**) versus his actual **73 HRs** — the model doesn't
  prove steroid use but flags 2001 as a statistical outlier relative to his
  career trend (Assignment 4 Part II, Q2).
- Chi-squared goodness-of-fit: Palmer penguin species counts are
  significantly non-uniform (X² = 31.9, p ≈ **1.2 × 10⁻⁷**) versus an
  equal-proportions null (Assignment 4 Part II, Q3).

## Tech Stack

- **R**: base probability functions (`choose`, `dbinom`, `pbinom`, `dgeom`,
  `pgeom`, `pnorm`, `qnorm`, `pchisq`, `qt`), `replicate`/`for`-loops for
  Monte Carlo and bootstrap resampling, `binom.test` (Agresti-Coull/plus-4),
  `ggplot2` for bar graphs/violin plots/scatterplots/boxplots/histograms,
  `mosaic`/`dplyr` for grouped summary statistics and `qdata()`
- Datasets loaded directly from instructor-hosted GitHub CSVs (GSS 2002
  survey, delivery-time sample, Alberta counties median income) or built
  into R (`iris`), or generated in-code (`rbinom`, `sample`) — no local
  data files needed to reproduce

## Files

- `Assignment-1-Probability-Distributions/` — question sheet (PDF), my
  solution R Markdown source (`Assignment_1.Rmd`), rendered notebook
  (`Assignment_1_Solutions.nb.html`), and a `data/` folder with local
  copies of the CSVs used (the `.Rmd` reads them from public GitHub URLs,
  so it knits standalone).
- `Assignment-2-Bootstrap-Confidence-Intervals/` — question sheet (PDF), my
  solution R Markdown source (`Assignment_2.Rmd`), rendered notebook
  (`Assignment_2_Solutions.nb.html`), and a `data/` folder with the Alberta
  counties CSV (again read from a public GitHub URL in the `.Rmd`, so no
  local file is required to reproduce).
- `Assignment-3-Hypothesis-Testing/` — question sheet (PDF), my solution R
  Markdown source (`Assignment_3.Rmd`), rendered notebook
  (`Assignment_3_Solutions.nb.html`), and a `data/` folder with the used-book
  price CSV (the `.Rmd` reads it directly from a public GitHub raw URL, so
  no local file is required to reproduce).
- `Assignment-4-Part-1-Permutation-Tests-Chi-Square/` — question sheet (PDF),
  my solution R Markdown source (`Assignment_4_Part1.Rmd`), and the rendered
  notebook (`Assignment_4_Part1_Solutions.nb.html`). All datasets (PSQI
  scores, McCleskey v. Zant table, GSS 2002, generation/workweek poll,
  chocolate ratings) are either typed in directly or read from public GitHub
  raw URLs, so no local data files are needed.
- `Assignment-4-Part-2-Regression-Chi-Square-Goodness-Of-Fit/` — question
  sheet (PDF), my solution R Markdown source (`Assignment_4_Part2.Rmd`),
  rendered notebook (`Assignment_4_Part2_Solutions.nb.html`), and a `data/`
  folder with a local copy of the Barry Bonds HR-rate CSV (the `.Rmd` reads
  both the CAPM and Bonds data from public GitHub raw URLs, so no local file
  is required to reproduce; the Palmer penguins data loads from the
  `palmerpenguins` R package).

Only my own submitted solutions are included here — the instructor's answer
keys/marking rubrics are intentionally excluded from all assignments.
