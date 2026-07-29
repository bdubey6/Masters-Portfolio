# Statistical Learning Toolkit: EDA, Classification, PCA, Clustering & Power BI

**Course:** DATA 614 – Advanced Data Analytics, University of Calgary (Winter 2026)
**Type:** Individual assignment
**Author:** Bhuvan Dubey

A tour through the core statistical learning toolkit across five real datasets — EDA and diagnostics, four classification approaches compared head-to-head, dimensionality reduction, clustering, cost-sensitive decision-making, and a Power BI dashboard built from an Access database.

## What's in here

**1. Exploratory data analysis — Beijing air quality (CO concentration)**
Sequence plots, lag plots, histograms, and Q-Q plots on hourly CO readings. Found clear temporal dependence (positive autocorrelation — a given hour's reading relates to the previous hour's) and a right-skewed, non-normal distribution with heavy tails. Also discusses the tradeoffs of dropping missing values from hourly sensor data (breaks the time regularity — better to impute or drop per-variable than listwise-delete).

**2. Logistic regression + cost-sensitive thresholding — online shopper purchase intent**
Logistic regression on 10,000 sampled sessions predicting purchase (`Revenue`). Found **returning visitors are ~27.2% less likely to purchase than new visitors** (via odds ratio on the fitted coefficient). Went further than a standard 0.5 threshold: given asymmetric error costs ($10 for a false positive, $11 for a false negative), swept thresholds from 0.1–0.5 to find the cost-minimizing decision boundary — a more business-relevant framing than accuracy alone.

**3. Classification comparison — LDA vs. QDA vs. KNN on speaker accent recognition**
Same MFCC accent dataset as the DATA 614 second assignment, but comparing four classifiers directly:
- **LDA** and **QDA** on the same 250-observation training split — QDA outperformed LDA, implying the classes don't share a common covariance structure (a linear boundary undersells the true class separation)
- **KNN** at k=5 vs. k=10 — **k=5 hit ~77.2% accuracy vs. ~72.2% for k=10**, suggesting the classes are locally clustered enough that a smaller neighborhood generalizes better than averaging over more neighbors

**4. PCA — dimensionality reduction on the same accent data**
Biplot of the first two principal components, loading interpretation (which MFCC frequencies drive PC1 vs. PC2), and a proportion-of-variance-explained (PVE) analysis — concluding ~3–4 components capture the bulk of the variance, a reasonable dimensionality-reduction target before modeling.

**5. Clustering — TV/radio/newspaper ad spend vs. sales**
K-means (K=3 and K=4) and hierarchical clustering (complete linkage) on scaled advertising spend data. Identified which cluster is most homogeneous (lowest within-cluster SS ratio) and interpreted the clusters in business terms — e.g., a low-spend/low-sales group vs. a high-TV-and-radio/high-sales group.

**6. Business framing — Carseats dataset discussion**
A non-code section reasoning about what a retail sales dataset does and doesn't capture (missing: competitor actions, macroeconomic conditions, product usability) and what business questions it could answer.

**7. Random forest + cost-based error analysis — bank marketing campaign targeting**
Random forest classifier predicting term-deposit subscription from the UCI Bank Marketing dataset, with variable importance ranking. Explicit discussion of **which error type costs more** in a call-center context (missing an interested client costs more than an unwanted call) and which variables (`duration`, call outcome) would leak information not actually available before making the call — a data-leakage catch that matters for a realistic deployment.

**8. Power BI dashboard — university bookstore/library analytics**
Built from `BookstoreDemo.accdb` (a course/instructor/enrollment/publisher database): split the `Term` field into separate `Term` and `Year` columns, then built a single-page dashboard with:
- A "potential sales" matrix (Publisher × Instructor, enrollment-weighted)
- A trend line of enrollment and book order size over time
- A stacked column chart of enrollment by instructor, broken out by course
- One original visual chosen to surface something useful to library managers (enrollment by course over time — flags which courses reliably need restocking vs. which are low-demand)

## Tech Stack

R (`data.table`, `MASS` for LDA/QDA, `class` for KNN, `cluster`, `randomForest`, `caret`, `ggplot2`), Power BI (Power Query transformations + dashboard), Microsoft Access.

## Files

- `code/Bhuvan_Dubey_Asgn1.R` — full script covering parts 1–7
- `data/` — source datasets: `AirQualityUCI.csv`, `online_shoppers_intention2.csv`, `accent-mfcc-data-1.csv`, `ad.csv`, `BankMarketingSample.csv`
- `powerbi/Bookstore_Dashboard.pbix` — the Power BI dashboard (open in Power BI Desktop)
- `powerbi/BookstoreDemo.accdb` — source Access database
- `powerbi/*.csv` — exported query outputs from the dashboard (top instructors by enrollment, instructor × course enrollment, yearly enrollment/order-size trend, publisher × instructor enrollment matrix)

*Note: the Carseats dataset (part 6) loads from R's `ISLR` package, no separate file needed.*
