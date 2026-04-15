# =========================
# Author: Florian Gbodja Codjia
# =========================================================
# =========================================================
# FIG S4–S6
# Climate PCA analysis
# =========================================================

library(tidyverse)
library(FactoMineR)
library(factoextra)

climate <- read_excel("data/raw/climate.xlsx")

res <- PCA(climate, scale.unit = TRUE)

fviz_pca_biplot(res)