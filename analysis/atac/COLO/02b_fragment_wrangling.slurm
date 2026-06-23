#!/usr/bin/env bash
#SBATCH -n 1
#SBATCH -c 10
#SBATCH -A XX
#SBATCH -p XX
#SBATCH --mem 100G
#SBATCH --time=05:00:00
#SBATCH --cluster XX
#SBATCH --mail-type=FAIL,END
#SBATCH --mail-user=XX
#SBATCH --output=logs/R-%x.%j.out
#SBATCH --error=logs/R-%x.%j.err
#SBATCH --job-name=fragment-wrangling
#SBATCH --array=0-2

# script to format snapatac2 fragment to pycistopic fomat.

ml HTSlib/1.21-GCC-10.3.0
ARRAY=( COLO829_rep1 COLO829_rep2 COLO829BL )

# submit to array job
i=${ARRAY[$SLURM_ARRAY_TASK_ID-1]}

cd /atac/COLO/fragments

echo "Processing $i"
zcat ${i}.tsv.gz  | sort -k1,1 -k2,2n | cut -f 1-5 | bgzip > ${i}_corrected.tsv.gz
tabix -p bed ${i}_corrected.tsv.gz
echo "Done processing $i"


