# 1a)
library(data.table)

# Load Data
AQdata <- fread("AirQualityUCI.csv")

# Remove rows with any NA
AQdataFULL <- na.omit(AQdata)
AQdataFULL

# Extract CO variable
co_data <- AQdataFULL$`CO(GT)`
co_data

# 1b) 
# Removing rows with NA may bias the analysis if missing data is systematic.
# I would do in this case, is for time series data, I would consider imputation methods if missingness is not random.

# 1c)
# Sequence plot
plot(co_data, type='l', main='Plot of CO concentration', xlab='Observation', ylab='CO')

# Lag plot
lag.plot(co_data)

# Histogram
hist(co_data, main='Histogram of CO Concentration', xlab='CO (mg/m^3)', col='lightblue')

# Observation: 
# The sequence plot shows fluctuations with possible periodic patterns.
# The lag plot shows positive autocorrelation, with current values related to previous ones.
# The histogram is right-skewed, with most concentrations between 0.5 and 3 mg/m³.
# The data shows temporal dependence and occasional high concentration spikes.

# 1d) Q-Q plot
qqnorm(co_data)
qqline(co_data)
# The Q-Q plot shows the data points deviate from the line, indicating non-normality.
# The distribution appears skewed with heavy tails.

#------------------------------------------------------------------
#2a) 
# Load data
online_shoppers <- fread("online_shoppers_intention2.csv")
summary(online_shoppers)

set.seed(99)

# Sample training and test sets
train_idx <- sample(nrow(online_shoppers), 10000, replace = FALSE)
train_data <- online_shoppers[train_idx]
test_data  <- online_shoppers[-train_idx]

# Convert categorical variables to factors
train_data$Revenue <- as.factor(train_data$Revenue)
train_data$VisitorType <- as.factor(train_data$VisitorType)
train_data$Weekend <- as.factor(train_data$Weekend)

# Logistic regression model
model <- glm(Revenue ~ ., data = train_data, family = binomial)
summary(model)

# Odds ratio and percent change
odds_ratio <- exp(coef(model)["VisitorTypeReturning_Visitor"])
percent_change <- (1 - odds_ratio) * 100
percent_change
# Returning visitors are 27.2% less likely to make a purchase compared to new visitors.

#2b)
# Convert categorical variables to factors
test_data$Weekend <- as.factor(test_data$Weekend)
test_data$VisitorType <- as.factor(test_data$VisitorType)
test_data$Revenue <- as.factor(test_data$Revenue)

# Prediction
prob_pred <- predict(model, newdata = test_data, type = "response")
pred_class <- ifelse(prob_pred > 0.5, TRUE, FALSE)

#2c)
# Actual values
actual <- test_data$Revenue

# Confusion matrix
conf_mat <- table(Predicted = pred_class, Actual = actual)
conf_mat

# Accuracy
accuracy <- sum(diag(conf_mat)) / sum(conf_mat)
accuracy

# Sensitivity (True Positive Rate)
sensitivity <- conf_mat["TRUE","TRUE"] / sum(conf_mat[,"TRUE"])
sensitivity

# Specificity (True Negative Rate)
specificity <- conf_mat["FALSE","FALSE"] / sum(conf_mat[,"FALSE"])
specificity

#2d) 
# Lower threshold 
pred_class_new <- ifelse(prob_pred > 0.3, TRUE, FALSE)

# Confusion matrix for new threshold
conf_mat_new <- table(Predicted = pred_class_new, Actual = actual)
conf_mat_new

# Type I error: False Positives
type1 <- conf_mat_new["TRUE","FALSE"]
type1 

# Type II error: False Negatives
type2 <- conf_mat_new["FALSE","TRUE"]
type2 

#2e)
# Costs
cost_typeI <- 10  # False positive
cost_typeII <- 11 # False negative

# Thresholds to test
thresholds <- seq(0.1, 0.5, by = 0.05)
costs <- numeric(length(thresholds))

# Loop through thresholds
for (i in seq_along(thresholds)) {
  t <- thresholds[i]
  
  # Convert predicted probabilities to classes
  pred_temp <- ifelse(prob_pred >= t, "TRUE", "FALSE")
  pred_temp <- factor(pred_temp, levels = c("FALSE", "TRUE"))
  
  # Confusion matrix
  cm_table <- table(Predicted = pred_temp, Actual = test_data$Revenue)
  
  # Type I and II errors safely
  FP <- ifelse(is.na(cm_table["TRUE","FALSE"]), 0, cm_table["TRUE","FALSE"])
  FN <- ifelse(is.na(cm_table["FALSE","TRUE"]), 0, cm_table["FALSE","TRUE"])
  
  # Total cost
  costs[i] <- FP * cost_typeI + FN * cost_typeII
}

# Optimal threshold
min_idx <- which.min(costs)
optimal_threshold <- thresholds[min_idx]

cat("Optimal threshold to minimize cost:", optimal_threshold, "\n")
cat("Minimum expected cost:", costs[min_idx], "\n")

#------------------------------------------------------------------------------------------
# Load libraries
library(MASS)      # For LDA and QDA
library(class)     # For KNN

# 3a) Load data
accent_mfcc <- fread("accent-mfcc-data-1.csv")

set.seed(29)

# Sample 250 observations for training
train_idx <- sample(nrow(accent_mfcc), 250, replace = FALSE)
train_data <- accent_mfcc[train_idx]
test_data  <- accent_mfcc[-train_idx]

# Make sure target is a factor
train_data$language <- as.factor(train_data$language)
test_data$language  <- as.factor(test_data$language)

# LDA classifier using all MFC inputs
lda_model <- lda(language ~ ., data = train_data)
lda_model

# 3b) 
# Predict LDA on test set
lda_pred <- predict(lda_model, newdata = test_data)$class
lda_pred

# 3c) 
# Accuracy and confusion matrix for LDA
lda_conf_mat <- table(Predicted = lda_pred, Actual = test_data$language)
lda_conf_mat

lda_accuracy <- sum(diag(lda_conf_mat)) / sum(lda_conf_mat)
cat("3c) LDA accuracy:", round(lda_accuracy,3), "\n")

# 3d) 
# Create QDA classifier
qda_model <- qda(language ~ ., data = train_data)
qda_model

# 3e)
# Predict QDA on test set
qda_pred <- predict(qda_model, newdata = test_data)$class
qda_pred

# 3f) 
# Accuracy and confusion matrix for QDA
qda_conf_mat <- table(Predicted = qda_pred, Actual = test_data$language)
qda_conf_mat

qda_accuracy <- sum(diag(qda_conf_mat)) / sum(qda_conf_mat)
cat("3f) QDA accuracy:", round(qda_accuracy,3), "\n")

# Comparison:
# QDA performs better than LDA, suggesting class covariances are not equal.

# Additional steps to check:
# Inspect covariance matrices of each class
# Check for multicollinearity among MFC features
# Try cross-validation to confirm stability

# 3g)
# Prepare data
train_X <- as.matrix(train_data[, !("language"), with = FALSE])
train_Y <- train_data$language
test_X  <- as.matrix(test_data[, !("language"), with = FALSE])
test_Y  <- test_data$language

set.seed(29)

# KNN with k=5
knn_pred5 <- knn(train = train_X, test = test_X, cl = train_Y, k = 5)
knn_conf_mat5 <- table(Predicted = knn_pred5, Actual = test_Y)
knn_accuracy5 <- sum(diag(knn_conf_mat5)) / sum(knn_conf_mat5)
cat("3g) KNN accuracy (k=5):", round(knn_accuracy5,3), "\n")

# KNN with k=10
knn_pred10 <- knn(train = train_X, test = test_X, cl = train_Y, k = 10)
knn_conf_mat10 <- table(Predicted = knn_pred10, Actual = test_Y)
knn_accuracy10 <- sum(diag(knn_conf_mat10)) / sum(knn_conf_mat10)
cat("3g) KNN accuracy (k=10):", round(knn_accuracy10,3), "\n")

# The accuracy for k=5 is approximately 77.2%, and for k=10 it is about 72.2%.
# When comparing the two, the model with k=5 performs better, indicating that using fewer neighbors may better capture the local structure of the data and improve classification accuracy.

#--------------------------------------------------------------------------------------
# 4)
library(ggplot2)

# Input variables 
input_data <- accent_mfcc[, !("language"), with = FALSE]

# Scale data
input_scaled <- scale(input_data)

# Perform PCA
pca_model <- prcomp(input_scaled, center = TRUE, scale. = TRUE)

# Biplot for first two PCs
biplot(pca_model, scale = 0, cex = 0.7)
title("4a) Biplot of first two PCs")

# 4b)
# interpretation
loadings <- pca_model$rotation[, 1:2]
print("Loadings for PC1 and PC2:")
print(round(loadings, 3))

# PC scores for observations
scores <- pca_model$x[, 1:2]

# first three observations
head(scores, 3)
print(round(scores[1:3,], 3))

# Interpretation: 
# The loadings indicate which features influence each principal component.
# Features X3 and X10 mainly influence PC2, while X9 and X6 influence PC1.
# The biplot shows three distinct groups of data points based on PC1 and PC2.
# This suggests that the first two PCs separate the data into different clusters,
# potentially corresponding to different speaker accents or groups.
# Observations with high PC1 and PC2 scores are in one group, while those with lower scores form other groups.
# Overall, the first two PCs help distinguish between different categories within the data.

# 4c) 
# Variance explained by each PC
pve <- (pca_model$sdev)^2 / sum((pca_model$sdev)^2)
cum_pve <- cumsum(pve)

# Plot PVE
plot(pve, type = "b", xlab = "Principal Component", ylab = "Proportion of Variance Explained",
     main = "4c) PVE for Each Principal Component", pch = 19)

# Plot cumulative PVE
plot(cum_pve, type = "b", xlab = "Principal Component", ylab = "Cumulative PVE",
     main = "4c) Cumulative PVE", pch = 19)

# Observation
# From the PVE plot, the first few PCs explain most of the variance. For example, PC1 alone might explain around 40-50%,
# and PC2 adds another significant portion. The cumulative PVE plot shows that by the third or fourth PC,
# about 70-80% of the total variance is captured.
# Therefore, a good number of PCs to retain would be around 3 to 4, balancing dimensionality reduction with information retention.
# Using more PCs beyond this point yields diminishing returns, as the additional variance explained is minimal.

# ------------------------------------------------------------------------------------------------------
# 5)
# Load Library
library(cluster)

# Load Data
ad_data <- fread ("ad.csv")

# Look at structure
str(ad_data)

# a) 
# For clustering (unsupervised learning), splitting into train/test is generally not needed,
# The goal is to find patterns/groups in the whole dataset.
# Splitting is more important for supervised learning.
# So, no train/test split is needed here.

# b)
# Scale all features
ad_scaled <- scale(ad_data[, c("TV", "radio", "newspaper")])

# Clustering with 3 clusters
set.seed(1)
k3 <- kmeans(ad_scaled, centers=3, nstart=10)
k3

# Clustering with 4 clusters
set.seed(1)
k4 <- kmeans(ad_scaled, centers=4, nstart=10)
k4

# c)
# Plot 3D scatter for k=3 clusters colored by cluster
ad_scaled_df <- as.data.frame(ad_scaled)
ad_scaled_df$cluster3 <- factor(k3$cluster)

pairs(ad_scaled_df[, 1:3], col = ad_scaled_df$cluster3,
      main = "5c) Pairwise Scatter Plots Colored by 3 Clusters")

# Cluster show moderate separation, especially along the TV and radio dimensions. 
# Overlap between clusters when newspaper is involved, indicating weaker separation on that variable.

# d) 
# within-cluster errors (withinss) 
total_withinss <- sum(k4$withinss)
# Ratio of within-cluster errors
cluster_withinss_ratio <- k4$withinss / total_withinss

# Plot within-cluster sum of squares
barplot(k4$withinss, main="Within-Cluster Errors for k=4",
        xlab="Cluster", ylab="Within-cluster sum of squares")

# Identify most homogeneous cluster -- smallest 
homogeneous_cluster <- which.min(k4$withinss)
cat("Most homogeneous cluster:", homogeneous_cluster, "\n")

# e) 
# Hierarchical clustering with complete linkage
dist_matrix <- dist(ad_scaled)
hc_complete <- hclust(dist_matrix, method = "complete")

# Plot dendrogram and  line for height h=4
plot(hc_complete, main = "5e) Complete Linkage Dendrogram")
abline(h=4, col="red", lwd=2)

# Cut dendrogram into 4 clusters
hc_clusters_4 <- cutree(hc_complete, k = 4)
table(hc_clusters_4)

# f) 
# Cluster using dendrogram cut at height h=3
hc_clusters_h3 <- cutree(hc_complete, h = 3)
table(hc_clusters_h3)
cat("5f) Number of clusters at height h=3:", length(unique(hc_clusters_h3)), "\n")

#-----------------------------------------------------------------------------------
#6a) 
# Load the ISLR package
library(ISLR)
data("Carseats")

# First few rows
head(Carseats)

# a) 
# The  "Sales" variable (sales of Carseats) is likely the main business objective.

# b)
# The dataset captures factors influencing sales, such as price, advertising, store location, shelf location, etc. 
# Aspects missing might include customer demographics, competitors' actions, market trends, or seasonal effects.

# c) 
# Which factors most significantly affect sales?
# What is the impact of advertising on sales?
# Are certain store locations more profitable?
# How does price sensitivity vary across stores?

# --------------------------------------------------------------------------------------
# 7) 
# Load Data
BankMarketing_data <- fread ("BankMarketingSample.csv")
BankMarketing_data

# a)
# Logistic regression, decision trees, random forests, SVM, or boosting are good options.
# They predict whether 'y' is 'yes' or 'no'.
# Ex. Random Forest - ensemble, robust, handles complex interactions

# Load Library
library(caret)
library(randomForest)

# Convert target variable to factor for classification
BankMarketing_data$y <- as.factor(BankMarketing_data$y)

# Split data into training and testing sets
set.seed(123)
trainIndex <- createDataPartition(BankMarketing_data$y, p = 0.8, list = FALSE)
trainData <- BankMarketing_data[trainIndex]
testData <- BankMarketing_data[-trainIndex]

# Random Forest model
rf_model <- randomForest(y ~ ., data = trainData, importance = TRUE)

# b) 
# Predict on test data
predictions <- predict(rf_model, testData)

# Evaluate model with confusion matrix
conf_mat <- confusionMatrix(predictions, testData$y, positive = "yes")
print(conf_mat)

# Number of false positives and false negatives
fp <- conf_mat$table["no", "yes"]
fn <- conf_mat$table["yes", "no"]
cat("False Positives (Type I error):", fp, "\n")
cat("False Negatives (Type II error):", fn, "\n")

# Type I error (False Positive): Predicting 'yes' when the client won't subscribe — wastes resources.  
# Cost: Wasted marketing resources by contacting uninterested clients.

# Type II error (False Negative): Predicting 'no' when the client would subscribe — missed sales.
# Cost: Missed opportunities, potential revenue loss.

# Type II errors are more costly because missing potential subscribers leads to lost revenue.
# To reduce these, we can adjust the decision threshold or use cost-sensitive methods. 

# c) 
# Variable importance
importance(rf_model)
varImpPlot(rf_model)

# 'Age', 'housing', 'loan', and 'voicemail' have low or negative importance and are likely not useful for prediction.
# These variables may not strongly influence whether a client subscribes.
# 'Duration', 'emp.var.rate', 'cons.price.idx', 'cons.conf.idx', 'euribor3m', and 'nr.employed' are the most important variables.
# Variables with low importance can be removed to improve the model’s accuracy and simplicity.


# ----------------------------------------------------------------------------------------------
#8) 
# This visual shows total enrollment by course across different years.
# It shows which courses consistently attract high student enrollment at which year
# and which courses have lower demand. 
# This helps library managers identify courses for book purchasing,
# ensuring sufficient stock for high-demand courses while avoiding over-ordering for low-demand courses.

