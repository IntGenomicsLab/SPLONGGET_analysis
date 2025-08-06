# ATAC analysis

file list and description 


- `01_bam_filtering.ipynb` - filtering the bam files based on the sequence length <br>
- `02_fragment_creation.ipynb` - running SnapATAC2 <br>
- `02b_fragment_wrangling.ipynb` - wrangling the SnapATAC2 fragment files to make them compatible with pycistopic <br>
- `03_pycistopic.ipynb` - running pycistopic up to topic modelling  <br>
- `03a_pycistopic_modelling.slurm` - topic modelling slurm submission file <br>
- `03b_pycistopic_modelling.py` - topic modelling script <br>
- `04_pycistopic_post_modelling.ipynb` - post topic modelling analysis <br>
- `preprocessing/atac/D0_Q1_subset/01_subset_cistopic.ipynb` - subsetting the cells from D0 and Q1 <br>
- `preprocessing/atac/D0_Q1_subset/02_pycistopic_modelling.py` - topic modelling for subset cells <br>
- `preprocessing/atac/D0_Q1_subset/02_pycistopic_modelling.slurm` - topic modelling submission script for subset cells <br>
- `preprocessing/atac/D0_Q1_subset/03_pycistopic_post_modelling.ipynb` - post topic modelling analysis <br>
- `preprocessing/atac/Q3_subset/01_pycistopic.ipynb` - pycistopic running from scratch for Q3 cells <br>
- `preprocessing/atac/Q3_subset/02_pycistopic_modelling.py` - topic modelling script <br>
- `preprocessing/atac/Q3_subset/02_pycistopic_modelling.slurm` - topic modelling submission file <br>
- `preprocessing/atac/Q3_subset/03_pycistopic_post_modelling.ipynb` - analysis post topic modelling <br>
- `preprocessing/atac/Q3_subset/umap_coordinates_extraction.ipynb` - extract UMAP coordinates for plotting <br>

The details on environment
- `requirements_snapatac2.txt` for `02_fragment_creation.ipynb`
- `requirements_pycistopic.txt` for all the other notebooks