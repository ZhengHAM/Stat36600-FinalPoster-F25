# Output Directory

This directory contains all generated outputs from the analysis pipeline.

## Directory Structure

```
output/
├── README.md                          # This file
├── preprocessed_data.RData            # R workspace with processed data
├── summary_statistics.csv             # Summary stats by groups
├── plots/                             # All visualizations
│   ├── 01_mpg_distribution.png       # Target variable histogram
│   ├── 02_correlation_matrix.png     # Correlation heatmap
│   ├── 03_scatter_plots.png          # MPG vs Weight/HP
│   ├── 04_boxplots.png               # MPG by Cylinders/Gears
│   ├── 05_pairs_plot.png             # Pairs plot of variables
│   ├── 06_model_performance_comparison.png  # RMSE and R² bars
│   ├── 07_predicted_vs_actual.png    # Prediction accuracy
│   ├── 08_residual_analysis.png      # Residual plots
│   └── 09_feature_importance.png     # Random Forest importance
└── models/                            # Saved models and metrics
    ├── all_models.RData              # All trained models
    ├── model_performance.csv          # Performance comparison
    └── best_model_info.csv           # Best model details
```

## Generated Files

### Data Files

**preprocessed_data.RData**
- Contains: `train_data`, `test_data`, `data` objects
- Format: R workspace
- Usage: `load("output/preprocessed_data.RData")`

**summary_statistics.csv**
- Summary statistics grouped by cylinder count
- Columns: cyl, count, mean_mpg, sd_mpg, mean_hp, mean_wt

### Visualization Files

All plots are saved as PNG files with high resolution (800-1000 px).

1. **01_mpg_distribution.png**
   - Type: Histogram
   - Shows: Distribution of MPG with mean line

2. **02_correlation_matrix.png**
   - Type: Heatmap
   - Shows: Correlation coefficients between all variables

3. **03_scatter_plots.png**
   - Type: Scatter plots (2 panels)
   - Shows: MPG vs Weight and MPG vs Horsepower

4. **04_boxplots.png**
   - Type: Box plots (2 panels)
   - Shows: MPG distribution by Cylinders and Gears

5. **05_pairs_plot.png**
   - Type: Pairs plot
   - Shows: All pairwise relationships

6. **06_model_performance_comparison.png**
   - Type: Bar charts (2 panels)
   - Shows: RMSE and R² for all models

7. **07_predicted_vs_actual.png**
   - Type: Scatter plots (4 panels)
   - Shows: Predicted vs actual for each model

8. **08_residual_analysis.png**
   - Type: Residual plots (4 panels)
   - Shows: Residuals for each model

9. **09_feature_importance.png**
   - Type: Horizontal bar chart
   - Shows: Feature importance from Random Forest

### Model Files

**all_models.RData**
- Contains: `models`, `predictions`, `performance` lists
- Models included: linear, random_forest, ridge, lasso
- Usage: `load("output/models/all_models.RData")`

**model_performance.csv**
- Comparison table of all models
- Columns: Model, RMSE, MAE, R_squared
- Sorted by model name

**best_model_info.csv**
- Information about the best performing model
- Single row with metrics

## Interpreting Results

### Good Performance Indicators

**RMSE (Root Mean Squared Error)**
- Measures average prediction error
- For MPG: < 3.0 is excellent, < 5.0 is good
- Lower is better

**MAE (Mean Absolute Error)**
- Average absolute difference
- Similar interpretation to RMSE
- Lower is better

**R² (R-squared)**
- Proportion of variance explained
- > 0.8 is excellent, > 0.6 is good
- Higher is better (max = 1.0)

### Typical Results

Expected performance hierarchy:
1. **Random Forest**: Usually best (RMSE: 2-3, R²: 0.85-0.95)
2. **Ridge/Lasso**: Good balance (RMSE: 2.5-3.5, R²: 0.80-0.90)
3. **Linear Regression**: Baseline (RMSE: 3-4, R²: 0.75-0.85)

## Using the Results

### Loading Saved Data
```r
# Load preprocessed data
load("output/preprocessed_data.RData")

# Access data objects
head(train_data)
head(test_data)
```

### Loading Saved Models
```r
# Load all models
load("output/models/all_models.RData")

# Make predictions with best model
best_model <- models$random_forest
new_predictions <- predict(best_model, new_data)
```

### Reading Performance Metrics
```r
# Read model performance
performance_df <- read.csv("output/models/model_performance.csv")
print(performance_df)

# Find best model
best_idx <- which.min(performance_df$RMSE)
best_model_name <- performance_df$Model[best_idx]
```

## Troubleshooting

### Missing Files
If some files are not generated:
1. Check for error messages in console
2. Ensure all R packages are installed
3. Verify input data exists
4. Check write permissions

### Corrupted Plots
If plots look strange:
1. Ensure graphics device drivers are installed
2. Try different plot dimensions
3. Check for data quality issues

### Model Performance Issues
If all models perform poorly:
1. Check data quality and preprocessing
2. Verify target variable is correct
3. Consider feature engineering
4. Check for data leakage

## Cleanup

To remove all generated files and start fresh:

```bash
# Remove all output files (Linux/Mac)
rm -rf output/plots/*.png
rm -f output/*.RData
rm -f output/*.csv
rm -f output/models/*

# Or just delete the output directory and recreate
rm -rf output/
mkdir -p output/plots output/models
```

---

**Note**: These files are generated automatically by the analysis pipeline. Do not edit manually unless you know what you're doing.
