# ATAC analysis

file list and description 


- `01_bam_filtering.ipynb` - filtering the bam files based on the sequence length <br>
- `02_fragment_creation.ipynb` - running SnapATAC2 <br>
- `02b_fragment_wrangling.ipynb` - wrangling the SnapATAC2 fragment files to make them compatible with pycistopic <br>
- `03_pycistopic.ipynb` - running pycistopic up to topic modelling  <br>
- `03a_pycistopic_modelling.slurm` - topic modelling slurm submission file <br>
- `03b_pycistopic_modelling.py` - topic modelling script <br>
- `04_pycistopic_post_modelling.ipynb` - analysis post topic modelling <br>


The details on environment
- `requirements_snapatac2.txt` for `02_fragment_creation.ipynb`
- `requirements_pycistopic.txt` for `03_pycistopic.ipynb`,`03a_pycistopic_modelling.slurm`,`03b_pycistopic_modelling.py` and `04_pycistopic_post_modelling.ipynb`