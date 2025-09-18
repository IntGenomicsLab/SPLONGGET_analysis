#!/bin/bash

NAME=$1

cellsnp=cellsnp-lite_v.sif


#With NAME the 4 tumour timepoints and the pseudobulks of the Cytotoxic T -cells
T_BAM=${NAME}.dedup.sorted.bam

BAR=/staging/leuven/stg_00096/home/projects/2023_Cools_B-ALL/aligned/bamfiles/BM_XG111_${NAME}_ATAC_merged.whitelist.tsv
OUTDIR=/CART_cells_analysis/ascat_chr3/${NAME}

loci_file=/CART_cells_analysis/highest_BAF_chr3.vcf

mkdir -p ${OUTDIR}

singularity exec -B /staging/leuven/stg_00096 \
    ${cellsnp} cellsnp-lite \
    -s ${T_BAM} \
    -b ${BAR} \
    -O ${OUTDIR} \
    -R ${loci_file} \
    --UMItag None \
    --cellTAG CB \
    --genotype \
    --minMAF 0.01 \
    --minCOUNT 1 \
    -p 12 \
    --gzip