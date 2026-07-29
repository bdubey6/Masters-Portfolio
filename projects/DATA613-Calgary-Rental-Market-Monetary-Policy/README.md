# The Impact of Monetary Policy on Calgary's Rental Market

**Course:** DATA 613 – Data Analytics, University of Calgary (Winter 2026)
**Team:** Bhuvan Dubey, Gurmol Sohi, Bilal Naseem

## Problem

Housing affordability and rising borrowing costs have pushed demand toward the rental market across Canada, and Alberta's major cities have felt this shift acutely. This project investigates how Bank of Canada monetary policy connects to Calgary's rental market as of February 2026, asking:

1. Does the BoC policy rate predict rental listing volume (supply) in Calgary?
2. How do property characteristics (bedrooms, size, property type) drive rental prices?
3. How does the interaction between property type and square footage affect valuation, and where do standard linear models break down?

## Approach

- **Data collection:** scraped historical BoC policy rates directly from the Bank of Canada's site (`rvest`/`httr`), and pulled live rental listings from the RentFaster API across price bands ($500–$4,000) with rate-limited requests (`Sys.sleep()`).
- **Cleaning & joining:** standardized dates to a common monthly format, de-duplicated listings by ID, and merged rental snapshots with monthly policy-rate averages.
- **Modeling:**
  - **Model 1:** simple linear regression, rental listing count ~ policy rate
  - **Model 2:** multiple regression, rent price ~ bedrooms + sqft + property segment
  - **Model 3 / 3.1:** interaction model, rent price ~ sqft × property segment, then a log-log transform to address non-normal, heteroscedastic residuals in the luxury segment
- **Diagnostics:** Q-Q plots, Shapiro-Wilk tests for residual normality, and VIF/GVIF for multicollinearity.
- **Visualization:** correlation heatmaps, `GGally` pairs plots, violin/box plots by segment.

## Key Results

| Model | Question | Result |
|---|---|---|
| Model 1 | Policy rate → rental inventory | Only one live snapshot of listing data was scraped (not a repeated historical series), so this regression has a single data point and no meaningful degrees of freedom. This is an honest limitation of a single-scrape data collection approach — a repeated/scheduled scrape over several months would be needed to properly test this relationship. |
| Model 2 | Bedrooms + sqft + segment → rent | R² ≈ 3% — not statistically significant on its own (p = 0.62). Bedrooms and sqft alone are weak predictors of price. |
| Model 3 | Sqft × segment interaction → rent | R² = 52%, p < 0.001. Full homes carry a ~$231 flat premium over apartments/condos; price-per-sqft is flat for shared rooms and declines for "Other" property types. |
| Model 3.1 | Log-log transform | Shapiro-Wilk W improved from 0.949 → 0.993, substantially reducing the influence of 108 luxury-segment outliers ($2,599–$4,075/mo), at the cost of higher multicollinearity (GVIF 18.29). |

**Bottom line:** the strongest, most defensible finding from this project is the property-type × square-footage interaction model (Model 3/3.1) — it's well-specified, statistically significant, and its diagnostics were properly checked and corrected. The policy-rate-vs-inventory question (Model 1) was constrained by the single-snapshot nature of the scraped rental data rather than a true multi-month time series.

## Tech Stack

R (`rvest`, `httr`, `jsonlite`, `dplyr`, `ggplot2`, `GGally`, `car` for VIF/GVIF, `corrplot`), RentFaster API, Bank of Canada public data.

## Files

- `R/web_scraping/House_Prices.R` — BoC + RentFaster API scraping
- `R/visualization/Correlation_Heatmap.R`, `R/visualization/More_Plots.R` — correlation/pairs plots
- `R/modelling/Regression_Models.R` — Models 1 & 2, full cleaning-to-modeling pipeline
- `R/modelling/Model3_Interaction_Loglog.Rmd` — Model 3 interaction model and log-log transform
- `R/modelling/Housing_Code_Graphs.R` — supporting regression visualizations
- `report/Report.pdf` — full written report (intro, methodology, results, discussion, appendix with figures and model output)
- `presentation/Presentation.pptx` — class presentation slides

*Code sourced from the team repo maintained by Gurmol: [github.com/gu12934/Data_613_Final_Project](https://github.com/gu12934/Data_613_Final_Project). The repo has several in-progress/experimental script versions in its history; this folder keeps only the final versions actually used for the report's real (non-illustrative) results.*
