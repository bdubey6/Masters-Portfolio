# Working directory to where the data is stored on my computer
# Set your working directory to the folder containing the data files below
# setwd("path/to/data")

# Load datasets
load("../data/HW2Q5_v1.rda")
load("../data/HW2Q5_v2.rda")
load("../data/HW2Q5_v3.rda")
load("../data/HW2Q5_v4.rda")
load("../data/exam_scores1.rda")
load("../data/exam_scores2.rda")
load("../data/exam_scores3.rda")
load("../data/exam_scores4.rda")
load("../data/exam_scores5.rda")

# Midterm Retake Policy Function ------------------------------------------------------------------
# Question 1
# S: initial score or pre-retake score
# R: highest retake score
# P and B: policy parameters
# Function looking at initial score (S), retake attempts (R), and policy parameter (P and B) to find final score.
post_retake_score <- function(S, R, P, B) {
  if (S < P) { # For students below P then maximum is P+B, otherwise, use highest retake score. 
    if (R >= P + B) {
      return(P + B)   
    } else {
      return(R)       
    }
  } else { # For students at or above P then maximum is S+B, otherwise, use highest retake score. 
    if (R >= S + B) {
      return(S + B)   
    } else {
      return(R)       
    }
  }
}

# S=21, R=50, P=30, B=30
Q1_score <- post_retake_score(21, 50, 30, 30)
cat("Q1: Final score when initial=21, R=50:", Q1_score, "\n")  

# Question 2: S=21, R=60, P=30, B=30 
Q2_score <- post_retake_score(21, 60, 30, 30)
cat("Q2: Final score when initial=21, R=60:", Q2_score, "\n") 

# Question 3: S=21, R=70, P=30, B=30 
Q3_score <- post_retake_score(21, 70, 30, 30)
cat("Q3: Final score when initial=21, R=70:", Q3_score, "\n")  

# Question 4: S=21, P=30, B=30
# Maximum possible score function for students at or above P then maximum is S+B, and for students below P then maximum is P+B. 
highest_possible_score <- function(S, P, B) {
  if (S >= P) {
    return(S + B)
  } else {
    return(P + B)}
}

max_score <- highest_possible_score(21, 30, 30)
cat("Q4: Highest possible score for initial=21:", max_score, "\n") 

# Question 5: S=54, R=67, P=22, B=30
Q5_score <- post_retake_score(54, 67, 22, 30)
cat("Q5: Final score when R=67:", Q5_score, "\n") 

# Question 6: S=54, R=78, P=22, B=30
Q6_score <- post_retake_score(54, 78, 22, 30)
cat("Q6: Final score when R=78:", Q6_score, "\n")  

# Question 7: S=54, R=89, P=22, B=30
Q7_score <- post_retake_score(54, 89, 22, 30)
cat("Q7: Final score when R=89:", Q7_score, "\n") 

# Question 8: S=54, P=22, B=30
Q8_score <- highest_possible_score(54, 22, 30)
cat("Q8: Highest possible score for initial=54:", Q8_score, "\n")  

# Question 9: S=22, P=30, B=30
Q9_score <- highest_possible_score(22, 30, 30)
cat("Q9: Highest possible score for initial=22:", Q9_score, "\n")  

# Question 10: S=86, P=30, B=30
Q10_score <- highest_possible_score(86, 30, 30)
cat("Q10: Highest possible score for initial=86:", Q10_score, "\n")

# Building the Midterm Retake Policy Function  ------------------------------------------------------------------
# Part 1
find_P_B <- function(pre_scores) {
  pre_sd <- sd(pre_scores)   # Standard deviation of pre scores
  max_score <- max(pre_scores)   # Max pre score
  max_range <- max_score + 30  # Extend the range for candidate P and B

  # P and B values - positive multiples of 2
  P_candidates <- seq(2, max_range, by=2) 
  B_candidates <- seq(2, max_range, by=2)
  results <- data.frame(P=double(), B=double(), mean_score=double(), sd_score=double(), stringsAsFactors=FALSE) # Data frame to store results
  
  # Loop - P and B values
  for (P in P_candidates) {
    for (B in B_candidates) {
      if (P + B >= 60) {
        # Compute max possible scores for each student
        max_scores <- sapply(pre_scores, function(S) {
          if (S >= P) {
            min(S + B, 100)  # cap at 100
          } else {
            min(P + B, 100)}})
        avg_score <- mean(max_scores)
        sd_score <- sd(max_scores)
        results <- rbind(results, data.frame(P=P, B=B, mean_score=avg_score, sd_score=sd_score))}}}
  
  candidates <- results[results$mean_score > 70 & results$mean_score < 75,]  # Filter for mean in (70,75)
  
  if (nrow(candidates) > 0) {
    candidates$sd_diff <- abs(candidates$sd_score - pre_sd) # Use SD comparison: closest to pre_scores SD
    best_idx <- which.min(candidates$sd_diff) # Tie-break: smallest B
    best <- candidates[best_idx,]
    return(list(P=best$P, B=best$B))
  } else {
    # No candidates in (70,75), try to find closest to 75 from below or above
    candidates_above <- results[results$mean_score >= 75,]
    if (nrow(candidates_above) > 0) {
      candidates_above$diff <- abs(candidates_above$mean_score - 75) # pick the one closest to 75
      best_idx <- which.min(candidates_above$diff)
      best <- candidates_above[best_idx,]
      return(list(P=best$P, B=best$B))
    } else {       # else pick the highest mean score
      best_idx <- which.max(results$mean_score)
      best <- results[best_idx,]
      return(list(P=best$P, B=best$B))}}}

# Dataset 1
cat("\n exam_scores1:\n")
result1 <- find_P_B(exam_scores1)
cat("Optimal P:", result1$P, "Optimal B:", result1$B, "\n")

# Dataset 2
cat("\n exam_scores2:\n")
result2 <- find_P_B(exam_scores2)
cat("Optimal P:", result2$P, "Optimal B:", result2$B, "\n")

# Dataset 3
cat("\n exam_scores3:\n")
result3 <- find_P_B(exam_scores3)
cat("Optimal P:", result3$P, "Optimal B:", result3$B, "\n")

# Dataset 4
cat("\n exam_scores4:\n")
result4 <- find_P_B(exam_scores4)
cat("Optimal P:", result4$P, "Optimal B:", result4$B, "\n")

# Dataset 5
cat("\n exam_scores5:\n")
result5 <- find_P_B(exam_scores5)
cat("Optimal P:", result5$P, "Optimal B:", result5$B, "\n")

# Part 2 
# Main function to determine the optimal values of P and B
find_P_B <- function(pre_scores) {
  candidate_values <- seq(20, 200, by = 20)   # Candidate values for P and B - multiples of 20 from 20 to 200
  results <- data.frame(P = integer(), B = integer(), mean_score = numeric(), stringsAsFactors = FALSE)   # Empty data frame to store all P,B pairs along with their average scores
  
  # Loop through all possible pairs of P and B
  for (P in candidate_values) {
    for (B in candidate_values) {
      # Sum of P and B meets the minimum condition of at least 40
      if (P + B >= 40) {
        # For each student's pre-retake score, determine the maximum possible score after retake
        max_scores <- sapply(pre_scores, function(S) {
          if (S >= P) {
            # Student already meets/exceeds the passing score P, so max score is S plus B (maximum at 100)
            min(S + B, 100)
          } else {
            # Student below P, so max score is P plus B (maximum at 100)
            min(P + B, 100)}})
        # Check if all calculated max scores are within the valid range (<= 100)
        if (all(max_scores <= 100)) {
          # Calculate the average of these maximum scores for the current (P, B) pair
          mean_score <- mean(max_scores)
          results <- rbind(results, data.frame(P = P, B = B, mean_score = mean_score))}}}} # Store the results (P, B, and the average score)
  
  # Look for pairs where the mean score is between 70 and 75
  candidates <- results[results$mean_score > 70 & results$mean_score < 75, ]
  if (nrow(candidates) > 0) {
    candidates <- candidates[order(-candidates$P, candidates$B), ]
    # Return the top candidate
    return(list(P = candidates$P[1], B = candidates$B[1]))}
  
  # If no pairs found between 70 and 75 find the pair with mean score closest to 75 
  results$diff <- abs(results$mean_score - 75)
  # Order by the absolute difference (closest to 75), then largest P, then smallest B
  candidates <- results[order(results$diff, -results$P, results$B), ]
  return(list(P = candidates$P[1], B = candidates$B[1]))}   # Return the top candidate

# Apply the function to the datasets
datasets <- list(exam_scores1, exam_scores2, exam_scores3, exam_scores4, exam_scores5)
dataset_names <- c("exam_scores1", "exam_scores2", "exam_scores3", "exam_scores4", "exam_scores5")

# Dataset 1
cat("Results for dataset 1:\n")
res1 <- find_P_B(exam_scores1)
cat("Selected P =", res1$P, "and B =", res1$B, "\n\n")

# Dataset 2
cat("Results for dataset 2:\n")
res2 <- find_P_B(exam_scores2)
cat("Selected P =", res2$P, "and B =", res2$B, "\n\n")

# Dataset 3
cat("Results for dataset 3:\n")
res3 <- find_P_B(exam_scores3)
cat("Selected P =", res3$P, "and B =", res3$B, "\n\n")

# Dataset 4
cat("Results for dataset 4:\n")
res4 <- find_P_B(exam_scores4)
cat("Selected P =", res4$P, "and B =", res4$B, "\n\n")

# Dataset 5
cat("Results for dataset 5:\n")
res5 <- find_P_B(exam_scores5)
cat("Selected P =", res5$P, "and B =", res5$B, "\n")

# 2. Random Student Selector ------------------------------------------------------------------
# Define the function to randomly select N students from a CSV file
select_random_students <- function(N, filename) {
  class_roster <- read.csv(filename, stringsAsFactors=FALSE)   # Read CSV file containing student roster
  print(names(class_roster))   # Check column names to confirm names ("Last.Name" and "First.Name")
  
  # Create random indices without replacement
  indices <- sample(1:nrow(class_roster), size=N, replace=FALSE)
  
  # Create their full names using the correct column names
  selected_names <- paste(class_roster$`First.Name`[indices], class_roster$`Last.Name`[indices])
  return(selected_names)   # Return the selected student names
}

# Example: Call the function with the specific file and number of students
N <- 4 # Replace N (number of students)
file_path <- "C:/Users/bhuva/Downloads/DATA 613/HW2/DATA 613 L01 - (Winter 2026).csv" # Replace file 
selected_students <- select_random_students(N, file_path) # Call function
print(selected_students) # print the students

# 2.1) How many arguments does your Random Student Selector function have?
# Two Arguments: N (the number of students) and filename (path of CSV file containing the student roster)

# 2.2) Could an instructor of BTMA 601 use your function to randomly select three BTMA 601 students? 
# Yes, the function can be used for any class, so the teacher can randomly select three BTMA 601 students. 

# 2.3) Could an instructor of MGST 217 use your function to randomly select four MGST 217 students?
# Yes, the function can be used for any class, so the instructor can randomly select four MGST 217 student. 

# 2.4) If I asked you to randomly select five students from this class, is there a chance that you would be selected?
# Yes, if I pick five students, there's always a chance they I will be chosen.

# 2.5) Assuming no two students have the same name, could the output of your function ever print the same student twice when running your function once?
# No, this function samples without replacement (replace=FALSE) so it will not be able to select the same student twice when running your function once.

# 3. Training and Testing  ------------------------------------------------------------------
# Splits the data into training and testing parts based on proportion (p) of data to be used for training (0 < p < 1)
# Returns both as a list with two dataframes: 'train' and 'test'
split_data <- function(df, p) {
  # Check that p is between 0 and 1
  if (p <= 0 || p >= 1) {
    stop("p must be between 0 and 1.")}
  
  # Get total number of rows in the dataframe
  n <- nrow(df)
  
  # Determine number of rows for training dataset
  train_size <- round(n * p)
  
  # Randomly sample indices for training dataset
  train_indices <- sample(1:n, size = train_size, replace = FALSE)
  
  # Create training dataset using the sampled indices
  train_df <- df[train_indices, ]
  
  # Create testing dataset with remaining rows
  test_df <- df[-train_indices, ]
  return(list(training = train_df, testing = test_df))}   # Return a list containing both datasets

# 3.1) If your input dataframe has 500 rows and your input p was p = 1/3 , then how many rows would your testing dataset have?
n <- 500
p <- 1/3
df <- data.frame(ID = 1:n, Value = rnorm(n)) # Create a sample dataframe with 500 rows
split_result <- split_data(df, p) # Split the data
train_data <- split_result$training
test_data <- split_result$testing
cat("Training set rows:", nrow(train_data), "\n")
cat("Testing set rows:", nrow(test_data), "\n")
# The testing set has 333 rows

# 3.2) Your function has two datasets (the training and testing datasets) as outputs.
# True, the function returns both the training set and the testing set as outputs, so you get two separate dataframes.

# 3.3) The sum of the number of rows in the training dataset and testing dataset equals the number of rows of the original dataset.
# True, when you split the data, all original rows are assigned either to training or testing. So, if you add up the rows from both, you'll get back the total number of rows in the original dataset.

# 3.4) There can be rows from the original dataset that appear in both the training and testing datasets when you call your function once.
# False, each row from the original data is only put into either the training or the testing set. No row shows up in both.

# 3.5) The number of columns in the testing dataset matches the number of columns in the original dataset (the one the user inputs).
# True both datasets have the same columns as the original dataset. So, the testing dataset will have the same number of columns as your original data frame.

# 4. Random Team Builder ------------------------------------------------------------------
# Function to create valid teams of 4 or 5 students
create_teams <- function(roster) {
  if (nrow(roster) < 12)   # Check if roster has at least 12 students
  {stop("The roster must have at least 12 students.")}
  total_students <- nrow(roster)
  
  # Generate all possible combinations of team counts of 4 and 5 that sum to total number of student
  possible_combinations <- list()
  for (num_teams_of_4 in 0:(total_students %/% 4)) {
    remaining <- total_students - num_teams_of_4 * 4
    if (remaining %% 5 == 0) {
      num_teams_of_5 <- remaining %/% 5
      # Only consider combinations where at least one team of 4 or 5 exists
      if (num_teams_of_4 + num_teams_of_5 > 0) {
        possible_combinations[[length(possible_combinations) + 1]] <- list(
          fours = num_teams_of_4,
          fives = num_teams_of_5)}}}
  
  # If no valid combinations, return error
  if (length(possible_combinations) == 0) {
    stop("Cannot partition the students into teams of 4 and 5.")}
  
  selected <- sample(possible_combinations, 1)[[1]]   # Select 1 combination in random manner
  shuffled <- roster[sample(nrow(roster)), ]   # Shuffle students 
  teams <- list()   # Initialize list to hold teams
  start_idx <- 1   # Starting index for slicing students
  
  # Create teams of 4
  if (selected$fours > 0) {
    for (i in 1:selected$fours) {
      end_idx <- start_idx + 3
      teams[[length(teams) + 1]] <- shuffled[start_idx:end_idx, ]  # Assign a slice of 4 students to a team
      start_idx <- end_idx + 1}}    # Update starting index for next team
  
  # Create teams of 5
  if (selected$fives > 0) {
    for (i in 1:selected$fives) {
      end_idx <- start_idx + 4
      teams[[length(teams) + 1]] <- shuffled[start_idx:end_idx, ]   # Assign a slice of 5 students to a team
      start_idx <- end_idx + 1}}   # Update starting index for next team
  return(teams)}

# Create sample roster
students <- data.frame(
  LastName = paste("Last", 1:15),
  FirstName = paste("First", 1:15))

teams <- create_teams(students) # Generate teams

# Print teams
for (i in seq_along(teams)) {
  cat(sprintf("Team %d:\n", i))
  print(teams[[i]])
  cat("\n")}

# check that every student has been assigned exactly once 
assigned_students <- do.call(rbind, teams)
print(nrow(unique(assigned_students)) == nrow(students)) 
# True

# 4.1) Would your function work on any class roster with at least twelve students?
# Yes, the function can work any class roster with at least twelve students.

# 4.2) If I used your function on a class of at least twelve, would it be possible that some student is not on a team?
# No, every student will be assigned to one team, so no student will be left out.

# 4.3) If I used your function on a class of at least twelve, would it be possible that some student is on more than one team?
# No, the function makes sure no student is placed in more than one team.

# 4.4) If I used your function on a class of at least twelve, would it be possible for a student to be on a team of fewer than four or more than five students total?
# No, all teams will have either four/five students, so there won’t be any teams that are too small or too big.

# 5. Let’s Play a Game ------------------------------------------------------------------
# Question 5a: Expected loss if you were to choose 25
N <- 100000  # Number of simulations
choice_25 <- 25
random_draws <- sample(c(7, 77, 777), size = N, replace = TRUE)
losses_25 <- (random_draws - choice_25)^2
expected_loss_25 <- mean(losses_25)
cat("Expected loss if choosing 25:", round(expected_loss_25 / 5000) * 5000, "\n\n") # Round to nearest five thousand dollars

# Question 5b: Expected loss if you choose 115
choice_115 <- 115
losses_115 <- (random_draws - choice_115)^2
expected_loss_115 <- mean(losses_115)
cat("Expected loss if choosing 115:", round(expected_loss_115 / 5000) * 5000, "\n\n") # Round to nearest five thousand dollars


# Question 5c: Expected loss if you choose 510
choice_510 <- 510
losses_510 <- (random_draws - choice_510)^2
expected_loss_510 <- mean(losses_510)
cat("Expected loss if choosing 510:", round(expected_loss_510 / 5000) * 5000, "\n\n") # Round to nearest five thousand dollars


# Question 5d: Number between 7 and 777 that minimizes expected loss
choices <- 7:777
expected_loss_vec <- numeric(length(choices))
N <- 100000  # Number of simulations

for (i in seq_along(choices)) {
  set.seed(123)  # for reproducibility
  random_draws <- sample(c(7, 77, 777), size = N, replace = TRUE)
  losses <- (random_draws - choices[i])^2
  expected_loss_vec[i] <- mean(losses)
  }

min_idx <- which.min(expected_loss_vec)
optimal_choice <- choices[min_idx]
cat("Optimal choice to minimize expected loss (nearest 10):", round(optimal_choice / 10) * 10, "\n\n") # Round to nearest multiple of 10

# Question 5e: Expected loss at this chosen number 
set.seed(123)  # for reproducibility
random_draws <- sample(c(7, 77, 777), size = N, replace = TRUE)
losses_optimal <- (random_draws - optimal_choice)^2
expected_loss_optimal <- mean(losses_optimal)
cat("Expected loss at this chosen number:", round(expected_loss_optimal / 5000) * 5000, "\n\n") # Round to nearest five thousand dollars

# Question 5f: Function to find the optimal number
find_optimal_number <- function(numbers) {
  optimal_value <- mean(numbers)   # The best choice under squared loss is the mean
  return(optimal_value)}

# Apply the user-defined function to the dataset provided
optimal_v1 <- find_optimal_number(HW2Q5_v1)
optimal_v2 <- find_optimal_number(HW2Q5_v2)
optimal_v3 <- find_optimal_number(HW2Q5_v3)
optimal_v4 <- find_optimal_number(HW2Q5_v4)

# Round answers to the nearest multiple of 5
cat("Optimal number for dataset 1:", round(optimal_v1 / 5) * 5, "\n")
cat("Optimal number for dataset 2:", round(optimal_v2 / 5) * 5, "\n")
cat("Optimal number for dataset 3:", round(optimal_v3 / 5) * 5, "\n")
cat("Optimal number for dataset 4:", round(optimal_v4 / 5) * 5, "\n")

