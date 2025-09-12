#!/usr/bin/env bash
#SBATCH -n 1
#SBATCH -c 30
#SBATCH -A account
#SBATCH -p partition
#SBATCH --mem 270G
#SBATCH --time=05:00:00
#SBATCH --cluster wice
#SBATCH --mail-type=FAIL,END
#SBATCH --mail-user=mail@mail.mail
#SBATCH --job-name="cistopic_modelling"
#SBATCH --output=logs/R-%x.%j.out
#SBATCH --error=logs/R-%x.%j.err

# script to run cistopic modelling

apptainer run -B /data,/scratch/,/lustre1/ \
pycistopic_2.0a.sif python 02_pycistopic_modelling.py
