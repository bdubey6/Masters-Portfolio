# Load the dataset (run from this assignment's code/ folder)
load("../data/HW1_data.RData")

# Load package for data analysis (https://dplyr.tidyverse.org/reference/mutate.html)
library(dplyr)

# Convert the 'Date' columns in all datasets from character/other formats to Date type. 
bitcoin.data$Date <- as.Date(bitcoin.data$Date)
BNB.data$Date <- as.Date(BNB.data$Date)
ethereum.data$Date <- as.Date(ethereum.data$Date)
ripple.data$Date <- as.Date(ripple.data$Date)
dogecoin.data$Date <- as.Date(dogecoin.data$Date)
solana.data$Date <- as.Date(solana.data$Date)
cardano.data$Date <- as.Date(cardano.data$Date)

# Rename the 'Price' column in each dataset to the name of the cryptocurrency. 
colnames(bitcoin.data)[which(colnames(bitcoin.data) == "Price")] <- "BTC"
colnames(BNB.data)[which(colnames(BNB.data) == "Price")] <- "BNB"
colnames(ethereum.data)[which(colnames(ethereum.data) == "Price")] <- "ETH"
colnames(ripple.data)[which(colnames(ripple.data) == "Price")] <- "XRP"
colnames(dogecoin.data)[which(colnames(dogecoin.data) == "Price")] <- "DOGE"
colnames(solana.data)[which(colnames(solana.data) == "Price")] <- "SOL"
colnames(cardano.data)[which(colnames(cardano.data) == "Price")] <- "ADA"

# Merge all individual cryptocurrency datasets into one big dataset.The join is done on the 'Date' column, so all data aligns by date.
full_data <- bitcoin.data %>%
  full_join(BNB.data, by = "Date") %>%
  full_join(ethereum.data, by = "Date") %>%
  full_join(ripple.data, by = "Date") %>%
  full_join(dogecoin.data, by = "Date") %>%
  full_join(solana.data, by = "Date") %>%
  full_join(cardano.data, by = "Date") %>%
  arrange(Date)  # Data is sorted chronologically

# Define the start and end dates for the analysis (period from January 17, 2025, to January 16, 2026)
start_date <- as.Date("2025-01-17")
end_date <- as.Date("2026-01-16")

# Extract the prices of all cryptocurrencies at the start date.
price_start <- full_data %>% filter(Date == start_date)

# Extract the prices of all cryptocurrencies at the end date.
price_end <- full_data %>% filter(Date == end_date)

# Question 1 ------------------------------------------------------------------
# 1a. Calculate the long-run ROI for each crypto?
# ROI is the percentage increase from January 17, 2025 to January 16, 2026.
roi_values <- (as.numeric(price_end[1, c("BTC","ETH","BNB","SOL","XRP","ADA","DOGE")]) - 
                 as.numeric(price_start[1, c("BTC","ETH","BNB","SOL","XRP","ADA","DOGE")])) /
  as.numeric(price_start[1, c("BTC","ETH","BNB","SOL","XRP","ADA","DOGE")])

# Maximum ROI among all cryptocurrencies.
max_roi <- max(roi_values)

# Convert it to a percentage and round to the nearest whole number.
max_roi_percent <- round(max_roi * 100)
cat("1a. The highest long-run ROI amoung these cryptocurrencies is:", max_roi_percent, "%\n")

# 1b. Which crypto had the highest mean daily return?
# Calculate daily returns for each crypto. Daily return is calculated as (today's price / yesterday's price) - 1. 
daily_returns <- full_data %>%
  arrange(Date) %>%
  mutate(
    BTC = BTC / lag(BTC) - 1,
    ETH = ETH / lag(ETH) - 1,
    BNB = BNB / lag(BNB) - 1,
    XRP = XRP / lag(XRP) - 1,
    DOGE = DOGE / lag(DOGE) - 1,
    SOL = SOL / lag(SOL) - 1,
    ADA = ADA / lag(ADA) - 1
  )

# Calculate the average daily return for each crypto.
mean_returns <- colMeans(daily_returns[,c("BTC","ETH","BNB","XRP","DOGE","SOL","ADA")], na.rm=TRUE)

# Convert to percentage and round.
mean_percent <- round(mean_returns * 100, 2)

# Find the crypto with the highest average daily return.
best_crypto <- names(which.max(mean_percent))
best_value <- max(mean_percent)
cat("1b. The crypto with the highest average daily return is", best_crypto, "with", best_value, "%\n")

# 1c.  Which crypto has the lowest standard deviation of its daily return?
# Standard deviation of daily returns measures the volatility.
sd_returns <- apply(daily_returns[,c("BTC","ETH","BNB","XRP","DOGE","SOL","ADA")], 2, sd, na.rm=TRUE)
sd_percent <- round(sd_returns * 100, 2)
least_volatile_crypto <- names(which.min(sd_percent))
least_sd <- min(sd_percent)
cat("1c. The least volatile crypto is", least_volatile_crypto, "with SD of", least_sd, "%\n")


#  Question 2 ------------------------------------------------------------------
# 2a. How much is each portfolio is worth? 
# Find the number of units bought with the initial investment using the initial prices
init_BTC <- as.numeric(price_start$BTC)
init_ETH <- as.numeric(price_start$ETH)
init_BNB <- as.numeric(price_start$BNB)
init_SOL <- as.numeric(price_start$SOL)
init_XRP <- as.numeric(price_start$XRP)
init_ADA <- as.numeric(price_start$ADA)
init_DOGE <- as.numeric(price_start$DOGE)

# Calculate how much each crypto were bought at the start
hold_BTC <- 5000 / init_BTC
hold_ETH <- 2500 / init_ETH
hold_BNB <- 2500 / init_BNB
hold_SOL <- 1250 / init_SOL
hold_XRP <- 1250 / init_XRP
hold_ADA <- 1250 / init_ADA
hold_DOGE <- 1250 / init_DOGE

# Create portfolio columns in combined 'full_data' for each day 
full_data <- full_data %>%
  mutate(
    Port1 = hold_BTC * BTC,
    Port2 = hold_ETH * ETH + hold_BNB * BNB,
    Port3 = hold_SOL * SOL + hold_XRP * XRP + hold_ADA * ADA + hold_DOGE * DOGE
  )

# Filter the dataset to get the row corresponding to the end date (January 16, 2026)
final_row <- full_data %>% filter(Date == end_date)

# Get the portfolio values for each portfolio on the end date
port1_end_value <- final_row$Port1
port2_end_value <- final_row$Port2
port3_end_value <- final_row$Port3

# Round to nearest hundred dollars
port1_end_value <- round(port1_end_value / 100) * 100
port2_end_value <- round(port2_end_value / 100) * 100
port3_end_value <- round(port3_end_value / 100) * 100

# Print out the rounded worth for each portfolio on end date.
cat("2a. Portfolio 1 is worth approximately: $", port1_end_value, "\n")
cat("2a. Portfolio 2 is worth approximately: $", port2_end_value, "\n")
cat("2a. Portfolio 3 is worth approximately: $", port3_end_value, "\n")

# 2b. Create columns for each day's portfolio value which lets us see how the portfolios performed over time
full_data <- full_data %>%
  mutate(
    Port1 = hold_BTC * BTC,
    Port2 = hold_ETH * ETH + hold_BNB * BNB,
    Port3 = hold_SOL * SOL + hold_XRP * XRP + hold_ADA * ADA + hold_DOGE * DOGE
  )

# Maximum value each portfolio reached 
max_P1 <- max(full_data$Port1, na.rm=TRUE)
max_P2 <- max(full_data$Port2, na.rm=TRUE)
max_P3 <- max(full_data$Port3, na.rm=TRUE)

# Round to the nearest hundred dollars
max_P1 <- round(max_P1 / 100) * 100
max_P2 <- round(max_P2 / 100) * 100
max_P3 <- round(max_P3 / 100) * 100

# Print maximum values
cat("2b. Max value Portfolio 1 reached:", max_P1, "\n")
cat("2b. Max value Portfolio 2 reached:", max_P2, "\n")
cat("2b. Max value Portfolio 3 reached:", max_P3, "\n")

# 2c. Find which portfolio had the largest maximum value
if(max_P1 > max_P2 & max_P1 > max_P3){
  cat("Portfolio 1 had the highest value during this period.\n")
} else if(max_P2 > max_P1 & max_P2 > max_P3){
  cat("Portfolio 2 had the highest value during this period.\n")
} else {
  cat("Portfolio 3 had the highest value during this period.\n")
}

# Plot the value of each portfolio over time (https://chatgpt.com/share/69746b5b-50ec-800f-9dd5-41541a303fe7)
par(mfrow=c(3,1)) 
plot(full_data$Date, full_data$Port1, type='l', col='blue', main='Portfolio 1')
plot(full_data$Date, full_data$Port2, type='l', col='red', main='Portfolio 2')
plot(full_data$Date, full_data$Port3, type='l', col='green', main='Portfolio 3')
par(mfrow=c(1,1))  # Reset layot to single plot


# Find the date when each portfolio reached highest value
max_P1_date <- full_data$Date[which.max(full_data$Port1)]
max_P2_date <- full_data$Date[which.max(full_data$Port2)]
max_P3_date <- full_data$Date[which.max(full_data$Port3)]

# Print the dates
cat("2c. Portfolio 1 reached its peak in:", format(max_P1_date, "%B %Y"), "\n")
cat("2c. Portfolio 2 reached its peak in:", format(max_P2_date, "%B %Y"), "\n")
cat("2c. Portfolio 3 reached its peak in:", format(max_P3_date, "%B %Y"), "\n")

# 2d. Calculate how correlated the daily percent changes of the portfolios are with Bitcoin.
# Calculate daily percentage change for each portfolio and Bitcoin.
daily_pct <- full_data %>%
  arrange(Date) %>%
  mutate(
    Pct_Port1 = Port1 / lag(Port1) - 1,
    Pct_Port2 = Port2 / lag(Port2) - 1,
    Pct_Port3 = Port3 / lag(Port3) - 1,
    Pct_BTC = BTC / lag(BTC) - 1
  ) %>%
  slice(-1)  # Remove the first row with NA

# Calculate the correlation between each portfolio and Bitcoin's daily change.
corr_port2_btc <- round(cor(daily_pct$Pct_Port2, daily_pct$Pct_BTC, use="complete.obs"), 2)
corr_port3_btc <- round(cor(daily_pct$Pct_Port3, daily_pct$Pct_BTC, use="complete.obs"), 2)

# Print the correlation values.
cat("2d. Correlation between Portfolio 2 and Bitcoin:", corr_port2_btc, "\n")
cat("2d. Correlation between Portfolio 3 and Bitcoin:", corr_port3_btc, "\n")

# Plot scatterplots to visually see the relationship.
plot(daily_pct$Pct_BTC, daily_pct$Pct_Port2,
     xlab="Bitcoin Daily % Change", ylab="Portfolio 2 Daily % Change",
     main="Portfolio 2 vs Bitcoin")
abline(lm(daily_pct$Pct_Port2 ~ daily_pct$Pct_BTC), col='red')

plot(daily_pct$Pct_BTC, daily_pct$Pct_Port3,
     xlab="Bitcoin Daily % Change", ylab="Portfolio 3 Daily % Change",
     main="Portfolio 3 vs Bitcoin")
abline(lm(daily_pct$Pct_Port3 ~ daily_pct$Pct_BTC), col='red')

# 2e. Find the worst drop from all-time high for each portfolio.
# Look at the highest value and see how much it drops below that.
n <- nrow(full_data)
drop_P1 <- numeric(n)
drop_P2 <- numeric(n)
drop_P3 <- numeric(n)

# Initialize maximum values for each portfolio to very low numbers
max_P1 <- -Inf
max_P2 <- -Inf
max_P3 <- -Inf

for(i in 1:n){
  # Update maximum value for each portfolio
  if(full_data$Port1[i] > max_P1) max_P1 <- full_data$Port1[i]
  if(full_data$Port2[i] > max_P2) max_P2 <- full_data$Port2[i]
  if(full_data$Port3[i] > max_P3) max_P3 <- full_data$Port3[i]
  
  # Calculate how far each current value is below the maximum - drop from ATH
  drop_P1[i] <- ifelse(max_P1 == 0, 0, (max_P1 - full_data$Port1[i]) / max_P1)
  drop_P2[i] <- ifelse(max_P2 == 0, 0, (max_P2 - full_data$Port2[i]) / max_P2)
  drop_P3[i] <- ifelse(max_P3 == 0, 0, (max_P3 - full_data$Port3[i]) / max_P3)
}

# Find the maximum drop for each portfolio.
worst_P1 <- round(max(drop_P1) * 100, 2)
worst_P2 <- round(max(drop_P2) * 100, 2)
worst_P3 <- round(max(drop_P3) * 100, 2)

# Print the worst drops for each portfolio
cat("2e. Worst drop from ATH for Portfolio 1:", worst_P1, "%\n")
cat("2e. Worst drop from ATH for Portfolio 2:", worst_P2, "%\n")
cat("2e. Worst drop from ATH for Portfolio 3:", worst_P3, "%\n")

# Question 3 ------------------------------------------------------------------
# Buying $1 a day of Dogecoin since January 17, 2025 all the way up to January 16, 2026
# Filter data for the period
doge_period <- full_data %>%
  filter(Date >= start_date & Date <= end_date)

# Calculate how many Dogecoin bought each day with $1.
doge_period <- doge_period %>%
  mutate(Doge_bought = 1 / DOGE)

# Sum all Dogecoin bought over the period to know total Dogecoin holding
total_doge <- sum(doge_period$Doge_bought, na.rm=TRUE)

# Find the Dogecoin price on the last day
final_doge_price <- tail(doge_period$DOGE, 1)

# Calculate the total value of all Dogecoin holdings at the end
total_value_doge <- round(total_doge * final_doge_price)

# Print the total Dogecoin bought and its value on the last date.
cat("So if I had bought $1 worth of Dogecoin each day, I would have", total_doge, "Dogecoin.\n")
cat("That would be worth approximately $", total_value_doge, " on Jan 16, 2026.\n")
