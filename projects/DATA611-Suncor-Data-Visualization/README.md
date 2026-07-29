# Insights into Suncor (TSX:SU) Stock Prices, 2015–2026

**Course:** DATA 611 – Predictive Analysis, University of Calgary (Winter 2026)
**Team:** Bhuvan Dubey and Andrea Abenoja

## Problem

Following Suncor CEO Rich Kruger's public statement that buying Suncor stock is "our best
investment," this project uses data visualization to independently examine that claim — exploring
how Suncor's stock price has evolved over an 11-year window, how volatile its returns have been,
and whether trading volume or seasonal/calendar effects help explain return behavior. This project
is the exploratory precursor to [Cross-Asset Analysis to Predict Suncor Returns](../DATA611-Suncor-Cross-Asset-Returns/),
which builds a predictive model on top of these findings.

## Approach

- **Data:** daily closing, high, low price, and trading volume for Suncor (TSX:SU) from Jan 2,
2015 to Jan 21, 2026 (2,769 observations), pulled via Google Sheets' `GOOGLEFINANCE()` function.
- Seven visualizations built in Python (matplotlib/seaborn): a smoothed price-trend line chart, a
return-distribution histogram, a by-year box plot of return volatility, monthly bar charts of
average return and average trading volume, a return-vs-volume scatter plot, and a day-of-week ×
month seasonality heat map.
- Each visualization was designed to answer one of three guiding questions: how has price
evolved, how volatile/extreme are returns, and does volume or seasonality help explain return
behavior.

## Key Results

- **Price trend:** a sharp ~45% price decline from 2020–2022 coinciding with COVID-19's
disruption of energy markets, followed by a strong recovery and steady climb to an all-time high
by January 2026.
- **Return distribution:** daily returns cluster tightly around 0% but are right-skewed, with
occasional large positive-return days.
- **Volatility:** return spread was narrow in most years, with a clear widening during 2020–2022
and notable outliers (including unusually large positive-return days in 2020, reflecting sharp
rebounds during a period of otherwise falling prices).
- **Volume:** average monthly trading volume was stable from 2015–2019, then rose sharply
during the 2020 crash and **stayed elevated through 2025** — suggesting sustained investor
attention well beyond the initial shock.
- **Volume and seasonality as predictors:** the scatter plot showed only a weak relationship
between trading volume and return magnitude, and the seasonality heat map showed no strong
day-of-week or month-of-year patterns — implying Suncor's return behavior is driven more by
major market events than by predictable calendar effects. This finding directly motivated the
follow-up project's shift toward cross-asset and sector-peer predictors instead.

## Tech Stack

Python (pandas, numpy, matplotlib, seaborn). Data sourced via Google Sheets `GOOGLEFINANCE()`.

## Files

- `code/Suncor_Visualization.py` — full visualization pipeline (all 7 figures)
- `data/TSX_SU_Stock_Price.csv` — daily price/volume data used
- `report/Report.docx` — full written report with all figures and discussion
- `presentation/Presentation.pptx` — presentation slides
- `figures/` — a few of the generated charts (return distribution, monthly average return, return
vs. volume)
