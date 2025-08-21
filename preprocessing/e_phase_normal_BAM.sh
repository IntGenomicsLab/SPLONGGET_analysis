#!/bin/bash

Long=longphase-1.7.3.sif

#Input BAM:
BAM=all_normals_length1000.bam

singularity exec -B /staging/leuven/stg_00096/ \
    ${Long} longphase haplotag \
    -s "phased_vcf_form_CLAIR3" \
    -b ${BAM} \
    -r ${REF} \
    -t 8 \
    -o all_timepoints_normals.bam

echo "Stop here and debug"


