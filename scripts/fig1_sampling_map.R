# =========================================================
# FIGURE 1
# Sampling sites of Red river hog and Common warthog in Benin (West Africa)
# =========================================================
# Author: Florian Gbodja Codjia
# Description:
# This script generates the study area map showing sampling locations
# and species distribution across Benin.
# =========================================================

# ----------------------------
# 1. PACKAGES
# ----------------------------
library(sf)
library(ggplot2)
library(ggspatial)
library(cowplot)
library(rnaturalearth)
library(rnaturalearthdata)
library(png)
library(grid)

# ----------------------------
# 2. PATHS (EDITABLE)
# ----------------------------
data_dir   <- "data/raw/shapefiles/"
output_dir <- "outputs/figures/"

# ----------------------------
# 3. LOAD DATA
# ----------------------------
africa <- ne_countries(scale = "medium", continent = "Africa", returnclass = "sf")

benin <- africa[africa$name == "Benin", ]
neighbors <- africa[africa$name %in% c("Burkina Faso","Niger","Nigeria","Togo"), ]

benin_dept <- st_read(file.path(data_dir, "gadm41_BEN_1.shp"))
trois_rivieres <- st_read(file.path(data_dir, "Trois_Rivieres.shp"))

# Harmonize CRS
benin_dept <- st_transform(benin_dept, 4326)
trois_rivieres <- st_transform(trois_rivieres, 4326)

# ----------------------------
# 4. SAMPLING SITES
# ----------------------------
sites <- data.frame(
  name = c("Agbe Mongnigbe", "Sedje Denou", "Trois Rivieres"),
  lon = c(1.90, 2.41, 3.25),
  lat = c(7.17, 6.79, 10.53),
  species = c("Common warthog", "Red river hog", "Common warthog")
)

sites_sf <- st_as_sf(sites, coords = c("lon", "lat"), crs = 4326)

# ----------------------------
# 5. SPECIES ILLUSTRATIONS
# ----------------------------
warthog <- rasterGrob(readPNG(file.path(data_dir, "warthog_img.png")), interpolate = TRUE)
redhog  <- rasterGrob(readPNG(file.path(data_dir, "redhog_img.png")), interpolate = TRUE)

# ----------------------------
# 6. MAIN MAP
# ----------------------------
main_map <- ggplot() +
  
  geom_sf(data = neighbors, fill = "grey85", color = "grey60") +
  geom_sf(data = benin, fill = "grey70", color = "black", size = 0.5) +
  geom_sf(data = benin_dept, fill = "grey60", color = "white", size = 0.3) +
  geom_sf(data = trois_rivieres, fill = "#7CAE00", color = "black", size = 0.6) +
  
  # Species illustrations
  annotation_custom(warthog, xmin=1.75,xmax=2.05,ymin=7.0,ymax=7.3) +
  annotation_custom(redhog, xmin=2.30,xmax=2.60,ymin=6.6,ymax=6.9) +
  annotation_custom(warthog, xmin=3.10,xmax=3.40,ymin=10.30,ymax=10.70) +
  
  # Sampling points
  geom_sf(data = sites_sf, aes(shape = species),
          size = 4, color = "black", fill="white", stroke=1.2,
          position = position_nudge(x = 0.05, y = 0.05)) +
  
  coord_sf(xlim = c(1,4), ylim = c(6,12), expand = FALSE) +
  
  scale_shape_manual(values = c(21, 24)) +
  
  theme_minimal() +
  theme(
    panel.grid = element_blank(),
    legend.position = "right",
    legend.title = element_blank()
  ) +
  
  annotation_scale(location = "bl", width_hint = 0.3) +
  annotation_north_arrow(location = "tr")

# ----------------------------
# 7. INSET MAP (AFRICA)
# ----------------------------
inset_map <- ggplot() +
  geom_sf(data = africa, fill="grey90", color="white") +
  geom_sf(data = benin, fill="red") +
  coord_sf(xlim = c(-20, 55), ylim = c(-35, 38)) +
  theme_void()

# ----------------------------
# 8. FINAL COMPOSITION
# ----------------------------
final_map <- ggdraw() +
  draw_plot(main_map) +
  draw_plot(inset_map, x=0.02, y=0.78, width=0.23, height=0.23)

# ----------------------------
# 9. EXPORT
# ----------------------------
ggsave(
  filename = file.path(output_dir, "Figure1_sampling_map.png"),
  plot = final_map,
  width = 10,
  height = 12,
  dpi = 600
)