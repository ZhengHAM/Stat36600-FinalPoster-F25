# best subset using BIC

library(bestglm)
source("helpers.R")

# load data
d <- load_data()
train <- d$train
test  <- d$test

# binary response for roc
y_test <- as.integer(test$civil.war == "YES")

# prepare training data for bestglm (response must be numeric and last)
train_bss <- train
train_bss$y <- as.integer(train_bss$civil.war == "YES")
train_bss$civil.war <- NULL

# fit best subset logistic (BIC)
set.seed(400)
bss_model <- suppressMessages(bestglm(
  Xy     = train_bss,
  family = binomial,
  IC     = "BIC"
))

cat("best subset logistic model:\n")
print(bss_model$BestModel)

# predict probabilities
bss_probs <- predict(bss_model$BestModel, newdata = test, type = "response")

# compute roc and auc
bss_roc <- compute_roc_auc(bss_probs, y_test)
cat("auc:", bss_roc$auc, "\n")

# threshold via youden j
bss_threshold <- bss_roc$youden_threshold
bss_pred <- factor(ifelse(bss_probs >= bss_threshold, "YES", "NO"),
  levels = levels(test$civil.war))
bss_confusion <- table(bss_pred, test$civil.war)
cat("confusion matrix:\n")
print(bss_confusion)

# misclassification rate
bss_mcr <- mean(bss_pred != test$civil.war)
cat("mcr:", bss_mcr, "\n")
cat("threshold:", bss_threshold, "\n")

# plot roc
ensure_results_dir()
png(file.path("results", "bss_roc.png"))
plot(bss_roc$fpr, bss_roc$tpr, type = "l",
  main = "best subset logistic roc",
  xlab = "fpr", ylab = "tpr")
abline(0, 1, lty = 2, col = "gray")
dev.off()
