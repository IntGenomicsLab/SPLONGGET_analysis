# Plotting packages
require(ggplot2)
require(cowplot)
require(RColorBrewer)
require(viridis)
require(ggsci)
require(ggpubr)
require(ggdendro)
require(patchwork)
require(ggtree)
require(ggrastr)

# Data manipulation packages
require(data.table)
require(pbapply)
require(dplyr)
require(tidyr)
require(GenomicRanges)

# Other
require(ASCAT.sc)
require(schard)

# Set plotting theme
theme_set(theme_cowplot())

# Functions
source("./functions/ASCATsc_plotting.R")
source("./functions/save_and_plot.R")

# Colour themes
timepoints_cols = c("D0" = "#fac710",
										"Q1" = "#709AE1FF",
										"Q2" = "#8f18c7",
										"Q3" = "#977140")

annot_cols = c("Tumour cells (D0)" = "#FFA500",
							 "Tumour cells (Q1)" = "#FF6347",
							 "Tumour cells (Q2)" = "#DC143C",
							 "Tumour cells (Q3)" = "#800101",
							 "Classical monocytes" = "#94ca76",
							 "Tcm/Naive helper T cells" = "#4acabd",
							 "Non-classical monocytes" = "#357711",
							 "Tem/Trm cytotoxic T cells" = "#0f517e",
							 "Naive B cells" = "#D2AF81FF",
							 "CD16+ NK cells" = "#a25cce")