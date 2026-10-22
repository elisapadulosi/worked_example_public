# Worked example: temporal change in spatial beta diversity

This repository contains the code and processed data required to reproduce the worked example of temporal change in spatial beta diversity presented in the manuscript.

The example compares community ecology, landscape ecology, and remote sensing using the same four neighbouring 10 × 10 km atlas grid cells in Czechia. We study temporal change in compositional dissimilarity using breeding-bird communities, CORINE Land Cover classes, and Landsat-derived multispectral classes.

The repository contains only the processed subsets and derived products required for the worked example. The complete original datasets are not redistributed.

## Author

Worked example, data processing, analysis, and figure preparation by:

**Elisa Padulosi**  
Email: padulosi@fzp.czu.cz  
Affiliation: Faculty of Environmental Sciences, Czech University of Life Sciences Prague, Czech Republic

If you use or adapt the code or worked example from this repository, please cite the manuscript, this repository, and the original data sources listed below.

## Overview

The analysis asks whether bird communities, land-cover composition, and remotely sensed multispectral composition became more homogeneous or more differentiated between an early and a recent period.

The same four neighbouring 10 × 10 km atlas grid cells (A–D) are used for all three datasets.

For each dataset, we calculate pairwise compositional dissimilarity among the six possible pairs of grid cells separately for the two periods:

- Bird communities: **Jaccard dissimilarity**
- CORINE land-cover composition: **Ružička dissimilarity**
- Landsat-derived multispectral composition: **Ružička dissimilarity**

A decrease in pairwise dissimilarity through time indicates **spatial homogenization**, whereas an increase indicates **spatial differentiation**.

The three datasets share the same 10 × 10 km analytical grid but differ in native spatial resolution:

- Bird communities: 10 × 10 km atlas grid cell
- CORINE Land Cover: 100 m raster cells
- Landsat multispectral classes: 30 m pixels

The figure retains the real spatial arrangement of CORINE and multispectral pixels within the four selected atlas cells.

## Data included

The repository includes only the processed and derived data required to reproduce the analysis and figures, including:

- selected atlas grid cells;
- bird presence–absence data;
- the bird-species subset used for visualization;
- CORINE class composition and 100 m raster pixels;
- multispectral-class composition and 30 m classified Landsat pixels;
- pairwise dissimilarities and summary statistics.

The complete original bird-atlas, CORINE, and Landsat datasets are not included.

## Data sources, licensing, and citation

### Czech breeding-bird atlas data

Bird-community composition is represented by breeding-bird atlas presence–absence data for:

- **P1: 1985–1989**
- **P2: 2014–2017**

The Czech bird-atlas data presented here are provided under the **Creative Commons Attribution 4.0 International licence (CC BY 4.0)**.

Users of these data are encouraged to include the following acknowledgement, or a similar statement:

> “We acknowledge the thousands of volunteers without which the atlas(es) could not have happened.”

Users should also cite the relevant Czech breeding-bird atlas editions:

- Šťastný, K., Bejček, V. & Hudec, K. (1997). *Atlas hnízdního rozšíření ptáků v České republice 1985–1989*. H & H, Jinočany.
- Šťastný, K., Bejček, V., Mikuláš, I. & Telenský, T. (2021). *Atlas hnízdního rozšíření ptáků v České republice 2014–2017*. Aventinum, Praha.

The bird-atlas data and associated workflow should additionally be cited as:

**Gabriel R. Ortega-Solís, Karel Šťastný, Vladimír Bejček, Tomáš Telenský, Daniela Mellado-Mansilla, Jan Zárybnicky, Florencia Grattarola, Markéta Zárybnická, Zdeněk Vermouzek, Petr Voříšek, François Leroy, Melanie Tietje, Carmen Diana Soria, Elisa Padulosi, Eva Trávníčková, Friederike Johanna Rosa Wölke, Petr Keil. bioRxiv 2026.05.29.728651. https://doi.org/10.64898/2026.05.29.728651**

For visual clarity, we display a fixed subset of 16 species in the bird-community panels and use the same subset across all cells and both periods. We calculate pairwise bird-community dissimilarity using all bird species recorded in the four selected grid cells.

### CORINE Land Cover

We use:

- **CLC1990** as the closest available representation of the early period;
- **CLC2018** as the recent-period representation.

We summarize CORINE classes within the same four 10 × 10 km atlas grid cells and express landscape composition as the proportional cover of each class within each cell.

For the figure, we retain the original spatial arrangement of the processed **100 m CORINE raster pixels** within the four selected cells. Ružička dissimilarity is calculated from land-cover class proportions summarized at the 10 × 10 km grid-cell level.

The original CORINE products were obtained from the **Copernicus Land Monitoring Service / European Environment Agency**.

The datasets are cited as:

- **European Environment Agency. (2019). CORINE Land Cover 1990 (raster 100 m), Europe, 6-yearly—Version 2020_20u1, May 2020 (Version 20.01) [GeoTIFF]. European Environment Agency. https://doi.org/10.2909/C89324EF-7729-4477-9F1B-623F5F88EAA1**
- **European Environment Agency. (2019). CORINE Land Cover 2018 (raster 100 m), Europe, 6-yearly—Version 2020_20u1, May 2020 (Version 20.01) [GeoTIFF]. European Environment Agency. https://doi.org/10.2909/960998C1-1870-4E82-8051-6485205EBBAC**

Users should cite the original CORINE products when reusing these data or derived products.

### Landsat surface-reflectance data and multispectral classes

We derive remote-sensing composition from **Landsat Collection 2 Level-2 surface-reflectance imagery** provided by the U.S. Geological Survey.

The worked example uses:

- **P1: 1985–1989** — Landsat 5 Thematic Mapper (TM)
- **P2: 2014–2017** — Landsat 8 Operational Land Imager (OLI)

For both periods, we use June–August imagery to construct summer median surface-reflectance composites and harmonize Landsat 5 and Landsat 8 imagery to a common set of spectral bands.

For each 10 × 10 km atlas grid cell, we represent multispectral composition as the proportion of valid Landsat pixels assigned to each multispectral class and use these proportions to calculate Ružička dissimilarity.

For the figure, we retain the real spatial positions of the processed **30 m classified Landsat pixels** within the four selected cells.

The Landsat source datasets should be cited as:

- Earth Resources Observation and Science (EROS) Center. 2020a.  
  *Landsat 4–5 Thematic Mapper Level-2, Collection 2* [dataset].  
  U.S. Geological Survey.  
  https://doi.org/10.5066/P9IAXOVV

- Earth Resources Observation and Science (EROS) Center. 2020b.  
  *Landsat 8–9 Operational Land Imager / Thermal Infrared Sensor Level-2, Collection 2* [dataset].  
  U.S. Geological Survey.  
  https://doi.org/10.5066/P9OGBGM6
  
## Licence

Original materials created specifically for this repository by Elisa Padulosi are licensed under the **Creative Commons Attribution 4.0 International licence (CC BY 4.0)**, unless otherwise stated.

This licence does not override the licences or terms of use of the original datasets from which some processed or derived products were generated.

Original data remain subject to their respective licences and terms of use:

- Czech bird-atlas data: **CC BY 4.0**, subject to the attribution and citation recommendations described above.
- CORINE Land Cover: subject to the applicable Copernicus / European Environment Agency reuse conditions.
- Landsat: subject to the applicable U.S. Geological Survey data-use conditions.

Users are responsible for complying with the terms associated with each original data source.

## Reproducing the analysis

The analysis and final figure can be reproduced from the processed data included in this repository. Access to the complete original raw datasets is not required.

After cloning the repository, set the working directory to the repository root and run:

```r
source("scripts/00_setup.R")
source("scripts/01_recalculate_pairwise_dissimilarity.R")
source("scripts/02_make_worked_example_figure.R")
source("scripts/03_make_study_area_map.R")
source("scripts/04_make_final_figure.R")