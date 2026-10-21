# =============================================================================
# 02_make_worked_example_figure.R
#
# Create the final worked-example figure.
#
# Rows:
#   a) Community ecology
#   b) Landscape ecology
#   c) Remote sensing
#
# Left:
#   Composition in the same four atlas cells for two periods
#
# Right:
#   Pairwise dissimilarity among the six cell pairs
#
# IMPORTANT:
#   - Bird points use a fixed subset of species for visualisation only.
#   - CORINE maps use real raster pixels.
#   - Spectral maps use real 30 m spectral-class pixels.
#   - Dissimilarity calculations use the complete composition datasets.
#
# Output:
#   figures/worked_example_final.png
#   figures/worked_example_final.pdf
# =============================================================================

source("scripts/00_setup.R")


# =============================================================================
# 1. READ DATA
# =============================================================================

bird_plot <- readr::read_csv(
  file.path(
    dir_data_processed,
    "bird_composition_2x2_top_species.csv"
  ),
  show_col_types = FALSE
)

corine_pixels <- readr::read_csv(
  file.path(
    dir_data_processed,
    "corine_pixels_2x2.csv"
  ),
  show_col_types = FALSE
)

spectral_pixels <- readRDS(
  file.path(
    dir_data_processed,
    "spectral_pixels_2x2.rds"
  )
)

pairwise <- readr::read_csv(
  file.path(
    dir_data_processed,
    "pairwise_dissimilarity_recalculated.csv"
  ),
  show_col_types = FALSE
)


# =============================================================================
# 2. STANDARDISE VARIABLES
# =============================================================================

bird_plot <- bird_plot %>%
  dplyr::mutate(
    siteID = as.character(siteID),
    cell_label = as.character(cell_label),
    period = as.character(period),
    species = as.character(species),
    presence = as.numeric(presence)
  )


corine_pixels <- corine_pixels %>%
  dplyr::mutate(
    siteID = as.character(siteID),
    cell_label = as.character(cell_label),
    period = as.character(period),
    corine_class = as.character(corine_class)
  )


spectral_pixels <- spectral_pixels %>%
  dplyr::mutate(
    siteID = as.character(siteID),
    cell_label = as.character(cell_label),
    period = as.character(period),
    spectral_class = as.character(spectral_class)
  )


pairwise <- pairwise %>%
  dplyr::mutate(
    period = factor(
      period,
      levels = c("P1", "P2")
    ),
    pair = as.character(pair),
    dissimilarity = as.numeric(dissimilarity)
  )


# =============================================================================
# 3. COMMON 2 x 2 LAYOUT
#
# Geographic arrangement:
#
#       B | A
#      -------
#       D | C
#
# P1 and P2 use exactly the same arrangement.
# =============================================================================

cell_layout_base <- tibble::tibble(
  cell_label = c(
    "B",
    "A",
    "D",
    "C"
  ),
  base_x = c(
    1,
    2,
    1,
    2
  ),
  cell_y = c(
    2,
    2,
    1,
    1
  )
)


period_offsets <- tibble::tibble(
  period = c(
    "P1",
    "P2"
  ),
  x_offset = c(
    0,
    2.35
  )
)


cell_layout_period <- tidyr::crossing(
  cell_layout_base,
  period_offsets
) %>%
  dplyr::mutate(
    cell_x = base_x + x_offset
  )


# =============================================================================
# 4. PERIOD LABELS
# =============================================================================

bird_period_labels <- tibble::tibble(
  label = c(
    "1985–1989",
    "2014–2017"
  ),
  x = c(
    1.5,
    3.85
  ),
  y = 2.67
)


corine_period_labels <- tibble::tibble(
  label = c(
    "CLC1990",
    "CLC2018"
  ),
  x = c(
    1.5,
    3.85
  ),
  y = 2.67
)


spectral_period_labels <- tibble::tibble(
  label = c(
    "1985–1989",
    "2014–2017"
  ),
  x = c(
    1.5,
    3.85
  ),
  y = 2.67
)


# =============================================================================
# 5. BIRD POSITIONS
#
# Each displayed species receives one fixed position within each atlas cell.
# This position is identical across cells and periods.
# =============================================================================

species_layout <- bird_plot %>%
  dplyr::distinct(species) %>%
  dplyr::arrange(species) %>%
  dplyr::mutate(
    species_plot_id = dplyr::row_number()
  )


if (nrow(species_layout) > 16) {
  species_layout <- species_layout %>%
    dplyr::slice_head(
      n = 16
    )
}


pos_template <- tibble::tibble(
  species_plot_id = 1:16,
  
  local_x = c(
    0.20, 0.40, 0.60, 0.80,
    0.20, 0.40, 0.60, 0.80,
    0.20, 0.40, 0.60, 0.80,
    0.20, 0.40, 0.60, 0.80
  ),
  
  local_y = c(
    0.80, 0.80, 0.80, 0.80,
    0.60, 0.60, 0.60, 0.60,
    0.40, 0.40, 0.40, 0.40,
    0.20, 0.20, 0.20, 0.20
  )
)


bird_positions <- bird_plot %>%
  dplyr::filter(
    presence == 1,
    species %in% species_layout$species
  ) %>%
  dplyr::inner_join(
    species_layout,
    by = "species"
  ) %>%
  dplyr::left_join(
    pos_template,
    by = "species_plot_id"
  ) %>%
  dplyr::left_join(
    cell_layout_period,
    by = c(
      "period",
      "cell_label"
    )
  ) %>%
  dplyr::mutate(
    x_plot =
      cell_x - 0.5 + local_x,
    
    y_plot =
      cell_y - 0.5 + local_y
  )


species_colours <- setNames(
  grDevices::hcl.colors(
    nrow(species_layout),
    palette = "Dark 3"
  ),
  species_layout$species
)


# =============================================================================
# 6. POSITION REAL CORINE PIXELS IN COMMON LAYOUT
# =============================================================================

corine_plot <- corine_pixels %>%
  dplyr::left_join(
    cell_layout_period,
    by = c(
      "period",
      "cell_label"
    )
  ) %>%
  dplyr::mutate(
    x_plot =
      cell_x - 0.5 + x_local,
    
    y_plot =
      cell_y - 0.5 + y_local
  )


corine_classes <- sort(
  unique(
    corine_plot$corine_class
  )
)


corine_colours <- setNames(
  grDevices::hcl.colors(
    length(corine_classes),
    palette = "Fall"
  ),
  corine_classes
)


# =============================================================================
# 7. POSITION REAL SPECTRAL PIXELS IN COMMON LAYOUT
# =============================================================================

spectral_plot <- spectral_pixels %>%
  dplyr::left_join(
    cell_layout_period,
    by = c(
      "period",
      "cell_label"
    )
  ) %>%
  dplyr::mutate(
    x_plot =
      cell_x - 0.5 + x_local,
    
    y_plot =
      cell_y - 0.5 + y_local
  )


# Sort spectral classes numerically, not alphabetically
spectral_classes <- spectral_plot %>%
  dplyr::distinct(
    spectral_class
  ) %>%
  dplyr::mutate(
    class_number = as.numeric(
      spectral_class
    )
  ) %>%
  dplyr::arrange(
    class_number
  ) %>%
  dplyr::pull(
    spectral_class
  )


spectral_colours <- setNames(
  grDevices::hcl.colors(
    length(spectral_classes),
    palette = "Temps"
  ),
  spectral_classes
)


# =============================================================================
# 8. COMMON MAP DECORATIONS
# =============================================================================

add_cell_labels <- function(p) {
  
  # Create a simple black outline around white text
  offsets <- tibble::tibble(
    dx = c(
      -0.018,
      0.018,
      0,
      0
    ),
    dy = c(
      0,
      0,
      -0.018,
      0.018
    )
  )
  
  outline_df <- tidyr::crossing(
    cell_layout_period,
    offsets
  ) %>%
    dplyr::mutate(
      label_x =
        cell_x - 0.40 + dx,
      
      label_y =
        cell_y + 0.38 + dy
    )
  
  p +
    ggplot2::geom_text(
      data = outline_df,
      ggplot2::aes(
        x = label_x,
        y = label_y,
        label = cell_label
      ),
      inherit.aes = FALSE,
      colour = "black",
      fontface = "bold",
      size = 4.6
    ) +
    
    ggplot2::geom_text(
      data = cell_layout_period,
      ggplot2::aes(
        x = cell_x - 0.40,
        y = cell_y + 0.38,
        label = cell_label
      ),
      inherit.aes = FALSE,
      colour = "white",
      fontface = "bold",
      size = 4.6
    )
}


add_arrow <- function(p) {
  
  p +
    ggplot2::annotate(
      "segment",
      x = 2.57,
      xend = 2.78,
      y = 1.50,
      yend = 1.50,
      arrow = grid::arrow(
        length = grid::unit(
          0.20,
          "cm"
        ),
        type = "closed"
      ),
      linewidth = 1.25,
      colour = "grey35"
    )
}


common_map_theme <- function() {
  
  list(
    
    ggplot2::coord_equal(
      clip = "off"
    ),
    
    ggplot2::scale_x_continuous(
      limits = c(
        0.45,
        4.90
      ),
      breaks = NULL,
      expand = c(
        0,
        0
      )
    ),
    
    ggplot2::scale_y_continuous(
      limits = c(
        0.45,
        2.80
      ),
      breaks = NULL,
      expand = c(
        0,
        0
      )
    ),
    
    ggplot2::theme_void(
      base_size = 11
    ),
    
    ggplot2::theme(
      legend.position = "none",
      plot.margin = ggplot2::margin(
        2,
        2,
        2,
        2
      )
    )
  )
}


# =============================================================================
# 9. COMMUNITY-ECOLOGY MAP
# =============================================================================

p_bird_map <- ggplot2::ggplot() +
  
  ggplot2::geom_tile(
    data = cell_layout_period,
    ggplot2::aes(
      x = cell_x,
      y = cell_y
    ),
    fill = "grey96",
    colour = "grey25",
    linewidth = 0.65,
    width = 1,
    height = 1
  ) +
  
  ggplot2::geom_point(
    data = bird_positions,
    ggplot2::aes(
      x = x_plot,
      y = y_plot,
      fill = species
    ),
    shape = 21,
    size = 3.3,
    colour = "grey15",
    stroke = 0.25
  ) +
  
  ggplot2::geom_text(
    data = bird_period_labels,
    ggplot2::aes(
      x = x,
      y = y,
      label = label
    ),
    fontface = "bold",
    size = 3.7
  ) +
  
  ggplot2::scale_fill_manual(
    values = species_colours
  )


p_bird_map <- add_arrow(
  p_bird_map
)


# Bird labels can be black directly because the background is light
p_bird_map <- p_bird_map +
  
  ggplot2::geom_text(
    data = cell_layout_period,
    ggplot2::aes(
      x = cell_x - 0.40,
      y = cell_y + 0.38,
      label = cell_label
    ),
    fontface = "bold",
    size = 4.4,
    colour = "black"
  ) +
  
  common_map_theme()


# =============================================================================
# 10. LANDSCAPE-ECOLOGY MAP
# =============================================================================

p_corine_map <- ggplot2::ggplot() +
  
  ggplot2::geom_tile(
    data = corine_plot,
    ggplot2::aes(
      x = x_plot,
      y = y_plot,
      fill = corine_class,
      width = pixel_width,
      height = pixel_height
    ),
    colour = NA
  ) +
  
  # Explicit atlas-cell boundaries
  ggplot2::geom_tile(
    data = cell_layout_period,
    ggplot2::aes(
      x = cell_x,
      y = cell_y
    ),
    fill = NA,
    colour = "grey15",
    linewidth = 0.65,
    width = 1,
    height = 1
  ) +
  
  ggplot2::geom_text(
    data = corine_period_labels,
    ggplot2::aes(
      x = x,
      y = y,
      label = label
    ),
    fontface = "bold",
    size = 3.7
  ) +
  
  ggplot2::scale_fill_manual(
    values = corine_colours
  )


p_corine_map <- add_cell_labels(
  p_corine_map
)

p_corine_map <- add_arrow(
  p_corine_map
)

p_corine_map <- p_corine_map +
  common_map_theme()


# =============================================================================
# 11. REMOTE-SENSING MAP
#
# NOTE:
# This panel contains approximately 1.8 million 30 m pixels.
# Rendering can therefore take longer than the other panels.
# =============================================================================

p_spectral_map <- ggplot2::ggplot() +
  
  ggplot2::geom_tile(
    data = spectral_plot,
    ggplot2::aes(
      x = x_plot,
      y = y_plot,
      fill = spectral_class,
      width = pixel_width,
      height = pixel_height
    ),
    colour = NA
  ) +
  
  ggplot2::geom_tile(
    data = cell_layout_period,
    ggplot2::aes(
      x = cell_x,
      y = cell_y
    ),
    fill = NA,
    colour = "grey15",
    linewidth = 0.65,
    width = 1,
    height = 1
  ) +
  
  ggplot2::geom_text(
    data = spectral_period_labels,
    ggplot2::aes(
      x = x,
      y = y,
      label = label
    ),
    fontface = "bold",
    size = 3.7
  ) +
  
  ggplot2::scale_fill_manual(
    values = spectral_colours
  )


p_spectral_map <- add_cell_labels(
  p_spectral_map
)

p_spectral_map <- add_arrow(
  p_spectral_map
)

p_spectral_map <- p_spectral_map +
  common_map_theme()

# =============================================================================
# 12. DISCIPLINE PANEL TITLES
# =============================================================================

p_bird_map <- p_bird_map +
  ggplot2::labs(
    title = "a) Community ecology"
  ) +
  ggplot2::theme(
    plot.title = ggplot2::element_text(
      face = "bold",
      size = 12,
      hjust = 0,
      margin = ggplot2::margin(
        b = 4
      )
    )
  )


p_corine_map <- p_corine_map +
  ggplot2::labs(
    title = "b) Landscape ecology"
  ) +
  ggplot2::theme(
    plot.title = ggplot2::element_text(
      face = "bold",
      size = 12,
      hjust = 0,
      margin = ggplot2::margin(
        b = 4
      )
    )
  )


p_spectral_map <- p_spectral_map +
  ggplot2::labs(
    title = "c) Remote sensing"
  ) +
  ggplot2::theme(
    plot.title = ggplot2::element_text(
      face = "bold",
      size = 12,
      hjust = 0,
      margin = ggplot2::margin(
        b = 4
      )
    )
  )

# =============================================================================
# 13. DISSIMILARITY PANELS
# =============================================================================

component_colours <- c(
  "Bird communities" = "#E76F51",
  "CORINE land cover" = "#3B528B",
  "Multispectral composition" = "#21918C"
)


pairwise_plot <- pairwise %>%
  dplyr::mutate(
    period_x = dplyr::case_when(
      period == "P1" ~ 1,
      period == "P2" ~ 2,
      TRUE ~ NA_real_
    )
  )


# Use the same y-axis for all three disciplines.
y_upper <- max(
  pairwise_plot$dissimilarity,
  na.rm = TRUE
) * 1.15


y_upper <- max(
  y_upper,
  0.35
)


make_beta_panel <- function(
    component_name,
    show_y_axis = TRUE
) {
  
  df <- pairwise_plot %>%
    dplyr::filter(
      component == component_name
    )
  
  colour_value <- component_colours[
    component_name
  ]
  
  
  p <- ggplot2::ggplot(
    df,
    ggplot2::aes(
      x = period_x,
      y = dissimilarity,
      group = pair
    )
  ) +
    
    # Individual cell pairs
    ggplot2::geom_line(
      colour = "grey60",
      linewidth = 0.70,
      alpha = 0.90
    ) +
    
    ggplot2::geom_point(
      colour = colour_value,
      size = 2.8
    ) +
    
    # Mean pairwise dissimilarity
    ggplot2::stat_summary(
      ggplot2::aes(
        group = 1
      ),
      fun = mean,
      geom = "line",
      colour = "black",
      linewidth = 1.25
    ) +
    
    ggplot2::stat_summary(
      ggplot2::aes(
        group = 1
      ),
      fun = mean,
      geom = "point",
      colour = "black",
      size = 3.6
    ) +
    
    ggplot2::scale_x_continuous(
      breaks = c(
        1,
        2
      ),
      labels = c(
        "P1",
        "P2"
      ),
      limits = c(
        0.86,
        2.14
      ),
      expand = c(
        0,
        0
      )
    ) +
    
    ggplot2::scale_y_continuous(
      limits = c(
        0,
        y_upper
      ),
      expand = ggplot2::expansion(
        mult = c(
          0.02,
          0.05
        )
      )
    ) +
    
    ggplot2::labs(
      x = NULL,
      y = "Pairwise dissimilarity"
    ) +
    
    ggplot2::theme_minimal(
      base_size = 10
    ) +
    
    ggplot2::theme(
      panel.grid.minor = ggplot2::element_blank(),
      
      panel.grid.major.x =
        ggplot2::element_line(
          colour = "grey90"
        ),
      
      panel.grid.major.y =
        ggplot2::element_line(
          colour = "grey90"
        ),
      
      axis.text.x =
        ggplot2::element_text(
          size = 9
        ),
      
      axis.text.y =
        ggplot2::element_text(
          size = 8.5
        ),
      
      axis.title.y =
        ggplot2::element_text(
          size = 9.5
        ),
      
      plot.margin =
        ggplot2::margin(
          4,
          5,
          4,
          5
        )
    )
  
  
  if (!show_y_axis) {
    
    p <- p +
      ggplot2::labs(
        y = NULL
      ) +
      ggplot2::theme(
        axis.text.y =
          ggplot2::element_blank(),
        
        axis.ticks.y =
          ggplot2::element_blank()
      )
  }
  
  
  p
}


p_beta_bird <- make_beta_panel(
  "Bird communities",
  show_y_axis = TRUE
)

p_beta_corine <- make_beta_panel(
  "CORINE land cover",
  show_y_axis = TRUE
)

p_beta_spectral <- make_beta_panel(
  "Multispectral composition",
  show_y_axis = TRUE
)


# =============================================================================
# 14. COMBINE EACH DISCIPLINE INTO ONE ROW
# =============================================================================

row_bird <- p_bird_map +
  p_beta_bird +
  patchwork::plot_layout(
    widths = c(
      2.3,
      1
    )
  )


row_corine <- p_corine_map +
  p_beta_corine +
  patchwork::plot_layout(
    widths = c(
      2.3,
      1
    )
  )


row_spectral <- p_spectral_map +
  p_beta_spectral +
  patchwork::plot_layout(
    widths = c(
      2.3,
      1
    )
  )


# =============================================================================
# 15. FINAL FIGURE
# =============================================================================

worked_example_figure <-
  row_bird /
  row_corine /
  row_spectral +
  patchwork::plot_layout(
    heights = c(
      1,
      1,
      1
    )
  )


# =============================================================================
# 16. DISPLAY
# =============================================================================

print(
  worked_example_figure
)


# =============================================================================
# 17. SAVE
# =============================================================================

ggplot2::ggsave(
  filename = file.path(
    dir_figures,
    "worked_example_final.png"
  ),
  plot = worked_example_figure,
  width = 11,
  height = 10,
  dpi = 300,
  bg = "white"
)


ggplot2::ggsave(
  filename = file.path(
    dir_figures,
    "worked_example_final.pdf"
  ),
  plot = worked_example_figure,
  width = 11,
  height = 10,
  device = grDevices::cairo_pdf
)


message(
  "Final worked-example figure created successfully."
)