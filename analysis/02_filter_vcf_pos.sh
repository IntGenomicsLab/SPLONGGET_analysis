#!/bin/bash

sample=$1

ml BCFtools

cd /CLAIRS_TO/coverage_10/$sample

bcftools view -R loci.txt snv.vcf.gz  -o filtered.vcf

bgzip -f filtered.vcf