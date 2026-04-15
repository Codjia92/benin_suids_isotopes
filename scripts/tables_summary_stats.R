# =========================================================
# TABLES 2–3
# Summary statistics
# =========================================================
# Author: Florian Gbodja Codjia
# =========================================================

library(readxl)
library(dplyr)

data <- read_excel("data/raw/summary.xlsx")

summary_table <- data %>%
  group_by(ID) %>%
  summarise(
    mean = mean(d13C, na.rm = TRUE),
    sd   = sd(d13C, na.rm = TRUE)
  )

write.csv(summary_table, "outputs/tables/summary.csv")