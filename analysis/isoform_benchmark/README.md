# Isoform benchmark

- `kinnex_metrics_by_expression.R` - precision, recall and orthogonal support of the SPLONGGET isoforms against the SMaHT bulk Kinnex reference, by isoform expression (TPM bins), for COLO829 and COLO829BL. Recall bins the bulk isoforms by their bulk full-length TPM; precision and orthogonal support bin the SPLONGGET isoforms by their own pseudobulk TPM.

  Usage: `Rscript analysis/isoform_benchmark/kinnex_metrics_by_expression.R <benchmark_kinnex_dir> <plot_dir>`

  Inputs in `<benchmark_kinnex_dir>`:
  - `isoquant/<sample>_isoquant_summary.tsv` - overall metrics per filter
  - `isoquant/<sample>_isoquant_query_annotated.tsv.gz` - one row per SPLONGGET isoform (read count, filter, exact bulk match, orthogonal support)
  - `truth_comparison/recall_by_bulk_tpm.tsv` - recall per bulk TPM bin

  Writes `kinnex_metrics_by_expression_both_lines.png`, `_cairo_pdf.pdf` and `.tsv` to `<plot_dir>`.
