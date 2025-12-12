# random forest classifier

library(randomForest)
source("helpers.R")

# load data
d <- load_data()
train <- d$train
test <- d$test

# binary response for roc
y_test <- as.integer(test$civil.war == "YES")

# fit random forest
set.seed(400)
# weighted version (commented out after comparison)
# class_counts <- table(train$civil.war)
# # class weights can improve performance on minority yes class
# # motivated by class imbalance (~642 no vs 99 yes, ~13% yes)
# yes_weight <- as.numeric(class_counts["NO"] / class_counts["YES"])
# class_weights <- setNames(c(1, yes_weight), levels(train$civil.war))
# rf_model <- randomForest(civil.war ~ ., data = train, classwt = class_weights)
rf_model <- randomForest(civil.war ~ ., data = train)
cat("random forest model:\n")
print(rf_model)

# variable importance
cat("variable importance:\n")
print(importance(rf_model))

# predict probabilities
rf_probs <- predict(rf_model, newdata = test, type = "prob")[, "YES"]

# compute roc and auc
rf_roc <- compute_roc_auc(rf_probs, y_test)
cat("auc:", rf_roc$auc, "\n")

# threshold via youden j
rf_threshold <- rf_roc$youden_threshold
rf_pred <- factor(ifelse(rf_probs >= rf_threshold, "YES", "NO"), levels = levels(test$civil.war))
rf_confusion <- table(rf_pred, test$civil.war)
cat("confusion matrix:\n")
print(rf_confusion)

# misclassification rate
rf_mcr <- mean(rf_pred != test$civil.war)
cat("mcr:", rf_mcr, "\n")
cat("threshold:", rf_threshold, "\n")

# plot roc
ensure_results_dir()
png(file.path("results", "rf_roc.png"))
plot(rf_roc$fpr, rf_roc$tpr, type = "l", main = "random forest roc",
     xlab = "fpr", ylab = "tpr")
abline(0, 1, lty = 2, col = "gray")
dev.off()
