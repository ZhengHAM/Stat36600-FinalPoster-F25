# Contributing to the Project

## How to Extend This Project

### Adding New Models

To add a new prediction model:

1. **Edit `scripts/03_prediction_models.R`**:

```r
# Example: Adding Gradient Boosting Machine (GBM)
library(gbm)

cat("N. Training Gradient Boosting Model...\n")
gbm_model <- gbm(mpg ~ . - mpg_category,
                 data = train_data %>% select_if(is.numeric),
                 distribution = "gaussian",
                 n.trees = 500,
                 interaction.depth = 4,
                 shrinkage = 0.01)

models$gbm <- gbm_model
predictions$gbm <- predict(gbm_model, test_features, n.trees = 500)

# Calculate metrics
gbm_rmse <- sqrt(mean((predictions$gbm - test_features$mpg)^2))
gbm_mae <- mean(abs(predictions$gbm - test_features$mpg))
gbm_r2 <- cor(predictions$gbm, test_features$mpg)^2

performance$gbm <- data.frame(
  Model = "Gradient Boosting",
  RMSE = gbm_rmse,
  MAE = gbm_mae,
  R_squared = gbm_r2
)
```

2. **Update `scripts/04_model_evaluation.R`** to include the new model in visualizations.

### Adding New Visualizations

To add custom plots:

1. **Edit `scripts/02_exploratory_analysis.R`** or `scripts/04_model_evaluation.R`**:

```r
# Example: Adding a violin plot
p_new <- ggplot(data, aes(x = factor(cyl), y = mpg, fill = factor(cyl))) +
  geom_violin(alpha = 0.7) +
  geom_boxplot(width = 0.1, fill = "white", alpha = 0.5) +
  labs(title = "MPG Distribution by Cylinder (Violin Plot)",
       x = "Cylinders", y = "MPG") +
  theme_minimal()

ggsave("output/plots/custom_violin_plot.png", p_new, width = 10, height = 6)
```

### Adding Feature Engineering

To create new features:

1. **Edit `scripts/01_data_preprocessing.R`**:

```r
# Example: Creating power-to-weight ratio
data$power_to_weight <- data$hp / data$wt

# Example: Creating efficiency categories
data$efficiency_class <- cut(data$mpg,
                             breaks = quantile(data$mpg, probs = c(0, 0.25, 0.5, 0.75, 1)),
                             labels = c("Low", "Medium", "High", "Very High"),
                             include.lowest = TRUE)

# Example: Polynomial features
data$wt_squared <- data$wt^2

# Example: Interaction terms
data$hp_wt_interaction <- data$hp * data$wt
```

### Adding New Evaluation Metrics

To include additional metrics:

1. **Edit `scripts/03_prediction_models.R`** and `scripts/04_model_evaluation.R`**:

```r
# Example: Adding MAPE (Mean Absolute Percentage Error)
mape <- mean(abs((test_features$mpg - predictions$linear) / test_features$mpg)) * 100

# Example: Adding Max Error
max_error <- max(abs(predictions$linear - test_features$mpg))

# Update performance dataframe
performance$linear <- data.frame(
  Model = "Linear Regression",
  RMSE = lm_rmse,
  MAE = lm_mae,
  R_squared = lm_r2,
  MAPE = mape,
  Max_Error = max_error
)
```

## Code Style Guidelines

### R Coding Standards

1. **Naming Conventions**:
   - Variables: `snake_case` (e.g., `train_data`, `model_performance`)
   - Functions: `snake_case` (e.g., `calculate_metrics()`)
   - Constants: `UPPER_SNAKE_CASE` (e.g., `RANDOM_SEED`)

2. **Indentation**: Use 2 spaces (R standard)

3. **Comments**:
   - Use `#` for single-line comments
   - Add section headers with `# =============`
   - Document complex logic
   - Explain why, not just what

4. **Code Organization**:
   - Load libraries at the top
   - Set parameters early
   - Group related operations
   - Use meaningful variable names

### Example:

```r
# Load required libraries
library(tidyverse)
library(caret)

# Set parameters
RANDOM_SEED <- 123
TRAIN_SPLIT <- 0.8

# Set seed for reproducibility
set.seed(RANDOM_SEED)

# Load and preprocess data
data <- read.csv("data/input.csv")
data_clean <- data %>%
  filter(!is.na(target)) %>%
  mutate(feature_new = log(feature_old))
```

## Testing Your Changes

### Manual Testing Steps

1. **Test data preprocessing**:
```bash
Rscript scripts/01_data_preprocessing.R
# Check: data/ directory has CSV files
```

2. **Test visualizations**:
```bash
Rscript scripts/02_exploratory_analysis.R
# Check: output/plots/ has PNG files
```

3. **Test models**:
```bash
Rscript scripts/03_prediction_models.R
# Check: output/models/ has RData and CSV files
```

4. **Test full pipeline**:
```bash
Rscript scripts/00_main_pipeline.R
# Check: All outputs are created without errors
```

### Validation Checklist

- [ ] Code runs without errors
- [ ] All output files are created
- [ ] Plots are readable and informative
- [ ] Model performance metrics are reasonable
- [ ] Documentation is updated
- [ ] Comments explain complex logic
- [ ] Variable names are descriptive
- [ ] No hardcoded paths (use relative paths)

## Documentation Standards

### When to Update Documentation

Update documentation when you:
- Add new features
- Change existing functionality
- Add new dependencies
- Modify file structure
- Change input/output formats

### Files to Update

1. **README.md**: Overview and quick start
2. **USAGE_GUIDE.md**: Detailed instructions
3. **PROJECT_SUMMARY.md**: Methodology and findings
4. **REQUIREMENTS.txt**: New package dependencies
5. **Comments in code**: Inline documentation

## Common Pitfalls to Avoid

1. **Hardcoded Paths**: Use relative paths or parameterize
   ```r
   # Bad
   data <- read.csv("/home/user/project/data/file.csv")
   
   # Good
   data <- read.csv("data/file.csv")
   ```

2. **Not Setting Seeds**: Ensure reproducibility
   ```r
   # Always set seed before random operations
   set.seed(123)
   ```

3. **Large Files in Git**: Use .gitignore for:
   - Large datasets
   - Generated plots
   - Model files (optional)

4. **Missing Error Handling**: Add checks
   ```r
   # Check if file exists
   if (!file.exists("data/input.csv")) {
     stop("Input file not found!")
   }
   ```

## Getting Help

### Resources
- [R for Data Science](https://r4ds.had.co.nz/)
- [Advanced R](https://adv-r.hadley.nz/)
- [R Documentation](https://www.rdocumentation.org/)
- [Stack Overflow - R tag](https://stackoverflow.com/questions/tagged/r)

### Questions?
Open an issue on GitHub with:
- Clear description of the problem
- Steps to reproduce
- Expected vs actual behavior
- R version and package versions
- Error messages (if any)

## License
By contributing, you agree that your contributions will be licensed under the same license as this project.
