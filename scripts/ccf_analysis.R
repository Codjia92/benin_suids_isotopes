# ================================
# Author: Florian Gbodja Codjia
# =========================================================
# =========================================================
# TABLE 4
# Cross-correlation analysis
# =========================================================

library(readxl)
library(dplyr)

data <- read_excel("data/raw/ccf_data.xlsx")

normalize <- function(x) (x - mean(x)) / sd(x)

data <- data %>%
  group_by(ID) %>%
  mutate(
    d13C_n = normalize(d13C),
    d18O_n = normalize(d18O)
  )

ccf_res <- ccf(data$d13C_n, data$d18O_n, plot = FALSE)

print(ccf_res)