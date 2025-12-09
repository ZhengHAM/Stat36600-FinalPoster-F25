# Model Evaluation and Comparison Script
# This script evaluates and compares all trained models

# Load required libraries
library(tidyverse)
library(ggplot2)
library(gridExtra)

# Load models and data
load("output/models/all_models.RData")
load("output/preprocessed_data.RData")

# Create output directory
dir.create("output/plots", recursive = TRUE, showWarnings = FALSE)

cat("Evaluating and comparing models...\n\n")

# =============================================================================
# 1. Model Performance Comparison
# =============================================================================
performance_df <- do.call(rbind, performance)

# Bar plot of RMSE
p1 <- ggplot(performance_df, aes(x = reorder(Model, RMSE), y = RMSE, fill = Model)) +
  geom_bar(stat = "identity", alpha = 0.7) +
  geom_text(aes(label = round(RMSE, 2)), vjust = -0.5) +
  labs(title = "Model Comparison: Root Mean Squared Error (RMSE)",
       subtitle = "Lower is better",
       x = "Model", y = "RMSE") +
  theme_minimal() +
  theme(legend.position = "none",
        axis.text.x = element_text(angle = 45, hjust = 1))

# Bar plot of R-squared
p2 <- ggplot(performance_df, aes(x = reorder(Model, -R_squared), y = R_squared, fill = Model)) +
  geom_bar(stat = "identity", alpha = 0.7) +
  geom_text(aes(label = round(R_squared, 3)), vjust = -0.5) +
  labs(title = "Model Comparison: R-squared",
       subtitle = "Higher is better",
       x = "Model", y = "R-squared") +
  theme_minimal() +
  theme(legend.position = "none",
        axis.text.x = element_text(angle = 45, hjust = 1))

combined_perf <- grid.arrange(p1, p2, ncol = 2)
ggsave("output/plots/06_model_performance_comparison.png", combined_perf, width = 14, height = 6)

# =============================================================================
# 2. Predicted vs Actual Values
# =============================================================================
test_features <- test_data %>% select_if(is.numeric)

# Create a data frame with all predictions
pred_comparison <- data.frame(
  Actual = test_features$mpg,
  Linear = predictions$linear,
  Random_Forest = predictions$random_forest,
  Ridge = predictions$ridge,
  Lasso = predictions$lasso
)

# Reshape for plotting
pred_long <- pred_comparison %>%
  pivot_longer(cols = -Actual, names_to = "Model", values_to = "Predicted")

# Scatter plot: Predicted vs Actual for all models
p3 <- ggplot(pred_long, aes(x = Actual, y = Predicted, color = Model)) +
  geom_point(size = 3, alpha = 0.6) +
  geom_abline(intercept = 0, slope = 1, linetype = "dashed", color = "black", size = 1) +
  labs(title = "Predicted vs Actual MPG: All Models",
       x = "Actual MPG", y = "Predicted MPG") +
  theme_minimal() +
  facet_wrap(~ Model, ncol = 2)

ggsave("output/plots/07_predicted_vs_actual.png", p3, width = 12, height = 10)

# =============================================================================
# 3. Residual Analysis
# =============================================================================
# Calculate residuals
residuals_df <- data.frame(
  Actual = test_features$mpg,
  Linear = test_features$mpg - predictions$linear,
  Random_Forest = test_features$mpg - predictions$random_forest,
  Ridge = test_features$mpg - predictions$ridge,
  Lasso = test_features$mpg - predictions$lasso
)

# Reshape for plotting
residuals_long <- residuals_df %>%
  pivot_longer(cols = -Actual, names_to = "Model", values_to = "Residual")

# Residual plot
p4 <- ggplot(residuals_long, aes(x = Actual, y = Residual, color = Model)) +
  geom_point(size = 3, alpha = 0.6) +
  geom_hline(yintercept = 0, linetype = "dashed", color = "black", size = 1) +
  labs(title = "Residual Analysis: All Models",
       x = "Actual MPG", y = "Residual (Actual - Predicted)") +
  theme_minimal() +
  facet_wrap(~ Model, ncol = 2)

ggsave("output/plots/08_residual_analysis.png", p4, width = 12, height = 10)

# =============================================================================
# 4. Feature Importance (Random Forest)
# =============================================================================
if ("random_forest" %in% names(models)) {
  importance_df <- data.frame(
    Feature = rownames(importance(models$random_forest)),
    Importance = importance(models$random_forest)[, "%IncMSE"]
  )
  
  importance_df <- importance_df %>% arrange(desc(Importance))
  
  p5 <- ggplot(importance_df, aes(x = reorder(Feature, Importance), y = Importance)) +
    geom_bar(stat = "identity", fill = "steelblue", alpha = 0.7) +
    coord_flip() +
    labs(title = "Feature Importance (Random Forest)",
         x = "Feature", y = "Importance (% Increase in MSE)") +
    theme_minimal()
  
  ggsave("output/plots/09_feature_importance.png", p5, width = 8, height = 6)
}

# =============================================================================
# 5. Best Model Summary
# =============================================================================
best_model_idx <- which.min(performance_df$RMSE)
best_model_name <- performance_df$Model[best_model_idx]

cat("\n" , strrep("=", 60), "\n", sep="")
cat("BEST MODEL:", best_model_name, "\n")
cat(strrep("=", 60), "\n", sep="")
cat("RMSE:      ", performance_df$RMSE[best_model_idx], "\n")
cat("MAE:       ", performance_df$MAE[best_model_idx], "\n")
cat("R-squared: ", performance_df$R_squared[best_model_idx], "\n")
cat(strrep("=", 60), "\n", sep="")

# Save best model info
best_model_info <- performance_df[best_model_idx, ]
write.csv(best_model_info, "output/models/best_model_info.csv", row.names = FALSE)

cat("\nModel evaluation completed! Check output/plots/ for visualizations.\n")
