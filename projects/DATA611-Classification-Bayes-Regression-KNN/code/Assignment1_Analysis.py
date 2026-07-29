# Load libraries
import pandas as pd
from sklearn.model_selection import train_test_split
from sklearn.linear_model import LinearRegression
from sklearn.metrics import r2_score, mean_absolute_error, mean_squared_error
from sklearn.neighbors import KNeighborsClassifier
from sklearn.metrics import confusion_matrix, accuracy_score
from sklearn.preprocessing import LabelEncoder
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns

# 1. Classification Accuracy -----------------------------------------------------------------------
# Data setup
data = {
    'propensity': [0.03, 0.52, 0.38, 0.82, 0.33, 0.42, 0.55, 0.59, 0.09, 0.21, 0.43, 0.04, 0.08, 0.13, 0.01, 0.79, 0.42, 0.29, 0.08, 0.02],
    'actual':     [0, 0, 0, 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0]
}
df = pd.DataFrame(data)

# 1a) Confusion matrix for cutoff values of 0.25 and 0.75
# True Positive (TP), True Negative (TN), False Positive (FP), False Negative (FN)
def compute_confusion_matrix(df, cutoff):
    df['predicted'] = (df['propensity'] >= cutoff).astype(int)     
    TP = len(df[(df['actual'] == 1) & (df['predicted'] == 1)])
    TN = len(df[(df['actual'] == 0) & (df['predicted'] == 0)])
    FP = len(df[(df['actual'] == 0) & (df['predicted'] == 1)])
    FN = len(df[(df['actual'] == 1) & (df['predicted'] == 0)])
    return TP, TN, FP, FN

# Cutoffs 
cutoffs = [0.25, 0.75]
for cutoff in cutoffs:
    TP, TN, FP, FN = compute_confusion_matrix(df, cutoff)
    print(f"\n--- Confusion matrix at cutoff {cutoff} ---")
    print(f"TP: {TP}")
    print(f"TN: {TN}")
    print(f"FP: {FP}")
    print(f"FN: {FN}")
    
# 1b) Calculate the PCC both error rates, sensitivity and specificity using cutoff values 0.25 and 0.75
def calculate_metrics(TP, TN, FP, FN):
    total = TP + TN + FP + FN
    PCC = (TP + TN) / total if total > 0 else 0
    error_rate = (FP + FN) / total if total > 0 else 0
    sensitivity = TP / (TP + FN) if (TP + FN) > 0 else 0
    specificity = TN / (TN + FP) if (TN + FP) > 0 else 0
    return PCC, error_rate, sensitivity, specificity

for cutoff in cutoffs:
    TP, TN, FP, FN = compute_confusion_matrix(df, cutoff)
    PCC, error_rate, sensitivity, specificity = calculate_metrics(TP, TN, FP, FN)
    print(f"\n--- Metrics at cutoff {cutoff} ---")
    print(f"PCC (Accuracy): {PCC:.2f}")
    print(f"Error Rate: {error_rate:.2f}")
    print(f"Sensitivity (Recall): {sensitivity:.2f}")
    print(f"Specificity: {specificity:.2f}")
    
# 1c) Calculate the expected value for each cut-off value 0.25 and 0.75
cost_production = 15
sale_price = 25
total_samples = len(df)
actual_good = len(df[df['actual'] == 0])
actual_faulty = len(df[df['actual'] == 1])

for cutoff in cutoffs:
    TP, TN, FP, FN = compute_confusion_matrix(df, cutoff)
    false_negative_rate = FN / actual_faulty if actual_faulty > 0 else 0   # False negatives (faulty pieces missed)
    profit_good = (actual_good / total_samples) * (sale_price - cost_production)   # Profit from correctly selling good pieces
    faulty_missed = false_negative_rate * actual_faulty
    profit_faulty_missed = faulty_missed * (-cost_production) # no revenue, just replacement cost
    expected_value = profit_good + profit_faulty_missed
    print(f"\nExpected value at cutoff {cutoff}: ${expected_value:.2f}")

# 2. Bayes Rule and Conditional Probability -----------------------------------------------------------------------
# Probability that a random person uses the drug 
P_D1 = 0.0001
# Probability that a person does not use the drug
P_D0 = 1 - P_D1
# Drug test:
# Probability the test correctly identifies a user
P_T1_given_D1 = 0.97
# Probability the test correctly identifies a non-user
P_T0_given_D0 = 0.99
# 2a: Probability that a random person would test positive, P(T=1)
P_T1_given_D0 = 1 - P_T0_given_D0  # P(T=1 | D=0): false positive rate
P_T1 = (P_T1_given_D1 * P_D1) + (P_T1_given_D0 * P_D0)
print(f"Part 2a) - Probability that a person tests positive: {P_T1:.8f}")

# 2b: Calculate where most of these positive tests come from (true positives or false positives)
prob_true_positive = P_T1_given_D1 * P_D1
prob_false_positive = P_T1_given_D0 * P_D0
print(f"Part 2b) - True positives contribution: {prob_true_positive:.8f}")
print(f"Part 2b) - False positives contribution: {prob_false_positive:.8f}")
if prob_true_positive > prob_false_positive:
    print("Most positive tests are true positives.")
else:
    print("Most positive tests are false positives.")
    
# 2c: Probability that a random person who tests positive is a user, P(D=1|T=1)
P_D1_given_T1 = (prob_true_positive) / P_T1
print(f"Part 2c) - Probability that a person who tests positive is a user: {P_D1_given_T1:.8f}")

# 2d: Given this test to a random person and it came back positive, are they likely to be a drug user
print(f"Part 2d) - Given a positive test, the probability the person is a user: {P_D1_given_T1:.8f}")

# 3. Multiple Linear Regression -----------------------------------------------------------------------
# Load the dataset
file_path = "../data/Paleontology.csv"
df = pd.read_csv(file_path)

# d) Testing the Multiple Linear Regression Model [X = 'Brain size', 'Body size', 'Age group' and Y = 'Age (Myr)']
X = df[['Brain size', 'Body size', 'Age group']]
y = df['Age (Myr)']

# 3d. a) Partition data into training (80%) and testing (20%)
X_train, X_test, y_train, y_test = train_test_split(
    X, y, test_size=0.2, random_state=42
)

# Sample of training data
# Combine X_train with y_train
train_combined = X_train.copy()
train_combined['Age (Myr)'] = y_train
print("\nSample of combined training data (X_train + y_train):")
print(train_combined.head())

# Sample of Testing data
# Combine X_test with y_test 
test_combined = X_test.copy()
test_combined['Age (Myr)'] = y_test
print("\nSample of combined testing data (X_test + y_test):")
print(test_combined.head())


# 3d. b) Fit the multiple linear regression model 
model = LinearRegression()
model.fit(X_train, y_train)
coefficients = pd.Series(model.coef_, index=X.columns)
intercept = model.intercept_

equation = f"Age (Myr) = {intercept:.4f}"
for name, coef in coefficients.items():
    equation += f" + ({coef:.4f} * {name})"
print("\nModel Equation:\n", equation)

# 3d. c) Evaluate the models performance
y_pred_test = model.predict(X_test)
r2 = r2_score(y_test, y_pred_test)
mae = mean_absolute_error(y_test, y_pred_test)
mse = mean_squared_error(y_test, y_pred_test)
rmse = np.sqrt(mse)

print("\nModel performance on test data:")
print(f"R^2 score: {r2:.3f}")
print(f"MAE: {mae:.4f}")
print(f"MSE: {mse:.4f}")
print(f"RMSE: {rmse:.4f}")

# 3d. d) Conclusions
print(f"\nConclusion: The model explains approximately {r2*100:.2f}% of the variance in age.")
print("The MAE and RMSE shows the average prediction errors, explaining how well the model predicts age.")

# 3d. e) Training error comparison 
y_pred_train = model.predict(X_train)
train_mae = mean_absolute_error(y_train, y_pred_train)
train_mse = mean_squared_error(y_train, y_pred_train)
train_rmse = np.sqrt(train_mse)
print("\nTraining errors:")
print(f"MAE: {train_mae:.4f}")
print(f"MSE: {train_mse:.4f}")
print(f"RMSE: {train_rmse:.4f}")
    
# 3d. f) Predict age of new specimen 
# Given data:
brain_size_new = 1453
body_size_new = 68
age_group_new = 1

# Prepare input with training feature names
new_specimen = pd.DataFrame({
    'Brain size': [brain_size_new],
    'Body size': [body_size_new],
    'Age group': [age_group_new]
})
# Predict age using the trained model
predicted_age = model.predict(new_specimen)[0]
print(f"\nPredicted age for new specimen:")
print(f"Predicted Age (Million years): {predicted_age:.2f}")

# 5. K-Nearest Neighbors -----------------------------------------------------------------------
# a) Define predictor variables and target variable
predictor_cols = ['Age (Myr)', 'Brain size', 'Body size']
target_col = 'Taxonomy'

# Snapshot for the first 10 observations for the predictor variables and target variable
snapshot = df[predictor_cols + [target_col]].head(10)
print("First 10 observations of target and predictor variables:\n")
print(snapshot)

# b) Partition into 90% train and 10% test
# Check if these columns exist
for col in predictor_cols + [target_col]:
    if col not in df.columns:
        raise ValueError(f"Column '{col}' not found in dataset.")

X = df[predictor_cols]
y = df[target_col]

# Encode target variable
le = LabelEncoder()
y_encoded = le.fit_transform(y)

# Ensure predictor columns are numeric
X = X.select_dtypes(include=[np.number])

# Split data
X_train, X_test, y_train, y_test = train_test_split(
    X, y_encoded, test_size=0.1, random_state=42
)

# Snapshot of the training data
print("Training data snapshot:\n")
print(pd.concat([X_train, pd.Series(y_train, name='Taxonomy')], axis=1).head())

# Snapshot of the test data
print("\nTest data snapshot:\n")
print(pd.concat([X_test, pd.Series(y_test, name='Taxonomy')], axis=1).head())

# c) Create a k-NN classifier with k=3 and fit it
knn = KNeighborsClassifier(n_neighbors=3)
knn.fit(X_train, y_train)
y_pred = knn.predict(X_test)
print("\nPredicted labels for test data:\n")
print(le.inverse_transform(y_pred))

# d) Show confusion matrix and accuracy
cm = confusion_matrix(y_test, y_pred)
accuracy = accuracy_score(y_test, y_pred)
print("\nConfusion Matrix:\n", cm)
print(f"\nAccuracy: {accuracy*100:.2f}%")

# Plot confusion matrix
plt.figure(figsize=(8,6))
sns.heatmap(cm, annot=True, fmt='d', cmap='Blues',
            xticklabels=le.classes_, yticklabels=le.classes_)
plt.xlabel('Predicted')
plt.ylabel('Actual')
plt.title('Confusion Matrix')
plt.show()

# e) Is k=3 the 'best' k? 
k_values = list(range(1, 20, 2))
accuracies = []

for k in k_values:
    model = KNeighborsClassifier(n_neighbors=k)
    model.fit(X_train, y_train)
    pred = model.predict(X_test)
    accuracies.append(accuracy_score(y_test, pred))

# Plot accuracy vs k
plt.figure(figsize=(8,6))
plt.plot(k_values, accuracies, marker='o')
plt.xlabel('k')
plt.ylabel('Test Accuracy')
plt.title('KNN Accuracy for different k values')
plt.show()

# Find the best k
best_k = k_values[np.argmax(accuracies)]
print(f"\nThe best k based on test accuracy is: {best_k}")

# f) Classify the taxonomy 
# Create DataFrame with new specimen data
new_specimen_df = pd.DataFrame(
    [[0.33, 1453, 68]],
    columns=predictor_cols  # ['Age (Myr)', 'Brain size', 'Body size']
)

# Predict
predicted_taxonomy = le.inverse_transform(knn.predict(new_specimen_df))
print(f"\nThe predicted taxonomy for the new specimen is: {predicted_taxonomy[0]}")
