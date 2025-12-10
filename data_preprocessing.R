# data_preprocessing.r - load civil war data, create 80/20 train-test split, save to data folder

# load data
data <- read.csv("civilWar.csv")

# convert response and dominance to factors (no = 0, yes = 1 alphabetically)
data$civil.war <- factor(data$civil.war, levels = c("NO", "YES"))
data$dominance <- factor(data$dominance, levels = c("NO", "YES"))

# basic overview
cat("dimensions:", dim(data), "\n")
cat("columns:", colnames(data), "\n")
cat("response distribution:\n")
print(table(data$civil.war))
cat("missing values:", sum(is.na(data)), "\n")

# summary stats
print(summary(data))

# iqr outlier counts (no removal)
iqr_flags <- sapply(setdiff(names(data), c("civil.war", "dominance")), function(v) {
  x <- data[[v]]
  q1 <- quantile(x, 0.25, na.rm = TRUE)
  q3 <- quantile(x, 0.75, na.rm = TRUE)
  iqr <- q3 - q1
  sum(x < q1 - 1.5*iqr | x > q3 + 1.5*iqr, na.rm = TRUE)
})
cat("iqr outlier counts:\n")
print(iqr_flags)

# 80/20 train-test split
set.seed(400)
idx <- sample(seq_len(nrow(data)), size = floor(0.8 * nrow(data)))
train <- data[idx, ]
test <- data[-idx, ]

cat("train:", nrow(train), "test:", nrow(test), "\n")

# create data folder if not exists
if (!dir.exists("data")) dir.create("data")

# save train and test sets
write.csv(train, "data/train.csv", row.names = FALSE)
write.csv(test, "data/test.csv", row.names = FALSE)

cat("saved train.csv and test.csv to data folder\n")
