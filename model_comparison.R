# compare all models and generate summary

source("helpers.R")

# expects that the individual model scripts (model_logistic.R, model_tree.R, etc.)
# have already been run in this R session (for example via main.Rmd),
# so that objects like logit_roc, tree_roc, rf_roc, etc. are available.

# create results dataframe from in-memory objects
results <- data.frame(
  model = c("logistic", "tree", "pruned_tree", "random_forest", "knn", "xgboost"),
  AUC   = c(logit_roc$auc, tree_roc$auc, pruned_tree_roc$auc, rf_roc$auc, knn_roc$auc, xgb_roc$auc),
  MCR   = c(logit_mcr,     tree_mcr,     pruned_tree_mcr,     rf_mcr,     knn_mcr,     xgb_mcr)
)

cat("model comparison:\n")
print(results)

# sort by auc
results_sorted <- results[order(results$AUC, decreasing = TRUE), ]
cat("\nsorted by auc (descending):\n")
print(results_sorted)

# best model
best_idx <- which.max(results$AUC)
best_model <- results$model[best_idx]
cat("\nbest model by auc:", best_model, "\n")
cat("best auc:", results$AUC[best_idx], "\n")
cat("best mcr:", results$MCR[best_idx], "\n")

# all roc curves on one plot
ensure_results_dir()
colors <- c("black", "red", "blue", "forestgreen", "orange", "purple")
png(file.path("results", "all_roc_curves.png"), width = 800, height = 600)
plot(logit_roc$fpr, logit_roc$tpr, type = "l", col = colors[1],
     main = "roc curves - all models", xlab = "fpr", ylab = "tpr")
lines(tree_roc$fpr, tree_roc$tpr, col = colors[2])
lines(pruned_tree_roc$fpr, pruned_tree_roc$tpr, col = colors[3])
lines(rf_roc$fpr, rf_roc$tpr, col = colors[4])
lines(knn_roc$fpr, knn_roc$tpr, col = colors[5])
lines(xgb_roc$fpr, xgb_roc$tpr, col = colors[6])
abline(0, 1, lty = 2, col = "gray")
legend("bottomright",
       legend = c("logistic", "tree", "pruned_tree", "random_forest", "knn", "xgboost"),
       col = colors, lty = 1, cex = 0.8)
dev.off()
cat("saved all_roc_curves.png\n")

# optionally keep a single CSV summary (no RData clutter)
write.csv(results_sorted, file.path("results", "model_comparison.csv"), row.names = FALSE)
cat("saved model_comparison.csv\n")

## additional visualization panels in EDA_vis/
ensure_eda_dir()

# 06_model_performance_comparison.png (rmse and r2 using probabilities vs 0/1)
d <- load_data()
y_test_num <- as.integer(d$test$civil.war == "YES")

rmse <- function(y, yhat) sqrt(mean((y - yhat)^2))
r2   <- function(y, yhat) 1 - sum((y - yhat)^2) / sum((y - mean(y))^2)

model_ids <- c("logistic", "tree", "pruned_tree", "random_forest", "knn", "xgboost")
prob_list <- list(
  logistic     = logit_probs,
  tree         = tree_probs,
  pruned_tree  = pruned_tree_probs,
  random_forest= rf_probs,
  knn          = knn_probs,
  xgboost      = xgb_probs
)

rmse_vals <- sapply(prob_list, function(p) rmse(y_test_num, p))
r2_vals   <- sapply(prob_list, function(p) r2(y_test_num, p))

png(file.path("EDA_vis", "06_model_performance_comparison.png"), width = 800, height = 400)
par(mfrow = c(1, 2))
barplot(rmse_vals, names.arg = model_ids, main = "rmse", col = "gray", ylab = "rmse")
barplot(r2_vals,   names.arg = model_ids, main = "r-squared", col = "gray", ylab = "r²")
dev.off()

# 07_predicted_vs_actual.png - predicted vs actual for each model
png(file.path("EDA_vis", "07_predicted_vs_actual.png"), width = 800, height = 800)
par(mfrow = c(2, 3))
for (m in model_ids) {
  p <- prob_list[[m]]
  plot(y_test_num, p,
       xlab = "actual (0/1)", ylab = "predicted prob yes",
       main = paste("predicted vs actual -", m))
  abline(h = 0:1, col = "gray", lty = 3)
}
dev.off()

# 08_residual_analysis.png - residuals for each model
png(file.path("EDA_vis", "08_residual_analysis.png"), width = 800, height = 800)
par(mfrow = c(2, 3))
for (m in model_ids) {
  p <- prob_list[[m]]
  res <- y_test_num - p
  plot(p, res,
       xlab = "predicted prob yes", ylab = "residual",
       main = paste("residuals -", m))
  abline(h = 0, col = "red", lwd = 2)
}
dev.off()

# 09_feature_importance.png - random forest feature importance
png(file.path("EDA_vis", "09_feature_importance.png"), width = 700, height = 500)
imp <- importance(rf_model)
imp_vals <- imp[, 1]
imp_vals <- sort(imp_vals, decreasing = TRUE)
par(mar = c(5, 10, 4, 2))
barplot(imp_vals,
        horiz = TRUE,
        las = 1,
        main = "random forest feature importance",
        xlab = "importance")
dev.off()
