library(Signac)
#library(Seurat)
library(EnsDb.Hsapiens.v86)
library(BSgenome.Hsapiens.UCSC.hg38)
library(ggplot2)
library(patchwork)

track_colors <- c(
  Naive_B_cells ="#D2AF81FF",  
  CD16pos_NK_cells ="#a25cce",
  Classical_monocytes ="#94ca76", 
 # Mid_erythroid = "#daa0fd", 
  Non_classical_monocytes = "#357711", 
  Tcm_Naive_helper_T_cells = "#4acabd", 
  Tcm_Naive_helper_T_cells_SPLONGGET = "#4acabd", 
  Tcm_Naive_helper_T_cells_short = "#4acabd", 
  Tem_Trm_cytotoxic_T_cells =  "#0f517e",
  Tem_Trm_cytotoxic_T_cells_short =  "#0f517e",
  Tem_Trm_cytotoxic_T_cells_SPLONGGET =  "#0f517e",
  Tumour_cells_D0 = "#FFA500", 
  Tumour_cells_Q1 = "#FF6347", 
  Tumour_cells_Q2 = "#DC143C",
  Tumour_cells_Q3_SPLONGGET =  "#800101",
  Tumour_cells_Q3_short = "#800101"
)

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

}

# Set your gene of interest and region of interest (roi)
# uncomment one of the genes of interest

# TCF4
# gene_name <- "TCF4"
# roi <- "chr18-55214622-55600117"  

# DNTT
# gene_name <- "DNTT"
# roi <- "chr10-96283747-96342171"

# ERG
# gene_name <- "ERG"
# roi <- "chr21-38365608-38516169"

# CD8A
# gene_name <- "CD8A"
# roi <- "chr2-86782605-86810396"

# CCL5
# gene_name <- "CCL5"
# roi <- "chr17-35870151-35882404"

# CCR7
gene_name <- "CCR7"
roi <- "chr17-40551769-40567472"

# adjust paths accordingly
#q3_short_tumour <- "shortread/atac/outs/consensus_peak_calling/pseudobulk_bw_files/Pro-B_cells_Q3.bw"
#q3_long_tumour <- "atac/Q3_subset/outs/consensus_peak_calling/pseudobulk_bw_files/Pro-B_cells_Q3.bw"
tcm_short <-  "shortread/atac/outs/consensus_peak_calling/pseudobulk_bw_files/Tcm_Naive_helper_T_cells.bw"
tcm_long <-  "atac/Q3_subset/outs/consensus_peak_calling/pseudobulk_bw_files/Tcm_Naive_helper_T_cells.bw"
tem_short <-  "shortread/atac/outs/consensus_peak_calling/pseudobulk_bw_files/Tem_Trm_cytotoxic_T_cells.bw"
tem_long <-  "atac/Q3_subset/outs/consensus_peak_calling/pseudobulk_bw_files/Tem_Trm_cytotoxic_T_cells.bw"


track_list <- list(Tcm_Naive_helper_T_cells_short = tcm_short,
                   Tcm_Naive_helper_T_cells_SPLONGGET = tcm_long,
                   Tem_Trm_cytotoxic_T_cells_short = tem_short,
                   Tem_Trm_cytotoxic_T_cells_SPLONGGET = tem_long)

# Create the plot
plot <- create_plot(gene_name, roi)

# Create the gene/region label for the filename (replace ":" and "-" with "_")
roi_label <- gsub("[:-]", "_", roi)
pdf_filename <- paste0("atac/figures/",
            "Tumour_Q3_", gene_name, "_", roi_label, ".pdf")

# Optionally add the track names on the left
p_names <- ggplot() + 
   annotate("text",
    x = 0,                             
    y = rev(seq_along(track_list)),    
    label = names(track_list),         
    hjust = 0,
    size = 2)  + 
  theme_void()

combined_plot <- p_names + plot + plot_layout(widths = c(1, 4))

# Save to PDF
pdf(pdf_filename, width = 30, height = 15)
print(combined_plot)
dev.off()
