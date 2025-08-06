# GRN analysis

- `01_SCENIC_plus.ipynb` - preparing input files for SCENIC+ and running SCENIC+ Snakemake pipeline
- `02_scenic_output.ipynb` - analysing and visualising output from SCENIC+ pipeline
- `03_regulon_per_chr_enrichment.ipynb` - per chromosome gene enrichment - it is based on subset SCENIC+ analysis
- `subset/01_SCENIC_plus.ipynb` - running SCENIC+ for subset of cells
- `subset/02_SCENIC_output.ipynb` - analysing and visualising output from SCENIC+ pipeline from subset of cells

The details on the environment
- `requirements_scenicplus.txt` is to be used for all the notebooks. It is the same environment as used for ATAC analysis named `requirements_pycistopic.txt`.