#Now phase the 4 tumour files
NAME=$1
    
    Long=longphase-v.sif
    REF='Homo_sapiens_assembly38_masked_noALT.fasta'
    BAM=${NAME}_filtered_1000.bam
    OUTPUT=/phased_bams/${NAME}/
    mkdir -p ${OUTPUT}
    cd ${OUTPUT}

    singularity exec -B /staging/ \
    ${Long} longphase haplotag \
    -s "phased_vcf_form_CLAIR3" \
    -b ${BAM} \
    -r ${REF} \
    -t 8 \
    -o long_reads.bam 