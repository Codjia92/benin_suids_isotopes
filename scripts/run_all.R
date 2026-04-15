# ================================
# Benin Suids Isotopes - Main Script
# ================================

# Clean workspace
rm(list = ls())

# Load required packages
library(tidyverse)

# Create output directories if they don't exist
dir.create("outputs", showWarnings = FALSE)
dir.create("outputs/figures", showWarnings = FALSE)
dir.create("outputs/tables", showWarnings = FALSE)
dir.create("outputs/figures_finales", showWarnings = FALSE)
dir.create("outputs/tables_finales", showWarnings = FALSE)

# -------------------------------
# Load data
# -------------------------------
# Example: adjust filename if needed
data <- read.csv("data/your_data.csv")

# -------------------------------
# Data processing
# -------------------------------
# Example cleaning (adapt to your real data)
data_clean <- data %>%
  filter(!is.na(d13C), !is.na(d18O))

# -------------------------------
# Generate figure
# -------------------------------
p <- ggplot(data_clean, aes(x = d13C, y = d18O)) +
  geom_point() +

  theme_minimal()

# Save figure
ggsave("outputs/figures/isotope_scatter.png", plot = p)

# -------------------------------
# Export table
# -------------------------------
write.csv(data_clean, "outputs/tables/clean_data.csv", row.names = FALSE)

# -------------------------------
# End
# -------------------------------
cat("Analysis completed successfully.\n")


