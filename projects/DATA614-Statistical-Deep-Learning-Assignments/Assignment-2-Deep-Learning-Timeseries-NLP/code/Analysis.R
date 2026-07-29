#1 ) ----------------------------------------------------------------------------
#a)
# Load libraries
library(dplyr)
library(caret)
library(neuralnet)

# Load data
data <- read.csv("online_shoppers_intention2.csv")

# Convert character columns to factors
data <- data %>% mutate(across(where(is.character), as.factor))

# Min–Max Scaling for numeric variables
num_vars <- sapply(data, is.numeric)

minmax_scale <- function(x){
  (x - min(x)) / (max(x) - min(x))
}

data[num_vars] <- lapply(data[num_vars], minmax_scale)

# Convert target to numeric 0/1
data$Revenue <- as.numeric(data$Revenue) - 1

# Convert ALL factor predictors to dummy variables
dummies <- dummyVars(Revenue ~ ., data = data)
data_nn <- data.frame(predict(dummies, newdata = data))
data_nn$Revenue <- data$Revenue

# Train-test split (2,000 rows for training)
set.seed(1)
train_index <- sample(1:nrow(data_nn), 2000)

train <- data_nn[train_index, ]
test  <- data_nn[-train_index, ]

# Build formula for neural network
predictors <- names(train)[names(train) != "Revenue"]
formula <- as.formula(paste("Revenue ~", paste(predictors, collapse = " + ")))

# Train neural network
nn <- neuralnet(
  formula,
  data = train,
  hidden = c(16, 12, 10),
  linear.output = FALSE,
  lifesign = "minimal"
)

# Plot the neural network
plot(nn)

#1b)
# Predict test set
pred <- compute(nn, test[, predictors])$net.result
pred_class <- ifelse(pred > 0.5, 1, 0)

# Compute MSE
mse <- mean((pred_class - test$Revenue)^2)
mse

# Confusion Matrix
confusionMatrix(
  factor(pred_class, levels = c(0,1)),
  factor(test$Revenue, levels = c(0,1))
)

# 2) ----------------------------------------------------------------------------
# a)
# Load libraries
library(forecast)
library(tseries)

# Load data
df <- read.csv("PRSA_DataSample.csv")

# Extract TEMP
temp <- df$TEMP

# Monthly time series (frequency = 12)
temp_ts <- ts(temp, frequency = 12)

# Interpolate missing values
temp_ts_interp <- na.interp(temp_ts)

# b)
# Plot original interpolated temperature series
plot(temp_ts_interp, main = "Temperature Time Series", ylab = "TEMP", xlab = "Time")

# Compute 2-period moving average (last 2 observations)
ma2 <- stats::filter(temp_ts_interp, rep(1/2, 2), sides = 1)

# Plot 2-period moving average
plot(ma2, main = "2-Period Moving Average of Temperature", ylab = "TEMP (MA2)", xlab = "Time")
lines(temp_ts_interp, col = "grey80")

# c)
# ACF, PACF, and ADF test for stationarity
par(mfrow = c(1, 2))
Acf(temp_ts_interp, main = "ACF of TEMP")
Pacf(temp_ts_interp, main = "PACF of TEMP")
par(mfrow = c(1, 1))

# Augmented Dickey-Fuller test
adf_result <- adf.test(temp_ts_interp)
adf_result

# Interpretation:
# The ACF plot shows some significant spikes at lag 1 
# this indicates there may be autocorrelation in the data. 
# The PACF plot suggests a significant spike at lag 1, 
# which means the data may be correlated with its immediate past.
# The p-value from the ADF test is 0.01, which is less than 0.05, 
# so we reject the null hypothesis that the data is non-stationary.
# This means the data is stationary, and we do not need to difference it further.

# d) ARIMA model and forecast 24 months
fit_arima <- auto.arima(temp_ts_interp)
fit_arima

# 24-month forecast
fc_arima <- forecast(fit_arima, h = 24)

# Plot forecast with historical data
plot(fc_arima, main = "ARIMA Forecast for Temperature (24 Months)", ylab = "TEMP", xlab = "Time")

# Interpretation:
# The auto.arima found an ARIMA(0,1,1)(1,1,0)[12] model. 
# This means the data was differenced once to make it stationary. 
# The model uses one moving average term and one seasonal autoregressive term.
# No seasonal moving average term was used.
# The model includes seasonal and non-seasonal differences to capture patterns.
# The forecast shows the temperature for the next 24 months, including the seasonal cycle.

# e) 
# Classical additive decomposition
decomp <- decompose(temp_ts_interp, type = "additive")
plot(decomp)

# Holt-Winters model
hw_fit <- HoltWinters(temp_ts_interp)

# 24-month forecast
hw_fc <- forecast(hw_fit, h = 24)

# Plot Holt-Winters forecast with actual data
plot(hw_fc, main = "Holt-Winters Forecast for Temperature (24 Months)", ylab = "TEMP", xlab = "Time")
lines(temp_ts_interp, col = "black")

# f) 
# Interpolate WSPM
wspm <- df$WSPM
wspm_ts <- ts(wspm, frequency = 12)
wspm_ts_interp <- na.interp(wspm_ts)

# Regression with TEMP as exogenous regressor using auto.arima
fit_reg <- auto.arima(wspm_ts_interp, xreg = temp_ts_interp)
summary(fit_reg)

# Interpretation:
# The regression results show that the coefficient for temperature is -0.014, which is small.
# The standard error is about 0.0163, so the t-value is approximately -0.86.
# Since the t-value is less than 2 in absolute value, the p-value is greater than 0.05.
# So there is not enough evidence to say that temperature significantly impacts WSPM at the 95% confidence level.
# Thus, temperature does not appear to have a significant effect on maximum wind speed based on this analysis.

#3) ----------------------------------------------------------------------------
# a)
# Load library
library(e1071)

# Load data
df <- read.csv("accent-mfcc-data-1.csv")

df$language <- as.factor(df$language)
set.seed(1) 

# Random sample of 280 rows for training
train_index <- sample(1:nrow(df), 280)

train <- df[train_index, ]
test  <- df[-train_index, ]

# Language is the target variable
train_y <- train$language
test_y  <- test$language

# All other variables are predictors
train_x <- train[, !(names(train) %in% "language")]
test_x  <- test[, !(names(test) %in% "language")]

# Fit SVM with radial kernel, cost = 4, scaled = TRUE
svm_model <- svm(
  x = train_x,
  y = train_y,
  kernel = "radial",
  cost = 4,
  scale = TRUE
)

svm_model

# b) 
# Predict language for remaining observations
pred <- predict(svm_model, newdata = test_x)

# Confusion matrix
conf_mat <- table(Predicted = pred, Actual = test_y)
conf_mat

# Accuracy
accuracy <- mean(pred == test_y)
accuracy

# The model achieved about 81.6% accuracy on the test set.

# 4) ---------------------------------------------------------------------------
# Load libraries
library(MASS)
library(neuralnet)

# a)
set.seed(1)   

# Load Boston dataset
data("Boston")

# Scale all variables
scaled <- as.data.frame(scale(Boston))

# Random sample of 400 observations for training
train_index <- sample(1:nrow(scaled), 400)

train <- scaled[train_index, ]
test  <- scaled[-train_index, ]

# Create formula -- medv predicted by all other variables
vars <- names(scaled)
formula_nn <- as.formula(
  paste("medv ~", paste(vars[vars != "medv"], collapse = " + "))
)

# Fit neural network (1 hidden layer with default neurons)
nn_model <- neuralnet(
  formula_nn,
  data = train,
  hidden = 5,
  linear.output = TRUE
)

# Plot the neural network
plot(nn_model)

# b) 
# Predict using the neural network
nn_pred <- compute(nn_model, test[, vars != "medv"])$net.result

# Actual values (scaled)
actual <- test$medv

# RMSE
rmse <- sqrt(mean((nn_pred - actual)^2))
rmse

# 5) ---------------------------------------------------------------------------
# Load libraries
library(tm)
library(SnowballC)
library(wordcloud)
library(cluster)
library(syuzhet)
library(RColorBrewer)

# Load Data
textdata <- read.csv("TextData.csv", stringsAsFactors = FALSE)

# correct text column
corpus <- VCorpus(VectorSource(as.character(textdata$text)))

# a) 
# Cleaning and Stemming
corpus <- tm_map(corpus, content_transformer(tolower))
corpus <- tm_map(corpus, removePunctuation)
corpus <- tm_map(corpus, removeNumbers)
corpus <- tm_map(corpus, stripWhitespace)

# Build DTM before removing stopwords
dtm <- DocumentTermMatrix(corpus)

# Remove stopwords and stem
corpus <- tm_map(corpus, removeWords, stopwords("english"))
corpus <- tm_map(corpus, stemDocument)

# Rebuild DTM after full cleaning
dtm <- DocumentTermMatrix(corpus)

# b) 
# Frequent Terms and Associations
freq_terms <- findFreqTerms(dtm, lowfreq = 10)
print(freq_terms)

if (length(freq_terms) >= 2) {
  term1 <- freq_terms[1]
  term2 <- freq_terms[2]
  
  assoc1 <- findAssocs(dtm, term1, 0.5)
  assoc2 <- findAssocs(dtm, term2, 0.5)
  
  print(assoc1)
  print(assoc2)
} else {
  print("Not enough frequent terms found.")
}

# c) 
# Word Cloud
m <- as.matrix(dtm)
freq <- colSums(m)
freq <- freq[freq > 0]

wordcloud(
  names(freq),
  freq,
  max.words = 100,
  random.order = FALSE,
  colors = brewer.pal(8, "Dark2")
)

# d) 
# Hierarchical Clustering of Terms
dtm_sparse <- removeSparseTerms(dtm, 0.95)
m2 <- as.matrix(dtm_sparse)

dist_matrix <- dist(t(m2))
hc <- hclust(dist_matrix, method = "ward.D2")

plot(hc, main = "Hierarchical Clustering of Terms")
clusters_terms <- cutree(hc, k = 5)
clusters_terms

# e) 
# K-means Clustering of Documents (K = 5)
dtm_docs <- as.matrix(dtm_sparse)

set.seed(1)
kmeans_docs <- kmeans(dtm_docs, centers = 5)

kmeans_docs$cluster

# f) 
# NRC Sentiment Analysis
sentiments <- get_nrc_sentiment(as.character(textdata$text))
sentiment_totals <- colSums(sentiments)

barplot(
  sentiment_totals,
  las = 2,
  col = rainbow(10),
  main = "NRC Sentiment Scores for All Documents"
)

