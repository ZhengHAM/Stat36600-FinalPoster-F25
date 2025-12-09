# Main Analysis Pipeline
# This script runs the complete data analysis and prediction modeling workflow

cat(strrep("=", 80), "\n", sep="")
cat("DATA ANALYSIS AND PREDICTION MODELING PROJECT\n")
cat(strrep("=", 80), "\n\n", sep="")

# Check and install required packages if necessary
required_packages <- c("tidyverse", "caret", "corrplot", "randomForest", "glmnet", "gridExtra")

cat("Checking required packages...\n")
for (pkg in required_packages) {
  if (!require(pkg, character.only = TRUE, quietly = TRUE)) {
    cat("Installing package:", pkg, "\n")
    install.packages(pkg, repos = "http://cran.r-project.org", dependencies = TRUE)
    library(pkg, character.only = TRUE)
  } else {
    cat("  ✓", pkg, "is already installed\n")
  }
}

cat("\n")

# Create necessary directories
cat("Setting up project directories...\n")
dir.create("data", showWarnings = FALSE)
dir.create("output", showWarnings = FALSE)
dir.create("output/plots", recursive = TRUE, showWarnings = FALSE)
dir.create("output/models", recursive = TRUE, showWarnings = FALSE)

cat("\n")
cat(strrep("=", 80), "\n", sep="")
cat("STEP 1: DATA PREPROCESSING\n")
cat(strrep("=", 80), "\n", sep="")
source("scripts/01_data_preprocessing.R")

cat("\n")
cat(strrep("=", 80), "\n", sep="")
cat("STEP 2: EXPLORATORY DATA ANALYSIS\n")
cat(strrep("=", 80), "\n", sep="")
source("scripts/02_exploratory_analysis.R")

cat("\n")
cat(strrep("=", 80), "\n", sep="")
cat("STEP 3: PREDICTION MODELS\n")
cat(strrep("=", 80), "\n", sep="")
source("scripts/03_prediction_models.R")

cat("\n")
cat(strrep("=", 80), "\n", sep="")
cat("STEP 4: MODEL EVALUATION\n")
cat(strrep("=", 80), "\n", sep="")
source("scripts/04_model_evaluation.R")

cat("\n")
cat(strrep("=", 80), "\n", sep="")
cat("PIPELINE COMPLETED SUCCESSFULLY!\n")
cat(strrep("=", 80), "\n\n", sep="")

cat("Results Summary:\n")
cat("- Preprocessed data: data/\n")
cat("- Visualizations: output/plots/\n")
cat("- Models: output/models/\n")
cat("- Performance metrics: output/models/model_performance.csv\n")
cat("\nCheck the output directory for all results!\n")
