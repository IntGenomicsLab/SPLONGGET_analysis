#!/usr/bin/env bash
#SBATCH -n 1
#SBATCH -c 20
#SBATCH -A XX
#SBATCH -p XX
#SBATCH --mem 200G
#SBATCH --time=15:00:00
#SBATCH --cluster XX
#SBATCH --mail-type=FAIL,END
#SBATCH --mail-user=<mail>
#SBATCH --output=logs/R-%x.%j.out
#SBATCH --error=logs/R-%x.%j.err
#SBATCH --job-name=ATAC-bam_filtering

## sciprt to filter read in bams on size - only reads below 1000 bps are kept

ARRAY=( COLO829_rep1 COLO829_rep2 COLO829BL )

INPUTDIR=/scdnalong/COLO_data/results
OUTDIR=/atac/revision/COLO/bamfile_filtered

ml SAMtools/1.21-GCC-10.3.0

for name in "${ARRAY[@]}"
do
    INBAM=$INPUTDIR/$name/bam/dedup/${name}.dedup.sorted.bam
    OUTBAM=$OUTDIR/$name.filtered.bam
    echo "Running sample" $name
    echo $INBAM
    echo $OUTBAM
    samtools view -@ 20 -e 'length(seq)<1000' -b --write-index -o $OUTBAM $INBAM
    echo "sample done" $file
done
