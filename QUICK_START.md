# Quick Start Guide

## 🚀 Get Started in 3 Steps

### Step 1: Install Dependencies
```bash
Rscript install_dependencies.R
```

### Step 2: Run the Pipeline
```bash
Rscript scripts/00_main_pipeline.R
```

### Step 3: View Results
- Check `output/plots/` for visualizations
- Check `output/models/model_performance.csv` for metrics

## 📊 What You'll Get

### Visualizations (9 plots)
1. **MPG Distribution** - Histogram of target variable
2. **Correlation Matrix** - Relationships between all variables
3. **Scatter Plots** - MPG vs Weight and Horsepower
4. **Box Plots** - MPG by Cylinders and Gears
5. **Pairs Plot** - All variable relationships
6. **Model Comparison** - RMSE and R² comparison
7. **Predicted vs Actual** - Model accuracy visualization
8. **Residual Analysis** - Error patterns
9. **Feature Importance** - Most important predictors

### Models (4 algorithms)
- Linear Regression
- Random Forest
- Ridge Regression
- Lasso Regression

### Results
- Training/Test datasets
- Model performance metrics (RMSE, MAE, R²)
- Best model identification
- Feature importance rankings

## 💡 Common Tasks

### View a Specific Script
```bash
cat scripts/01_data_preprocessing.R
```

### Run Individual Steps
```bash
Rscript scripts/01_data_preprocessing.R  # Data prep only
Rscript scripts/02_exploratory_analysis.R  # EDA only
```

### Use Your Own Data
1. Place CSV in `data/your_data.csv`
2. Edit line 17 in `scripts/01_data_preprocessing.R`:
   ```r
   data <- read.csv("data/your_data.csv")
   ```
3. Run the pipeline

## ❓ Need Help?
- Read `USAGE_GUIDE.md` for detailed instructions
- Read `PROJECT_SUMMARY.md` for methodology
- Check `REQUIREMENTS.txt` for dependencies

## 📧 Issues?
If you encounter errors:
1. Ensure R is installed (`R --version`)
2. Check all packages are installed
3. Verify you're in the project directory
4. Check file paths are correct

---
**Time to complete**: ~5-10 minutes (depending on system speed)
