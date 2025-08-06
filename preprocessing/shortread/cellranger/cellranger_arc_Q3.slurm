#!/bin/bash -l
#SBATCH --account=account
#SBATCH --cluster=cluster
#SBATCH --partition=partition
#SBATCH --output="%x.o%A"
#SBATCH --error="%x.e%A"
#SBATCH --job-name=ball_Q3.cellranger_arc
#SBATCH --nodes=1
#SBATCH --ntasks-per-node="36"
#SBATCH --ntasks="36"
#SBATCH --mem-per-cpu="3400"
#SBATCH --time="18:00:00"


cellranger_arc_parent_output_dir="/preprocessing/shortread/cellranger/"

cd "${cellranger_arc_parent_output_dir}"
# Sample id: CellRanger-ARC will create a directory with this name in cellranger_arc_parent_output_dir.
sample_id=Q3
# Library file.
library_file=/preprocessing/shortread/cellranger/library_file.csv
# CellRanger-ARC reference directory.
# you need to chnage this path 
cellranger_arc_reference_dir="../genomes/10xgenomics/CellRangerARC/refdata-cellranger-arc-GRCh38-2020-A-2.0.0" 
# Load CellRanger-ARC module.
module load CellRanger-ARC/2.0.2
cellranger-arc count \
    --reference "${cellranger_arc_reference_dir}" \
    --libraries "${library_file}" \
    --id "${sample_id}" \
    --localcores 36 \
    --localmem 115
