library(Signac)
library(Seurat)
library(EnsDb.Hsapiens.v86)
library(Seurat)
library(BSgenome.Hsapiens.UCSC.hg38)
library(ggplot2)
library(patchwork)  # For combining plots



cd16pos_nk_cells <- "/atac/BALL/outs/consensus_peak_calling/pseudobulk_bw_files/CD16pos_NK_cells.bw"
class_mono <- "/atac/BALL/outs/consensus_peak_calling/pseudobulk_bw_files/Classical_monocytes.bw"
naiveb <-"/atac/BALL/outs/consensus_peak_calling/pseudobulk_bw_files/Naive_B_cells.bw"
non_mono <- "/atac/BALL/outs/consensus_peak_calling/pseudobulk_bw_files/Non-classical_monocytes.bw"
d0 <- "/atac/BALL/outs/consensus_peak_calling/pseudobulk_bw_files/Pro-B_cells_D0.bw"
q1 <- "/atac/BALL/outs/consensus_peak_calling/pseudobulk_bw_files/Pro-B_cells_Q1.bw"
q2 <- "/atac/BALL/outs/consensus_peak_calling/pseudobulk_bw_files/Pro-B_cells_Q2.bw"
q3 <- "/atac/BALL/outs/consensus_peak_calling/pseudobulk_bw_files/Pro-B_cells_Q3.bw"
helper <- "/atac/BALL/outs/consensus_peak_calling/pseudobulk_bw_files/Tcm_Naive_helper_T_cells.bw"
toxic <- "/atac/BALL/outs/consensus_peak_calling/pseudobulk_bw_files/Tem_Trm_cytotoxic_T_cells.bw"



track_colors <- c(
  Naive_B_cells ="#D2AF81FF",  
  CD16pos_NK_cells ="#a25cce",
  Classical_monocytes ="#94ca76", 
  Non_classical_monocytes = "#357711", 
  Tcm_Naive_helper_T_cells = "#4acabd", 
  Tem_Trm_cytotoxic_T_cells =  "#0f517e",
  Tumour_cells_D0 = "#FFA500", 
  Tumour_cells_Q1 = "#FF6347", 
  Tumour_cells_Q2 = "#DC143C",
  Tumour_cells_Q3 =  "#800101" 
)


track_list <- list(
                    CD16pos_NK_cells = cd16pos_nk_cells,
                    Non_classical_monocytes = non_mono,
                    Classical_monocytes = class_mono,
                    Tcm_Naive_helper_T_cells = helper,
                    Tem_Trm_cytotoxic_T_cells = toxic,
                    Naive_B_cells = naiveb,
                  Tumour_cells_D0 = d0,
                  Tumour_cells_Q1 = q1,
                  Tumour_cells_Q2 = q2,
                  Tumour_cells_Q3 = q3)



p_names <- ggplot() + 
   annotate("text",
      x = 0,                             
      y = rev(seq_along(track_list)),    
      label = names(track_list),         
      hjust = 0,
      size = 2)  + 
  theme_void()



# List of gene names (order must match rois)
gene_list <- c('NKG7',           # CD16+ NK cells
               'S100A12',       # classical monocytes
               'LYZ',            # monocytes
               'CCR7',           # naive T cells
               'CCL5',           # cytotoxic T cells
               'MS4A1',          # naive B cells
               'DNTT')           # cancer

# Hand-picked ROIs (order must match gene_list)
rois <- c("chr19-51370100-51375134", # NKG7
          "chr1-153371589-153378703", # S100A12
          "chr12-69346878-69350480", # LYZ
          "chr17-40548878-40572456", # CCR7
          "chr17-35876000-35882360", # CCL5
          "chr11-60454887-60456673", # MS4A1
          "chr10-96300890-96339110"  # DNTT
)

# Create a named vector for gene-specific ROIs
gene_rois <- setNames(rois, gene_list)

# dummy data for revision --> informarion on gene locations and annotations
dummy <- readRDS("dummy.rds")


create_plot <- function(gene_name, roi) {
  bigwig <- BigwigTrack(
    region = roi,
    bigwig = track_list,
    smooth = 200,
    type = "coverage",
    y_label = "",
    max.downsample = 3000,
    downsample.rate = 0.1,
    ymax = "q95") +
    scale_fill_manual(values = track_colors) +
    ggtitle(label = gene_name) +
    theme(
      legend.position = "none", # remove legend
          strip.text.y.left = element_blank(), 
          axis.ticks.x = element_blank(),       # Remove x-axis ticks
  axis.text.x = element_blank(),       
  axis.title.y = element_blank(),      
  axis.ticks.y = element_blank(),      
 axis.text.y = element_blank(),
  axis.line = element_blank(),
  axis.title.x = element_blank(), # Remove x-axis label
  plot.title = element_text(face = "italic")
          )
  # add gene annotation plot
  gene_plot <- AnnotationPlot(
    object = dummy,
    region = roi) + 
    theme(
      legend.position = "none", # remove legend
      strip.text.y.left = element_blank(), 
      axis.ticks.x = element_blank(),       # Remove x-axis ticks
      axis.text.x = element_blank(),
      axis.title.y = element_blank(),
      axis.ticks.y = element_blank(),
      axis.line = element_blank(),
      axis.title.x = element_blank(),
  )   
  
  # Combine the two plots vertically using patchwork
  	p <- CombineTracks(
	  plotlist = list(bigwig, gene_plot),
	  heights = c(6,1),
	)
  return(p)
}


# Now use gene_rois in your plotting loop
plots <- lapply(gene_list, function(gene_name) {
  roi <- gene_rois[[gene_name]]
  create_plot(gene_name, roi)
})


combined_plot <- p_names + wrap_plots(plots, nrow = 1) + plot_layout(widths = c(1, 4)) 
combined_plot


pdf("peaks_markergenes_without_y_ticks.select_regions.revision.pdf", width = 30, height = 15) 
combined_plot
dev.off()