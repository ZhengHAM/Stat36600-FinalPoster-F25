# Data Preprocessing Script
# This script loads and prepares data for analysis

# Load required libraries
library(tidyverse)
library(caret)

# Set seed for reproducibility
set.seed(123)

# Load data (using mtcars as example dataset)
# You can replace this with your own data: data <- read.csv("data/your_data.csv")
data <- mtcars

# Display basic information
cat("Dataset Structure:\n")
str(data)

cat("\nDataset Summary:\n")
summary(data)

# Check for missing values
cat("\nMissing Values:\n")
missing_vals <- colSums(is.na(data))
print(missing_vals)

# Handle missing values if any (example)
# data <- na.omit(data)  # Remove rows with NA
# data[is.na(data)] <- 0  # Or replace with 0

# Feature engineering (example: add categorical variable)
data$mpg_category <- cut(data$mpg, 
                         breaks = c(0, 15, 20, 25, Inf),
                         labels = c("Low", "Medium", "High", "Very High"))

# Create train-test split (80-20)
train_index <- createDataPartition(data$mpg, p = 0.8, list = FALSE)
train_data <- data[train_index, ]
test_data <- data[-train_index, ]

# Save processed data
write.csv(train_data, "data/train_data.csv", row.names = FALSE)
write.csv(test_data, "data/test_data.csv", row.names = FALSE)
write.csv(data, "data/processed_data.csv", row.names = FALSE)

cat("\nData preprocessing completed!\n")
cat("Training set size:", nrow(train_data), "\n")
cat("Test set size:", nrow(test_data), "\n")

# Save workspace for next steps
save(train_data, test_data, data, file = "output/preprocessed_data.RData")
