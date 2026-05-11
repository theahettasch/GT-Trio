# GenoType-based Trio-binning (GT-Trio)

Test.

This is a [Snakemake](https://snakemake.readthedocs.io/en/stable/) pipeline for creating *de novo* haplotype-resolved genome assemblies with trio-binning, using phased genotypes as parental input. 

The pipeline consists of five steps: (1) parental sequence reconstruction, (2) parental read simulation (3) parental k-mer dictionary construction, (4) haplotype-resolved assembly with trio-binning and (5) reference-based scaffolding. 
 

## Pipeline description
### Step 1: Parental sequence reconstruction
**Software:** [BCFtools](https://samtools.github.io/bcftools/bcftools.html) (v1.18)

Parent-specific genome sequences are reconstructed from a high-quality reference genome (FASTA) and a dataset of phased parental genotypes (VCF) with BCFtools consensus. To account for phasing, two parent-specific sequences, representing either haplotypes are reconstructed using the `--haplotype` option.

### Step 2: Parental read simulation
**Software:** [SAMtools](https://github.com/samtools/samtools) (v1.18)

To mimic Illumina short-read data used in conventional trio-binning, paired-end 150 bp reads are simulated from the parent-specific genome sequences with SAMtools wgsim. A user-defined number of read pairs `-N` is set to achieve the desired coverage of parental reads. 

### Step 3: Parental k-mer dictionary construction
**Software:** [Yak](https://github.com/lh3/yak) (v0.1)

Parental k-mer dictionaries are created from simulated parental reads with Yak. An appropriate k-mer size has to be chosen to ensure a dictionary of unique paternal and maternal k-mers. See Koren et al. on how to choose an appropriate value of k.  

### Step 4: Haplotype-resolved assembly
**Software:** [Hifiasm](https://github.com/chhylp123/hifiasm) (v0.24.0)

Offspring long-reads (ONT) are assembled into haplotypes using the trio-binning feature implemented in Hifiasm. 

### Step 5: Reference-guided scaffolding
**Software:** [RagTag](https://github.com/malonge/RagTag/wiki/scaffold) (v2.1.0)

Contigs outputted by Hifiasm are combined into chromosome-level scaffolds with RagTag against a high-quality reference genome. 

## Usage
### Environment setup
Install conda and snakemake. 

### Clone git repo
```
git clone https://github.com/theahettasch/GT-Trio.git
cd GT-Trio
```
### Running the pipeline with your own data
To run the pipeline with you own data, open the configuration file `config.yaml` and define any required input files and parameters.  

### Required input files
- A high-quality reference genome (FASTA) for parental sequence reconstruction. 
- Phased genotypes for trio all trio parents (VCF). Remember that the VCF has to be phased with alleles separated by vertical pipes `0|0` `1|0` `1|1`
- Oxford Nanopore (ONT) long-reads from offspring genome (FASTQ). Perform any desired filtering of reads prior to running the pipeline.

### Required parameters (config.yaml)
```
### Input files and parameters ###

out_dir: "/path/out_dir_name"                         #Define the path and name for the output directory
reference: "/path/to/reference_genome.fa"             #Path to high-quality reference genome used for parental sequence reconstruction and scaffolding
vcf: "/path/to/parents.phased.vcf.gz"                 #Path to VCF with phased genotypes for trio parents
offspring_reads: "/path/to/offspring_reads.fq.gz"     #Path to offspring reads (ONT)

### Step 1: Sequence reconstruction parameters ###

pat_sample: "paternal_samplename"                     #Paternal sample name used in VCF with phased genotypes
mat_sample: "maternal_samplename"                     #Maternal sample name used in VCF with phased genotypes

### Step 2: Read simulation parameters

read_length: "150"                                    #Read length (bp)
read_depth: "30"                                      #Desired read depth per parent
genome_size: "2800000000"                             #Genome size. Required to convert read_depth to read count (-N) in wgsim
error_rate: "0"                                       #Base error rate
mutation_rate: "0"                                    #Mutation rate
indel_fraction: "0"                                   #Indel fraction
indel_extension: "0"                                  #Indel extension probability

### Step 3: Haplotype assembly parameters

yak_kmer: "21"                                        #K-mer size
yak_bloom_bits: "37"                                  #Bloom filter used to filter out singleton k-mers
```
### Output files
The pipeline outputs the following output files:

`parent_data/*aternal_sequence_hap1.fasta` Reconstructed paternal/maternal sequence of haplotype 1

`parent_data/*aternal_sequence_hap2.fasta` Reconstructed paternal/maternal sequence of haplotype 2

`parent_data/*aternal_reads.fg.gz` Paternal/maternal simulated reads

`parent_data/*aternal_count.yak` Paternal/maternal k-mer dictionaries

`hifiasm/offspring_assembly.hifiasm.asm*` Output from Hifiasm. See [Hifiasm output](https://hifiasm.readthedocs.io/en/latest/interpreting-output.html#interpreting-output) for details.

`ragtag/ragtag.scaffold*` Output from RagTag. See [RagTag output](https://github.com/malonge/RagTag/wiki/scaffold) for details.

`assembly/offspring_assembly_contig_paternal.fa` Offspring assembly of paternal haplotype (contigs)

`assembly/offspring_assembly_contig_maternal.fa` Offspring assembly of maternal haplotype (contigs)

`assembly/offspring_assembly_chr_paternal.fasta` Offspring assembly of paternal haplotype (chromosome scaffolds)

`assembly/offspring_assembly_chr_maternal.fasta` Offspring assembly of maternal haplotype (chromosome scaffolds)

## Citing
I you use the pipeline, please site this paper:

