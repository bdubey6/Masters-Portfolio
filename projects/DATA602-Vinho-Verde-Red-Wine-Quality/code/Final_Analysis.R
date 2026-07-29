# DATA 602 Term Project — Investigating the Relationship Between Red Wine
# Quality and Key Chemical Properties: pH and Alcohol Content
# Group 8: Bhuvan Dubey, Yu Hao, Namya Dimri, Abdalla Elshafey
#
# This is the final analysis script, reconstructed from the R appendix of
# final_report.pdf so the exact code behind every table/figure in the report
# and presentation lives in the repo as a runnable file. Paths below are
# relative to this file's location inside code/.

rm(list = ls(all = TRUE))
library(ggplot2)
library(mosaic)
library(patchwork)
library(ggbreak)

### INTRODUCTION
## Data Wrangling and Summary Statistics

# Read the dataset into R
wine.df <- read.csv("../data/winequality-red.csv")

# Create and assign values to the quality.cat variable based on wine quality score
quality.cat <- c()
for (i in wine.df$quality) {
  if (i <= 5) {
    quality.cat <- c(quality.cat, "Low")
  } else {
    quality.cat <- c(quality.cat, "High")
  }
}

# Add the quality.cat variable into the wine data frame
wine.df <- data.frame(wine.df, quality.cat)

# Generate summary statistics for % alcohol content based on quality group
favstats(~alcohol | quality.cat, data = wine.df)

# Generates summary statistics for pH level variable
favstats(wine.df$pH)

## Data Visualization

# Barplot showing the distribution of quality scores
wine.df$quality1 <- factor(wine.df$quality)
quality.plot <- ggplot(wine.df, aes(x = quality1, fill = quality.cat)) +
  geom_bar() +
  scale_fill_manual(values = c("Low" = "#F8766D", "High" = "#00BFC4")) +
  theme_minimal(base_size = 13) +
  labs(
    title = "Count of Red Wines by Quality Score",
    subtitle = "Vinho Verde Red Wines (Low vs High Quality)",
    x = "Quality Score",
    y = "Count",
    fill = "Quality"
  ) +
  theme(
    plot.title = element_text(face = "bold", size = 15),
    plot.subtitle = element_text(size = 11, color = "gray30")
  )
quality.plot$labels$fill <- "Red Wine Quality"
quality.plot

# Violin plot for the distribution of % alcohol content between high and low quality groups
alcohol.plot <- ggplot(wine.df, aes(x = quality.cat, y = alcohol, fill = quality.cat)) +
  geom_violin(trim = FALSE, alpha = 0.5, color = "black") +
  geom_boxplot(width = 0.15, outlier.shape = 16, outlier.size = 1.5, color = "black", fill = "white") +
  scale_fill_manual(values = c("Low" = "#F8766D", "High" = "#00BFC4")) +
  theme_minimal(base_size = 13) +
  labs(
    title = "% Alcohol Content by Wine Quality Level",
    subtitle = "Vinho Verde Red Wines (Low vs High Quality)",
    x = "Red Wine Quality",
    y = "Alcohol (% by volume)",
    fill = "Quality"
  ) +
  theme(
    plot.title = element_text(face = "bold", size = 10),
    plot.subtitle = element_text(size = 11, color = "gray30"),
    legend.position = "none"
  )

# Violin plot for the distribution of pH level between high and low quality groups
pH.plot <- ggplot(wine.df, aes(x = quality.cat, y = pH, fill = quality.cat)) +
  geom_violin(trim = FALSE, alpha = 0.5, color = "black") +
  geom_boxplot(width = 0.15, outlier.shape = 16, outlier.size = 1.5, color = "black", fill = "white") +
  scale_fill_manual(values = c("Low" = "#F8766D", "High" = "#00BFC4")) +
  theme_minimal(base_size = 13) +
  labs(
    title = "pH Content by Wine Quality",
    subtitle = "Vinho Verde Red Wines (Low vs High Quality)",
    x = "Red Wine Quality",
    y = "pH",
    fill = "Quality"
  ) +
  theme(
    plot.title = element_text(face = "bold", size = 10),
    plot.subtitle = element_text(size = 11, color = "gray30"),
    legend.position = "none"
  )

# Combines the two plots above into one graphic
alcohol.plot + pH.plot


### HYPOTHESIS TESTING Q1
# Do high quality Vinho Verde red wines have a significantly higher
# percentage alcohol content compared to low quality red wines?
## Statistical Analysis

# Right-sided independent two sample t-test
t.test(~alcohol | quality.cat, data = wine.df, alternative = "greater")

# Right-sided permutation test using 4999 iterations
threshold <- mean(subset(wine.df, quality.cat == "High")$alcohol) -
  mean(subset(wine.df, quality.cat == "Low")$alcohol)
threshold

n <- length(wine.df$alcohol)
n.high <- length(subset(wine.df, quality.cat == "High")$alcohol)
n.low <- length(subset(wine.df, quality.cat == "Low")$alcohol)

set.seed(1111)
N <- 4999
permvector <- numeric(N)
for (i in 1:N) {
  index <- sample(n, n.high, replace = FALSE)
  permvector[i] <- mean(wine.df$alcohol[index]) - mean(wine.df$alcohol[-index])
}
(sum(permvector >= threshold) + 1) / (N + 1)

# Histogram for the distribution of mean differences in % alcohol content
# Adds scale breaks on the x-axis to show threshold value
permvector.df <- data.frame(permvector)
perm.plot <- ggplot(permvector.df, aes(x = permvector)) +
  geom_histogram(aes(y = after_stat(density)), col = "black", fill = "skyblue") +
  scale_x_break(c(0.3, 0.9)) +
  geom_vline(xintercept = threshold, color = "red", linetype = "dashed", size = 1) +
  geom_density(col = "red", size = 1.2) +
  theme_minimal() +
  labs(
    title = "Permutation Distribution of Mean Alcohol Differences",
    subtitle = "High-quality vs Low-quality Vinho Verde Red Wines",
    x = "Difference Between Mean % Alcohol Content in Red Wine (High - Low)",
    y = "Density"
  ) +
  theme(plot.title = element_text(face = "bold", size = 15))

perm.plot + scale_x_continuous(
  limits = c(-0.2, 1),
  breaks = c(-0.2, -0.1, 0, 0.1, 0.2, 0.3, 0.9, 1.0),
  minor_breaks = NULL
)

# 95% confidence interval for difference in mean % alcohol content from
# student's t distribution
t.test(~alcohol | quality.cat, data = wine.df)$conf


### HYPOTHESIS TESTING Q2
# Is the final pH level of Vinho Verde red wines significantly associated
# with its perceived quality?
## Data Wrangling and Assumption Check

# Created variable for chemical pH categories
pH.cat.chem <- c()
for (i in wine.df$pH) {
  if (i <= 3.2) {
    pH.cat.chem <- c(pH.cat.chem, 1)
  } else if (i > 3.2 & i <= 3.5) {
    pH.cat.chem <- c(pH.cat.chem, 2)
  } else {
    pH.cat.chem <- c(pH.cat.chem, 3)
  }
}

# Created variable for quartile pH categories
pH.cat.bal <- c()
for (i in wine.df$pH) {
  if (i <= 3.21) {
    pH.cat.bal <- c(pH.cat.bal, 1)
  } else if (i > 3.21 & i <= 3.31) {
    pH.cat.bal <- c(pH.cat.bal, 2)
  } else if (i > 3.31 & i <= 3.40) {
    pH.cat.bal <- c(pH.cat.bal, 3)
  } else {
    pH.cat.bal <- c(pH.cat.bal, 4)
  }
}

# Add the chemical and quartile pH categories back into wine dataframe
wine.df <- data.frame(wine.df, pH.cat.chem, pH.cat.bal)

# Create crosstable for chemical pH categories
quality <- c("Low", "High")
chem.ct <- rbind(c(189, 473, 82), c(199, 570, 86))
rownames(chem.ct) <- c("Low Quality", "High Quality")
colnames(chem.ct) <- c("High Acidity", "Moderate Acidity", "Low Acidity")

# Create crosstable for quartile (balanced) pH categories
bal.ct <- rbind(c(200, 186, 173, 185), c(224, 212, 217, 202))
rownames(bal.ct) <- c("Low Quality", "High Quality")
colnames(bal.ct) <- c("High Acidity", "High Moderate Acidity", "Low Moderate Acidity", "Low Acidity")

# Bar plot for chemical pH category crosstable
wine.df$pH.cat.chem1 <- factor(wine.df$pH.cat.chem,
  levels = c(1, 2, 3),
  labels = c("High Acidity", "Moderate Acidity", "Low Acidity")
)
chem.ct.plot <- ggplot(data = wine.df, aes(x = pH.cat.chem1, fill = quality.cat)) +
  geom_bar(position = "dodge") +
  scale_fill_manual(values = c("Low" = "#F8766D", "High" = "#00BFC4")) +
  theme_minimal(base_size = 13) +
  labs(
    title = "Count of Red Wine Quality within Each pH Chemical Category",
    x = "pH Level",
    y = "Count"
  ) +
  theme(
    plot.title = element_text(face = "bold", size = 10),
    plot.subtitle = element_text(size = 11, color = "gray30")
  )
chem.ct.plot$labels$fill <- "Red Wine Quality"

# Bar plot for quartile pH category crosstable
wine.df$pH.cat.bal1 <- factor(wine.df$pH.cat.bal,
  levels = c(1, 2, 3, 4),
  labels = c("High Acidity", "High Moderate Acidity", "Low Moderate Acidity", "Low Acidity")
)
bal.ct.plot <- ggplot(data = wine.df, aes(x = pH.cat.bal1, fill = quality.cat)) +
  geom_bar(position = "dodge") +
  scale_fill_manual(values = c("Low" = "#F8766D", "High" = "#00BFC4")) +
  theme_minimal(base_size = 13) +
  labs(
    title = "Count of Red Wine Quality within Each pH Quartile Category",
    x = "pH Level",
    y = "Count"
  ) +
  theme(
    axis.text.x = element_text(angle = 20, hjust = 1),
    plot.title = element_text(face = "bold", size = 10),
    plot.subtitle = element_text(size = 11, color = "gray30")
  )
bal.ct.plot$labels$fill <- "Red Wine Quality"

# Combine the above two plots into a single graphic, keeping only one legend
q2.plot <- chem.ct.plot + bal.ct.plot + plot_layout(guides = "collect")
q2.plot

## Statistical Analysis

# Chi-squared test of independence based on chemical pH crosstable
xchisq.test(chem.ct, correct = F)

# Chi-squared test of independence based on quartile pH crosstable
xchisq.test(bal.ct, correct = F)
