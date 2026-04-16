# Trio-binning-genotype
This is a pipeline for creating haplotype-resolved genome assemblies with trio-binning, using parent sequences reconstructed from genotypes as input for trio-binning. The pipeline consists of four main steps: (1) parental sequence reconstruction from genotypes, (2) read simulation, (3) haplotype-resolved assembly with trio-binning and (4) reference-based scaffolding of contigs. 

## Workflow description
### Step 1: Reconstruction of parental sequences 
In parent_sequence_reconstruction.sh, parent sequences are reconstructed from a high-quality reference genome (FASTA) and a dataset of phased parental genotypes (VCF) with BCFtools consensus. To account for phasing, two parent-specific sequences, representing either haplotypes are reconstructed using the `--haplotype` option.



### Step 2: Read simulation
read_simulation.sh

### Step 3: Haplotype-resolved assembly
haplotype_assembly.sh

### Step 4: Reference-based scaffolding
scaffolding.sh


## Running the pipeline with your own data
The scripts provided in this repository can be downloaded and used to do genotype-based trio-binning. The following sofware tools and input files are have to be available. 

## Software dependencies
- [BCFtools](https://samtools.github.io/bcftools/bcftools.html)
- [SAMtools](https://github.com/samtools/samtools)
- [Yak](https://github.com/lh3/yak)
- [Hifiasm](https://github.com/chhylp123/hifiasm) (v0.24.0 or newer)
- [RagTag](https://github.com/malonge/RagTag)
  
## Input file requirements
- A high-quality reference genome (FASTA) for parental sequence reconstruction (step 1) and reference-based scaffolding (step 4)
- Phased genotypes for trio parent individuals (VCF)
- ONT reads for offspring individual (FASTQ)

## Citing
