# =========================
# 0. PACKAGES
# =========================

# Installer si nécessaire
install.packages("readxl")
install.packages("tidyverse")

# Charger les librairies
library(readxl)
library(tidyverse)

# =========================
# 1. IMPORT DES DONNÉES (EXCEL)
# =========================
getwd()
data <- read_excel("d13c and d18o isotopes bulk values.xlsx")

# =========================
# 2. NETTOYAGE DES DONNÉES
# =========================

# Conversion des virgules en points + numérique
data <- data %>%
  mutate(
    `normalised d13C vs VPDB (permil)` = as.numeric(gsub(",", ".", `normalised d13C vs VPDB (permil)`)),
    `normalised d18O vs VPDB (permil)` = as.numeric(gsub(",", ".", `normalised d18O vs VPDB (permil)`))
  )

# Renommer les colonnes (plus simple pour analyse)
colnames(data) <- c("Specimens", "d13C", "d18O", "Country", "Location")

# Vérification
str(data)
head(data)

# =========================
# 3. STATISTIQUES DESCRIPTIVES
# =========================

summary_stats <- data %>%
  summarise(
    mean_d13C = mean(d13C, na.rm = TRUE),
    sd_d13C = sd(d13C, na.rm = TRUE),
    min_d13C = min(d13C, na.rm = TRUE),
    max_d13C = max(d13C, na.rm = TRUE),
    mean_d18O = mean(d18O, na.rm = TRUE),
    sd_d18O = sd(d18O, na.rm = TRUE),
    min_d18O = min(d18O, na.rm = TRUE),
    max_d18O = max(d18O, na.rm = TRUE)
  )

print(summary_stats)

# =========================
# 4. CORRELATION δ13C vs δ18O
# =========================

cor_test <- cor.test(data$d13C, data$d18O)
print(cor_test)

# =========================
# 5. VARIABILITÉ PAR LOCALITÉ
# =========================

site_stats <- data %>%
  group_by(Location) %>%
  summarise(
    mean_d13C = mean(d13C, na.rm = TRUE),
    sd_d13C = sd(d13C, na.rm = TRUE),
    mean_d18O = mean(d18O, na.rm = TRUE),
    sd_d18O = sd(d18O, na.rm = TRUE),
    n = n()
  )

print(site_stats)

# =========================
# 6. FIGURE PRINCIPALE (SCATTER δ13C vs δ18O)
# =========================

ggplot(data, aes(x = d13C, y = d18O, color = Location)) +
  geom_point(size = 3) +
  theme_minimal() +
  labs(
    x = expression(delta^{13}*C~"(‰ VPDB)"),
    y = expression(delta^{18}*O~"(‰ VPDB)"),
    title = "Bulk isotopic values of Benin suids"
  )

# =========================
# 7. BOXPLOTS (OPTIONNEL)
# =========================

# δ13C
ggplot(data, aes(x = Location, y = d13C, fill = Location)) +
  geom_boxplot() +
  theme_minimal() +
  labs(title = "δ13C variability by location")

# δ18O
ggplot(data, aes(x = Location, y = d18O, fill = Location)) +
  geom_boxplot() +
  theme_minimal() +
  labs(title = "δ18O variability by location")
