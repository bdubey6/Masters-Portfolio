# Simulation Model: Inventory Management  ----------------------------------------
# Parameters
mu <- 400.26
sigma <- 31.23
cost_per_donut <- 1.25
selling_price <- 2.00

# Function for profit
simulate_profit <- function(Q, demand_samples) {
  sales <- pmin(demand_samples, Q)
  profits <- (sales * selling_price) - (Q * cost_per_donut)
  return(profits)
}

# 1a1) Demand = 450, Stock = 420
D1 <- 450
Q1 <- 420
sales1 <- min(D1, Q1)
profit1 <- (sales1 * selling_price) - (Q1 * cost_per_donut) 
cat(sprintf("Part 1a1: Demand=450, Stock=420 -> Profit = $%.2f\n", profit1))

# 1a2) Demand = 380, Stock = 420
D2 <- 380
Q2 <- 420
sales2 <- min(D2, Q2)
profit2 <- (sales2 * selling_price) - (Q2 * cost_per_donut)
cat(sprintf("Part 1a2: Demand=380, Stock=420 -> Profit = $%.2f\n\n", profit2))

# What is your estimate for the mean of the demand distribution? 
set.seed(142)
num_simulations <- 10000
demand_samples <- rnorm(num_simulations, mean = mu, sd = sigma)
estimated_mean <- mean(demand_samples)
cat(sprintf("Estimated mean of demand: %d\n", round(estimated_mean)))

# 1b)
# What is the decision variable here (i.e., what lever is used to maximize expected profit)?
# The decision variable is the stock level Q, which is the number of donuts to stock for tomorrow. 
# Will use different levels of Q to maximize the expected profit. 
# Decision variable: stock level Q

# What part of the problem makes this a stochastic model (i.e., where does the randomness of the problem come from)?
# The problem is stochastic because the demand D for donuts is uncertain and follows a normal distribution
# With a known mean (mu) and standard deviation (sigma). 
# This randomness in demand leads to a random profit, making the problem a stochastic problem where decisions are made with uncertainty.
# Uncertainty: demand D ~ N(mu, sigma)

#1b2) What is your estimate for the standard deviation of the demand distribution?
estimated_sd <- sd(demand_samples)
cat(sprintf("Estimated SD of demand: %d\n", round(estimated_sd)))

# 1c) Expected Profit for Q = 350, 400, 450
Q_fixed <- c(350, 400, 450)
for (Q in Q_fixed) {
  profits <- simulate_profit(Q, demand_samples)
  cat(sprintf("Expected profit for Q = %d: $%.2f\n", Q, mean(profits)))
}

# Plot distribution of profits for Q = 450
profits_450 <- simulate_profit(450, demand_samples)
hist(profits_450, breaks = 50, col = "blue", main = "Distribution of Profits (Q = 450)", xlab = "Profit ($)", 
     ylab = "Frequency")
cat("The simulated profit values resemble most closely the truncated Normal distribution.\n")

# 1d) 
# Range of Q values to test
Q_range <- seq(10, 500, 10)

# Expected profit for each Q
expected_profits <- sapply(Q_range, function(Q) {
  mean(simulate_profit(Q, demand_samples))
})

# Find optimal Q
Q_optimal <- Q_range[which.max(expected_profits)]
max_profit <- max(expected_profits)

cat(sprintf("Optimal Q = %d\n", Q_optimal))
cat(sprintf("Maximum Expected Profit = $%.2f\n\n", max_profit))

# Plot expected profit vs. Q
plot(Q_range, expected_profits, type = "b", pch = 19, col = "blue", xlab = "Stocking Level Q", ylab = "Expected Profit ($)",
     main = "Expected Profit vs Stocking Level")
abline(v = Q_optimal, col = "red", lty = 2)

# 1e)
# Standard deviation of profit as Q varies
std_devs <- sapply(Q_range, function(Q) {
  sd(simulate_profit(Q, demand_samples))
})

plot(Q_range, std_devs, type = "b", pch = 19, col = "green", xlab = "Stocking Level Q", ylab = "Std Dev of Profit ($)",
     main = "Std Dev of Profit vs Stocking Level")
cat("The curve is S-shaped.\n\n")

# 1f) Probability all demand is Met
prob_demand_met <- pnorm(Q_optimal, mean = mu, sd = sigma)
cat(sprintf("Probability all demand is met at Q=%d: %.2f\n\n", Q_optimal, prob_demand_met))

# 1g) Conditional Excess Demand
stockouts <- demand_samples > Q_optimal
excess_demand <- demand_samples[stockouts] - Q_optimal
cat(sprintf("Average excess demand given stockout: %.f\n\n", ceiling(mean(excess_demand))))

# 1h Conditional Excess Supply
overstock <- demand_samples < Q_optimal
excess_supply <- Q_optimal - demand_samples[overstock]
cat(sprintf("Average excess supply given overstock: %.f\n", ceiling(mean(excess_supply))))

# Probability and Simulation Models: Inventory Management, Part II ---------------------------------
mu_hat <- mu  # Estimated mean demand 
sigma_hat <- sigma  # Estimated sd of demand

# 2a) Expected marginal cost of stocking one more donut
expected_marginal_cost <- cost_per_donut
cat(sprintf("2a: Expected marginal cost of stocking one more donut = $%.2f\n\n", expected_marginal_cost))

# 2b) Expected marginal revenue of stocking one more donut
# Set the probability that demand exceeds S* such that expected marginal revenue = marginal cost
# P(Demand > S*) = Marginal Cost / Price = 1.25 / 2.00 = 0.625
# P(Demand ≤ S*) = 1 - 0.625 = 0.375
# Calculate the optimal S* based on the demand distribution
p_d_greater_s_target <- cost_per_donut / selling_price  # 0.625
target_cdf <- 1 - p_d_greater_s_target                # 0.375

# Compute S* as the demand level at which the demand's CDF is 0.375
S_star <- round(qnorm(target_cdf, mean = mu_hat, sd = sigma_hat))

# Calculate expected marginal revenue
expected_marginal_revenue <- pnorm(S_star, mean = mu_hat, sd = sigma_hat, lower.tail = FALSE) * selling_price
cat(sprintf("E[Marginal Revenue] = (%.3f) × $2.00\n", pnorm(S_star, mean = mu_hat, sd = sigma_hat, lower.tail = FALSE)))

# 2c) Theoretically optimal stocking level S*
# Find S* as the demand level at P(Demand ≤ S*) = 0.375
S_star_theoretical <- round(qnorm(1 - p_d_greater_s_target, mean = mu_hat, sd = sigma_hat))
cat(sprintf("2c: Theoretically optimal stocking level S* = %d\n", S_star_theoretical))

# Exploratory Data Analysis: Citi Bike --------------------------------------------------------
url<-"https://s3.amazonaws.com/tripdata/202512-citibike-tripdata.zip"

temp <- tempfile()
options(timeout = 300)
download.file(url, temp)

# Unzip the zip file
zip_contents <- unzip(temp, list = TRUE)

# Loop through each .csv file in the zip contents
for (i in 1:length(zip_contents$Name)) {
  # Check if file ends with .csv
  if (grepl("\\.csv$", zip_contents$Name[i])) {
    # Read the .csv file and store it in a variable named after the file
    df <- read.csv(unz(temp, zip_contents$Name[i]), stringsAsFactors = FALSE)
    # Assign the data to the variable
    assign(gsub("\\.csv$", "", zip_contents$Name[i]), df)
  }
}

# Combine the data into one larger dataframe
citibike.trips <- rbind(`202512-citibike-tripdata_1`, `202512-citibike-tripdata_2`, `202512-citibike-tripdata_3`)

# Remove the zip file from your temporary files location
unlink(temp)

# Remove unneeded objects from the Environment
rm(df, `202512-citibike-tripdata_1`, `202512-citibike-tripdata_2`, 
   `202512-citibike-tripdata_3`)

# Ensure proper timestamps
citibike.trips$started_at <- as.POSIXct(citibike.trips$started_at) # Convert start times to POSIXc
citibike.trips$ended_at   <- as.POSIXct(citibike.trips$ended_at) # Convert end times to POSIXct

# Compute trip duration in seconds and minutes
citibike.trips$tripduration <- as.numeric(difftime(citibike.trips$ended_at, citibike.trips$started_at, units="secs")) #seconds
citibike.trips$trip_minutes <- citibike.trips$tripduration / 60  #minutes

# Remove lost/stolen bikes (trips >= 24 hours)
citibike.trips <- subset(citibike.trips, tripduration < 24*60*60)

# Identify trips that incur overage
casual_overage <- subset(citibike.trips, member_casual=="casual" & trip_minutes > 30) # Casual users with trips longer than 30 minutes
member_overage <- subset(citibike.trips, member_casual=="member" & trip_minutes > 45) # Members with trips longer than 45 minutes

# 3a: Continuous per-second overage charges
# Calculate overage charges for casual users:(tripduration in seconds - free period in seconds) * rate per second
casual_overage$charge_sec <- ceiling((casual_overage$tripduration - 30*60) * (0.26/60) * 100) / 100
# Calculate overage charges for members: (tripduration in seconds - free period in seconds) * rate per second
member_overage$charge_sec <- ceiling((member_overage$tripduration - 45*60) * (0.17/60) * 100) / 100
# Combine all overage charges into one vector for overall analysis
all_charges_sec <- c(casual_overage$charge_sec, member_overage$charge_sec)
# Average overage charge across all trips
avg_sec <- format(round(mean(all_charges_sec), 2), nsmall = 2)
cat("3a: Average overage charge (continuous per-second): $", avg_sec, "\n")

# 3b: Standard deviation of overage charges
sd_value <- sd(all_charges_sec)
sd_rounded <- round(sd_value / 0.10) * 0.10 # Rounded to nearest 10 cents
sd_formatted <- format(sd_rounded, nsmall = 2)
cat("3b: SD of overage charge (continuous per-second): $", sd_formatted, "\n")

# 3c: Total revenue under continuous policy
total_casual_sec <- sum(casual_overage$charge_sec) # Sum of all casual users overage charges
total_member_sec <- sum(member_overage$charge_sec) # Sum of all members overage charges
total_continuous <- total_casual_sec + total_member_sec 

# Round to nearest thousand
total_casual_sec_rounded <- round(total_casual_sec, -3)
total_member_sec_rounded <- round(total_member_sec, -3)
total_continuous_rounded <- round(total_continuous, -3)
cat("3c: Total revenue (continuous): Casual $", total_casual_sec_rounded,
    ", Member $", total_member_sec_rounded, ", Total $", total_continuous_rounded, "\n")

# 3d: Average overage charge per trip under current per-minute policy
casual_overage$charge_min <- ceiling(casual_overage$trip_minutes - 30) * 0.26 # For casual users
member_overage$charge_min <- ceiling(member_overage$trip_minutes - 45) * 0.17 # For members
all_charges_min <- c(casual_overage$charge_min, member_overage$charge_min) # Combine all charges
avg_min <- round(mean(all_charges_min), 1) # Average overage charge
cat("3d: Average overage charge (per-minute policy): $", avg_min, "\n") 

# 3e: Standard deviation of overage charge under current policy
sd_min  <- round(sd(all_charges_min), 1)    
cat("3e: SD of overage charge (per-minute policy): $", sd_min, "\n")

# 3f: Expected overage charge by user type (conditional on overage)
mean_casual <- round(mean(casual_overage$charge_min), 1) # For casual users
mean_member <- round(mean(member_overage$charge_min), 1) # For members
cat("3f: Expected overage charge: Casual $", mean_casual, ", Member $", mean_member, "\n")

# 3g: Total overage revenue under current per-minute policy
total_casual_min <- sum(casual_overage$charge_min) # Sum of overage charges for casual users
total_member_min <- sum(member_overage$charge_min) # Sum of overage charges for members
total_current_policy <- total_casual_min + total_member_min
total_current_policy_rounded <- round(total_current_policy, -3) # Round to nearest thousand
cat("3g: Total revenue (per-minute policy): $", total_current_policy_rounded, "\n")

# Recommendation
if(total_current_policy > total_continuous) {
  cat("Recommendation: Stick with current per-minute pricing policy for higher revenue.\n")
} else {
  cat("Recommendation: Continuous per-second pricing policy would generate more revenue.\n")
}

# Probability and Simulation Models: Lottery Game ------------------------------------------------
#4a:
# Parameters
total_tickets <- 20e9  # 20 billion tickets
your_tickets <- 10000  # Your 10,000 tickets
draws_per_week <- 7*24*60*60/3  # Number of draws in a week (201,600)

p_win <- your_tickets / total_tickets # Probability of winning in a single draw
p_no_win <- 1 - p_win # Probability of no win in a single draw
p_no_wins_in_week <- p_no_win^draws_per_week # Probability of no wins in a week (201,600 draws)
p_at_least_one_win <- 1 - p_no_wins_in_week # Probability of at least one win in a week

# Output rounded to 2 decimal places
round(p_no_wins_in_week, 2)  # Probability of no wins
round(p_at_least_one_win, 2)  # Probability of at least one win

# 4b)
target_prob <- 0.80 # Target probability for at least one win

# Minimum number of tickets needed to reach target probability
find_tickets <- function(target_prob, total_tickets, draws_per_week) {
  calc_prob <- function(n) {
    1 - (1 - n / total_tickets) ^ draws_per_week}
  # Search in steps of 100 tickets from 100 to total_tickets
  for (tickets in seq(100, total_tickets, by = 100)) {
    if (calc_prob(tickets) >= target_prob) {
      return(tickets)}
  }
}

# Required number of tickets
required_tickets <- find_tickets(target_prob, total_tickets, draws_per_week)
round(required_tickets, -4)  # Round to the nearest ten thousand

#4c)
prize <- 250  # Prize for winning a single raffle
draws_per_year <- 365*24*60*60/3  # Number of draws in a year
expected_wins <- p_win * draws_per_year # Expected number of wins in a year
expected_winnings <- expected_wins * prize # Expected winnings
round(expected_winnings, -2)  # Round to the nearest hundred dollars

# 4d)
total_tickets <- 20e9  # 20 billion tickets
prize <- 250  # Prize for winning a single raffle
draws_per_year <- 365 * 24 * 60 * 60 / 3  # Number of draws in a year (10,512,000)

# Expected winnings for a given number of tickets
expected_winnings <- function(tickets, total_tickets, draws_per_year, prize) {
  p_win <- tickets / total_tickets  # Probability of winning in a single draw
  expected_wins <- p_win * draws_per_year  # Expected wins in a year
  return(expected_wins * prize)  # Expected winnings
}

ticket_range <- 10^(2:7)  # Ticket range from 100 to 10,000,000 in log scale
expected_rewards <- sapply(ticket_range, function(tickets) expected_winnings(tickets, total_tickets, draws_per_year, prize)) #expected rewards for each number of tickets

# Plot expected winnings vs. number of tickets 
plot(ticket_range, expected_rewards, log="x", type="l", col="blue", lwd=2,
     xlab="Number of Tickets", ylab="Expected Winnings ($)", main="Expected Yearly Winnings vs. Number of Tickets")
grid()

winnings_100k <- expected_winnings(100000, total_tickets, draws_per_year, prize) # Expected winnings for a friend with 100,000 tickets
winnings_1M <- expected_winnings(1000000, total_tickets, draws_per_year, prize) # Expected winnings for a friend with 1,000,000 tickets

# Round to the nearest thousand dollars
round(winnings_100k, -3)
round(winnings_1M, -3)

#4e)
# Function to simulate waiting time (in days) between wins
simulate_waiting_time <- function(tickets, total_tickets, num_simulations = 10000) {
  p_win <- tickets / total_tickets
  waiting_times <- numeric(num_simulations)
  for (i in 1:num_simulations) {
    num_draws <- ceiling(1 / p_win) # Expected number of draws until first win
    waiting_times[i] <- num_draws * 3  # Each draw is 3 seconds
  }
  waiting_times_days <- waiting_times / (60*60*24)       # Convert seconds to days
  return(mean(waiting_times_days))  # Return average waiting time in days
}

waiting_time_100k <- simulate_waiting_time(100000, total_tickets)  # Average days between wins for 100,000 tickets
waiting_time_1M <- simulate_waiting_time(1000000, total_tickets) # Average days between wins for 1,000,000 tickets

# Round to the nearest whole number
round(waiting_time_100k)
round(waiting_time_1M)

