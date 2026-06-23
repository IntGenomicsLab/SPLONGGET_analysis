library(Signac)
library(ggplot2)
library(patchwork)

rep1 <- "/atac/COLO/outs/consensus_peak_calling/pseudobulk_bw_files/COLO829_rep1.bw"
rep2 <- "/atac/COLO/outs/consensus_peak_calling/pseudobulk_bw_files/COLO829_rep2.bw"
bl <- "/atac/COLO/outs/consensus_peak_calling/pseudobulk_bw_files/COLO829BL.bw"

track_colors <- c("COLO829BL" = "#709AE1FF",
                    "COLO829_rep1" = "#8f18c7",
                    "COLO829_rep2" = "#fac710")

track_list <- list(
  COLO829BL    = bl,
  COLO829_rep1 = rep1,
  COLO829_rep2 = rep2
)

#rois <- c("chr15-39909964-39991609")
rois <- c("chr4-110569227-110687682")
# load any Signac object that has genome annotation — only used for AnnotationPlot
dummy <- readRDS("dummy.rds")

create_plot <- function(roi) {
  bigwig <- BigwigTrack(
    region          = roi,
    bigwig          = track_list,
    smooth          = 200,
    type            = "coverage",
    y_label         = "",
    max.downsample  = 3000,
    downsample.rate = 0.1,
    ymax            = "q95") +
    scale_fill_manual(values = track_colors) +
    ggtitle(label = roi) +
    theme(
      legend.position   = "none",
      strip.text.y.left = element_blank(),
      axis.ticks.x      = element_blank(),
      axis.text.x       = element_blank(),
      axis.title.y      = element_blank(),
      axis.ticks.y      = element_blank(),
      axis.text.y       = element_blank(),
      axis.line         = element_blank(),
      axis.title.x      = element_blank(),
      plot.title        = element_text(size = 8)
    )

  gene_plot <- AnnotationPlot(
    object = dummy,
    region = roi) +
    theme(
      legend.position   = "none",
      strip.text.y.left = element_blank(),
      axis.ticks.x      = element_blank(),
      axis.text.x       = element_blank(),
      axis.title.y      = element_blank(),
      axis.ticks.y      = element_blank(),
      axis.line         = element_blank(),
      axis.title.x      = element_blank()
    )

  CombineTracks(
    plotlist = list(bigwig, gene_plot),
    heights  = c(6, 1)
  )
}

plots <- lapply(rois, create_plot)

p_names <- ggplot() +
  annotate("text",
    x     = 0,
    y     = rev(seq_along(track_list)),
    label = names(track_list),
    hjust = 0,
    size  = 2) +
  theme_void()

combined_plot <- p_names + wrap_plots(plots, nrow = 1) + plot_layout(widths = c(1, 4))


pdf("peaks_rois.pdf", width = 30, height = 8)
combined_plot
dev.off()
