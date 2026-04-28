# GenoType-based Trio-binning (GT-Trio)

This is a [Snakemake](https://snakemake.readthedocs.io/en/stable/) pipeline for creating haplotype-resolved genome assemblies with trio-binning, using phased genotypes as parental input. The pipeline consists of three main steps: (1) parental sequence reconstruction, (2) read simulation and (3) haplotype-resolved assembly with trio-binning. 


## Workflow description
### Step 1: Parental sequence reconstruction
**Software:** [BCFtools](https://samtools.github.io/bcftools/bcftools.html)

Parent sequences are reconstructed from a high-quality reference genome (FASTA) and a dataset of phased parental genotypes (VCF) with BCFtools consensus. To account for phasing, two parent-specific sequences, representing either haplotypes are reconstructed using the `--haplotype` option.

### Step 2: Read simulation
**Software:** [SAMtools](https://github.com/samtools/samtools)
read_simulation.sh

### Step 3: Haplotype-resolved assembly with trio-binning
**Software:** [Yak](https://github.com/lh3/yak), [Hifiasm](https://github.com/chhylp123/hifiasm) (v0.24.0 or newer)
haplotype_assembly.sh


## Usage
### Environment setup
### Clone repo
### Prepare input files
- A high-quality reference genome (FASTA) for parental sequence reconstruction (step 1) and reference-based scaffolding (step 4)
- Phased genotypes for trio parent individuals (VCF)
- ONT reads for offspring individual (FASTQ)

## Running the pipeline with your own data
The scripts provided in this repository can be downloaded and used to do genotype-based trio-binning. The following sofware tools and input files are have to be available. 
  
## Input file requirements


## Citing
