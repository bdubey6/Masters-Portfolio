# Multiple Linear Regression Assignments

**Course:** DATA 603, University of Calgary
**Author:** Bhuvan Dubey

## Problem

Three individual assignments covering the core multiple linear regression
(MLR) workflow in R: model fitting and interpretation, hypothesis testing
(global F-test, partial F-test, individual t-tests), confidence intervals,
interaction terms, qualitative/dummy variables, model selection, and — in
Assignment 3 — a full regression-assumptions diagnostic workflow (VIF,
Breusch-Pagan, Shapiro-Wilk, Cook's distance, Box-Cox) plus an extension into
logistic regression (odds, ROC/AUC, Hosmer-Lemeshow).

## Approach

**Assignment 1 — `Assignment-1-Water-Clocks-Turbines/`**
- **Water usage:** fit a full 4-predictor MLR model, ran the global F-test,
  used t-tests and a partial F-test to drop the non-significant `DAYS`
  predictor, built a 95% CI for the `TEMP` coefficient, and compared
  full vs. reduced models via adjusted R² and RSE before fitting a two-way
  interaction model.
- **Antique clock auction prices:** fit `PRICE ~ AGE + NUMBIDS`, built the
  ANOVA table, tested individual and joint significance, computed a 95% CI
  for `AGE`, and compared the additive model against an `AGE * NUMBIDS`
  interaction model via partial F-test.
- **Gas turbine heat rate:** fit an additive model with `RPM`, `INLET.TEMP`,
  `EXH.TEMP`, `AIRFLOW`, then tested all two-way interaction terms with a
  partial F-test at α = 0.06 to select a final predictive model.

**Assignment 2 — `Assignment-2-Tires-Mental-Health-Bidding-KBI/`**
- **Tire tread wear:** first-order model with an interaction term between a
  quantitative predictor (speed) and a qualitative predictor (tire type).
- **Depression treatment methods (A/B/C):** modeled treatment effect as a
  function of age, method, and their interaction; derived and interpreted
  separate age-slope sub-models for each of the three treatment methods and
  plotted the three regression lines against the data.
- **Collusive bidding in Florida road construction:** model selection among
  candidate predictors for detecting bid-rigging from FLAG's contract data.
- **Caregiver burden (Korean Burden Inventory):** model selection identifying
  `CGDUR`, `MEM`, and `SOCIALSU` as the strongest predictors of caregiver
  burden, testing whether interaction terms among them are significant.

**Assignment 3 — `Assignment-3-Diagnostics-Logistic-Regression/`**
- **Water usage (assumptions battery):** for a `PROD × TEMP + PROD × HOUR`
  interaction model, tested multicollinearity (scatterplots + VIF),
  heteroscedasticity (Breusch-Pagan test + residuals-vs-fitted plot),
  normality (histogram, Q-Q plot, Shapiro-Wilk), linearity
  (residuals-vs-predicted), and influential outliers (Cook's distance,
  residuals-vs-leverage) — then diagnosed a normality violation and proposed
  a Box-Cox transformation as the fix.
- **Caregiver burden (KBI), continued:** re-ran the same full assumptions
  battery (normality, homoscedasticity, linearity, leverage-based outlier
  removal) on the final reduced model from Assignment 2.
- **Coronary heart disease (WCGS cohort study):** logistic regression on CHD
  event as a function of behavior type and other risk factors, with
  train/test splitting, misclassification rate, accuracy at a chosen
  threshold, and ROC/AUC evaluation (AUC = 0.742).
- **Titanic survival:** logistic regression on survival vs. class, sex, and
  age (with a class × sex interaction), including a Hosmer-Lemeshow
  goodness-of-fit test, VIF, Cook's distance/leverage outlier screening, and
  deviance-residual diagnostics — concluding the model's assumptions hold
  except for multicollinearity between class, sex, and their interaction.

## Key Results

- Assignment 1: final water-usage model retains `TEMP` and `PROD` only
  (`DAYS` dropped, partial F p = 0.555); the `TEMP × PROD` interaction is
  highly significant and substantially improves fit (partial F = 84.2,
  p < 2.2e-16).
- Assignment 2: age's effect on depression-treatment effectiveness differs
  significantly by method — Method C starts lowest for young patients but
  has the steepest age slope (≈1.03/year) and overtakes Methods A and B for
  older patients.
- Assignment 3: the water-usage interaction model satisfies linearity,
  homoscedasticity (Breusch-Pagan p = 0.848), and has no influential Cook's-
  distance outliers, but fails the normality assumption (Shapiro-Wilk
  W = 0.677, p < 2.2e-16), motivating a Box-Cox transform; the Titanic
  logistic model achieves a good Hosmer-Lemeshow fit (p = 0.105) but shows
  meaningful multicollinearity between `Pclass`, `Sex`, and their
  interaction (VIFs > 50).

## Tech Stack

- **R**: `lm`, `glm`, `anova`, `car::vif`, `lmtest::bptest`, `shapiro.test`,
  `cooks.distance`, `MASS::boxcox`, `pROC::roc/auc`, `ResourceSelection::hoslem.test`
- Datasets loaded directly from instructor-hosted GitHub CSVs (water, clocks,
  turbine, tires, mental health, KBI, WCGS, Titanic) — no local data files
  needed to reproduce

## Files

Each assignment folder contains the original question sheet (PDF), the
solution R Markdown source (`.Rmd`), and the rendered output (PDF or
`.nb.html` notebook, matching whatever was submitted):

- `Assignment-1-Water-Clocks-Turbines/` — questions, solutions PDF, and `Assignment_1.Rmd`
- `Assignment-2-Tires-Mental-Health-Bidding-KBI/` — questions, rendered `.nb.html`, and `Assignment_2.Rmd`
- `Assignment-3-Diagnostics-Logistic-Regression/` — questions, rendered `.nb.html`, and `Assignment_3.Rmd`

All `.Rmd` files read their source data directly from public GitHub URLs, so
each one can be knit standalone without any additional data files.
