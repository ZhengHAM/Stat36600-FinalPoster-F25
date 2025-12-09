# Stat36600-FinalPoster-F25
## Data Analysis and Prediction Modeling Project

This project implements a comprehensive data analysis and prediction modeling pipeline in R, featuring exploratory data analysis (EDA), multiple machine learning models, and comparative evaluation.

## 📋 Project Overview

This project demonstrates a complete workflow for:
- Data preprocessing and cleaning
- Exploratory data analysis with visualizations
- Building multiple prediction models (Linear Regression, Random Forest, Ridge, Lasso)
- Model evaluation and comparison
- Feature importance analysis

The project uses the `mtcars` dataset as a demonstration, predicting fuel efficiency (MPG) based on various vehicle characteristics.

## 🗂️ Project Structure

```
Stat36600-FinalPoster-F25/
├── README.md                          # This file
├── install_dependencies.R             # Package installation script
├── data/                              # Data directory
│   ├── train_data.csv                 # Training dataset
│   ├── test_data.csv                  # Test dataset
│   └── processed_data.csv             # Full processed dataset
├── scripts/                           # R scripts
│   ├── 00_main_pipeline.R            # Main execution pipeline
│   ├── 01_data_preprocessing.R       # Data loading and preprocessing
│   ├── 02_exploratory_analysis.R     # EDA and visualizations
│   ├── 03_prediction_models.R        # Model training
│   └── 04_model_evaluation.R         # Model evaluation and comparison
└── output/                            # Output directory
    ├── plots/                         # Generated visualizations
    │   ├── 01_mpg_distribution.png
    │   ├── 02_correlation_matrix.png
    │   ├── 03_scatter_plots.png
    │   ├── 04_boxplots.png
    │   ├── 05_pairs_plot.png
    │   ├── 06_model_performance_comparison.png
    │   ├── 07_predicted_vs_actual.png
    │   ├── 08_residual_analysis.png
    │   └── 09_feature_importance.png
    └── models/                        # Saved models and results
        ├── all_models.RData
        ├── model_performance.csv
        └── best_model_info.csv
```

## 🚀 Getting Started

### Prerequisites

- R (version 4.0 or higher recommended)
- RStudio (optional, but recommended)

### Installation

1. Clone this repository:
```bash
git clone https://github.com/ZhengHAM/Stat36600-FinalPoster-F25.git
cd Stat36600-FinalPoster-F25
```

2. Install required R packages:
```r
Rscript install_dependencies.R
```

Or manually in R:
```r
install.packages(c("tidyverse", "caret", "corrplot", "randomForest", "glmnet", "gridExtra"))
```

### Running the Analysis

#### Option 1: Run Complete Pipeline
```bash
Rscript scripts/00_main_pipeline.R
```

This will execute all scripts in sequence:
1. Data preprocessing
2. Exploratory analysis
3. Model training
4. Model evaluation

#### Option 2: Run Individual Scripts
```bash
Rscript scripts/01_data_preprocessing.R
Rscript scripts/02_exploratory_analysis.R
Rscript scripts/03_prediction_models.R
Rscript scripts/04_model_evaluation.R
```

## 📊 Models Implemented

1. **Linear Regression**: Basic linear model for baseline comparison
2. **Random Forest**: Ensemble method for capturing non-linear relationships
3. **Ridge Regression**: Regularized linear model (L2 penalty)
4. **Lasso Regression**: Regularized linear model (L1 penalty)

## 📈 Evaluation Metrics

Models are evaluated using:
- **RMSE** (Root Mean Squared Error): Lower is better
- **MAE** (Mean Absolute Error): Lower is better
- **R²** (R-squared): Higher is better (closer to 1)

## 🔍 Key Features

### Data Preprocessing
- Missing value detection and handling
- Train-test split (80-20)
- Feature engineering
- Data standardization

### Exploratory Data Analysis
- Distribution analysis
- Correlation analysis
- Scatter plots and relationships
- Box plots by categories
- Pairs plots

### Model Training
- Cross-validation (5-fold)
- Hyperparameter tuning
- Model persistence

### Model Evaluation
- Performance comparison
- Predicted vs. actual plots
- Residual analysis
- Feature importance visualization

## 📝 Customization

To use your own dataset:

1. Place your CSV file in the `data/` directory
2. Modify `scripts/01_data_preprocessing.R`:
```r
# Replace this line:
data <- mtcars

# With:
data <- read.csv("data/your_dataset.csv")
```
3. Adjust the target variable and features as needed

## 📧 Contact

For questions or issues, please contact the repository owner or create an issue on GitHub.

## 📄 License

This project is for educational purposes as part of Stat36600 course.

---

**Course**: Statistics 36600  
**Term**: Fall 2025  
**Project**: Final Poster Project
