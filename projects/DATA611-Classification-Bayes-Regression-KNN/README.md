# Classification Metrics, Bayes' Rule, Regression & KNN Fundamentals

**Course:** DATA 611 – Predictive Analysis, University of Calgary (Winter 2026)
**Author:** Bhuvan Dubey

## Problem

A four-part foundations assignment covering the core building blocks of predictive analytics:
evaluating a classifier at different decision thresholds (including under asymmetric business costs),
applying Bayes' rule to a diagnostic-test scenario, building and validating a multiple linear
regression model to estimate fossil ages from physical measurements, and using k-NN to classify
fossil taxonomy — plus a set of short-answer conceptual questions on trees, cross-validation, and
regularization.

## Approach

**1. Classification accuracy & cost-sensitive evaluation** — built confusion matrices at two decision
thresholds (0.25 and 0.75) for a manufacturing quality-control classifier, computed PCC/accuracy,
error rate, sensitivity, and specificity at each, then translated the confusion matrix into an
**expected-value/profit calculation** using the actual production cost ($15) and sale price ($25) —
showing how the "best" threshold depends on business economics, not just accuracy.

**2. Bayes' rule** — worked through a classic diagnostic-test paradox: given a rare condition
(0.01% prevalence) and a test with 97%/99% sensitivity/specificity, computed the overall positive-test
rate, decomposed it into true- vs. false-positive contributions, and derived the posterior probability
that a positive test actually indicates the condition — illustrating why testing rare events produces
mostly false positives even with a "highly accurate" test.

**3. Multiple linear regression** — used brain size, body size, and age group to predict the age (in
millions of years) of hominin fossils, with an 80/20 train-test split. Evaluated the fitted model with
R², MAE, MSE, and RMSE on both test and training data to check for overfitting, then used the model to
date a new, previously unclassified specimen.

**4. Conceptual questions** — binary tree capacity, k-fold cross-validation trade-offs, translation
invariance for audio classifiers, why squared error (not equality) is used as a regression loss, and
how L1 regularization affects feature sparsity and the bias-variance trade-off.

**5. K-Nearest Neighbors** — classified fossil taxonomy (Mid-Pleistocene Homo / Neanderthals /
Pleistocene Homo sapiens) from age, brain size, and body size using a 90/10 train-test split,
evaluated with a confusion matrix and accuracy, and swept k from 1–19 to check whether k=3 was
actually the best choice.

## Key Results

- **Cost-sensitive thresholding:** despite a *lower* raw accuracy (PCC = 0.60 vs. 0.95), the 0.25
cutoff produced a **positive expected value (+$8.50)** while the stricter 0.75 cutoff produced a
**negative expected value (–$6.50)** — because missing a faulty piece (false negative) is costlier
here than flagging a good piece as faulty. This is a direct illustration of why threshold selection
should be driven by the cost structure of the business problem, not by accuracy alone.
- **Bayes' rule:** the probability a random person tests positive is ~1.01%, but **most of that
signal is false positives** (0.999% vs. only 0.0097% true positives) — so the posterior probability
that a positive-testing person is actually a user is just **~0.96%**, despite the test being "97%/99%
accurate." Classic base-rate fallacy demonstration.
- **Regression:** the model achieved **R² = 0.987** on held-out test data (MAE = 0.0201, RMSE = 0.0253
million years), with training-set errors nearly identical (MAE = 0.0171, RMSE = 0.0229) — indicating
no overfitting and high reliability for dating new specimens.
- **KNN classification:** k=3 achieved **83.3% test accuracy**, correctly classifying 5 of 6 test
specimens (the one error was a Neanderthal misclassified as Pleistocene Homo sapiens). A sweep across
k=1–19 confirmed accuracy plateaus at ~82.5% for a wide middle range of k (roughly k=3–15), with sharp
drop-off at both extremes — validating k=3 as a reasonable choice.

## Tech Stack

Python (pandas, numpy, scikit-learn, matplotlib, seaborn).

## Files

- `code/Assignment1_Analysis.py` — full solution: confusion matrices & expected value, Bayes' rule
calculations, multiple linear regression, and k-NN classification
- `data/Paleontology.csv` — hominin fossil dataset (age, brain/body size, taxonomy, and other
measurements) used for the regression and KNN sections
- `report/Report.pdf` — full written report with all answers, code output, and figures
