# =============================================================================
# 03_make_study_area_map.R
#
# Study-area map with zoomed inset for the 2 x 2 worked example.
#
# Output object:
#   p_study_area_map
# =============================================================================

source("scripts/00_setup.R")

library(sf)
library(dplyr)
library(readr)
library(ggplot2)
library(patchwork)
library(rnaturalearth)
library(rnaturalearthdata)
# =============================================================================
# 1. PATHS
# =============================================================================

grid_path <- file.path(
  dir_data_processed,
  "atlas_grid_10km.gpkg"
)

selected_cells_path <- file.path(
  dir_data_processed,
  "selected_2x2_cells.gpkg"
)


if (!file.exists(grid_path)) {
  stop(
    "Atlas grid not found: ",
    grid_path
  )
}

if (!file.exists(selected_cells_path)) {
  stop(
    "Selected cells not found: ",
    selected_cells_path
  )
}


# =============================================================================
# 2. READ GRID AND SELECTED CELLS
# =============================================================================

grid <- sf::st_read(
  grid_path,
  quiet = TRUE
) %>%
  dplyr::mutate(
    siteID = as.character(siteID)
  ) %>%
  sf::st_make_valid()


selected_grid <- sf::st_read(
  selected_cells_path,
  quiet = TRUE
) %>%
  dplyr::mutate(
    siteID = as.character(siteID),
    cell_label = as.character(cell_label)
  ) %>%
  sf::st_make_valid()


if (nrow(selected_grid) != 4) {
  stop(
    "Expected four selected grid cells, but found ",
    nrow(selected_grid),
    "."
  )
}


# =============================================================================
# 3. CZECHIA BOUNDARY
# =============================================================================

cz_boundary <- rnaturalearth::ne_countries(
  country = "Czechia",
  scale = "medium",
  returnclass = "sf"
)


cz_boundary <- sf::st_transform(
  cz_boundary,
  sf::st_crs(grid)
)


# =============================================================================
# 4. BOUNDING BOXES
# =============================================================================

selected_bbox <- sf::st_bbox(
  selected_grid
)

x_range <-
  selected_bbox["xmax"] -
  selected_bbox["xmin"]

y_range <-
  selected_bbox["ymax"] -
  selected_bbox["ymin"]


# Small box around selected cells shown on national map
selected_bbox_main <- selected_bbox

selected_bbox_main["xmin"] <-
  selected_bbox["xmin"] -
  0.10 * x_range

selected_bbox_main["xmax"] <-
  selected_bbox["xmax"] +
  0.10 * x_range

selected_bbox_main["ymin"] <-
  selected_bbox["ymin"] -
  0.10 * y_range

selected_bbox_main["ymax"] <-
  selected_bbox["ymax"] +
  0.10 * y_range


selected_bbox_main_sf <- sf::st_as_sfc(
  selected_bbox_main
) %>%
  sf::st_sf(
    geometry = .
  ) %>%
  sf::st_set_crs(
    sf::st_crs(grid)
  )


# Larger extent for zoom panel
selected_bbox_zoom <- selected_bbox

selected_bbox_zoom["xmin"] <-
  selected_bbox["xmin"] -
  0.70 * x_range

selected_bbox_zoom["xmax"] <-
  selected_bbox["xmax"] +
  0.70 * x_range

selected_bbox_zoom["ymin"] <-
  selected_bbox["ymin"] -
  0.70 * y_range

selected_bbox_zoom["ymax"] <-
  selected_bbox["ymax"] +
  0.70 * y_range


selected_label_points <- sf::st_point_on_surface(
  selected_grid
)


# =============================================================================
# 5. MAIN CZECHIA MAP
# =============================================================================

p_map_main <- ggplot2::ggplot() +
  
  ggplot2::geom_sf(
    data = cz_boundary,
    fill = "white",
    colour = "grey30",
    linewidth = 0.45
  ) +
  
  ggplot2::geom_sf(
    data = grid,
    fill = NA,
    colour = "grey75",
    linewidth = 0.10
  ) +
  
  ggplot2::geom_sf(
    data = selected_grid,
    fill = "#E76F51",
    colour = "black",
    linewidth = 0.45,
    alpha = 0.95
  ) +
  
  ggplot2::geom_sf(
    data = selected_bbox_main_sf,
    fill = NA,
    colour = "black",
    linewidth = 0.8
  ) +
  
  ggplot2::coord_sf(
    datum = NA
  ) +
  
  ggplot2::labs(
    title = "Worked-example location",
    subtitle = "Four neighbouring 10 × 10 km atlas grid cells in Czechia",
    x = NULL,
    y = NULL
  ) +
  
  ggplot2::theme_void(
    base_size = 10
  ) +
  
  ggplot2::theme(
    plot.title = ggplot2::element_text(
      face = "bold",
      size = 11
    ),
    
    plot.subtitle = ggplot2::element_text(
      size = 9
    ),
    
    plot.margin = ggplot2::margin(
      2,
      2,
      2,
      2
    )
  )


# =============================================================================
# 6. ZOOM
# =============================================================================

p_map_zoom <- ggplot2::ggplot() +
  
  ggplot2::geom_sf(
    data = grid,
    fill = NA,
    colour = "grey70",
    linewidth = 0.18
  ) +
  
  ggplot2::geom_sf(
    data = selected_grid,
    fill = "#E76F51",
    colour = "black",
    linewidth = 0.70,
    alpha = 0.90
  ) +
  
  ggplot2::geom_sf_text(
    data = selected_label_points,
    ggplot2::aes(
      label = cell_label
    ),
    colour = "white",
    fontface = "bold",
    size = 4.2
  ) +
  
  ggplot2::coord_sf(
    xlim = c(
      selected_bbox_zoom["xmin"],
      selected_bbox_zoom["xmax"]
    ),
    ylim = c(
      selected_bbox_zoom["ymin"],
      selected_bbox_zoom["ymax"]
    ),
    datum = NA
  ) +
  
  ggplot2::labs(
    title = "Zoom",
    x = NULL,
    y = NULL
  ) +
  
  ggplot2::theme_void(
    base_size = 10
  ) +
  
  ggplot2::theme(
    plot.title = ggplot2::element_text(
      face = "bold",
      size = 10,
      hjust = 0.5
    ),
    
    panel.border = ggplot2::element_rect(
      colour = "black",
      fill = NA,
      linewidth = 0.7
    ),
    
    plot.margin = ggplot2::margin(
      2,
      2,
      2,
      2
    )
  )


# =============================================================================
# 7. COMBINE
# =============================================================================

p_study_area_map <-
  p_map_main |
  p_map_zoom


p_study_area_map <-
  p_study_area_map +
  patchwork::plot_layout(
    widths = c(
      1.35,
      1
    )
  )


print(
  p_study_area_map
)


# =============================================================================
# 8. SAVE STANDALONE VERSION
# =============================================================================

dir.create(
  file.path(
    dir_figures,
    "study_area"
  ),
  recursive = TRUE,
  showWarnings = FALSE
)


ggplot2::ggsave(
  filename = file.path(
    dir_figures,
    "study_area",
    "worked_example_study_area_map_with_zoom.png"
  ),
  plot = p_study_area_map,
  width = 7.4,
  height = 3.8,
  dpi = 300,
  bg = "white"
)


message(
  "Study-area map created as object: p_study_area_map"
)