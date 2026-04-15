# =========================================================
# FIGURE 5
# δ13C and δ18O profiles along enamel
# =========================================================
# Author: Florian Gbodja Codjia
# =========================================================

library(readxl)
library(dplyr)
library(ggplot2)

data <- read_excel("data/raw/Stable carbon isotope values_All.xlsx")

data <- data %>%
  filter(tooth == "M3") %>%
  rename(
    d13C = d13cv_pdb,
    d18O = d18ov_pdb,
    dist = dist_erj_mm
  )

p <- ggplot(data, aes(dist, d13C)) +
  geom_line() +
  facet_wrap(~id) +
  theme_bw()

ggsave("outputs/figures/Figure5_profiles.png", p)