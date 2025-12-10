# model_pruned_tree.r - pruned decision tree classifier (cp from xerror min)

library(rpart)
source("helpers.R")

# load data
d <- load_data()
train <- d$train
test <- d$test

# binary response for roc
y_test <- as.integer(test$civil.war == "YES")

# fit initial tree
tree_model <- rpart(civil.war ~ ., data = train, method = "class")

# prune using cp that minimizes cross-validated error
cp_opt <- tree_model$cptable[which.min(tree_model$cptable[, "xerror"]), "CP"]
cat("optimal cp:", cp_opt, "\n")
pruned_tree_model <- prune(tree_model, cp = cp_opt)
cat("pruned tree model:\n")
print(pruned_tree_model)

# predict probabilities
pruned_tree_probs <- predict(pruned_tree_model, newdata = test, type = "prob")[, "YES"]

# compute roc and auc
pruned_tree_roc <- compute_roc_auc(pruned_tree_probs, y_test)
cat("auc:", pruned_tree_roc$auc, "\n")

# threshold via youden j
pruned_tree_threshold <- pruned_tree_roc$youden_threshold
pruned_tree_pred <- factor(ifelse(pruned_tree_probs >= pruned_tree_threshold, "YES", "NO"), levels = levels(test$civil.war))
pruned_tree_confusion <- table(pruned_tree_pred, test$civil.war)
cat("confusion matrix:\n")
print(pruned_tree_confusion)

# misclassification rate
pruned_tree_mcr <- mean(pruned_tree_pred != test$civil.war)
cat("mcr:", pruned_tree_mcr, "\n")
cat("threshold:", pruned_tree_threshold, "\n")

# plot roc
ensure_results_dir()
png(file.path("results", "pruned_tree_roc.png"))
plot(pruned_tree_roc$fpr, pruned_tree_roc$tpr, type = "l", main = "pruned tree roc",
     xlab = "fpr", ylab = "tpr")
abline(0, 1, lty = 2, col = "gray")
dev.off()
