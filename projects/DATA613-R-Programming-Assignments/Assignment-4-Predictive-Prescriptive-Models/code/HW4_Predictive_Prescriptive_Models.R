#### Building Predictive Models ----------------------------------------------------
# Load the Data
# NOTE: btma.431.736.f2018.v2.rda (anonymized course scores dataset) is not redistributed here for privacy reasons.
load("../data/btma.431.736.f2018.v2.rda")

# Assign the loaded object to 'data'
data <- btma.431.736.f2018

#### Problem 1a #### 
# Fit regression using all other variables as predictors
model_1a <- lm(final.raw.score.excluding.bonus ~ final.project + post.retake.midterm + HW.average + textbook.quiz.average + BANA,
               data = data)
summary(model_1a)

# Determine coefficient for final.project
coef_final_project <- coef(model_1a)["final.project"]
round(coef_final_project, 2) # Round to 2 decimals

#### Problem 1b ####
# Scale homework (scores out of 20) to percentage
data$HW_pct <- (data$HW.average / 20) * 100

# Scale textbook quiz (scores out of 15) to percentage
data$textbook_pct <- (data$textbook.quiz.average / 15) * 100

# Refit regression with scaled predictors
model_1b <- lm(final.raw.score.excluding.bonus ~ final.project + post.retake.midterm + HW_pct + textbook_pct + BANA,
               data = data)
summary(model_1b)
# The coefficients and standard errors for both HW.average and textbook.quiz.average changed.

#### Problem 1c ####
# Test whether BANA students perform significantly differently than non-BANA students
summary_1c <- summary(model_1a)
bana_row <- "BANAYes" # Row name for BANA

# P-value for BANA coefficient
p_value_bana <- summary_1c$coefficients[bana_row, "Pr(>|t|)"]
round(p_value_bana, 2) # Round to 2 decimals
# p is greater than 0.05 so no statistically significant difference

#### Problem 1d ####
# Add interaction between post.retake.midterm and BANA
model_1d <- lm(final.raw.score.excluding.bonus ~ final.project + post.retake.midterm * BANA + HW.average + textbook.quiz.average,
               data = data)
summary_1d <- summary(model_1d)
interaction_row <- "post.retake.midterm:BANAYes" # Row name for the interaction term
p_value_interaction <- summary_1d$coefficients[interaction_row, "Pr(>|t|)"]  # P-value for interaction term
round(p_value_interaction, 2) # Round to 2 decimals
# p is greater than 0.05 so no evidence slopes differ

#### Problem 1e ####
# Remove BANA and estimate log-log model
model_log <- lm(log(final.raw.score.excluding.bonus) ~ log(final.project) + log(post.retake.midterm) + log(HW.average) + log(textbook.quiz.average),
                data = data)
summary(model_log)

# Coefficient for log(final.project)
coef_log_final_project <- coef(model_log)["log(final.project)"]
round(coef_log_final_project, 2) # Round to 2 decimals

#### Building Prescriptive Models ----------------------------------------
#### Load the dataset ####
# NOTE: salesData.rda (Farmer Jill's apple juice sales) is provided by the course; not redistributed here.
load("../data/salesData.rda") 

#### Problem 2a ####
# Function for quantity demanded based on price p
demand_2a <- function(p) {
  Q <- 50 - 5*p # Quantity demanded at price 'p' using the demand equation Q(p) = 50 - 5p
  # Revenue = price * quantity = p * Q and Cost = marginal cost * quantity = 1 * Q
  # Profit = Revenue - Cost = (p * Q) - (1 * Q) = (p - 1) * Q
  profit <- (p - 1) * Q
  return(profit)
}

# Search for optimal price between p=1 and p=9
prices <- seq(1, 9, by = 0.01)
profits <- sapply(prices, demand_2a) # Profit for each price in the sequence
optimal_index <- which.max(profits) # Index of the highest profit
optimal_price <- prices[optimal_index] # Price that gives the highest profit
optimal_profit <- profits[optimal_index] # Maximum profit 
round(optimal_price, 2)  # Optimal price to two decimals
round(optimal_profit, 2) # Profit at optimal price to two decimals

#### Problem 2b ####
# Demand function is Q(p) = 45 - 5p
demand_45 <- function(p) {
  Q <- 45 - 5*p   # How many bottles she would sell at price p
  profit <- (p - 1) * Q 
  return(profit)
}
profits_45 <- sapply(prices, demand_45) # Profit for each price in the range
optimal_price_45 <- prices[which.max(profits_45)] # Price that gives the highest profit
optimal_price_45

# Demand function is Q(p) = 55 - 5p
demand_55 <- function(p) {
  Q <- 55 - 5*p  # How many bottles she would sell at price p
  profit <- (p - 1) * Q
  return(profit)
}
profits_55 <- sapply(prices, demand_55) # Profit for each price in the range
optimal_price_55 <- prices[which.max(profits_55)] # Price that gives the highest profit
optimal_price_55

#### Problem 2c ####
# Sequence of demand maximums (M) from 40 to 60, increasing by 1
M_values <- seq(40, 60, by = 1)
# For each M, find the best price (p*) that maximizes profit
optimal_prices_M <- sapply(M_values, function(M) {
  profit <- function(p) (p - 1) * (M - 5*p) # Function to calculate profit at any price p, given M
  prices <- seq(1, 15, by = 0.01) # Prices from $1 to $15 in small steps
  profits <- sapply(prices, profit) # Profit for each price
  prices[which.max(profits)] # Price that gives the highest profit
})

# Load package
library(ggplot2) 

# Plot optimal price p* vs M
plot(M_values, optimal_prices_M, type="b", col="darkgreen",
     xlab="Maximum demand M", ylab="Optimal price p*", main="Optimal price vs Maximum demand")
# The shape of the curve tracing the optimal price as a function of M is an upward sloping line

#### Problem 2d ####
# Create a sequence of k values from 2 to 8, increasing by 0.1 
k_values <- seq(2, 8, by = 0.1)

# For M=45, find the best price p* for each k
optimal_prices_k_M45 <- sapply(k_values, function(k) {
  profit <- function(p) (p - 1) * (45 - k*p)  # profit function based on current k and M=45
  prices <- seq(1, 15, by = 0.01)   # Prices from $1 to $15
  profits <- sapply(prices, profit) # Profits for all prices
  prices[which.max(profits)] # Price that gives max profit
})

# For M=55, find the best price p* for each k
optimal_prices_k_M55 <- sapply(k_values, function(k) {
  profit <- function(p) (p - 1) * (55 - k*p) # profit function based on current k and M=55
  prices <- seq(1, 15, by = 0.01) # Prices from $1 to $15
  profits <- sapply(prices, profit) # Profits for all prices
  prices[which.max(profits)] # Price that gives max profit
})

# Create a data frame for plotting
df_k <- data.frame(
  k = rep(k_values, 2), # k values repeated twice
  optimal_price = c(optimal_prices_k_M45, optimal_prices_k_M55), # prices for both M values
  M = factor(rep(c(45, 55), each = length(k_values))) # M value labels
)

ggplot(df_k, aes(x=k, y=optimal_price, color=M)) + geom_line(size=1.2) + 
  labs(title="Optimal price vs k for different M", x="k", y="Optimal price p*") +
  scale_color_manual(values=c("red", "blue")) +
  theme_minimal()

# The k value where the optimal price is exactly $5 when M=45
# (45-k*5) + (5-1)*(-k)=0 so 45-5k-4k = 0 -> 45-9k=0 -> k=45/9=5
k_for_p5 <- 45/9  
k_for_p5 # Output the k where p* = $5 for M=45

# For M=55 and using the same k, optimal price p* = (M + k)/(2k)
optimal_price_M55 <- (55 + k_for_p5)/(2*k_for_p5)  
round(optimal_price_M55, 2) # Optimal price when M=55 to the nearest two decimal places

#### Problem 2e ####
# Function to find the best price to maximize profit based on data
find_optimal_price <- function(data) {
  # Calculate profit for each data point: (price - cost) * quantity
  data$profit <- (data$price - 1) * data$quantity
  
  # Fit quadratic regression model: profit as a function of price
  model <- lm(profit ~ poly(price, 2, raw=TRUE), data=data)
  
  # Define function to predict profit from price
  pred_profit <- function(p) {
    coef(model)[1] + coef(model)[2]*p + coef(model)[3]*p^2
  }
  
  # Search for price maximizing predicted profit
  prices <- seq(min(data$price), max(data$price), by=0.01)
  profits <- sapply(prices, pred_profit) # Predicted profits for all these prices
  prices[which.max(profits)] # Find and return the price that gives the maximum predicted profit
}

# Use the function on Jill's dataset
# Make sure 'salesData' is loaded into your R environment before this step
optimal_price_jill <- find_optimal_price(salesData)
round(optimal_price_jill, 2) # Round the price to nearest ten cents (two decimals)
