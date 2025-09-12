#!/bin/bash

SAMPLE=$1

CTAT=ctat_lr_fusion.v.simg
GENOMELIB=/GRCh38_gencode_v37_CTAT_lib_Mar012021.plug-n-play/ctat_genome_lib_build_dir

FASTA=/${SAMPLE}_filtered.fastq.gz

OUTDIR=/ctat_fusion/${SAMPLE}
mkdir -p ${OUTDIR}
cd ${OUTDIR}


singularity exec -e -B /staging/  \
        ${CTAT} \
        ctat-LR-fusion \
        -T ${FASTA} \
        --genome_lib_dir ${GENOMELIB} \
        --vis \
        --CPU 18