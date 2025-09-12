#!/bin/bash
# Define the timepoint name passed as the argument
NAME=$1

# Define paths
T_BAM=${NAME}.dedup.sorted.bam
REF='GRCh38.alt-masked-V2-noALT/fasta/Homo_sapiens_assembly38_masked_noALT.fasta'
CLAIRS='clairs-to_v.sif'
MODEL=ont_r10_dorado_sup_5khz # or Clair3 model: r1041_e82_400bps_sup_v430
PLATFORM='ont'

# Define output directory
OUTPUT=/output

# Create output directory
mkdir -p ${OUTPUT}
cd ${OUTPUT}

# Run CLAIRS on the current timepoint
singularity exec -B /staging/ --cleanenv \
    ${CLAIRS} \
    /opt/bin/run_clairs_to \
    -s ${NAME} \
    --tumor_bam_fn ${T_BAM} \
    --ref_fn ${REF} \
    -p ${MODEL} \
    -t 12 \
    -o ${OUTPUT} \
    --min_coverage 10 \
    --remove_intermediate_dir   