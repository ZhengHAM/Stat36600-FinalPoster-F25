# Exploratory Data Analysis (EDA) Script
# This script performs comprehensive exploratory analysis and creates visualizations

# Load required libraries
library(tidyverse)
library(corrplot)
library(ggplot2)
library(gridExtra)

# Load preprocessed data
load("output/preprocessed_data.RData")

# Create output directory for plots if it doesn't exist
dir.create("output/plots", recursive = TRUE, showWarnings = FALSE)

# 1. Distribution of target variable (mpg)
cat("Analyzing target variable distribution...\n")
p1 <- ggplot(data, aes(x = mpg)) +
  geom_histogram(binwidth = 2, fill = "steelblue", color = "black", alpha = 0.7) +
  geom_vline(aes(xintercept = mean(mpg)), color = "red", linetype = "dashed", size = 1) +
  labs(title = "Distribution of Miles Per Gallon (MPG)",
       x = "MPG", y = "Frequency") +
  theme_minimal()

ggsave("output/plots/01_mpg_distribution.png", p1, width = 8, height = 6)

# 2. Correlation matrix
cat("Generating correlation matrix...\n")
numeric_data <- data %>% select_if(is.numeric)
correlation_matrix <- cor(numeric_data)

png("output/plots/02_correlation_matrix.png", width = 800, height = 800)
corrplot(correlation_matrix, method = "color", type = "upper", 
         addCoef.col = "black", number.cex = 0.7,
         tl.col = "black", tl.srt = 45,
         title = "Correlation Matrix of Variables",
         mar = c(0,0,1,0))
dev.off()

# 3. Scatter plots of key relationships
cat("Creating scatter plots...\n")
p2 <- ggplot(data, aes(x = wt, y = mpg)) +
  geom_point(aes(color = factor(cyl)), size = 3, alpha = 0.7) +
  geom_smooth(method = "lm", se = TRUE, color = "black", linetype = "dashed") +
  labs(title = "MPG vs Weight by Cylinder Count",
       x = "Weight (1000 lbs)", y = "MPG",
       color = "Cylinders") +
  theme_minimal()

p3 <- ggplot(data, aes(x = hp, y = mpg)) +
  geom_point(aes(color = factor(cyl)), size = 3, alpha = 0.7) +
  geom_smooth(method = "lm", se = TRUE, color = "black", linetype = "dashed") +
  labs(title = "MPG vs Horsepower by Cylinder Count",
       x = "Horsepower", y = "MPG",
       color = "Cylinders") +
  theme_minimal()

combined_scatter <- grid.arrange(p2, p3, ncol = 2)
ggsave("output/plots/03_scatter_plots.png", combined_scatter, width = 14, height = 6)

# 4. Box plots by categorical variables
cat("Creating box plots...\n")
p4 <- ggplot(data, aes(x = factor(cyl), y = mpg, fill = factor(cyl))) +
  geom_boxplot(alpha = 0.7) +
  labs(title = "MPG Distribution by Cylinder Count",
       x = "Number of Cylinders", y = "MPG",
       fill = "Cylinders") +
  theme_minimal()

p5 <- ggplot(data, aes(x = factor(gear), y = mpg, fill = factor(gear))) +
  geom_boxplot(alpha = 0.7) +
  labs(title = "MPG Distribution by Gear Count",
       x = "Number of Gears", y = "MPG",
       fill = "Gears") +
  theme_minimal()

combined_box <- grid.arrange(p4, p5, ncol = 2)
ggsave("output/plots/04_boxplots.png", combined_box, width = 14, height = 6)

# 5. Summary statistics by groups
cat("\nSummary Statistics by Cylinder Count:\n")
summary_by_cyl <- data %>%
  group_by(cyl) %>%
  summarise(
    count = n(),
    mean_mpg = mean(mpg),
    sd_mpg = sd(mpg),
    mean_hp = mean(hp),
    mean_wt = mean(wt)
  )
print(summary_by_cyl)

# Save summary statistics
write.csv(summary_by_cyl, "output/summary_statistics.csv", row.names = FALSE)

# 6. Pairs plot for key variables
cat("Creating pairs plot...\n")
png("output/plots/05_pairs_plot.png", width = 1000, height = 1000)
pairs(~ mpg + wt + hp + disp + drat, data = data,
      main = "Pairs Plot of Key Variables",
      pch = 19, col = as.numeric(factor(data$cyl)))
dev.off()

cat("\nExploratory analysis completed! Check output/plots/ for visualizations.\n")
