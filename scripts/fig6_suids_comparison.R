# =========================================================
# FIGURE 6
# δ13C variation across African suids
# =========================================================

library(tidyverse)
library(readxl)
library(janitor)

data <- read_excel("data/raw/Stable carbon isotope values_All.xlsx") %>%
  clean_names()

p <- ggplot(data, aes(species_scientific_name_or_taxon, d13cv_pdb)) +
  geom_boxplot() +
  coord_flip() +
  theme_classic()

ggsave("outputs/figures/Figure6_suids.png", p)