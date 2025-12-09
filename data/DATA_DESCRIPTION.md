# Data Description

## Dataset: mtcars (Motor Trend Car Road Tests)

### Overview
The data was extracted from the 1974 Motor Trend US magazine, and comprises fuel consumption and 10 aspects of automobile design and performance for 32 automobiles (1973–74 models).

### Source
Built-in R dataset (Henderson and Velleman, 1981)

### Variables

| Variable | Description | Type | Range/Values |
|----------|-------------|------|--------------|
| **mpg** | Miles per gallon (US) | Numeric | 10.4 - 33.9 |
| **cyl** | Number of cylinders | Integer | 4, 6, 8 |
| **disp** | Displacement (cu.in.) | Numeric | 71.1 - 472.0 |
| **hp** | Gross horsepower | Numeric | 52 - 335 |
| **drat** | Rear axle ratio | Numeric | 2.76 - 4.93 |
| **wt** | Weight (1000 lbs) | Numeric | 1.513 - 5.424 |
| **qsec** | 1/4 mile time (seconds) | Numeric | 14.5 - 22.9 |
| **vs** | Engine shape (V or Straight) | Binary | 0 = V-shaped, 1 = Straight |
| **am** | Transmission type | Binary | 0 = Automatic, 1 = Manual |
| **gear** | Number of forward gears | Integer | 3, 4, 5 |
| **carb** | Number of carburetors | Integer | 1, 2, 3, 4, 6, 8 |

### Target Variable
- **mpg** (Miles per Gallon): Continuous variable representing fuel efficiency

### Prediction Task
**Regression Problem**: Predict fuel efficiency (MPG) based on vehicle characteristics

### Dataset Statistics
- **Number of observations**: 32
- **Number of features**: 10 (excluding target)
- **Missing values**: None
- **Training set**: ~26 observations (80%)
- **Test set**: ~6 observations (20%)

### Feature Correlations
Strong negative correlations with MPG:
- Weight (wt): r ≈ -0.87
- Cylinders (cyl): r ≈ -0.85
- Displacement (disp): r ≈ -0.85
- Horsepower (hp): r ≈ -0.78

Strong positive correlations with MPG:
- Rear axle ratio (drat): r ≈ 0.68
- Manual transmission (am): r ≈ 0.60

### Practical Significance
Understanding MPG predictors helps:
- Design more fuel-efficient vehicles
- Understand trade-offs (power vs efficiency)
- Make informed purchasing decisions
- Environmental impact assessment

### Engineering Context
**Key Relationships**:
- Heavier cars consume more fuel (weight effect)
- More cylinders → larger engines → lower efficiency
- Engine configuration affects performance and efficiency
- Transmission type impacts fuel consumption

### Using Your Own Dataset

To replace mtcars with your own data:

1. **Prepare your CSV file** with columns:
   - One target variable (continuous for regression)
   - Multiple predictor variables (numeric or categorical)

2. **Data requirements**:
   - No missing values (or handle them in preprocessing)
   - Numeric predictors (categorical ones can be encoded)
   - Sufficient samples (recommended: 50+ observations)

3. **File format example**:
```csv
target,feature1,feature2,feature3,...
23.5,120,3.5,1,...
18.2,150,4.0,0,...
```

4. **Update the script**: Replace `data <- mtcars` with `data <- read.csv("data/your_file.csv")`

### References
- Henderson and Velleman (1981), Building multiple regression models interactively. *Biometrics*, 37, 391–411.
- Motor Trend Magazine (1974)

---

**Note**: This is a demonstration dataset. For production use, consider:
- Larger sample sizes
- More recent data
- Domain-specific features
- Cross-validation with multiple datasets
