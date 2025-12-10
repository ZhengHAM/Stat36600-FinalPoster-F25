# model_tree.r - unpruned decision tree classifier

library(rpart)
source("helpers.R")

# load data
d <- load_data()
train <- d$train
test <- d$test

# binary response for roc
y_test <- as.integer(test$civil.war == "YES")

# fit unpruned tree
tree_model <- rpart(civil.war ~ ., data = train, method = "class")
cat("tree model:\n")
print(tree_model)

# predict probabilities
tree_probs <- predict(tree_model, newdata = test, type = "prob")[, "YES"]

# compute roc and auc
tree_roc <- compute_roc_auc(tree_probs, y_test)
cat("auc:", tree_roc$auc, "\n")

# threshold via youden j
tree_threshold <- tree_roc$youden_threshold
tree_pred <- factor(ifelse(tree_probs >= tree_threshold, "YES", "NO"), levels = levels(test$civil.war))
tree_confusion <- table(tree_pred, test$civil.war)
cat("confusion matrix:\n")
print(tree_confusion)

# misclassification rate
tree_mcr <- mean(tree_pred != test$civil.war)
cat("mcr:", tree_mcr, "\n")
cat("threshold:", tree_threshold, "\n")

# plot roc
ensure_results_dir()
png(file.path("results", "tree_roc.png"))
plot(tree_roc$fpr, tree_roc$tpr, type = "l", main = "unpruned tree roc",
     xlab = "fpr", ylab = "tpr")
abline(0, 1, lty = 2, col = "gray")
dev.off()
