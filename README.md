# GenoType-based Trio-binning (GT-Trio)

This is a [Snakemake](https://snakemake.readthedocs.io/en/stable/) pipeline for creating haplotype-resolved genome assemblies with trio-binning, using phased genotypes as parental input. The pipeline consists of three main steps: (1) parental sequence reconstruction, (2) parental read simulation and (3) haplotype-resolved assembly with trio-binning. 


## Workflow description
### Step 1: Parental sequence reconstruction
**Software:** [BCFtools](https://samtools.github.io/bcftools/bcftools.html)

Parent-specific genome sequences are reconstructed from a high-quality reference genome (FASTA) and a dataset of phased parental genotypes (VCF) with BCFtools consensus. To account for phasing, two parent-specific sequences, representing either haplotypes are reconstructed using the `--haplotype` option.

### Step 2: Parental read simulation
**Software:** [SAMtools](https://github.com/samtools/samtools)

To mimic Illumina short-read data used in conventional trio-binning, paired-end 150 bp reads are simulated from the parent-specific genome sequences with SAMtools wgsim. A user-defined number of read pairs `-N` is set to achieve the desired coverage of parental reads. 

### Step 3: Haplotype-resolved assembly with trio-binning
**Software:** [Yak](https://github.com/lh3/yak), [Hifiasm](https://github.com/chhylp123/hifiasm) (v0.24.0 or newer)

Offspring long-reads (ONT) are assembled into haplotypes using the trio-binning feature implemented in Hifiasm. Parental k-mer dictionaries are created from simulated parental reads with Yak and provided as parental input to Hifiasm. An appropriate k-mer size has to be chosen to ensure a dictionary of unique paternal and maternal k-mers.  


## Usage
### Environment setup
Install conda and snakemake. 

### Clone git repo
```
git clone https://github.com/theahettasch/GT-Trio.git
cd GT-Trio
```

### Running the pipeline with your own data
To run the pipeline with you own data, open the configuration file `config.yaml` and add any required input files and parameters.  

### Required input files
- A high-quality reference genome (FASTA) for parental sequence reconstruction. 
- Phased genotypes for trio all trio parents (VCF). Remember that the VCF has to be phased with alleles separated by vertical pipes `0|0` `1|0` `1|1`
- Oxford Nanopore (ONT) long-reads from offspring genome (FASTQ). Perform any desired filtering of reads prior to running the pipeline.

### Required parameters
```
### Input files and parameters ###

out_dir: "/path/out_dir_name"                         #Define the path and name for the output directory
reference: "/path/to/reference_genome.fa"             #Path to high-quality reference genome
vcf: "/path/to/parents.phased.vcf.gz"                 #Path to VCF with phased genotypes for trio parents
offspring_reads: "/path/to/offspring_reads.fq.gz"     #Path to offspring reads (ONT)

### Step 1: Sequence reconstruction parameters ###

pat_sample: "paternal_samplename"                     #Paternal sample name used in VCF with phased genotypes
mat_sample: "maternal_samplename"                     #Maternal sample name used in VCF with phased genotypes

### Step 2: Read simulation parameters ###

read_length: "150"                                    #Read length (similar to Illumina short-reads)
read_depth: "30"                                      #Desired read depth per parent
error_rate: "0"                                       #Base error rate
mutation_rate: "0"                                    #Mutation rate
indel_fraction: "0"                                   #Indel fraction
indel_extension: "0"                                  #Indel extension probability
genome_size: "2800000000"                             #Required to convert read_depth to read count (-N) in wgsim

### Step 3: Haplotype assembly parameters ###

yak_kmer: "21"
yak_bloom_bits: "37"
```

## Citing
I you use the pipeline, please site this paper:

