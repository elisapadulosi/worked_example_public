# =============================================================================
# 04_make_final_figure.R
#
# Combine study-area map and worked-example panels.
# =============================================================================

source("scripts/00_setup.R")

library(patchwork)


# Create main worked-example figure
source(
  "scripts/02_make_worked_example_figure.R"
)


# Create study-area map
source(
  "scripts/03_make_study_area_map.R"
)


# =============================================================================
# COMBINE
#
# Study-area map above.
# Three disciplinary panels below.
# =============================================================================

final_figure <-
  p_study_area_map /
  worked_example_figure +
  patchwork::plot_layout(
    heights = c(
      0.70,
      3.00
    )
  )


print(
  final_figure
)


# =============================================================================
# SAVE
# =============================================================================

ggplot2::ggsave(
  filename = file.path(
    dir_figures,
    "worked_example_complete.png"
  ),
  plot = final_figure,
  width = 11,
  height = 12,
  dpi = 300,
  bg = "white"
)


ggplot2::ggsave(
  filename = file.path(
    dir_figures,
    "worked_example_complete.pdf"
  ),
  plot = final_figure,
  width = 11,
  height = 12,
  device = grDevices::cairo_pdf
)


message(
  "Complete worked-example figure created."
)