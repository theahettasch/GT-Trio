#!/bin/bash
set -euo pipefail

#Software: Hifiasm (v0.24.0)

offspring_reads="$1"
pat_k="$2"
mat_k="$3"
threads="$4"
outdir="$5"

mkdir -p ${outdir}/hifiasm
cd ${outdir}/hifiasm

#Run hifiasm to assemble haplotypes with trio-binning
hifiasm --ont -o offspring_assembly.hifiasm.asm -t ${threads} -1 ${pat_k} -2 ${mat_k} ${offspring_reads}

mkdir -p ${outdir}/assembly
cd ${outdir}/assembly

#Convert GFA to FASTA
awk '/^S/{print ">"$2;print $3}' ${outdir}/hifiasm/offspring_assembly.hifiasm.asm.dip.hap1.p_ctg.gfa > offspring_assembly_contig_paternal.fa
awk '/^S/{print ">"$2;print $3}' ${outdir}/hifiasm/offspring_assembly.hifiasm.asm.dip.hap2.p_ctg.gfa > offspring_assembly_contig_maternal.fa

