#!/bin/bash

#Script to run on the multiome data -> Phase the BAM files with LongPhase on the normal phased vcf file -> Run Severus on the phased bam files:
ml cluster/genius/batch
ml SAMtools

D0_BAM=/phased_bams/D0/long_reads.bam 
Q1_BAM=/phased_bams/Q1/long_reads.bam 
Q2_BAM=/phased_bams/Q2/long_reads.bam 
Q3_BAM=/phased_bams/Q3/long_reads.bam 


REF=/Homo_sapiens_assembly38_masked_noALT.fasta
Severus=severus_v.sif
phased_vcf=/CLAIR3/normal_bam/phased_merge_output.vcf.gz

OUTBASE=/Variant_calling/Severus
mkdir -p  ${OUTBASE}
cd ${OUTBASE}
echo "Processing BAM file: ${INPUT_BAM} in ${OUTBASE}"
    
singularity exec -B /staging/ \
    ${Severus} /opt/Severus/severus.py \
    --out-dir ${OUTBASE} \
    -t 18 \
    --target-bam ${D0_BAM} ${Q1_BAM} ${Q2_BAM} ${Q3_BAM} \
    --phasing-vcf ${phased_vcf} \
    --vntr-bed /opt/Severus/vntrs/human_GRCh38_no_alt_analysis_set.trf.bed \
    --PON /opt/Severus/pon/PoN_1000G_hg38.tsv.gz \
    --min-support 6