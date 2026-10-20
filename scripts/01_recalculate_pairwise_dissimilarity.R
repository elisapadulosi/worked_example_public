# =============================================================================
# 01_recalculate_pairwise_dissimilarity.R
#
# Recalculate pairwise compositional dissimilarity among the four atlas cells.
#
# Metrics:
#   Bird communities          -> Jaccard dissimilarity
#   CORINE land cover         -> Ruzicka dissimilarity
#   Multispectral composition -> Ruzicka dissimilarity
#
# Output:
#   data/processed/pairwise_dissimilarity_recalculated.csv
#   data/processed/pairwise_change_summary_recalculated.csv
# =============================================================================

source("scripts/00_setup.R")


# =============================================================================
# 1. DEFINE THE SIX CELL PAIRS
# =============================================================================

cell_pairs <- combn(
  c("A", "B", "C", "D"),
  2,
  simplify = FALSE
)

pair_table <- purrr::map_dfr(
  cell_pairs,
  function(x) {
    
    tibble::tibble(
      cell_a = x[1],
      cell_b = x[2],
      pair = paste0(
        x[1],
        "\u2013",
        x[2]
      )
    )
  }
)

print(pair_table)


# =============================================================================
# 2. DISSIMILARITY FUNCTIONS
# =============================================================================

# -----------------------------------------------------------------------------
# Jaccard dissimilarity
# -----------------------------------------------------------------------------

jaccard_dissimilarity <- function(x, y) {
  
  x <- as.numeric(x > 0)
  y <- as.numeric(y > 0)
  
  intersection <- sum(
    x == 1 & y == 1,
    na.rm = TRUE
  )
  
  union <- sum(
    x == 1 | y == 1,
    na.rm = TRUE
  )
  
  if (union == 0) {
    return(NA_real_)
  }
  
  1 - intersection / union
}


# -----------------------------------------------------------------------------
# Ruzicka dissimilarity
# -----------------------------------------------------------------------------

ruzicka_dissimilarity <- function(x, y) {
  
  x <- as.numeric(x)
  y <- as.numeric(y)
  
  numerator <- sum(
    pmin(x, y),
    na.rm = TRUE
  )
  
  denominator <- sum(
    pmax(x, y),
    na.rm = TRUE
  )
  
  if (denominator == 0) {
    return(NA_real_)
  }
  
  1 - numerator / denominator
}


# =============================================================================
# 3. BIRD COMMUNITIES
# =============================================================================

bird <- readr::read_csv(
  file.path(
    dir_data_processed,
    "bird_presence_absence_2x2.csv"
  ),
  show_col_types = FALSE
) %>%
  dplyr::mutate(
    period = as.character(period),
    cell_label = as.character(cell_label),
    scientificName = as.character(scientificName),
    presence = as.numeric(presence)
  )


bird_wide <- bird %>%
  dplyr::select(
    period,
    cell_label,
    scientificName,
    presence
  ) %>%
  tidyr::pivot_wider(
    names_from = scientificName,
    values_from = presence,
    values_fill = 0
  ) %>%
  dplyr::arrange(
    period,
    cell_label
  )


bird_species_cols <- setdiff(
  names(bird_wide),
  c(
    "period",
    "cell_label"
  )
)


calculate_bird_pairs <- function(period_name) {
  
  df <- bird_wide %>%
    dplyr::filter(
      period == period_name
    )
  
  purrr::map_dfr(
    seq_len(nrow(pair_table)),
    
    function(i) {
      
      a <- pair_table$cell_a[i]
      b <- pair_table$cell_b[i]
      
      row_a <- df %>%
        dplyr::filter(
          cell_label == a
        )
      
      row_b <- df %>%
        dplyr::filter(
          cell_label == b
        )
      
      if (
        nrow(row_a) != 1 ||
        nrow(row_b) != 1
      ) {
        stop(
          "Bird data problem for pair ",
          a,
          "-",
          b,
          " in ",
          period_name
        )
      }
      
      x <- as.numeric(
        row_a[
          1,
          bird_species_cols
        ]
      )
      
      y <- as.numeric(
        row_b[
          1,
          bird_species_cols
        ]
      )
      
      tibble::tibble(
        component = "Bird communities",
        metric = "Jaccard",
        period = period_name,
        cell_a = a,
        cell_b = b,
        pair = pair_table$pair[i],
        dissimilarity = jaccard_dissimilarity(
          x,
          y
        )
      )
    }
  )
}


bird_pairwise <- purrr::map_dfr(
  c(
    "P1",
    "P2"
  ),
  calculate_bird_pairs
)


# =============================================================================
# 4. CORINE LAND COVER
# =============================================================================

corine <- readr::read_csv(
  file.path(
    dir_data_processed,
    "corine_composition_2x2.csv"
  ),
  show_col_types = FALSE
) %>%
  dplyr::mutate(
    period = as.character(period),
    cell_label = as.character(cell_label),
    corine_class = as.character(corine_class),
    proportion = as.numeric(proportion)
  )


all_corine_classes <- sort(
  unique(
    corine$corine_class
  )
)


corine_complete <- tidyr::expand_grid(
  period = c(
    "P1",
    "P2"
  ),
  
  cell_label = c(
    "A",
    "B",
    "C",
    "D"
  ),
  
  corine_class = all_corine_classes
) %>%
  dplyr::left_join(
    corine %>%
      dplyr::select(
        period,
        cell_label,
        corine_class,
        proportion
      ),
    by = c(
      "period",
      "cell_label",
      "corine_class"
    )
  ) %>%
  dplyr::mutate(
    proportion = tidyr::replace_na(
      proportion,
      0
    )
  )


corine_wide <- corine_complete %>%
  tidyr::pivot_wider(
    names_from = corine_class,
    values_from = proportion,
    values_fill = 0
  ) %>%
  dplyr::arrange(
    period,
    cell_label
  )


corine_class_cols <- setdiff(
  names(corine_wide),
  c(
    "period",
    "cell_label"
  )
)


calculate_corine_pairs <- function(period_name) {
  
  df <- corine_wide %>%
    dplyr::filter(
      period == period_name
    )
  
  purrr::map_dfr(
    seq_len(nrow(pair_table)),
    
    function(i) {
      
      a <- pair_table$cell_a[i]
      b <- pair_table$cell_b[i]
      
      row_a <- df %>%
        dplyr::filter(
          cell_label == a
        )
      
      row_b <- df %>%
        dplyr::filter(
          cell_label == b
        )
      
      if (
        nrow(row_a) != 1 ||
        nrow(row_b) != 1
      ) {
        stop(
          "CORINE data problem for pair ",
          a,
          "-",
          b,
          " in ",
          period_name
        )
      }
      
      x <- as.numeric(
        row_a[
          1,
          corine_class_cols
        ]
      )
      
      y <- as.numeric(
        row_b[
          1,
          corine_class_cols
        ]
      )
      
      tibble::tibble(
        component = "CORINE land cover",
        metric = "Ruzicka",
        period = period_name,
        cell_a = a,
        cell_b = b,
        pair = pair_table$pair[i],
        dissimilarity = ruzicka_dissimilarity(
          x,
          y
        )
      )
    }
  )
}


corine_pairwise <- purrr::map_dfr(
  c(
    "P1",
    "P2"
  ),
  calculate_corine_pairs
)


# =============================================================================
# 5. MULTISPECTRAL COMPOSITION
# =============================================================================

spectral <- readr::read_csv(
  file.path(
    dir_data_processed,
    "spectral_composition_2x2.csv"
  ),
  show_col_types = FALSE
) %>%
  dplyr::mutate(
    period = as.character(period),
    cell_label = as.character(cell_label),
    spectral_class = as.character(spectral_class),
    proportion = as.numeric(proportion)
  )


all_spectral_classes <- sort(
  unique(
    spectral$spectral_class
  )
)


spectral_complete <- tidyr::expand_grid(
  period = c(
    "P1",
    "P2"
  ),
  
  cell_label = c(
    "A",
    "B",
    "C",
    "D"
  ),
  
  spectral_class = all_spectral_classes
) %>%
  dplyr::left_join(
    spectral %>%
      dplyr::select(
        period,
        cell_label,
        spectral_class,
        proportion
      ),
    by = c(
      "period",
      "cell_label",
      "spectral_class"
    )
  ) %>%
  dplyr::mutate(
    proportion = tidyr::replace_na(
      proportion,
      0
    )
  )


spectral_wide <- spectral_complete %>%
  tidyr::pivot_wider(
    names_from = spectral_class,
    values_from = proportion,
    values_fill = 0
  ) %>%
  dplyr::arrange(
    period,
    cell_label
  )


spectral_class_cols <- setdiff(
  names(spectral_wide),
  c(
    "period",
    "cell_label"
  )
)


calculate_spectral_pairs <- function(period_name) {
  
  df <- spectral_wide %>%
    dplyr::filter(
      period == period_name
    )
  
  purrr::map_dfr(
    seq_len(nrow(pair_table)),
    
    function(i) {
      
      a <- pair_table$cell_a[i]
      b <- pair_table$cell_b[i]
      
      row_a <- df %>%
        dplyr::filter(
          cell_label == a
        )
      
      row_b <- df %>%
        dplyr::filter(
          cell_label == b
        )
      
      if (
        nrow(row_a) != 1 ||
        nrow(row_b) != 1
      ) {
        stop(
          "Spectral data problem for pair ",
          a,
          "-",
          b,
          " in ",
          period_name
        )
      }
      
      x <- as.numeric(
        row_a[
          1,
          spectral_class_cols
        ]
      )
      
      y <- as.numeric(
        row_b[
          1,
          spectral_class_cols
        ]
      )
      
      tibble::tibble(
        component = "Multispectral composition",
        metric = "Ruzicka",
        period = period_name,
        cell_a = a,
        cell_b = b,
        pair = pair_table$pair[i],
        dissimilarity = ruzicka_dissimilarity(
          x,
          y
        )
      )
    }
  )
}


spectral_pairwise <- purrr::map_dfr(
  c(
    "P1",
    "P2"
  ),
  calculate_spectral_pairs
)


# =============================================================================
# 6. COMBINE ALL THREE COMPONENTS
# =============================================================================

pairwise_all <- dplyr::bind_rows(
  bird_pairwise,
  corine_pairwise,
  spectral_pairwise
) %>%
  dplyr::arrange(
    component,
    period,
    pair
  )


if (nrow(pairwise_all) != 36) {
  stop(
    "Expected 36 pairwise observations, but found ",
    nrow(pairwise_all)
  )
}


if (
  any(
    pairwise_all$dissimilarity < 0 |
    pairwise_all$dissimilarity > 1,
    na.rm = TRUE
  )
) {
  stop(
    "At least one dissimilarity is outside the 0–1 range."
  )
}


# =============================================================================
# 7. SUMMARISE TEMPORAL CHANGE
# =============================================================================

mean_dissimilarity <- pairwise_all %>%
  dplyr::group_by(
    component,
    period
  ) %>%
  dplyr::summarise(
    mean_dissimilarity = mean(
      dissimilarity,
      na.rm = TRUE
    ),
    .groups = "drop"
  )


change_summary <- mean_dissimilarity %>%
  tidyr::pivot_wider(
    names_from = period,
    values_from = mean_dissimilarity
  ) %>%
  dplyr::mutate(
    delta = P2 - P1,
    
    interpretation = dplyr::case_when(
      delta < 0 ~ "Homogenization",
      delta > 0 ~ "Differentiation",
      TRUE ~ "No change"
    )
  )


# =============================================================================
# 8. PRINT RESULTS
# =============================================================================

message("Pairwise dissimilarities:")

print(pairwise_all)


message("Temporal-change summary:")

print(change_summary)


# =============================================================================
# 9. SAVE RECALCULATED RESULTS
# =============================================================================

readr::write_csv(
  pairwise_all,
  file.path(
    dir_data_processed,
    "pairwise_dissimilarity_recalculated.csv"
  )
)


readr::write_csv(
  change_summary,
  file.path(
    dir_data_processed,
    "pairwise_change_summary_recalculated.csv"
  )
)


message(
  "Pairwise dissimilarities recalculated successfully."
)