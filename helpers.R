
# roc/auc helper using trapezoidal rule and youden j
compute_roc_auc <- function(probs, y_true) {
  # build threshold grid
  thresholds <- sort(unique(c(0, probs, 1)))
  tpr <- numeric(length(thresholds))
  fpr <- numeric(length(thresholds))
  for (i in seq_along(thresholds)) {
    thr <- thresholds[i]
    preds <- ifelse(probs >= thr, 1, 0)
    tp <- sum(preds == 1 & y_true == 1)
    fp <- sum(preds == 1 & y_true == 0)
    fn <- sum(preds == 0 & y_true == 1)
    tn <- sum(preds == 0 & y_true == 0)
    tpr[i] <- if ((tp + fn) == 0) 0 else tp / (tp + fn)
    fpr[i] <- if ((fp + tn) == 0) 0 else fp / (fp + tn)
  }
  ord <- order(fpr, tpr)
  fpr <- fpr[ord]
  tpr <- tpr[ord]
  thresholds <- thresholds[ord]
  # trapezoidal auc
  auc <- sum(diff(fpr) * (head(tpr, -1) + tail(tpr, -1)) / 2)
  # youden j selection
  youden <- tpr - fpr
  j_idx <- which.max(youden)
  list(fpr = fpr, tpr = tpr, thresholds = thresholds, auc = auc, 
       youden_threshold = thresholds[j_idx], youden_j = youden[j_idx])
}

# load train and test data
load_data <- function() {
  train <- read.csv("data/train.csv")
  test <- read.csv("data/test.csv")
  # ensure factors
  train$civil.war <- factor(train$civil.war, levels = c("NO", "YES"))
  train$dominance <- factor(train$dominance, levels = c("NO", "YES"))
  test$civil.war <- factor(test$civil.war, levels = c("NO", "YES"))
  test$dominance <- factor(test$dominance, levels = c("NO", "YES"))
  list(train = train, test = test)
}

# ensure results directory exists for saving model output plots / tables
ensure_results_dir <- function() {
  if (!dir.exists("results")) dir.create("results")
}

# ensure eda directory exists for saving exploratory plots
ensure_eda_dir <- function() {
  if (!dir.exists("EDA_vis")) dir.create("EDA_vis")
}
