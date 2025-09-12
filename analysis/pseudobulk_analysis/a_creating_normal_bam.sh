#!/bin/bash

ml SAMtools

SAMPLE=$1

#GIVE THE BAM FILE AND THE FILE WITH THE NORMAL TAGS

#With this script we are making a normal.bam file based on the annotations of the normal cell
#Important that we extract the normal cells/reads for each sample
#This needs to be done for RNA and DNA; Be aware, for the RNA -> use the sample normal RNA barcodes and the RNA bam; and for DNA the DNA ones -> variable

omic=DNA #(or RNA)

INPUT_BAM=${omic}_${SAMPLE}.dedup.sorted.bam
normal_tags=/normal_barcodes_${omic}/"${SAMPLE}"_normal_sample.txt

OUTBASE=/normal_bam/${SAMPLE}
mkdir -p ${OUTBASE}

#SUBSET TO NORMAL SAM
samtools view ${INPUT_BAM} | LC_ALL=C grep -F -f ${normal_tags} > ${OUTBASE}/normal_${SAMPLE}.sam

# Save the header lines
samtools view -H ${INPUT_BAM} > ${OUTBASE}/normal_${SAMPLE}.header

# Combine header and body
cat ${OUTBASE}/normal_${SAMPLE}.header ${OUTBASE}/normal_${SAMPLE}.sam > ${OUTBASE}/normal_${SAMPLE}_final.sam

# Convert filtered.sam to BAM format
samtools view -b ${OUTBASE}/normal_${SAMPLE}_final.sam > ${OUTBASE}/normal_${omic}_${SAMPLE}_final.bam

samtools index ${OUTBASE}/normal_${omic}_${SAMPLE}_final.bam


#After this go to the output folder and use samtools merge * normal_cells.bam

#Important note: this method can be used to make every pseudobulk -> This method was also used to create a bulk of the cytotoxic T -cell (CART cells), for later LOH analysis