# Usage Guide

## Quick Start

### 1. Installation
```bash
# Install R dependencies
Rscript install_dependencies.R
```

### 2. Run the Complete Pipeline
```bash
# Run all analysis steps
Rscript scripts/00_main_pipeline.R
```

## Detailed Workflow

### Step 1: Data Preprocessing
This script loads the data, checks for missing values, performs feature engineering, and creates train-test splits.

```bash
Rscript scripts/01_data_preprocessing.R
```

**Output:**
- `data/train_data.csv` - Training set (80% of data)
- `data/test_data.csv` - Test set (20% of data)
- `data/processed_data.csv` - Full processed dataset
- `output/preprocessed_data.RData` - R workspace with data objects

### Step 2: Exploratory Data Analysis
Generates comprehensive visualizations and summary statistics.

```bash
Rscript scripts/02_exploratory_analysis.R
```

**Output:**
- `output/plots/01_mpg_distribution.png` - Histogram of target variable
- `output/plots/02_correlation_matrix.png` - Correlation heatmap
- `output/plots/03_scatter_plots.png` - Scatter plots of key relationships
- `output/plots/04_boxplots.png` - Box plots by categorical variables
- `output/plots/05_pairs_plot.png` - Pairs plot of all numeric variables
- `output/summary_statistics.csv` - Summary statistics by groups

### Step 3: Prediction Models
Trains multiple machine learning models with cross-validation.

```bash
Rscript scripts/03_prediction_models.R
```

**Models trained:**
1. Linear Regression
2. Random Forest (500 trees)
3. Ridge Regression (tuned alpha=0)
4. Lasso Regression (tuned alpha=1)

**Output:**
- `output/models/all_models.RData` - All trained models
- `output/models/model_performance.csv` - Performance metrics for all models

### Step 4: Model Evaluation
Compares models and generates evaluation visualizations.

```bash
Rscript scripts/04_model_evaluation.R
```

**Output:**
- `output/plots/06_model_performance_comparison.png` - Bar charts comparing RMSE and R²
- `output/plots/07_predicted_vs_actual.png` - Predicted vs. actual scatter plots
- `output/plots/08_residual_analysis.png` - Residual plots for all models
- `output/plots/09_feature_importance.png` - Feature importance from Random Forest
- `output/models/best_model_info.csv` - Best model information

## Using Your Own Data

### Method 1: Replace the Dataset
1. Place your CSV file in `data/your_data.csv`
2. Edit `scripts/01_data_preprocessing.R`:
   ```r
   # Change line ~17 from:
   data <- mtcars
   
   # To:
   data <- read.csv("data/your_data.csv")
   ```

### Method 2: Modify the Target Variable
If your target variable is not `mpg`, update these lines in all scripts:
- In `01_data_preprocessing.R`: Change the partitioning variable
- In `03_prediction_models.R`: Update the formula `mpg ~ .` to `your_target ~ .`
- In `04_model_evaluation.R`: Update references to the target variable

## Interpreting Results

### Model Performance Metrics

**RMSE (Root Mean Squared Error):**
- Measures average prediction error
- Lower values indicate better performance
- Unit: Same as target variable (e.g., MPG)

**MAE (Mean Absolute Error):**
- Average absolute difference between predictions and actual values
- Less sensitive to outliers than RMSE
- Lower values indicate better performance

**R² (R-squared):**
- Proportion of variance explained by the model
- Range: 0 to 1 (higher is better)
- 0.8+ is considered good for most applications

### Choosing the Best Model

The best model is typically the one with:
- Lowest RMSE/MAE
- Highest R²
- Good balance between bias and variance

Consider:
- **Linear Regression**: Interpretable, fast, works well with linear relationships
- **Random Forest**: Handles non-linearity, robust to outliers, less interpretable
- **Ridge/Lasso**: Good for high-dimensional data, prevents overfitting

## Troubleshooting

### Package Installation Issues
```r
# Try installing packages individually
install.packages("tidyverse", dependencies = TRUE)
install.packages("caret", dependencies = TRUE)
# ... etc
```

### Memory Issues
If you encounter memory issues with large datasets:
- Reduce the number of trees in Random Forest (ntree parameter)
- Use a smaller sample of data for training
- Increase system memory allocation to R

### Path Issues
Make sure you're running scripts from the project root directory:
```bash
cd /path/to/Stat36600-FinalPoster-F25
Rscript scripts/00_main_pipeline.R
```

## Advanced Usage

### Running in RStudio
1. Open RStudio
2. Set working directory: `setwd("/path/to/project")`
3. Open and run scripts interactively
4. View plots in the Plots pane

### Customizing Models

To add your own model to the pipeline, edit `scripts/03_prediction_models.R`:

```r
# Example: Adding SVM
library(e1071)

svm_model <- svm(mpg ~ ., data = train_features, kernel = "radial")
models$svm <- svm_model
predictions$svm <- predict(svm_model, test_features)

# Calculate and store performance metrics
svm_rmse <- sqrt(mean((predictions$svm - test_features$mpg)^2))
svm_r2 <- cor(predictions$svm, test_features$mpg)^2

performance$svm <- data.frame(
  Model = "SVM",
  RMSE = svm_rmse,
  R_squared = svm_r2
)
```

### Hyperparameter Tuning

The Ridge and Lasso models use automatic hyperparameter tuning. To customize:

```r
# In scripts/03_prediction_models.R, modify the tuneGrid:
ridge_model <- train(mpg ~ .,
                     data = train_features,
                     method = "glmnet",
                     tuneGrid = expand.grid(
                       alpha = 0,
                       lambda = seq(0.001, 2, length = 50)  # Try more lambda values
                     ),
                     trControl = ctrl)
```

## References

- [R for Data Science](https://r4ds.had.co.nz/)
- [caret package documentation](https://topepo.github.io/caret/)
- [tidyverse documentation](https://www.tidyverse.org/)
- [Random Forest algorithm](https://www.stat.berkeley.edu/~breiman/RandomForests/)
