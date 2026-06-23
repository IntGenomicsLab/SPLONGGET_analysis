# ATAC analysis

### file list and description 


- `BALL/01_bam_filtering.ipynb` - filtering the bam files based on the sequence length <br>
- `BALL/02_fragment_creation.ipynb` - running SnapATAC2 <br>
- `BALL/02b_fragment_wrangling.ipynb` - wrangling the SnapATAC2 fragment files to make them compatible with pycistopic <br>
- `BALL/03_pycistopic.ipynb` - running pycistopic up to topic modelling  <br>
- `BALL/03a_pycistopic_modelling.slurm` - topic modelling slurm submission file <br>
- `BALL/03b_pycistopic_modelling.py` - topic modelling script <br>
- `BALL/04_pycistopic_post_modelling.ipynb` - post topic modelling analysis <br>
- `atac/BALL/D0_Q1_subset/01_subset_cistopic.ipynb` - subsetting the cells from D0 and Q1 <br>
- `atac/BALL/D0_Q1_subset/02_pycistopic_modelling.py` - topic modelling for subset cells <br>
- `atac/BALL/D0_Q1_subset/02_pycistopic_modelling.slurm` - topic modelling submission script for subset cells <br>
- `atac/BALL/D0_Q1_subset/03_pycistopic_post_modelling.ipynb` - post topic modelling analysis <br>
- `atac/BALL/Q3_subset/01_pycistopic.ipynb` - pycistopic running from scratch for Q3 cells <br>
- `atac/BALL/Q3_subset/02_pycistopic_modelling.py` - topic modelling script <br>
- `atac/BALL/Q3_subset/02_pycistopic_modelling.slurm` - topic modelling submission file <br>
- `atac/BALL/Q3_subset/03_pycistopic_post_modelling.ipynb` - analysis post topic modelling <br>
- `atac/BALL/Q3_subset/umap_coordinates_extraction.ipynb` - extract UMAP coordinates for plotting <br>
- `atac/COLO/01_bam_filtering.slurm` - filtering the bam files based on the sequence length <br>
- `atac/COLO/02_fragment_creation.ipynb` - running SnapATAC2 <br>
- `atac/COLO/02b_fragment_wrangling.slurm`  - wrangling the SnapATAC2 fragment files to make them compatible with pycistopic <br>
- `atac/COLO/03_pycistopic-Copy-for-IDR.ipynb` - getting peaks without any filetring based on p-values <br>
- `atac/COLO/03_pycistopic.ipynb`  - running pycistopic up to topic modelling  <br>
- `atac/COLO/03a_pycistopic_modelling.slurm`  - topic modelling  <br>
- `atac/COLO/03b_pycistopic_modelling.py`  -  topic modelling  <br>
- `atac/COLO/04_pycistopic_post_modelling.ipynb` - post topic modelling analysis <br>
- `atac/COLO/05_jaccard_similarity.ipynb` - compare IDR and DNAsee I <br>
- `atac/COLO/DARs_bw.R` - plotting DARs in COLO <br>
- `atac/COLO/kneeplot.ipynb` - kneeplot for COLO <br>
- `atac/COLO/06_bases_covered.ipynb` - bases covered plot <br>



### The details on environment <br>
- `requirements_snapatac2.txt` for `02_fragment_creation.ipynb`
- `requirements_pycistopic.txt` for all the other notebooks
- `requirements_plotting_R_SessionInfo.txt` for `bw_vis_with_genes.R` and `visualise_bw_per_cell_type_short_vs_long.R`


### Input files <br>
- the blacklist region for the ATAC analysis can be downloaded from here: https://github.com/aertslab/pycisTopic/blob/main/blacklist/hg38-blacklist.v2.bed


> **_NOTE:_**  You may need to update input directories in the scripts above!