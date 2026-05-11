#!/bin/bash
#Software: BCFtools (v1.18)

set -euo pipefail

#Define arguments
reference="$1"
vcf="$2"
pat_sample="$3"
mat_sample="$4"
pat_out_1="$5"
pat_out_2="$6"
mat_out_1="$7"
mat_out_2="$8"

#Reconstruct paternal sequences 
bcftools consensus -f ${reference} -s ${pat_sample} --haplotype 1 ${vcf} > ${pat_out_1}
bcftools consensus -f ${reference} -s ${pat_sample} --haplotype 2 ${vcf} > ${pat_out_2}

#Reconstruct maternal sequences
bcftools consensus -f ${reference} -s ${mat_sample} --haplotype 1 ${vcf} > ${mat_out_1}
bcftools consensus -f ${reference} -s ${mat_sample} --haplotype 2 ${vcf} > ${mat_out_2}