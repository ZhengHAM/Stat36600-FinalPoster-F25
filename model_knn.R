# model_knn.r - k-nearest neighbors classifier with k=5

library(class)
source("helpers.R")

# load data
d <- load_data()
train <- d$train
test <- d$test

# binary response for roc
y_test <- as.integer(test$civil.war == "YES")

# prepare numeric predictors only (exclude dominance factor and response)
numeric_cols <- setdiff(names(train), c("civil.war", "dominance"))

# convert dominance to numeric for knn
train_x <- as.matrix(train[, numeric_cols])
train_x <- cbind(train_x, dominance = as.integer(train$dominance == "YES"))
test_x <- as.matrix(test[, numeric_cols])
test_x <- cbind(test_x, dominance = as.integer(test$dominance == "YES"))

# scale using training parameters
train_scaled <- scale(train_x)
test_scaled <- scale(test_x, center = attr(train_scaled, "scaled:center"), 
                     scale = attr(train_scaled, "scaled:scale"))

# fit knn with k=5
k <- 5
knn_pred <- knn(train_scaled, test_scaled, cl = train$civil.war, k = k, prob = TRUE)
knn_prob_win <- attr(knn_pred, "prob")

# convert to probability of YES class
knn_probs <- ifelse(knn_pred == "YES", knn_prob_win, 1 - knn_prob_win)

# compute roc and auc
knn_roc <- compute_roc_auc(knn_probs, y_test)
cat("auc:", knn_roc$auc, "\n")

# threshold via youden j
knn_threshold <- knn_roc$youden_threshold
knn_pred_label <- factor(ifelse(knn_probs >= knn_threshold, "YES", "NO"), levels = levels(test$civil.war))
knn_confusion <- table(knn_pred_label, test$civil.war)
cat("confusion matrix:\n")
print(knn_confusion)

# misclassification rate
knn_mcr <- mean(knn_pred_label != test$civil.war)
cat("mcr:", knn_mcr, "\n")
cat("threshold:", knn_threshold, "\n")
cat("k:", k, "\n")

# plot roc
ensure_results_dir()
png(file.path("results", "knn_roc.png"))
plot(knn_roc$fpr, knn_roc$tpr, type = "l", main = paste0("knn (k=", k, ") roc"),
     xlab = "fpr", ylab = "tpr")
abline(0, 1, lty = 2, col = "gray")
dev.off()
