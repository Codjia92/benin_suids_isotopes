# =========================================================
# FIGURE 2
# Seasonal rainfall climatology in Benin (CHIRPS v2.0, 2008–2023)
# =========================================================
# Author: Florian Gbodja Codjia
# =========================================================

rm(list = ls())
gc()

# ----------------------------
# 1. PACKAGES
# ----------------------------
library(terra)
library(sf)
library(tmap)
library(dplyr)

terraOptions(progress = 1, memfrac = 0.6)

# ----------------------------
# 2. PATHS
# ----------------------------
data_dir   <- "data/raw/chirps/"
output_dir <- "outputs/figures/"
dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)

# ----------------------------
# 3. LOAD CHIRPS DATA
# ----------------------------
gz_files <- list.files(data_dir, pattern = "\\.tif\\.gz$", full.names = TRUE)

if (length(gz_files) > 0) {
  for (f in gz_files) R.utils::gunzip(f, remove = FALSE)
}

tif_files <- list.files(data_dir, pattern = "\\.tif$", full.names = TRUE)
stopifnot(length(tif_files) > 0)

prec <- rast(tif_files)
prec[prec < 0] <- NA

# ----------------------------
# 4. TIME HANDLING
# ----------------------------
ym <- gsub("chirps-v2.0.", "", names(prec))
year  <- as.integer(substr(ym, 1, 4))
month <- as.integer(substr(ym, 6, 7))

time(prec) <- as.Date(sprintf("%04d-%02d-01", year, month))

# ----------------------------
# 5. BENIN BOUNDARY
# ----------------------------
benin <- geodata::gadm(country = "BEN", level = 0, path = "data/boundaries")
benin <- st_as_sf(benin) |> st_transform(crs(prec))

prec_benin <- crop(prec, benin) |> mask(benin)

# ----------------------------
# 6. SEASONAL CLIMATOLOGY
# ----------------------------
mo <- as.integer(format(time(prec_benin), "%m"))

season_idx <- list(
  DJF = which(mo %in% c(12,1,2)),
  MAM = which(mo %in% c(3,4,5)),
  JJA = which(mo %in% c(6,7,8)),
  SON = which(mo %in% c(9,10,11))
)

seasonal_sum <- function(r, idx) {
  tapp(r[[idx]], index = format(time(r)[idx], "%Y"), fun = sum, na.rm = TRUE)
}

prec_season_clim <- lapply(season_idx, \(i) mean(seasonal_sum(prec_benin, i)))
prec_season_clim <- rast(prec_season_clim)
names(prec_season_clim) <- names(season_idx)

# ----------------------------
# 7. STUDY SITES
# ----------------------------
sites <- data.frame(
  site = c("Agbe–Mongnigbe", "Sedje–Denou", "Trois-Rivieres"),
  lon = c(1.90, 2.41, 3.25),
  lat = c(7.17, 6.79, 10.53)
)

sites_sf <- st_as_sf(sites, coords = c("lon","lat"), crs = 4326) |>
  st_transform(crs(prec))

# ----------------------------
# 8. MAP
# ----------------------------
tmap_mode("plot")

season_map <- tm_shape(prec_season_clim) +
  tm_raster(style = "quantile", palette = "-YlGnBu", title = "Rainfall (mm)") +
  tm_shape(benin) + tm_borders(lwd = 1.2) +
  tm_shape(sites_sf) +
  tm_symbols(shape = 21, size = 0.8, fill = "red", col = "black") +
  tm_facets(ncol = 2) +
  tm_layout(frame = FALSE,
            title = "Seasonal rainfall climatology in Benin (2008–2023)")

# ----------------------------
# 9. EXPORT
# ----------------------------
tmap_save(
  season_map,
  filename = file.path(output_dir, "Figure2_CHIRPS.png"),
  dpi = 600,
  width = 18,
  height = 12,
  units = "cm"
)