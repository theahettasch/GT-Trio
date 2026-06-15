# GenoType-based Trio-binning (GT-Trio)

This is a [Snakemake](https://snakemake.readthedocs.io/en/stable/) pipeline for creating *de novo* haplotype-resolved genome assemblies with trio-binning, using phased genotypes as parental input. 

The pipeline consists of five steps: (1) parental sequence reconstruction, (2) parental read simulation (3) parental k-mer dictionary construction, (4) haplotype-resolved assembly and (5) reference-guided scaffolding. 
 

## Pipeline description
### Step 1: Parental sequence reconstruction
**Software:** [BCFtools](https://samtools.github.io/bcftools/bcftools.html) (v1.18)

Parent-specific genome sequences are reconstructed from a high-quality reference genome (FASTA) and a dataset of phased parental genotypes (VCF) with *BCFtools consensus*. To account for phasing, two parent-specific sequences, representing either haplotypes are reconstructed using the `--haplotype` option.

### Step 2: Parental read simulation
**Software:** [SAMtools](https://github.com/samtools/samtools) (v1.18)

To mimic Illumina short-read data used in conventional trio-binning, paired-end 150 bp reads are simulated from the parent-specific genome sequences with *SAMtools wgsim*. A user-defined number of read pairs `-N` is set to achieve the desired coverage of parental reads. 

### Step 3: Parental k-mer dictionary construction
**Software:** [Yak](https://github.com/lh3/yak) (v0.1)

Parental k-mer dictionaries are created from simulated parental reads with *Yak*. An appropriate k-mer size has to be chosen to ensure a dictionary of unique paternal and maternal k-mers. See [Koren et al. (2018)](https://www.nature.com/articles/nbt.4277) on how to choose an appropriate value of k for your species.  

### Step 4: Haplotype-resolved assembly
**Software:** [Hifiasm](https://github.com/chhylp123/hifiasm) (v0.24.0)

The paternal and maternal haplotypes of the trio offspring individuals are assembled from long-reads (ONT) using the trio-binning feature implemented in *Hifiasm*. 

### Step 5: Reference-guided scaffolding
**Software:** [RagTag](https://github.com/malonge/RagTag/wiki/scaffold) (v2.1.0)

Assembled contigs outputted from *Hifiasm* are combined into chromosome-level scaffolds with *RagTag* against the high-quality reference genome. 

## Usage
### Environment setup
Make sure that [Conda](https://docs.conda.io/projects/conda/en/stable/index.html) and [Snakemake](https://snakemake.readthedocs.io/en/stable/) is installed. 

### Clone git repo
```
git clone https://github.com/theahettasch/GT-Trio.git
cd GT-Trio
```

### Define input files and parameters
To run the pipeline with you own data, open the configuration file `config/config.yaml` and define any required input files and parameters (see [config/README.md](https://github.com/theahettasch/GT-Trio/blob/main/config/README.md)).

### Run pipeline
When necessary dependencies (Conda and Snakemake) are available and any required input files and parameters have been defined in the configuration file, the GT-Trio pipeline can be run with one of the following commands from inside the GT-Trio directory:

```
#Run locally. Be aware that some of the tools implemented in the pipeline require certain amounts of memory and threads. 

snakemake \
  --use-conda \
  --cores 8 \ 
  --resources mem_mb=16000 
```
or
```
#Run on SLURM cluster. Required memory and threads is allready defined individually in each snakemake rule.

#!/usr/bin/env bash
#SBATCH --job-name=GT-Trio
#SBATCH --cpus-per-task=1
#SBATCH --mem=20G
#SBATCH --partition=partition_name
#SBATCH --output=logs/GT-Trio_%j.out
#SBATCH --error=logs/GT-Trio_%j.err

snakemake \
  --use-conda \
  --jobs 10 \
  --cluster "sbatch --mem={resources.mem_mb} --cpus-per-task={threads} --output={log[0]}" 
```

### Output files
The pipeline outputs the following files:

`parent_data/*aternal_sequence_hap1.fasta` Reconstructed paternal/maternal sequence of haplotype 1

`parent_data/*aternal_sequence_hap2.fasta` Reconstructed paternal/maternal sequence of haplotype 2

`parent_data/*aternal_reads.fq.gz` Paternal/maternal simulated reads

`parent_data/*aternal_count.yak` Paternal/maternal k-mer dictionaries

`hifiasm/offspring_assembly.hifiasm.asm*` Output from Hifiasm. See [Hifiasm output](https://hifiasm.readthedocs.io/en/latest/interpreting-output.html#interpreting-output) for details.

`ragtag/ragtag.scaffold*` Output from RagTag. See [RagTag output](https://github.com/malonge/RagTag/wiki/scaffold) for details.

`assembly/offspring_assembly_contig_paternal.fa` Offspring assembly of paternal haplotype (contigs)

`assembly/offspring_assembly_contig_maternal.fa` Offspring assembly of maternal haplotype (contigs)

`assembly/offspring_assembly_chr_paternal.fasta` Offspring assembly of paternal haplotype (chromosome scaffolds)

`assembly/offspring_assembly_chr_maternal.fasta` Offspring assembly of maternal haplotype (chromosome scaffolds)

## Citing
I you use the pipeline, please site this paper: [Haplotype assembly without parental sequencing: Genotype-based trio-binning (GT-Trio)](https://doi.org/10.64898/2026.06.08.729486)

