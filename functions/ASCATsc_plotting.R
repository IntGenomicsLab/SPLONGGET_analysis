require(ggplot2)
require(cowplot)
require(data.table)
require(RColorBrewer)
require(ggsci)

plotProfile = function(segments, raw, bins, sc = TRUE, linesize = 1) {
  # Set theme
  theme_set(theme_cowplot())

  # Process bins
  bins = bins
  segments = segments
  raw = raw
  bins[, bin := seq_along(chr)]
  bins[, end_cum := cumsum((end - start) + 1)]
  bins[, start_cum := c(1, end_cum[seq_along(end_cum)-1] + 1)]

  # Make chr_bounds
  chr_bounds = bins[, list(min = min(bin), max = max(bin), chrlen_bp = sum(end - start)), by = chr]
  chr_bounds = chr_bounds %>%
    mutate(mid = round(min + (max - min) / 2, 0),
           end_bp = cumsum(as.numeric(chrlen_bp)),
           start_bp = end_bp - chrlen_bp,
           mid_bp = round((chrlen_bp / 2) + start_bp, 0))

  if (sc) {
    # dt = cbind(bins, segments, raw * cn)
    dt = cbind(bins, segments, raw)
    setnames(dt, c("chr", "start", "end", "bin", "end_cum", "start_cum", "cn", "raw"))

    dt[, cn := ifelse(cn < 11, cn, 11)]
    dt[, col := ifelse(cn < 11, as.character(cn), "10+")]
    dt[, col := factor(col, levels = c(as.character(0:10), "10+"))]

    colors = c("#153570", "#577aba", "#c1c1c1", "#e3b55f", "#d6804f", "#b3402e",
               "#821010", "#6a0936", "#ab1964", "#b6519f", "#ad80b9", "#c2a9d1")
    names(colors) = c(as.character(0:10), "10+")

    # save plot
    plot = ggplot(dt, aes(x = bin)) +
      geom_point(aes(y = raw, color = col), size = 0.7) +
      geom_point(aes(y = cn), size = linesize) +
      scale_color_manual(values = colors, drop = FALSE) +
      scale_y_continuous(labels = scales::comma_format(accuracy = 1), breaks = scales::pretty_breaks(6), limits = c(0, 12)) +
      scale_x_continuous(expand = c(0, 0)) +
      labs(y = "Copy Number", x = "") +
      geom_vline(data = chr_bounds, aes(xintercept = max), linetype = 2) +
      geom_text(data = chr_bounds, aes(x = mid, y = -Inf, label = chr), vjust = -0.5, hjust = "center", inherit.aes = FALSE) +
      theme(legend.position = "none",
            axis.text.x = element_blank(),
            axis.ticks.x = element_blank())
  } else {
  dt = cbind(bins, segments, raw)
  setnames(dt, c("chr", "start", "end", "bin", "end_cum", "start_cum", "segment", "raw"))

  # Assign colors
  dt[segment > log2(2.5 / 2), col := "Amplification"]
  dt[segment < log2(1.5 / 2), col := "Deletion"]
  dt[is.na(col), col := "Neutral"]

  colors = c(brewer.pal(3, "Set1")[1:2], "#c1c1c1")
  names(colors) = c("Amplification", "Deletion", "Neutral")

  # save plot
  plot = ggplot(dt, aes(x = bin)) +
    geom_point(aes(y = raw, color = col), size = 0.7) +
    geom_point(aes(y = segment), size = linesize) +
    scale_color_manual(values = colors, drop = FALSE) +
    scale_y_continuous(limits = c(-4, 4), labels = scales::comma_format(accuracy = 1), breaks = scales::pretty_breaks(6)) +
    scale_x_continuous(expand = c(0, 0)) +
    labs(y = "Log2 ratio", x = "") +
    geom_vline(data = chr_bounds, aes(xintercept = max), linetype = 2) +
    geom_text(data = chr_bounds, aes(x = mid, y = -Inf, label = chr), vjust = -0.5, hjust = "center", inherit.aes = FALSE) +
    theme(legend.position = "none",
          axis.text.x = element_blank(),
          axis.ticks.x = element_blank())
  }
  return(plot)
}


# Function to plot genomewide copy number profile heatmaps
plotHeatmap = function(profiles, bins, order, dendrogram = TRUE,
                       linesize = .5, rownames = FALSE, annotation = NULL, rasterize = FALSE) {
  # Check that order is not specified while dendrogram is also requested
  if (!missing(order)) dendrogram = FALSE
  # Load libraries
  packages = c("data.table", "ggplot2", "cowplot", "tidyverse", "ggdendro", "ggrastr", "patchwork", "ggrastr")
  sapply(packages, require, character.only = TRUE)

  # Make heatmap geom based on rasterization
  if (rasterize) {
    geom_heatmap = ggrastr::rasterize(geom_linerange(aes(ymin = start_cum, ymax = end_cum, x = variable, color = value), linewidth = linesize), dpi = 300)
  } else {
    geom_heatmap = geom_linerange(aes(ymin = start_cum, ymax = end_cum, x = variable, color = value), linewidth = linesize)
  }

  # Make sure they are data.tables
  setDT(bins)
  setDT(profiles)

  # Set cowplot theme
  theme_set(theme_cowplot())
  # Get cumulative locations
  bins[, bin := seq_along(chr)]
  bins[, end_cum := cumsum((end - start) + 1)]
  bins[, start_cum := c(1, end_cum[seq_along(end_cum) - 1] + 1)]

  # Make chr_bounds
  chr_bounds = bins[, list(min = min(bin), max = max(bin), chrlen_bp = sum(end - start)), by = chr]
  chr_bounds = chr_bounds %>%
    mutate(mid = round(min + (max - min) / 2, 0),
           end_bp = cumsum(as.numeric(chrlen_bp)),
           start_bp = end_bp - chrlen_bp,
           mid_bp = round((chrlen_bp / 2) + start_bp, 0))

  #Colors
  colors = c("#153570", "#577aba", "#c1c1c1", "#e3b55f", "#d6804f", "#b3402e",
             "#821010", "#6a0936", "#ab1964", "#b6519f", "#ad80b9", "#c2a9d1")

  names(colors) = c(as.character(0:10), "10+")

  dt = data.table(cbind(bins, profiles))

  # Set Theme depending on rownames
  if (rownames) {
    custom_theme = theme(axis.ticks.y = element_blank(),
                         axis.ticks.x = element_blank(),
                         axis.title = element_blank())
  } else {
    custom_theme = theme(axis.text.y = element_blank(),
                         axis.ticks.y = element_blank(),
                         axis.ticks.x = element_blank(),
                         axis.title = element_blank())
  }


  if (dendrogram) {
    # Clustering
    hc = hclust(dist(t(dt[, 7:ncol(dt)])), method = "average")
    dhc = as.dendrogram(hc)

    # Rectangular lines
    ddata = dendro_data(dhc, type = "rectangle")

    # Plot Dendrogram
    dendro = ggplot(ggdendro::segment(ddata)) +
      geom_segment(aes(x = x, y = y, xend = xend, yend = yend)) +
      coord_flip() +
      scale_y_reverse(expand = c(0, 0)) +
      scale_x_continuous(expand = c(0.004, 0.004)) +
      theme_dendro()

    # Prepare for heatmap
    dt_melt = melt(dt, id.vars = c("chr", "start", "end", "bin", "start_cum", "end_cum"))
    dt_melt[, value := factor(value)]
    dt_melt[as.numeric(value) > 10, value := "10+"]
    dt_melt[, value := factor(value, levels = c(as.character(0:10), "10+"))]

    # Set sample order
    dt_melt[, variable := factor(variable, levels = ddata$labels$label)]

    # Plot heatmap
    heatmap = ggplot(dt_melt) +
      geom_heatmap +
      coord_flip() +
      scale_color_manual(values = colors, drop = FALSE) +
      labs(color = "Copy Number") +
      scale_y_continuous(expand = c(0, 0), labels = chr_bounds$chr, breaks = chr_bounds$mid_bp) +
      geom_hline(data = chr_bounds, aes(yintercept = end_bp), linetype = 1, linewidth = .8) +
      custom_theme


    if (!is.null(annotation)) {
      setnames(annotation, c("sample", "variable", "value"))

      # Plot annotation
      annotation[, sample := factor(sample, levels = ddata$labels$label)]
      annot_plt = ggplot(annotation, aes(x = 1, y = sample, fill = value)) +
        geom_bar(stat = "identity", width = 1) +
        scale_fill_npg() +
        theme_void() +
        theme(legend.position = "right")

      combined = dendro + annot_plt + heatmap + plot_layout(ncol = 3, widths = c(0.2, 0.05, 2), guides = "collect")

    } else {
      combined = cowplot::plot_grid(dendro, heatmap, ncol = 2, rel_widths = c(0.1, 1))
    }

    return(combined)
  }

  # Prepare for heatmap
  dt_melt = melt(dt, id.vars = c("chr", "start", "end", "bin", "start_cum", "end_cum"))
  dt_melt[, value := factor(value)]
  dt_melt[as.numeric(value) > 10, value := "10+"]
  dt_melt[, value := factor(value, levels = c(as.character(0:10), "10+"))]

  if (!missing(order)) {
    # Set sample order
    dt_melt[, variable := factor(variable, levels = order)]
  } else {
    # Clustering
    hc = hclust(dist(t(dt[, 7:ncol(dt)])), method = "average")
    dhc = as.dendrogram(hc)

    dt_melt[, variable := factor(variable, levels = labels(dhc))]
  }

  # Plot heatmap
  heatmap = ggplot(dt_melt) +
    geom_heatmap +
    coord_flip() +
    scale_color_manual(values = colors, drop = FALSE) +
    labs(color = "Copy Number") +
    scale_y_continuous(expand = c(0, 0), labels = chr_bounds$chr, breaks = chr_bounds$mid_bp) +
    geom_hline(data = chr_bounds, aes(yintercept = end_bp), linetype = 1, linewidth = .8) +
    custom_theme
  
  if (!is.null(annotation)) {
      setnames(annotation, c("sample", "variable", "value"))

      # Plot annotation
      annotation[, sample := factor(sample, levels = levels(dt_melt$variable))]
      annot_plt = ggplot(annotation, aes(x = 1, y = sample, fill = value)) +
        geom_bar(stat = "identity", width = 1) +
        scale_fill_npg() +
        theme_void() +
        theme(legend.position = "right")

      combined = annot_plt + heatmap + plot_layout(ncol = 3, widths = c(0.2, 0.05, 2), guides = "collect")

    } else {
      combined = cowplot::plot_grid(heatmap, ncol = 2, rel_widths = c(0.1, 1))
    }
  
  return(heatmap)
}
