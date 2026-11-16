# SPLONGGET isoforms vs the SMaHT bulk Kinnex reference: precision, recall and orthogonal support
# by isoform expression (TPM bins), COLO829 (solid) and COLO829BL (dashed) in one panel.
#
#   Recall: bulk Kinnex isoforms (T1, gene expressed in the single-cell data) binned by their bulk
#           full-length (FL) TPM; fraction recovered by the SPLONGGET isoforms.
#   Precision / orthogonal support: SPLONGGET isoforms passing the published filter, binned by their
#           own pseudobulk TPM (IsoQuant read count / all IsoQuant reads of the sample * 1e6).
#           Unmatched SPLONGGET isoforms have no bulk TPM, so each side is binned by its own expression.
#   Bins: <1, 1-5, 5-10, 10-50, 50-100, >=100 TPM (right-closed, as in cut()).
#
# Usage: Rscript kinnex_metrics_by_expression.R <benchmark_kinnex_dir> <plot_dir>
#   <benchmark_kinnex_dir>/isoquant/<sample>_isoquant_summary.tsv          overall metrics (used as a check)
#   <benchmark_kinnex_dir>/isoquant/<sample>_isoquant_query_annotated.tsv.gz  one row per SPLONGGET isoform
#   <benchmark_kinnex_dir>/truth_comparison/recall_by_bulk_tpm.tsv         recall per bulk TPM bin
# Writes <plot_dir>/kinnex_metrics_by_expression_both_lines{.png,_cairo_pdf.pdf,.tsv}

require(data.table)
require(ggplot2)
require(cowplot)

args = commandArgs(trailingOnly = TRUE)
stopifnot(length(args) == 2)
bdir = args[1]
pdir = args[2]
script_dir = dirname(sub("--file=", "", grep("--file=", commandArgs(FALSE), value = TRUE)))
source(file.path(script_dir, "..", "..", "functions", "save_and_plot.R"))

samples = c("COLO829", "COLO829BL")
tpm_breaks = c(-Inf, 1, 5, 10, 50, 100, Inf)
tpm_levels = c("<1", "1-5", "5-10", "10-50", "50-100", ">=100")
tpm_labels = c("<1", "1–5", "5–10", "10–50", "50–100", "≥100")

# ---------------------------------------------------------------------------
# Overall metrics (published filter), used to check the per-isoform table
# ---------------------------------------------------------------------------
sm = rbindlist(lapply(samples, function(s)
  fread(file.path(bdir, "isoquant", paste0(s, "_isoquant_summary.tsv")))[filter == "published"][, sample := s]))
stopifnot(nrow(sm) == 2)

# ---------------------------------------------------------------------------
# Recall by bulk isoform expression
# ---------------------------------------------------------------------------
rt = fread(file.path(bdir, "truth_comparison", "recall_by_bulk_tpm.tsv"))[truth_set == "kinnex" & arm == "isoquant"]
rt[, tpm_bin := factor(tpm_bin, levels = tpm_levels, labels = tpm_labels)]
stopifnot(nrow(rt) == 12, !anyNA(rt$tpm_bin))

# ---------------------------------------------------------------------------
# Precision and orthogonal support by SPLONGGET isoform expression
# ---------------------------------------------------------------------------
qb = rbindlist(lapply(samples, function(s) {
  q = fread(file.path(bdir, "isoquant", paste0(s, "_isoquant_query_annotated.tsv.gz")),
            select = c("n_reads", "pass_published", "matched_exact", "supported_orthogonal"))
  stopifnot(!anyNA(q$n_reads), is.logical(q$pass_published))
  q[, tpm := n_reads / sum(n_reads) * 1e6]
  q = q[pass_published == TRUE]
  # the per-isoform flags must reproduce the overall precision and orthogonal support
  r = sm[sample == s]
  stopifnot(nrow(q) == r$n_query, !anyNA(q$matched_exact), !anyNA(q$supported_orthogonal),
            abs(mean(q$matched_exact) - r$prec_exact_any) < 1e-9,
            abs(mean(q$supported_orthogonal) - r$frac_supported_orthogonal) < 1e-9)
  q[, tpm_bin := factor(cut(tpm, breaks = tpm_breaks, labels = tpm_levels), levels = tpm_levels,
                        labels = tpm_labels)]
  q[, .(n = .N, Precision = mean(matched_exact), `Orthogonal support` = mean(supported_orthogonal)),
    by = tpm_bin][, sample := s]
}))

mx = rbind(melt(qb, id.vars = c("sample", "tpm_bin", "n"), variable.name = "metric",
                value.name = "value", variable.factor = FALSE),
           rt[, .(sample, tpm_bin, n, metric = "Recall", value = recall_published)],
           use.names = TRUE)
mx[, metric := factor(metric, levels = c("Precision", "Recall", "Orthogonal support"))]
mx[, sample := factor(sample, levels = samples)]
stopifnot(nrow(mx) == 36, !anyNA(mx$tpm_bin), !anyNA(mx$metric))
setorder(mx, sample, metric, tpm_bin)
print(dcast(mx, sample + tpm_bin ~ metric, value.var = "value"))
dir.create(pdir, showWarnings = FALSE, recursive = TRUE)
fwrite(mx, file.path(pdir, "kinnex_metrics_by_expression_both_lines.tsv"), sep = "\t")

# ---------------------------------------------------------------------------
# Plot. Colour-blind safe Okabe-Ito colours plus a point shape per metric; line type per cell line.
# ---------------------------------------------------------------------------
metric_cols = setNames(c("#E69F00", "#0072B2", "#009E73"), levels(mx$metric))
metric_shapes = setNames(c(16, 17, 15), levels(mx$metric))
sample_lty = setNames(c("solid", "22"), samples)

p = ggplot(mx, aes(x = tpm_bin, y = value, colour = metric, shape = metric, linetype = sample,
                   group = interaction(metric, sample))) +
  geom_line(linewidth = 1) +
  geom_point(size = 3.2) +
  scale_colour_manual(values = metric_cols, name = NULL) +
  scale_shape_manual(values = metric_shapes, name = NULL) +
  scale_linetype_manual(values = sample_lty, name = NULL) +
  scale_y_continuous(limits = c(0, 1), expand = expansion(mult = c(0, 0.02)), labels = scales::percent) +
  guides(linetype = guide_legend(override.aes = list(shape = NA, colour = "grey20"), order = 2),
         colour = guide_legend(order = 1), shape = guide_legend(order = 1)) +
  labs(x = "Isoform expression (TPM)", y = "SPLONGGET vs bulk Kinnex",
       caption = paste0("Recall: bulk Kinnex isoforms binned by bulk full-length TPM.\n",
                        "Precision, orthogonal support: SPLONGGET isoforms binned by pseudobulk TPM.\n",
                        "COLO829BL has no matched short reads; its orthogonal support uses bulk long-read junctions only.")) +
  theme_cowplot(font_size = 14) +
  theme(text = element_text(family = "Helvetica"), legend.position = "top", legend.justification = "left",
        plot.caption = element_text(size = 10, hjust = 0, colour = "grey30"),
        axis.text.x = element_text(size = 12), legend.key.width = unit(1.6, "cm"),
        legend.box = "vertical", legend.box.just = "left", legend.spacing.y = unit(0, "pt"))

save_and_plot(p, file.path(pdir, "kinnex_metrics_by_expression_both_lines"), width = 8, height = 6.2,
              output = c("png", "cairo_pdf"))
message("done")
