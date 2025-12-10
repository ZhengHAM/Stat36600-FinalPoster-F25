
# load civil war data, create 80/20 train-test split, save to data folder

source("helpers.R")

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

# eda visualizations (saved under EDA_vis/)
ensure_eda_dir()

# 01_mpg_distribution.png
png(file.path("EDA_vis", "01_mpg_distribution.png"))
hist(data$growth,
     main = "growth distribution",
     xlab = "growth",
     col = "gray",
     border = "white")
abline(v = mean(data$growth, na.rm = TRUE), col = "red", lwd = 2)
dev.off()

# 02_correlation_matrix.png
numeric_cols <- setdiff(names(data), c("civil.war", "dominance"))
corr_mat <- cor(data[, numeric_cols], use = "complete.obs")
png(file.path("EDA_vis", "02_correlation_matrix.png"), width = 700, height = 700)
image(1:ncol(corr_mat), 1:ncol(corr_mat), t(corr_mat)[, ncol(corr_mat):1],
      axes = FALSE, xlab = "", ylab = "",
      col = colorRampPalette(c("blue", "white", "red"))(50))
axis(1, at = 1:ncol(corr_mat), labels = colnames(corr_mat), las = 2)
axis(2, at = 1:ncol(corr_mat), labels = rev(colnames(corr_mat)), las = 2)
title(main = "correlation matrix")
dev.off()

# 03_scatter_plots.png: growth vs exports and growth vs lnpop
png(file.path("EDA_vis", "03_scatter_plots.png"), width = 800, height = 400)
par(mfrow = c(1, 2))
plot(data$exports, data$growth,
     xlab = "exports", ylab = "growth",
     main = "growth vs exports")
plot(data$lnpop, data$growth,
     xlab = "lnpop", ylab = "growth",
     main = "growth vs lnpop")
dev.off()

# 04_boxplots.png: growth by dominance and by civil war
png(file.path("EDA_vis", "04_boxplots.png"), width = 800, height = 400)
par(mfrow = c(1, 2))
boxplot(growth ~ dominance, data = data,
        xlab = "dominance", ylab = "growth",
        main = "growth by dominance")
boxplot(growth ~ civil.war, data = data,
        xlab = "civil.war", ylab = "growth",
        main = "growth by civil war")
dev.off()

# 05_pairs_plot.png: pairwise numeric relationships
png(file.path("EDA_vis", "05_pairs_plot.png"), width = 800, height = 800)
pairs(data[, numeric_cols], main = "pairs plot - numeric predictors")
dev.off()

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
