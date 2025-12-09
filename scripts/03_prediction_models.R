# Prediction Models Script
# This script builds and trains multiple prediction models

# Load required libraries
library(tidyverse)
library(caret)
library(randomForest)
library(glmnet)

# Load preprocessed data
load("output/preprocessed_data.RData")

cat("Building prediction models for MPG...\n\n")

# Prepare data (remove non-numeric columns for modeling)
train_features <- train_data %>% select_if(is.numeric)
test_features <- test_data %>% select_if(is.numeric)

# Define control parameters for cross-validation
ctrl <- trainControl(method = "cv", number = 5, savePredictions = TRUE)

# Store all models
models <- list()
predictions <- list()
performance <- list()

# =============================================================================
# Model 1: Linear Regression
# =============================================================================
cat("1. Training Linear Regression Model...\n")
lm_model <- train(mpg ~ . - mpg_category, 
                  data = train_data %>% select_if(is.numeric),
                  method = "lm",
                  trControl = ctrl)

models$linear <- lm_model
predictions$linear <- predict(lm_model, test_features)

# Calculate performance metrics
lm_rmse <- sqrt(mean((predictions$linear - test_features$mpg)^2))
lm_mae <- mean(abs(predictions$linear - test_features$mpg))
lm_r2 <- cor(predictions$linear, test_features$mpg)^2

performance$linear <- data.frame(
  Model = "Linear Regression",
  RMSE = lm_rmse,
  MAE = lm_mae,
  R_squared = lm_r2
)

cat("  RMSE:", lm_rmse, "\n")
cat("  R-squared:", lm_r2, "\n\n")

# =============================================================================
# Model 2: Random Forest
# =============================================================================
cat("2. Training Random Forest Model...\n")
rf_model <- randomForest(mpg ~ . - mpg_category, 
                         data = train_data %>% select_if(is.numeric),
                         ntree = 500,
                         importance = TRUE)

models$random_forest <- rf_model
predictions$random_forest <- predict(rf_model, test_features)

# Calculate performance metrics
rf_rmse <- sqrt(mean((predictions$random_forest - test_features$mpg)^2))
rf_mae <- mean(abs(predictions$random_forest - test_features$mpg))
rf_r2 <- cor(predictions$random_forest, test_features$mpg)^2

performance$random_forest <- data.frame(
  Model = "Random Forest",
  RMSE = rf_rmse,
  MAE = rf_mae,
  R_squared = rf_r2
)

cat("  RMSE:", rf_rmse, "\n")
cat("  R-squared:", rf_r2, "\n\n")

# =============================================================================
# Model 3: Ridge Regression
# =============================================================================
cat("3. Training Ridge Regression Model...\n")
ridge_model <- train(mpg ~ . - mpg_category,
                     data = train_data %>% select_if(is.numeric),
                     method = "glmnet",
                     tuneGrid = expand.grid(alpha = 0, lambda = seq(0.001, 1, length = 20)),
                     trControl = ctrl)

models$ridge <- ridge_model
predictions$ridge <- predict(ridge_model, test_features)

# Calculate performance metrics
ridge_rmse <- sqrt(mean((predictions$ridge - test_features$mpg)^2))
ridge_mae <- mean(abs(predictions$ridge - test_features$mpg))
ridge_r2 <- cor(predictions$ridge, test_features$mpg)^2

performance$ridge <- data.frame(
  Model = "Ridge Regression",
  RMSE = ridge_rmse,
  MAE = ridge_mae,
  R_squared = ridge_r2
)

cat("  RMSE:", ridge_rmse, "\n")
cat("  R-squared:", ridge_r2, "\n\n")

# =============================================================================
# Model 4: Lasso Regression
# =============================================================================
cat("4. Training Lasso Regression Model...\n")
lasso_model <- train(mpg ~ . - mpg_category,
                     data = train_data %>% select_if(is.numeric),
                     method = "glmnet",
                     tuneGrid = expand.grid(alpha = 1, lambda = seq(0.001, 1, length = 20)),
                     trControl = ctrl)

models$lasso <- lasso_model
predictions$lasso <- predict(lasso_model, test_features)

# Calculate performance metrics
lasso_rmse <- sqrt(mean((predictions$lasso - test_features$mpg)^2))
lasso_mae <- mean(abs(predictions$lasso - test_features$mpg))
lasso_r2 <- cor(predictions$lasso, test_features$mpg)^2

performance$lasso <- data.frame(
  Model = "Lasso Regression",
  RMSE = lasso_rmse,
  MAE = lasso_mae,
  R_squared = lasso_r2
)

cat("  RMSE:", lasso_rmse, "\n")
cat("  R-squared:", lasso_r2, "\n\n")

# =============================================================================
# Save models and results
# =============================================================================
save(models, predictions, performance, file = "output/models/all_models.RData")

# Combine performance metrics
performance_df <- do.call(rbind, performance)
write.csv(performance_df, "output/models/model_performance.csv", row.names = FALSE)

cat("\nModel Performance Summary:\n")
print(performance_df)

cat("\nAll models saved to output/models/\n")
