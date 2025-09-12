#!/usr/bin/env bash
#SBATCH -n 1
#SBATCH -c 20
#SBATCH -A account
#SBATCH -p account
#SBATCH --mem 200G
#SBATCH --time=15:00:00
#SBATCH --cluster wice
#SBATCH --mail-type=FAIL,END
#SBATCH --mail-user=ruben.cools@kuleuven.be
#SBATCH --error=/logs/%x.e%a
#SBATCH --job-name=bam_filtering


SINF=samtools-v.img
module purge
module load cluster/wice/batch
ml  SAMtools


INBAM=normal_cells.bam 
OUTDIR=/normal_bam/

OUTBAM=${OUTDIR}/all_normals_length1000.bam
        
echo "Running sample" $file
echo $INBAM
echo $OUTBAM
samtools view -@ 20 -e 'length(seq)>1000' -b --write-index -o $OUTBAM $INBAM

