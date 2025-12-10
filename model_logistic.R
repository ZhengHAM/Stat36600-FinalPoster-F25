# model_logistic.r - logistic regression classifier

source("helpers.R")

# load data
d <- load_data()
train <- d$train
test <- d$test

# binary response for roc
y_test <- as.integer(test$civil.war == "YES")

# fit logistic regression
logit_model <- glm(civil.war ~ ., data = train, family = binomial())
cat("logistic regression model summary:\n")
print(summary(logit_model))

# predict probabilities
logit_probs <- predict(logit_model, newdata = test, type = "response")

# compute roc and auc
logit_roc <- compute_roc_auc(logit_probs, y_test)
cat("auc:", logit_roc$auc, "\n")

# threshold via youden j
logit_threshold <- logit_roc$youden_threshold
logit_pred <- factor(ifelse(logit_probs >= logit_threshold, "YES", "NO"), levels = levels(test$civil.war))
logit_confusion <- table(logit_pred, test$civil.war)
cat("confusion matrix:\n")
print(logit_confusion)

# misclassification rate
logit_mcr <- mean(logit_pred != test$civil.war)
cat("mcr:", logit_mcr, "\n")
cat("threshold:", logit_threshold, "\n")

# plot roc
ensure_results_dir()
png(file.path("results", "logistic_roc.png"))
plot(logit_roc$fpr, logit_roc$tpr, type = "l", main = "logistic regression roc",
     xlab = "fpr", ylab = "tpr")
abline(0, 1, lty = 2, col = "gray")
dev.off()
