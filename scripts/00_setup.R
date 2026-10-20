# =============================================================================
# 00_setup.R
# Public worked-example project setup
# =============================================================================

dir_data_processed <- file.path(
  "data",
  "processed"
)

dir_figures <- "figures"

dir.create(
  dir_figures,
  recursive = TRUE,
  showWarnings = FALSE
)

library(dplyr)
library(tidyr)
library(readr)
library(purrr)
library(ggplot2)
library(patchwork)
library(grid)

message("Public worked-example setup loaded.")