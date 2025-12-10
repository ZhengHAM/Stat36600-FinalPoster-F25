# compare all models and generate summary

# expects that the individual model scripts (model_logistic.R, model_tree.R, etc.)
# have already been run in this R session (for example via main.Rmd or run_all.R),
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
