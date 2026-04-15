# =========================
# Author: Florian Gbodja Codjia
# =========================================================
# =========================================================
# FIGURE 7
# Climate controls on isotopes
# =========================================================

library(tidyverse)
library(readxl)

data <- read_excel("data/raw/isotope_climate.xlsx")

mod1 <- lm(d13C ~ precipitation, data = data)
mod2 <- lm(d18O ~ humidity, data = data)

summary(mod1)
summary(mod2)