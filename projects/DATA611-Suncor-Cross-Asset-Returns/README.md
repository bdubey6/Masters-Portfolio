# Cross-Asset and Sector-Wide Analysis to Predict Suncor Returns

**Course:** DATA 611 – Predictive Analysis, University of Calgary (Winter 2026)
**Team:** Bhuvan Dubey and Andrea Abenoja

## Problem

Suncor's stock returns are shaped not just by company-specific news but by crude oil prices,
USD/CAD exchange rate movements, and the performance of its closest sector peers (Shell,
Imperial Oil, Cenovus, and CNRL). This project asks: do cross-asset and sector-wide return
signals meaningfully predict Suncor's next-day return, and is that relationship linear or
nonlinear? The project builds on an earlier single-asset analysis (Project 1) and, based on
feedback from that round, expands the scope to daily *returns* (rather than price levels, which
inflate R² through scale differences across securities) and adds external predictors.

## Approach

- **Data construction:** daily closing prices for Suncor, USO (WTI crude proxy), USD/CAD,
Shell, Imperial Oil, Cenovus, and CNRL from Jan 2015–Jan 2026 (2,769 trading days), pulled via
`GOOGLEFINANCE`, aligned by date, and converted to daily percentage returns.
- **Multiple linear regression (MLR):** interpretable baseline testing for a linear relationship
between Suncor's return and the six external return series, with a full diagnostic suite —
residual normality (Q-Q plot), heteroscedasticity, multicollinearity (VIF + correlation matrix),
and influential-point detection (Cook's distance).
- **Random forest regression:** nonlinear alternative to test for threshold effects and
interactions between predictors, with feature importance and partial dependence plots to
interpret *how* each predictor relates to Suncor's return.
- **Random forest classification:** a companion model predicting the *direction* (up/down) of
Suncor's next-day return, evaluated via ROC/AUC — the more decision-relevant framing for a
trader.
- **Evaluation discipline:** chronological (not random) 70/30 train-test split to preserve time-series
structure and avoid lookahead leakage; RMSE and adjusted R² on held-out test data.

## Key Results

- MLR explained **75.5% of test-set variance** (adjusted R² = 0.755) and cut prediction error by
**50.6%** versus a mean-prediction baseline.
- Five of six predictors were statistically significant (p < 0.05); only the crude oil proxy (USO)
was not — likely because oil-price exposure is already captured indirectly through peer stock
returns. Imperial Oil had the largest coefficient (β = 0.331), followed by CNRL, Shell, Cenovus,
and USD/CAD.
- No multicollinearity (all VIFs between 1.0–3.0) and no heteroscedasticity, but residuals failed
the normality assumption (heavy tails in the Q-Q plot) — a common feature of financial returns
data, and consistent with the 5 high-Cook's-distance observations tied to extreme-movement days.
- Random forest regression matched MLR's accuracy (RMSE = 0.006265) and confirmed the same
predictor ranking: **Imperial Oil, CNRL, and Cenovus** were the dominant drivers, with external
signals (crude oil, FX) playing a comparatively minor role — partial dependence plots showed a
consistently positive, mostly linear-looking relationship between peer returns and Suncor's return.
- The directional classification model achieved an **AUC of 0.964**, indicating strong ability to
predict whether Suncor's return would be positive or negative the next trading day.

## Tech Stack

Python (pandas, scikit-learn, statsmodels, matplotlib, seaborn, scipy). Originally developed in
Google Colab; the code here has been adapted to load data from a local relative path instead of
Google Drive.

## Files

- `code/Suncor_Returns_Analysis.py` — full analysis pipeline (MLR, random forest regression,
random forest classification, diagnostics, and all figures)
- `data/Project2Dataset_final.csv` — daily return series for Suncor and all six external predictors
- `report/Report.pdf` — full written report with methodology, results, and discussion
- `presentation/Presentation.pptx` — final presentation slides
