# Modular main

This repository contains a modular R pipeline for classifying civil war outcomes.
The main entry point is main.Rmd, which sources individual R scripts in sequence.
The data have already been split into train and test sets in data/train.csv and
data/test.csv; rerunning data_preprocessing.R will regenerate the same 80/20 split
using a fixed random seed.

How to run

1. Open main.Rmd in RStudio.
2. Run all chunks (or knit the document) to execute the full pipeline end to end.
3. ROC plots and comparison outputs are written to the results/ directory.

ROC helper function

The helper function compute_roc_auc in helpers.R takes predicted probabilities and
binary outcomes and:
- constructs a grid of thresholds
- computes true positive rate (TPR) and false positive rate (FPR) at each threshold
- computes area under the ROC curve (AUC) using the trapezoidal rule
- selects a cutoff using Youden's J statistic and returns the associated threshold

Models

The pipeline fits several classification models to the same train/test split:
- Logistic regression (model_logistic.R)
- Unpruned decision tree (model_tree.R)
- Pruned decision tree using optimal cp from cross-validation (model_pruned_tree.R)
- Random forest (model_random_forest.R)
- k-nearest neighbors with k = 5 (model_knn.R)
- XGBoost with binary logistic objective (model_xgboost.R)

Model comparison

The script model_comparison.R assumes all model scripts have already been run in
the current session. It constructs a summary table of AUC and misclassification
rate for each model, prints the sorted results, and produces:
- all_roc_curves.png summarizing ROC curves for all models
- model_comparison.csv in the results/ directory

