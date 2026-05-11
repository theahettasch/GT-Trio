#!/bin/bash
set -euo pipefail

#Software: SAMtools (v1.18)

pat_hap1="$1"
pat_hap2="$2"
mat_hap1="$3"
mat_hap2="$4"
out_pat="$5"
out_mat="$6"
read_length="$7"
read_pairs="$8"
mutation_rate="$9"
indel_fraction="$10"
indel_extension="$11"
error_rate="$12"


# Temp files
tmpdir=$(mktemp -d)
trap "rm -rf ${tmpdir}" EXIT


#Simulate reads from paternal sequences
wgsim -1 $read_length -2 $read_length -N $read_pairs -r $mutation_rate -R $indel_fraction -X $indel_extension -e $error_rate ${pat_hap1} ${tmpdir}/pat_hap1_R1.fastq ${tmpdir}/pat_hap1_R2.fastq
wgsim -1 $read_length -2 $read_length -N $read_pairs -r $mutation_rate -R $indel_fraction -X $indel_extension -e $error_rate ${pat_hap2} ${tmpdir}/pat_hap2_R1.fastq ${tmpdir}/pat_hap2_R2.fastq

cat ${tmpdir}/pat_hap1_R1.fastq ${tmpdir}/pat_hap1_R2.fastq ${tmpdir}/pat_hap2_R1.fastq ${tmpdir}/pat_hap2_R2.fastq | gzip > ${out_pat}

#Simulate reads from maternal sequences
wgsim -1 $read_length -2 $read_length -N $read_pairs -r $mutation_rate -R $indel_fraction -X $indel_extension -e $error_rate ${mat_hap1} ${tmpdir}/mat_hap1_1.fastq ${tmpdir}/mat_hap1_2.fastq
wgsim -1 $read_length -2 $read_length -N $read_pairs -r $mutation_rate -R $indel_fraction -X $indel_extension -e $error_rate ${mat_hap2} ${tmpdir}/mat_hap2_1.fastq ${tmpdir}/mat_hap2_2.fastq

cat ${mat_hap1} ${tmpdir}/mat_hap1_1.fastq ${tmpdir}/mat_hap1_2.fastq ${tmpdir}/mat_hap2_1.fastq ${tmpdir}/mat_hap2_2.fastq | gzip > ${out_mat}