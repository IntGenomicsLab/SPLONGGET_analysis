#!/bin/bash

ml SAMtools


SAMPLES=(
    "COLO829BL"
    "COLO829_rep1"
    "COLO829_rep2"
)

# 400
for SAMPLE in "${SAMPLES[@]}"; do
    echo "Processing $SAMPLE..."
    INPUT=/atac/COLO/bamfile_filtered_400/${SAMPLE}.filtered.bam
    samtools flagstat $INPUT > /atac/bases_covered/COLO/${SAMPLE}.filtered400.flagstat.txt
done

#1000
for SAMPLE in "${SAMPLES[@]}"; do
    echo "Processing $SAMPLE..."
    INPUT=/atac/COLO/bamfile_filtered/${SAMPLE}.filtered.bam
    samtools flagstat $INPUT > /atac/bases_covered/COLO/${SAMPLE}.filtered.flagstat.txt
done

# all
for SAMPLE in "${SAMPLES[@]}"; do
    echo "Processing $SAMPLE..."
    INPUT=/scdnalong/COLO_data/results/${SAMPLE}/bam/dedup//${SAMPLE}.dedup.sorted.bam
    samtools flagstat $INPUT > /atac/bases_covered/COLO/${SAMPLE}.flagstat.txt
done
