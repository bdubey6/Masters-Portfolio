# Bhuvan Dubey — Data Science & Analytics Portfolio

MSc Data Science and Analytics (Business Analytics), University of Calgary — graduating August 2026.
Background in Exercise & Health Physiology (First Class Honours, 2025) before moving into data science.

This repo collects course and applied projects from the MDSA program: problem framing, modeling approach, and results for each, with code included.

**Contents:** [DATA 614](#data-614--advanced-data-analytics) · [DATA 613](#data-613--data-analytics) · [DATA 612](#data-612--decision-analytics) · [DATA 611](#data-611--predictive-analysis) · [DATA 604](#data-604) · [DATA 603](#data-603) · [DATA 602](#data-602) · [DATA 601](#data-601--intro-to-data-science) · [Also See](#also-see)

## Projects

### DATA 614 – Advanced Data Analytics
| Project | Summary |
|---|---|
| [Insurance Fraud Detection](projects/DATA614-Insurance-Fraud-Detection/) | Logistic regression + random forest on 1,000 insurance claims (R), chi-square/correlation analysis of fraud drivers, PowerBI dashboard; random forest hit 0.676 recall / 0.658 F1 |
| [LLMs in Business Analytics](projects/DATA614-LLM-Business-Analytics/) | Group white paper on how LLMs automate analytics workflows (RAG, agentic workflows, long-context models) — benefits, risks, and governance |
| [Statistical Learning & Deep Learning/NLP Assignments](projects/DATA614-Statistical-Deep-Learning-Assignments/) | Two assignments: EDA/diagnostics, logistic regression with cost-sensitive thresholding, LDA/QDA/KNN comparison, PCA, K-means/hierarchical clustering, random forest, and a Power BI dashboard (Assignment 1); neural networks (purchase-intent & housing-price prediction), ARIMA/Holt-Winters forecasting, SVM accent classification (81.6% accuracy), and NLP/text mining with sentiment analysis (Assignment 2) |

### DATA 613 – Data Analytics
| Project | Summary |
|---|---|
| [Monetary Policy & Calgary's Rental Market](projects/DATA613-Calgary-Rental-Market-Monetary-Policy/) | Web-scraped BoC policy rates + RentFaster API rental data; regression modeling shows rental supply is driven by local housing starts/migration (not interest rates), while an interaction model explains 52% of rent price variance by property type × square footage |
| [R Programming: Financial Data, Decision Tools & Simulation](projects/DATA613-R-Programming-Assignments/) | Four assignments: crypto portfolio ROI/volatility/drawdown/correlation analysis (BNB was the only one of 7 coins with a positive 1-year return, +25%); from-scratch R functions for policy optimization, train/test splitting, and team assignment; Monte Carlo inventory simulation validated against closed-form theory and Citi Bike pricing-policy revenue analysis; regression + prescriptive price optimization |

### DATA 612 – Decision Analytics
| Project | Summary |
|---|---|
| [Vaccine Inventory Optimization](projects/DATA612-Vaccine-Inventory-Simulation/) | (s, S) inventory policy for perishable pediatric vaccines, solved via simulation + grid search; 97.2% service level at $844/week optimal cost |
| [Landhills Winery & Konys, Inc. Assignments](projects/DATA612-Optimization-Simulation-Assignments/) | Two group assignments: linear program (Gurobi) maximizing wine-blending profit under regulatory/quality constraints, extended to a mixed-integer program handling a volume discount (Assignment 1, $809,911 optimal profit, +6.5% with discount); Monte Carlo simulation comparing purchase vs. option contracts for LCD module procurement under demand/price uncertainty (Assignment 2, +30.9% expected profit over the best purchase-only strategy) |

### DATA 611 – Predictive Analysis
| Project | Summary |
|---|---|
| [Cross-Asset Analysis to Predict Suncor Returns](projects/DATA611-Suncor-Cross-Asset-Returns/) | Group project (with Andrea Abenoja) predicting Suncor's daily returns from oil prices, USD/CAD FX, and sector-peer returns using MLR (adj. R² = 0.755) and Random Forest (AUC = 0.964 for directional classification), with full regression diagnostics |
| [Insights into Suncor Stock Prices](projects/DATA611-Suncor-Data-Visualization/) | Exploratory data visualization (with Andrea Abenoja) of 11 years of Suncor stock data — price trend, return volatility, and seasonality — that motivated the cross-asset predictive project above |
| [PCA Feature Selection & K-Means from Scratch](projects/DATA611-PCA-Feature-Selection-KMeans/) | Filter vs. wrapper feature selection (Sequential Forward Selection) on a 73-feature facial-attribute dataset, PCA variance analysis, and a from-scratch K-means implementation with random-restart optimization and elbow-method cluster selection |
| [Classification Metrics, Bayes' Rule, Regression & KNN](projects/DATA611-Classification-Bayes-Regression-KNN/) | Cost-sensitive threshold selection via expected-value analysis, Bayes' rule applied to a rare-disease diagnostic test, multiple linear regression (R² = 0.987) predicting fossil age, and KNN taxonomy classification (83% accuracy) with k-sweep validation |

### DATA 604
| Project | Summary |
|---|---|
| [NASDAQ Stock Returns & Volatility Post-COVID](projects/DATA604-NASDAQ-Stock-Returns-Volatility/) | Group project (with Akaljot Sangha) using SQL + Python on 10 leading NASDAQ companies' daily prices; META saw the largest shift in performance pre- vs. post-COVID (+440% avg. annual return) alongside the largest volatility increase, while AAPL/MSFT stayed comparatively stable |
| [JSON/SQL Data Wrangling Assignments](projects/DATA604-JSON-SQL-Data-Wrangling-Assignments/) | Two assignments: parsing and flattening deeply nested JSON into normalized CSVs using only Python built-ins, no pandas (Assignment 1); SQL exploration via SQLAlchemy/SQLite of a City of Edmonton licensed-pets dataset by breed and Forward Sortation Area (Assignment 2) |

### DATA 603
| Project | Summary |
|---|---|
| [Parcel-Level Drivers of Property Assessment in Calgary](projects/DATA603-Calgary-Property-Assessment-Analysis/) | Group project (with Jimoh Adewumi and Adewale Adewumi) modeling Calgary's 2025 parcel-level property assessments with multiple linear regression (adj. R² ≈ 0.557) and full diagnostics (VIF, residuals, Kolmogorov–Smirnov); found community location and land-use designation as the strongest predictors of assessed value, with affluent SW communities (Bel-Aire, Britannia) topping the rankings |
| [Multiple Linear Regression Assignments](projects/DATA603-MLR-Assignments/) | Three individual assignments on the MLR workflow: model fitting, hypothesis testing, interaction terms, and qualitative variables across water usage, clock auctions, gas turbines, tire wear, depression treatment, and caregiver burden datasets; Assignment 3 adds a full regression-assumptions diagnostic battery (VIF, Breusch-Pagan, Shapiro-Wilk, Cook's distance, Box-Cox) and logistic regression (WCGS heart disease, Titanic survival) with ROC/AUC and Hosmer-Lemeshow evaluation |

### DATA 602
| Project | Summary |
|---|---|
| [What Makes a Vinho Verde Red Wine High Quality?](projects/DATA602-Vinho-Verde-Red-Wine-Quality/) | Group project (with Yu Hao, Namya Dimri, Abdalla Elshafey) testing whether alcohol content and pH drive perceived quality in 1,599 Portuguese *Vinho Verde* red wines; a Welch t-test + permutation test show high-quality wines average ~0.93% more alcohol (p < 0.0002), while Chi-squared tests of independence find no significant link between pH and quality |
| [Probability, Distributions & Bootstrap Inference Assignments](projects/DATA602-Statistical-Inference-Assignments/) | Four individual assignments: classical probability, combinatorics, Bayes' theorem, discrete/continuous random variables, and Monte Carlo simulation (Assignment 1); Central Limit Theorem, chi-squared sampling distributions, and bootstrap resampling vs. classical confidence intervals (t, normal-approximation, Agresti-Coull) for means, proportions, medians, and standard deviations (Assignment 2); hypothesis testing with bootstrap two-sample inference, exact binomial tests, Type I/II error and power analysis, one-sample/paired t-tests, and a custom test derived from a shifted-exponential pdf (Assignment 3); permutation tests, chi-squared tests of independence/goodness-of-fit, and simple linear regression (CAPM beta estimation, Barry Bonds HR-rate prediction) with classical and bootstrap inference (Assignment 4) |

### DATA 601 – Intro to Data Science
| Project | Summary |
|---|---|
| [Predicting Traffic Incident Density Using Equity Indicators](projects/DATA601-Calgary-Traffic-Incident-Density/) | Group project (with Andrew Gellner, Tony Steere, Lovette Daminabo) predicting Calgary traffic incident density from Census equity indicators using a Random Forest Regressor (Test R² = 0.9242); permutation importance identified low-income seniors (LIM-AT 65+) and renter status as the strongest predictors |

*(more projects added as coursework continues)*

## Also see

- [Gaming Research Pipeline](https://github.com/bdubey6/Gaming-Research) — RA work under Prof. Jinhee Huh (Marketing), building a YouTube data collection and engagement-tracking pipeline for game UGC research
- HubMeta PDF extraction pipeline — RA work at Mount Royal University (literature synthesis tooling)
