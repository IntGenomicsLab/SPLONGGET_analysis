#!/usr/bin/env bash
#SBATCH -n 1
#SBATCH -c 20
#SBATCH -A lp_account
#SBATCH -p account
#SBATCH --mem 200G
#SBATCH --time=15:00:00
#SBATCH --cluster wice
#SBATCH --mail-type=FAIL,END
#SBATCH --error=/logs/%x.e%a
#SBATCH --job-name=bam_filtering

## sciprt to filter read in bams on size - only reads below 1000 bps are kept

NAME=(D0 Q1 Q2 Q3)

SINF=samtools-1.20.img
module purge
module load cluster/wice/batch
ml  SAMtools
for file in "${NAME[@]}"
do

    INBAM=${file}/bam/dedup/${file}.dedup.sorted.bam
    OUTDIR=/filtered_tumour_bams/${file}
    mkdir -p $OUTDIR
    OUTBAM=${OUTDIR}/${file}_filtered_1000.bam
    echo "Running sample" $file
    echo $INBAM
    echo $OUTBAM
    samtools view -@ 20 -e 'length(seq)>1000' -b --write-index -o $OUTBAM $INBAM
    echo "sample done" $file
done
