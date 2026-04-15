# =========================================================
# FIGURE 3
# Sequential δ13C–δ18O trajectories (Red river hog)
# =========================================================
# Author: Florian Gbodja Codjia
# =========================================================

library(readxl)
library(dplyr)
library(stringr)
library(ggplot2)
library(ggrepel)

# ----------------------------
# PATHS
# ----------------------------
data_path  <- "data/raw/Isotope_biplotR.xlsx"
output_dir <- "outputs/figures/"

# ----------------------------
# LOAD + CLEAN
# ----------------------------
data <- read_excel(data_path) %>%
  rename(
    d13C = `normalised d13C vs VPDB`,
    d18O = `normalised d18O vs VPDB`
  ) %>%
  mutate(
    d13C = as.numeric(str_replace(d13C, ",", ".")),
    d18O = as.numeric(str_replace(d18O, ",", ".")),
    Specimen = str_extract(ID, "RRH-EC5-[A-Z]+3")
  ) %>%
  filter(!is.na(Specimen)) %>%
  group_by(Specimen) %>%
  mutate(position = row_number(),
         season = ifelse(d18O > mean(d18O), "Dry", "Wet")) %>%
  ungroup()

plot_data <- filter(data, Specimen %in% c("RRH-EC5-RUM3","RRH-EC5-RLM3"))

# ----------------------------
# FIGURE
# ----------------------------
p <- ggplot(plot_data, aes(d13C, d18O)) +
  geom_path(aes(color = season, group = Specimen), linewidth = 1.2) +
  geom_point(aes(shape = Specimen), size = 3) +
  geom_text_repel(aes(label = Specimen)) +
  theme_classic() +
  labs(
    x = expression(delta^{13}*C[1750]~"(‰ VPDB)"),
    y = expression(delta^{18}*O~"(‰ VPDB)")
  )

# ----------------------------
# EXPORT
# ----------------------------
ggsave(file.path(output_dir, "Figure3_RRH.png"), p, width = 9, height = 5, dpi = 400)