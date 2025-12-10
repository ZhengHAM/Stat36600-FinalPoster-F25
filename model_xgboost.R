# xgboost classifier with binary logistic

library(xgboost)
source("helpers.R")

# load data
d <- load_data()
train <- d$train
test <- d$test

# binary response for roc
y_test <- as.integer(test$civil.war == "YES")
y_train <- as.integer(train$civil.war == "YES")

# prepare numeric matrix (convert dominance to numeric)
prep_matrix <- function(df) {
  numeric_cols <- setdiff(names(df), c("civil.war", "dominance"))
  x <- as.matrix(df[, numeric_cols])
  x <- cbind(x, dominance = as.integer(df$dominance == "YES"))
  x
}

train_xgb <- prep_matrix(train)
test_xgb <- prep_matrix(test)

# create dmatrix
dtrain <- xgb.DMatrix(data = train_xgb, label = y_train)

# fit xgboost
set.seed(408)
xgb_model <- xgboost(data = dtrain, objective = "binary:logistic", nrounds = 100, verbose = 0)
cat("xgboost model trained with 100 rounds\n")

# predict probabilities
xgb_probs <- predict(xgb_model, newdata = test_xgb)

# compute roc and auc
xgb_roc <- compute_roc_auc(xgb_probs, y_test)
cat("auc:", xgb_roc$auc, "\n")

# threshold via youden j
xgb_threshold <- xgb_roc$youden_threshold
xgb_pred <- factor(ifelse(xgb_probs >= xgb_threshold, "YES", "NO"), levels = levels(test$civil.war))
xgb_confusion <- table(xgb_pred, test$civil.war)
cat("confusion matrix:\n")
print(xgb_confusion)

# misclassification rate
xgb_mcr <- mean(xgb_pred != test$civil.war)
cat("mcr:", xgb_mcr, "\n")
cat("threshold:", xgb_threshold, "\n")

# feature importance
cat("feature importance:\n")
print(xgb.importance(model = xgb_model))

# plot roc
ensure_results_dir()
png(file.path("results", "xgb_roc.png"))
plot(xgb_roc$fpr, xgb_roc$tpr, type = "l", main = "xgboost roc",
     xlab = "fpr", ylab = "tpr")
abline(0, 1, lty = 2, col = "gray")

dev.off()
