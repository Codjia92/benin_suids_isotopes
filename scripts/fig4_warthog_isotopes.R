# =========================================================
# FIGURE 4
# Intra-tooth isotope trajectories (warthogs)
# =========================================================
# Author: Florian Gbodja Codjia
# =========================================================

library(readxl)
library(dplyr)
library(stringr)
library(ggplot2)
library(ggrepel)

data <- read_excel("data/raw/Isotope_biplotW.xlsx") %>%
  rename(
    d13C = `normalised d13C vs VPDB`,
    d18O = `normalised d18O vs VPDB`
  ) %>%
  mutate(
    d13C = as.numeric(str_replace(d13C, ",", ".")),
    d18O = as.numeric(str_replace(d18O, ",", ".")),
    Specimen = str_extract(ID, "WH-EC[0-9]-[A-Z]+3")
  ) %>%
  group_by(Specimen) %>%
  mutate(season = ifelse(d18O > mean(d18O), "Dry", "Wet")) %>%
  ungroup()

p <- ggplot(data, aes(d13C, d18O)) +
  geom_path(aes(color = season, group = Specimen)) +
  geom_point(aes(shape = Specimen)) +
  facet_wrap(~Specimen) +
  theme_classic()

ggsave("outputs/figures/Figure4_warthog.png", p, width = 12, height = 6)