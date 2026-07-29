import pandas as pd
import matplotlib.pyplot as plt
import os
import pickle
import numpy as np
from sklearn.decomposition import PCA
from sklearn.preprocessing import StandardScaler
from sklearn.feature_selection import SequentialFeatureSelector
from sklearn.neighbors import KNeighborsClassifier
from sklearn.model_selection import train_test_split
import time


file_path = os.path.join('..', 'data', 'faces.csv')
# Load data
faces_df = pd.read_csv(file_path)
faces_df.head()

# Prepare features and target
X = faces_df.drop(columns=['person', 'imagenum'])
y = faces_df['person']

# Remove classes with only 1 observation
class_counts = y.value_counts()
valid_classes = class_counts[class_counts > 1].index

X_filtered = X[y.isin(valid_classes)]
y_filtered = y[y.isin(valid_classes)]

# Scale
scaler = StandardScaler()
X_scaled = scaler.fit_transform(X_filtered)

# kNN
knn = KNeighborsClassifier(n_neighbors=5)

# Sequential Forward Selection
sfs = SequentialFeatureSelector(knn, n_features_to_select=10, direction='forward', scoring='accuracy', cv=2)

start_time = time.time()
sfs.fit(X_scaled, y_filtered)
processing_time = time.time() - start_time

selected_features = X.columns[sfs.get_support()]

print("Processing time:", processing_time)
print("Selected features:", list(selected_features))

# Split data: 70% training, 30% testing
X_train, X_test, y_train, y_test = train_test_split(X_filtered, y_filtered, test_size=0.3, random_state=100, stratify=y_filtered)

print("Training set:", X_train.shape, y_train.shape)
print("Testing set:", X_test.shape, y_test.shape)

# Scale the training and testing data
scaler = StandardScaler()
X_train_scaled = scaler.fit_transform(X_train)
X_test_scaled = scaler.transform(X_test)

# Run PCA
pca = PCA()
X_train_pca = pca.fit_transform(X_train_scaled)
X_test_pca = pca.transform(X_test_scaled)

# Explained variance
explained_variance = pca.explained_variance_ratio_
print("Explained variance of first 10 components:", explained_variance[:10])

# Cumulative variance
cumulative_variance = np.cumsum(pca.explained_variance_ratio_)

# Plot
plt.figure(figsize=(8,5))
plt.plot(range(1, len(cumulative_variance)+1), cumulative_variance, marker='o', linestyle='--')
plt.axhline(y=0.8, color='r', linestyle='-')  # 80% threshold
plt.xlabel('Number of Principal Components')
plt.ylabel('Cumulative Explained Variance')
plt.title('Explained Variance by PCA Components')
plt.grid(True)
plt.show()

# Number of components to reach at least 80%
num_components_80 = np.argmax(cumulative_variance >= 0.8) + 1
print("Number of components to explain at least 80% variance:", num_components_80)

# Explained variance for first 2 components
variance_first_2 = sum(pca.explained_variance_ratio_[:2]) * 100
print(f"Variance explained by first 2 components: {variance_first_2:.2f}%")

# Eigenvalues for first two PCs
eigenvalues = pca.explained_variance_[:2]
print("Eigenvalues for first two PCs:", eigenvalues)

# Eigenvectors for first two PCs
eigenvectors = pca.components_[:2]
print("Eigenvectors for first two PCs:\n", eigenvectors)

# Calculate loadings [eigenvectors * sqrt(eigenvalues)]
loadings = eigenvectors.T * np.sqrt(eigenvalues)

# Create DataFrame
variables = X.columns
loadings_df = pd.DataFrame(loadings, index=variables, columns=['PC1 Loadings', 'PC2 Loadings'])

print(loadings_df)

# Training data onto first 2 PCs
X_pca_2 = X_train_pca[:, :2]
plt.figure(figsize=(10,8))
plt.scatter(X_pca_2[:,0], X_pca_2[:,1], alpha=0.5)
plt.xlabel('PC1')
plt.ylabel('PC2')
plt.title('Scatterplot of First 2 Principal Components')

# Feature loadings as vectors
for i, var in enumerate(variables):
    plt.arrow(0, 0, loadings_df['PC1 Loadings'][i]*5, loadings_df['PC2 Loadings'][i]*5,
              color='red', alpha=0.5)
    plt.text(loadings_df['PC1 Loadings'][i]*5*1.1, loadings_df['PC2 Loadings'][i]*5*1.1,
             var, fontsize=8, alpha=0.7)

plt.grid(True)
plt.show()

# Load clustering dataset

q2_file_path = os.path.join('..', 'data', 'clusterData.pkl')

# question 2a)

# completed code with error() function:

import matplotlib.pyplot as plt
import numpy as np
from pathlib import Path
import pickle


# This is to load the data
def load_dataset(file_path):
    with open(Path(q2_file_path).with_suffix(".pkl"), "rb") as f:
        return pickle.load(f)

data = load_dataset(q2_file_path)

# This is to calculate the Euclidean distance
def euclidean_dist_squared(X, Xtest):
    """Computes the Euclidean distance between rows of 'X' and rows of 'Xtest'

    Parameters
    ----------
    X : an N by D numpy array
    Xtest: an T by D numpy array

    Returns: an array of size N by T,
    #        containing the pairwise squared Euclidean distances.

    """
    #  sklearn.metrics.pairwise.euclidean_distances does this but a little bit nicer;
    # this code is just here so you can
    # easily see that it's not doing anything actually very complicated

    X_norms_sq = np.sum(X ** 2, axis=1)
    Xtest_norms_sq = np.sum(Xtest ** 2, axis=1)
    dots = X @ Xtest.T

    return X_norms_sq[:, np.newaxis] + Xtest_norms_sq[np.newaxis, :] - 2 * dots



class Kmeans:
    means = None

    def __init__(self, k):
        self.k = k

    def fit(self, X):
        n, d = X.shape
        y = np.ones(n)

        means = np.zeros((self.k, d))
        for kk in range(self.k):
            i = np.random.randint(n)
            means[kk] = X[i]

        while True:
            # iterations of k-means
            y_old = y

            # Compute euclidean distance to each mean
            distance_matrix = euclidean_dist_squared(X, means)
            distance_matrix[np.isnan(distance_matrix)] = np.inf
            y = np.argmin(distance_matrix, axis=1)

            # Update means
            for kk in range(self.k):
                if np.any(
                    y == kk
                ):  # don't update the mean if no examples are assigned to it (one of several possible approaches)
                    means[kk] = X[y == kk].mean(axis=0)

            changes = np.sum(y != y_old)
            # print('Running K-means, changes in cluster assignment = {}'.format(changes))

            # Stop if no point changed cluster
            if changes == 0:
                break

            # print(self.error(X, y, means))

        self.means = means

    def predict(self, X_hat):
        means = self.means
        distance_matrix = euclidean_dist_squared(X_hat, means)
        distance_matrix[np.isnan(distance_matrix)] = np.inf
        return np.argmin(distance_matrix, axis=1)

    def error(self, X, y, means):
        sse = 0
        for i in range(len(X)):
          sse += np.sum((X[i] - means[y[i]])**2)
        return sse

        raise NotImplementedError()

X = load_dataset("clusterData.pkl")["X"]
X.size

model = Kmeans(k=4)
model.fit(X)
y = model.predict(X)

plt.scatter(X[:, 0], X[:, 1], c=y, cmap="jet")
plt.title("K-means Clustering Results")
plt.show()

# print error value to see trend over time

error_value = model.error(X, y, model.means)
print(f"\nThe error value of this model is: {error_value}")

# question 2b)

# create a function of the cluster model
def run_cluster(k, data):
    model = Kmeans(k=k)
    model.fit(data)
    y = model.predict(data)
    error_value = model.error(data, y, model.means)
    return model, y, error_value

model_errors = [] # create vector for errors
model_runs = [] # create vector for models
y_values = [] # create vector for y

# run model 50 times to get the error values for 50 runs
for i in range(50):
  model, y, error_value = run_cluster(4, X)
  model_errors.append(error_value)
  model_runs.append(model)
  y_values.append(y)

# print the min error value
print(f"The minimum error across 50 runs with a k = 4 was: {min(model_errors)}")

# get index of the min(model_errors)
optimal_index = np.argmin(model_errors)

# then get model
optimal_model = model_runs[optimal_index]
optimal_y = y_values[optimal_index]

plt.scatter(X[:, 0], X[:, 1], c=optimal_y, cmap="jet")
plt.title("K-means Clustering Results")
plt.show()


# question 2c

potential_k = range(1, 20) # vector for potential k values
error_values = [] # create empty vector to store error vals from the potential k values

for k in potential_k:
   model, y, error_value = run_cluster(k, X)
   error_values.append(error_value)

plt.plot(potential_k, error_values, marker='o')
plt.xlabel('K')
plt.xticks(potential_k)
plt.ylabel('SSE')
plt.title('SSE vs. K')
plt.show()


# question 2d

from sklearn.model_selection import train_test_split

X_train, X_val = train_test_split(X, test_size=0.2, random_state=42)

train_errors = []
val_errors = []

for k in potential_k:
  model, y, error = run_cluster(k, X_train)
  train_errors.append(model.error(X_train, model.predict(X_train), model.means))
  val_errors.append(model.error(X_val, model.predict(X_val), model.means))

plt.plot(potential_k, train_errors, marker='o', label='Train Error')
plt.plot(potential_k, val_errors, marker='x', label='Validation Error')
plt.xlabel('K')
plt.xticks(potential_k)
plt.ylabel('SSE')
plt.title('K vs SSE for Training and Validation')
plt.legend()
plt.show()

# question 2e)

potential_k = range(1, 10) # vector for potential k values
error_values = [] # create empty vector to store error vals from the potential k values

for k in potential_k:
  model_errors = []
  for i in range(50):
   model, y, error_value = run_cluster(k, X)
   model_errors.append(error_value)
  error_values.append(min(model_errors))

plt.plot(potential_k, error_values, marker='o')
plt.xlabel('K')
plt.xticks(potential_k)
plt.ylabel('SSE')
plt.title('SSE vs. K')
plt.show()
