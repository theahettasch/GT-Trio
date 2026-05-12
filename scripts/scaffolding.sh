#!/bin/bash
set -euo pipefail

#Software: RagTag (v2.1.0)

in_hap1="$1"
in_hap2="$2"
reference="$3"
out_hap1="$4"
out_hap2="$5"
threads="$6"
group_conf="$7"
loc_conf="$8"
orient_conf="$9"
outdir="$10"

mkdir -p ${outdir}/ragtag

#Scaffold contigs agains reference genome
ragtag.py scaffold ${reference} ${in_hap1} -t ${threads} -i ${group_conf} -a ${loc_conf} -s ${orient_conf} -o ${outdir}/ragtag/paternal
ragtag.py scaffold ${reference} ${in_hap2} -t ${threads} -i ${group_conf} -a ${loc_conf} -s ${orient_conf} -o ${outdir}/ragtag/maternal

#Convert RagTag output to assembly FASTA
awk '/^>/{gsub(/_RagTag/,"")} {print}' ${outdir}/ragtag/paternal/ragtag.scaffold.fasta > ${out_hap1}
awk '/^>/{gsub(/_RagTag/,"")} {print}' ${outdir}/ragtag/maternal/ragtag.scaffold.fasta > ${out_hap2}
