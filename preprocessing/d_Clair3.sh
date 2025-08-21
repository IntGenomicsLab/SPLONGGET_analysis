#!/bin/bash

#Script to run Clair3 on the multiome data, on the normal bam -> use for phasing


BAM=normal_cells.bam 

G=1000g_pon.hg38.vcf.gz
REF=Homo_sapiens_assembly38_masked_noALT.fasta
CLAIR3=clair3-v1.0.9-rerio.img
MODEL='/opt/bin/rerio/clair3_models/r1041_e82_400bps_sup_v430'
PLATFORM='ont'
OUTPUT=/CLAIR3/

mkdir -p ${OUTPUT}
cd ${OUTPUT}

##Run if with the longphase:
singularity exec -B /staging  \
    ${CLAIR3} \
    /opt/bin/run_clair3.sh \
    -b ${BAM} \
    -f ${REF} \
    -m ${MODEL} \
    -t 18 \
    -p ${PLATFORM} \
    -o ${OUTPUT} \
    --remove_intermediate_dir \
    --vcf_fn=${G}
