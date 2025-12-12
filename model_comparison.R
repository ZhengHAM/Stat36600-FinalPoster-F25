# compare all models and generate summary

source("helpers.R")

# create results dataframe
results <- data.frame(
  model = c(
    "best_subset",
    "logistic",
    "tree",
    "pruned_tree",
    "random_forest",
    "knn",
    "xgboost"
  ),
  AUC = c(
    bss_roc$auc,
    logit_roc$auc,
    tree_roc$auc,
    pruned_tree_roc$auc,
    rf_roc$auc,
    knn_roc$auc,
    xgb_roc$auc
  ),
  MCR = c(
    bss_mcr,
    logit_mcr,
    tree_mcr,
    pruned_tree_mcr,
    rf_mcr,
    knn_mcr,
    xgb_mcr
  )
)

# rounded copy for display/output
results_display <- results
results_display$AUC <- round(results_display$AUC, 3)
results_display$MCR <- round(results_display$MCR, 3)

cat("model comparison:\n")
print(results_display)

# sort by auc
results_sorted <- results_display[
  order(results_display$AUC, decreasing = TRUE),
]
cat("\nsorted by auc (descending):\n")
print(results_sorted)

# best model
best_idx <- which.max(results_sorted$AUC)
cat("\nbest model by auc:", results_sorted$model[best_idx], "\n")
cat("best auc:", results_sorted$AUC[best_idx], "\n")
cat("best mcr:", results_sorted$MCR[best_idx], "\n")

# all roc curves
ensure_results_dir()
colors <- c(
  "pink",
  "black",
  "red",
  "blue",
  "forestgreen",
  "orange",
  "purple"
)

png(
  file.path("results", "all_roc_curves.png"),
  width = 800,
  height = 600
)

plot(
  bss_roc$fpr,
  bss_roc$tpr,
  type = "l",
  col = colors[1],
  main = "roc curves - all models",
  xlab = "fpr",
  ylab = "tpr"
)

lines(logit_roc$fpr, logit_roc$tpr, col = colors[2])
lines(tree_roc$fpr, tree_roc$tpr, col = colors[3])
lines(pruned_tree_roc$fpr, pruned_tree_roc$tpr, col = colors[4])
lines(rf_roc$fpr, rf_roc$tpr, col = colors[5])
lines(knn_roc$fpr, knn_roc$tpr, col = colors[6])
lines(xgb_roc$fpr, xgb_roc$tpr, col = colors[7])
abline(0, 1, lty = 2, col = "gray")

legend(
  "bottomright",
  legend = c(
    "best_subset",
    "logistic",
    "tree",
    "pruned_tree",
    "random_forest",
    "knn",
    "xgboost"
  ),
  col = colors,
  lty = 1,
  cex = 0.8
)

dev.off()
cat("saved all_roc_curves.png\n")

# save csv
write.csv(
  results_sorted,
  file.path("results", "model_comparison.csv"),
  row.names = FALSE
)
cat("saved model_comparison.csv\n")

# additional diagnostics
ensure_eda_dir()

d <- load_data()
y_test_num <- as.integer(d$test$civil.war == "YES")

rmse <- function(y, yhat) sqrt(mean((y - yhat)^2))
r2 <- function(y, yhat) 1 - sum((y - yhat)^2) / sum((y - mean(y))^2)

model_ids <- c(
  "best_subset",
  "logistic",
  "tree",
  "pruned_tree",
  "random_forest",
  "knn",
  "xgboost"
)

prob_list <- list(
  best_subset = bss_probs,
  logistic = logit_probs,
  tree = tree_probs,
  pruned_tree = pruned_tree_probs,
  random_forest = rf_probs,
  knn = knn_probs,
  xgboost = xgb_probs
)

rmse_vals <- sapply(prob_list, function(p) rmse(y_test_num, p))
r2_vals <- sapply(prob_list, function(p) r2(y_test_num, p))

png(
  file.path("EDA_vis", "06_model_performance_comparison.png"),
  width = 900,
  height = 400
)

par(mfrow = c(1, 2))
barplot(rmse_vals, names.arg = model_ids, main = "rmse", col = "gray", ylab = "rmse")
barplot(r2_vals, names.arg = model_ids, main = "r-squared", col = "gray", ylab = "r²")
dev.off()

png(
  file.path("EDA_vis", "07_predicted_vs_actual.png"),
  width = 900,
  height = 900
)

par(mfrow = c(3, 3))
for (m in model_ids) {
  p <- prob_list[[m]]
  plot(
    y_test_num,
    p,
    xlab = "actual (0/1)",
    ylab = "predicted prob yes",
    main = paste("predicted vs actual -", m)
  )
  abline(h = 0:1, col = "gray", lty = 3)
}
dev.off()

png(
  file.path("EDA_vis", "08_residual_analysis.png"),
  width = 900,
  height = 900
)

par(mfrow = c(3, 3))
for (m in model_ids) {
  p <- prob_list[[m]]
  res <- y_test_num - p
  plot(
    p,
    res,
    xlab = "predicted prob yes",
    ylab = "residual",
    main = paste("residuals -", m)
  )
  abline(h = 0, col = "red", lwd = 2)
}
dev.off()

png(
  file.path("EDA_vis", "09_feature_importance.png"),
  width = 700,
  height = 500
)

imp <- importance(rf_model)
imp_vals <- sort(imp[, 1], decreasing = TRUE)

par(mar = c(5, 10, 4, 2))
barplot(
  imp_vals,
  horiz = TRUE,
  las = 1,
  main = "random forest feature importance",
  xlab = "importance"
)
dev.off()

cat("\nconfusion matrices (Youden J threshold):\n\n")

confusion_list <- list(
  best_subset = bss_confusion,
  logistic = logit_confusion,
  tree = tree_confusion,
  pruned_tree = pruned_tree_confusion,
  random_forest = rf_confusion,
  knn = knn_confusion,
  xgboost = xgb_confusion
)

for (m in names(confusion_list)) {
  cat("model:", m, "\n")
  print(confusion_list[[m]])
  cat("\n")
}

