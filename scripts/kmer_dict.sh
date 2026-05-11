#!/bin/bash

#Software: Yak (v0.1)

bloom="$1"
threads="$2"
k_size="$3"

mkdir -p kmer_dict

#Build k-mer dictionaries from parental reads
yak count -o kmer_dict/paternal_count.yak -b${bloom} -t${threads} -k${k_size} parent_data/paternal_reads.fq.gz
yak count -o kmer_dict/maternal_count.yak -b${bloom} -t${threads} -k${k_size} parent_data/maternal_reads.fq.gz
