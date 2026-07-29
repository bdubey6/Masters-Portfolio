# Applied Machine Learning Methods: Neural Networks, Time Series, SVM & NLP

**Course:** DATA 614 – Advanced Data Analytics, University of Calgary (Winter 2026)
**Author:** Bhuvan Dubey

A single R script applying five different modeling techniques across four datasets — a tour through the core toolkit of applied analytics: deep learning, time-series forecasting, classification, and text mining.

## What's in here

**1. Neural network — purchase intent prediction**
Deep neural net (3 hidden layers, 16-12-10 neurons) predicting whether an online shopping session generates revenue, from the [Online Shoppers Purchasing Intention dataset](https://archive.ics.uci.edu/ml/datasets/Online+Shoppers+Purchasing+Intention+Dataset) (12,330 sessions). Min-max scaled numeric features, one-hot encoded categoricals, trained on 2,000 sampled sessions. Note: training stopped early (10 steps) and the model collapsed to predicting the majority class — a real limitation worth revisiting (more training steps or a lower convergence threshold would be the first fix) rather than a clean result to lead with.

**2. Time-series forecasting — Beijing air quality temperature**
Univariate time-series analysis on temperature data from the [Beijing Multi-Site Air-Quality dataset](https://archive.ics.uci.edu/ml/datasets/Beijing+Multi-Site+Air-Quality+Data):
- Missing-value interpolation, ACF/PACF diagnostics, and an Augmented Dickey-Fuller stationarity test
- **`auto.arima()`** selected an **ARIMA(0,1,1)(1,1,0)[12]** model (differenced once, one MA term, one seasonal AR term) — 24-month forecast plotted against actuals
- Classical seasonal decomposition (trend/seasonality/residual) and a **Holt-Winters** forecast as a comparison model
- Time-series regression testing whether temperature predicts max wind speed (WSPM) via `auto.arima(xreg=)` — **result: temperature has no statistically significant effect on WSPM at the 95% level** (p > 0.05)

**3. SVM classification — speaker accent recognition**
Radial-kernel SVM (cost=4) classifying native language (ES/FR/GE/IT/UK/US) from 11 Mel-frequency cepstrum (MFCC) audio features, from the [Speaker Accent Recognition dataset](https://archive.ics.uci.edu/ml/datasets/Speaker+Accent+Recognition). **81.6% test accuracy** across 6 classes.

**4. Neural network — Boston housing price prediction**
Neural net (5 hidden neurons) predicting median home value from the classic Boston housing dataset, trained on 400 of 506 observations.

**5. NLP / text mining — product review analysis**
Full text-mining pipeline on a corpus of product reviews:
- Cleaning (lowercase, stopword/punctuation/number removal, whitespace stripping) and stemming
- Document-term matrix, frequent-term extraction, and term-association analysis (correlation > 0.5)
- Word cloud generation
- Hierarchical clustering of terms (5 clusters) and k-means clustering of documents (K=5)
- Sentiment analysis via the NRC lexicon (`syuzhet` package), plotted by emotion category

## Key Results

| Task | Metric | Result |
|---|---|---|
| Purchase intent NN | Test set | Predicted only the majority class (training stopped after 10 steps) — flagged as a limitation, not a clean win |
| ARIMA temperature forecast | Model | ARIMA(0,1,1)(1,1,0)[12] |
| Temp → WSPM regression | Significance | Not significant (p > 0.05) |
| Accent SVM | Accuracy | 81.6% |
| Boston housing NN | RMSE (scaled) | 0.481 |

## Tech Stack

R — `neuralnet`, `caret`, `forecast`, `tseries`, `e1071` (SVM), `tm`, `SnowballC`, `wordcloud`, `syuzhet`.

## Files

- `code/Analysis.R` — full annotated script, runs top to bottom
- `data/` — all four source datasets (online shoppers, Beijing air quality, accent MFCC, product review text)

*Note: Boston housing data loads from R's built-in `MASS` package, no separate file needed.*
