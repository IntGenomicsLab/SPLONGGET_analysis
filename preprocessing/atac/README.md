# ATAC analysis

file list and description 

01_bam_filtering.ipynb - filtering the bam files based on the sequence length
02_fragment_creation.ipynb - running SnapATAC2
02b_fragment_wrangling.ipynb - wrangling the SnapATAC2 fragment files to make them compatible with pycistopic
03_pycistopic.ipynb - running pycistopic up to topic modelling 
03a_pycistopic_modelling.slurm - topic modelling slurm submission file
03b_pycistopic_modelling.py - topic modelling script
04_pycistopic_post_modelling.ipynb - analysis post topic modelling

The details on environment details are in the notebooks - usually they are specified at the end with `pip list` command