# PCA Feature Selection & K-Means Clustering from Scratch

**Course:** DATA 611 – Predictive Analysis, University of Calgary (Winter 2026)
**Team:** Bhuvan Dubey and Andrea Abenoja

## Problem

Two linked exercises in unsupervised learning fundamentals: (1) reducing the dimensionality of a
73-feature facial-attribute dataset using both filter and wrapper feature-selection methods, then
formally applying PCA to quantify how much variance a reduced set of components captures, and
(2) implementing the K-means clustering algorithm from scratch (rather than calling `sklearn.cluster.KMeans`)
to build an intuition for how the algorithm converges, how sensitive it is to random initialization,
and how to choose the number of clusters *k*.

## Approach

**1. Feature selection & PCA** (`faces.csv` — facial-attribute measurements labeled by person)
- Compared a **filter method** (variance/correlation-based screening) against a **wrapper method**
(Sequential Forward Selection with a k=5 kNN classifier, scored on accuracy) for identifying which
of the 73 attributes are most informative.
- Partitioned the data 70/30 (train/test, `random_state=100`) and standardized features before
running PCA, since PCA is scale-sensitive.
- Computed explained variance per component, plotted the cumulative explained-variance curve to
determine how many components are needed to reach 80% of total variance, and extracted the
eigenvalues, eigenvectors, and loadings for the first two principal components.
- Visualized the data projected onto PC1/PC2 with loading vectors overlaid, to interpret what each
component represents.

**2. K-means from scratch** (`clusterData.pkl` — 2D synthetic data with a known cluster structure)
- Implemented the full K-means algorithm — random initialization, iterative assignment/update steps,
and convergence detection — without using a pre-built clustering library.
- Implemented the `error()` method (sum of squared distances from each point to its assigned
cluster mean) to track convergence and compare cluster solutions.
- Ran the algorithm 50 times with random restarts to find the lowest-error clustering, since K-means
can converge to different local optima depending on initialization.
- Used the **elbow method** — plotting minimum SSE across k = 1 to 10 (and again with a train/validation
split) — to reason about how to choose the number of clusters, and why picking k purely by
minimizing training error is the wrong approach (error trivially decreases as k increases).

## Key Results

- Sequential Forward Selection with a 5-NN classifier selected 10 features (including `Male`,
`Asian`, `White`, `Youth`, `Senior`, `Bald`, `No Eyewear`, `Bushy Eyebrows`, `No Beard`, and
`Strong Nose-Mouth Lines`) as the most predictive subset, taking roughly 196 seconds to evaluate —
illustrating the computational cost of wrapper methods versus filter methods.
- PCA on the standardized features showed how many components were needed to explain at least 80%
of total variance, with the first two components alone capturing a meaningful share — useful for
2D visualization even though more components are needed for full variance retention.
- The from-scratch K-means implementation successfully recovered the four visually distinct clusters
in the synthetic dataset, with the best of 50 random restarts achieving the lowest sum-of-squared-error.
- The elbow plot (SSE vs. k) showed the classic diminishing-returns curve, demonstrating why training
error alone can't be used to pick k — it always improves with more clusters — and why a validation-based
or elbow-based heuristic is needed instead.

## Tech Stack

Python (pandas, numpy, scikit-learn for feature selection/PCA/train-test split, matplotlib for
visualization). The K-means algorithm itself uses only NumPy — no clustering library.

## Files

- `code/PCA_Feature_Selection_And_KMeans.py` — full solution: feature selection (filter + wrapper),
PCA, and from-scratch K-means with the elbow-method analysis
- `data/clusterData.pkl` — the synthetic 2D dataset used for the K-means exercise
- `report/Report.docx` — full written report with all answers, code output, and figures

Note: `faces.csv` (the facial-attribute dataset used for the PCA/feature-selection exercise) is
course-provided and not redistributed here.
