# Worked example: temporal change in spatial beta diversity

This repository contains the code and processed data required to reproduce the worked example of temporal change in spatial beta diversity presented in the manuscript.

The example compares community ecology, landscape ecology, and remote sensing using the same four neighbouring 10 × 10 km atlas grid cells in Czechia. We studied temporal change in compositional dissimilarity using breeding-bird communities, CORINE Land Cover classes, and Landsat-derived multispectral classes.

The repository contains only the processed subsets and derived products required for the worked example. The complete original datasets are not redistributed.

## Author

Worked example, data processing, analysis, and figure preparation by:

**Elisa Padulosi**

Email: padulosi@fzp.czu.cz  
Affiliation: Faculty of Environmental Sciences, Czech University of Life Sciences Prague, Czech Republic

If you use or adapt the code or worked example from this repository, please cite the manuscript, this repository, and the original data sources listed below.


## Overview of the worked example

The analysis asks whether bird communities, land-cover composition, and remotely sensed multispectral composition became more homogeneous or more differentiated between an early and a recent period.

The same four neighbouring 10 × 10 km atlas grid cells (A–D) are used for all three data types.

For each dataset, we calculated pairwise compositional dissimilarity among the six possible pairs of grid cells separately for the early and recent periods.

The metrics used are:

- Bird communities: **Jaccard dissimilarity**
- CORINE land-cover composition: **Ružička dissimilarity**
- Landsat-derived multispectral composition: **Ružička dissimilarity**

A decrease in pairwise dissimilarity through time is interpreted as **spatial homogenization**, whereas an increase is interpreted as **spatial differentiation**.

The three datasets differ in their native resolution, while composition and dissimilarity are summarized using the same 10 × 10 km spatial grain:

- Bird communities: 10 × 10 km atlas grid cell
- CORINE Land Cover: 100 m raster cells
- Landsat multispectral classes: 30 m pixels

The figure keeps the real spatial arrangement of CORINE and multispectral pixels within the four selected atlas cells.


## Data included in this repository

The public repository contains only the processed and derived data required to reproduce the analysis and figures.

These include:

- the identities of the four selected atlas grid cells;
- bird presence–absence data for the selected cells and periods;
- a fixed bird-species subset used only for visualization;
- CORINE land-cover composition by atlas cell;
- the real 100 m CORINE raster pixels within the four selected cells;
- Landsat-derived multispectral-class composition by atlas cell;
- the real 30 m multispectral-class pixels within the four selected cells;
- pairwise compositional dissimilarities;
- summary statistics describing temporal changes in mean pairwise dissimilarity.

The complete original bird-atlas, CORINE, and Landsat datasets are not included.


## Data sources, licensing, and citation

The worked example combines data derived from three independent sources. The original datasets remain subject to their respective licences, attribution requirements, and citation recommendations.

### Czech breeding-bird atlas data

Bird-community composition is represented by breeding-bird atlas presence–absence data for two periods:

- **P1: 1985–1989**
- **P2: 2014–2017**

The Czech bird-atlas data presented here are provided under the **Creative Commons Attribution 4.0 International licence (CC BY 4.0)**.

Users of these data are encouraged to include the following acknowledgement, or a similar statement, in products using the data:

> “We acknowledge the thousands of volunteers without which the atlas(es) could not have happened.”

Users should also cite the relevant Czech breeding-bird atlas editions:

- Šťastný, K., Bejček, V. & Hudec, K. (1997). *Atlas hnízdního rozšíření ptáků v České republice 1985–1989*. H & H, Jinočany.
- Šťastný, K., Bejček, V., Mikuláš, I. & Telenský, T. (2021). *Atlas hnízdního rozšíření ptáků v České republice 2014–2017*. Aventinum, Praha.

The bird-atlas data and associated workflow should additionally be cited as:

**Gabriel R. Ortega-Solís, Karel Šťastný, Vladimír Bejček, Tomáš Telenský, Daniela Mellado-Mansilla, Jan Zárybnicky, Florencia Grattarola, Markéta Zárybnická, Zdeněk Vermouzek, Petr Voříšek, François Leroy, Melanie Tietje, Carmen Diana Soria, Elisa Padulosi, Eva Trávníčková, Friederike Johanna Rosa Wölke, Petr Keil. bioRxiv 2026.05.29.728651. https://doi.org/10.64898/2026.05.29.728651**

For visual clarity, we display a fixed subset of 16 species in the bird-community panels of the manuscript figure and use the same subset across all cells and both periods. 

We calculate pairwise bird-community dissimilarity using all bird species recorded in the four selected grid cells, not only the species shown in the figure.


### CORINE Land Cover

Landscape composition is represented using **CORINE Land Cover (CLC)** data.

The worked example uses:

- **CLC1990** to represent the early period
- **CLC2018** to represent the recent period

We use **CLC1990** as the closest available CORINE representation of the first bird-atlas period (1985–1989), whereas we use **CLC2018** to represent land cover close to the second bird-atlas period (2014–2017).

We summarize CORINE classes within the same four 10 × 10 km atlas grid cells used for the bird data and express landscape composition as the proportional cover of each CORINE class within each grid cell.

For the manuscript figure, we also use the processed **100 m CORINE raster pixels** within the four selected atlas cells and retain their original spatial arrangement within each cell. We use these pixels only to reproduce the spatial composition panels in the figure, while we calculate Ružička dissimilarity from land-cover class proportions summarized at the 10 × 10 km grid-cell level.

We obtained the original CORINE Land Cover products from the **Copernicus Land Monitoring Service / European Environment Agency**. These products remain subject to the provider's applicable reuse and attribution conditions.

The datasets are cited in the manuscript as:

- **European Environment Agency. (2019). CORINE Land Cover 1990 (raster 100 m), Europe, 6-yearly—Version 2020_20u1, May 2020 (Version 20.01) [GeoTIFF]. European Environment Agency. https://doi.org/10.2909/C89324EF-7729-4477-9F1B-623F5F88EAA1**
- **European Environment Agency. (2019). CORINE Land Cover 2018 (raster 100 m), Europe, 6-yearly—Version 2020_20u1, May 2020 (Version 20.01) [GeoTIFF]. European Environment Agency. https://doi.org/10.2909/960998C1-1870-4E82-8051-6485205EBBAC**

Users should cite the original CORINE products when reusing these data or derived products.


### Landsat surface-reflectance data and multispectral classes

We derived remote-sensing composition from **Landsat Collection 2 Level-2 surface-reflectance imagery** provided by the U.S. Geological Survey.

The worked example uses the same temporal periods as the bird-atlas data:

- **P1: 1985–1989** — Landsat 5 Thematic Mapper (TM)
- **P2: 2014–2017** — Landsat 8 Operational Land Imager (OLI)

For both periods, we use June–August imagery to construct summer median surface-reflectance composites.

We harmonize Landsat 5 and Landsat 8 imagery to a common set of spectral bands.

For each 10 × 10 km atlas grid cell, we represent multispectral composition as the proportion of valid Landsat pixels assigned to each multispectral class. We use these proportions to calculate Ružička dissimilarity among grid cells.

For the manuscript figure, we also use the processed **30 m classified Landsat pixels** within the four selected atlas cells and retain their real spatial positions within each grid cell. The remote-sensing maps therefore show the actual spatial arrangement of the classified pixels rather than a synthetic reconstruction based on class proportions.

The Landsat source datasets should be cited as:

- Earth Resources Observation and Science (EROS) Center. 2020a.  
  *Landsat 4–5 Thematic Mapper Level-2, Collection 2* [dataset].  
  U.S. Geological Survey.  
  https://doi.org/10.5066/P9IAXOVV

- Earth Resources Observation and Science (EROS) Center. 2020b.  
  *Landsat 8–9 Operational Land Imager / Thermal Infrared Sensor Level-2, Collection 2* [dataset].  
  U.S. Geological Survey.  
  https://doi.org/10.5066/P9OGBGM6

## Reproducibility

The scripts in this repository reproduce the worked-example analysis and manuscript figure from the processed data included in the repository.

The analysis can be reproduced without access to the complete original raw datasets.

The public workflow includes scripts to:

1. recalculate pairwise Jaccard and Ružička dissimilarities from the processed composition data;
2. generate the community ecology, landscape ecology, and remote-sensing panels;
3. generate the study-area map showing the four selected atlas grid cells;
4. combine these components into the final worked-example figure.

The worked example is intended as a **small illustrative application of the conceptual framework**, rather than as a separate full-scale empirical analysis.


## Interpretation of the worked example

Mean pairwise dissimilarity among the four grid cells changed differently among the three components:

- bird-community dissimilarity decreased slightly through time, indicating weak spatial homogenization;
- CORINE land-cover dissimilarity increased, indicating spatial differentiation;
- multispectral dissimilarity increased, also indicating spatial differentiation.

The example is intended to show how the same ecological concept—temporal change in spatial beta diversity—can be applied across different disciplines even when the concepts, data, and scale differ.


## How to cite this repository and worked example

If you use or adapt the code, workflow, processed data, or worked example, please cite:

**[ZENODO REPOSITORY CITATION]**

For use of the Czech bird-atlas data, please additionally cite:

**Gabriel R. Ortega-Solís, Karel Šťastný, Vladimír Bejček, Tomáš Telenský, Daniela Mellado-Mansilla, Jan Zárybnicky, Florencia Grattarola, Markéta Zárybnická, Zdeněk Vermouzek, Petr Voříšek, François Leroy, Melanie Tietje, Carmen Diana Soria, Elisa Padulosi, Eva Trávníčková, Friederike Johanna Rosa Wölke, Petr Keil. bioRxiv 2026.05.29.728651. https://doi.org/10.64898/2026.05.29.728651**

and **the relevant atlas editions listed above.**

**Please also cite the original CORINE Land Cover and Landsat datasets when using or redistributing products derived from those sources.**


## Licence

The licence applied to the code and original materials in this repository does **not** override the licences or terms of use of the original datasets.

This repository does not redistribute the complete original datasets. It contains only the processed subsets and derived data products required to reproduce the worked example.

Original data remain subject to their respective licences and terms of use:

- Czech bird-atlas data: **CC BY 4.0**, subject to the attribution and citation recommendations described above.
- CORINE Land Cover: subject to the applicable Copernicus / European Environment Agency reuse conditions.
- Landsat: subject to the applicable U.S. Geological Survey data-use conditions.

Original materials and derived data products produced specifically for this repository by Elisa Padulosi are licensed under **CC BY 4.0**, except where they incorporate or depend on third-party data subject to separate terms.

Users are responsible for complying with the terms associated with each original data source.