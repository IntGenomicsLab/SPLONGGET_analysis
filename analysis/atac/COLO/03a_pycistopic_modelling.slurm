#!/usr/bin/env bash
#SBATCH -n 1
#SBATCH -c 30
#SBATCH -A XX
#SBATCH -p XX
#SBATCH --mem 270G
#SBATCH --time=10:00:00
#SBATCH --cluster XX
#SBATCH --mail-type=FAIL,END
#SBATCH --mail-user=XX
#SBATCH --job-name="cistopic_modelling"
#SBATCH --output=logs/R-%x.%j.out
#SBATCH --error=logs/R-%x.%j.err

# script to run cistopic modelling

apptainer run -B /data  \
pycistopic_2.0a.sif python /atac/COLO/03b_pycistopic_modelling.py
