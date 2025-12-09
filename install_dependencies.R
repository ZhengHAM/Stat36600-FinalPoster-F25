# Install Required R Packages
# Run this script once to install all necessary packages for the project

cat("Installing required R packages for the project...\n\n")

# List of required packages
required_packages <- c(
  "tidyverse",      # Data manipulation and visualization
  "caret",          # Machine learning framework
  "corrplot",       # Correlation plots
  "randomForest",   # Random Forest algorithm
  "glmnet",         # Ridge and Lasso regression
  "gridExtra"       # Arrange multiple plots
)

# Install packages
for (pkg in required_packages) {
  if (!require(pkg, character.only = TRUE, quietly = TRUE)) {
    cat("Installing:", pkg, "\n")
    install.packages(pkg, repos = "http://cran.r-project.org", dependencies = TRUE)
  } else {
    cat("Already installed:", pkg, "\n")
  }
}

cat("\n✓ All packages installed successfully!\n")
cat("You can now run the analysis pipeline using: Rscript scripts/00_main_pipeline.R\n")
