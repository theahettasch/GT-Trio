
### Required input files
The following input files are required to run the pipeline:

- `reference_genome.fa` A high-quality reference genome for parental sequence reconstruction. 
- `parents.phased.vcf.gz` Phased genotypes for trio parents with alleles separated by vertical pipes `0|0` `1|0` `1|1`. Remember that variant positions have to match the reference genome.  
- `offspring_reads.fq.gz` Oxford Nanopore (ONT) long-reads from offspring genome. Perform any desired filtering of reads prior to running the pipeline.

### Define input files and parameters in configuration file (config/config.yaml)
Any input files and required parameters have to be defined in the configuration file before running the pipeline. 
```
### Input files and parameters ###

out_dir: "/path/out_dir_name"                         #Define the path and name for the output directory.
reference: "/path/to/reference_genome.fa"             #Path to high-quality reference genome used for parental sequence reconstruction and scaffolding.
vcf: "/path/to/parents.phased.vcf.gz"                 #Path to VCF with phased genotypes for trio parents.
offspring_reads: "/path/to/offspring_reads.fq.gz"     #Path to offspring reads (ONT).

### Step 1: Sequence reconstruction parameters ###

pat_sample: "paternal_samplename"                     #Paternal sample name used in VCF with phased genotypes.
mat_sample: "maternal_samplename"                     #Maternal sample name used in VCF with phased genotypes.

### Step 2: Read simulation parameters

read_length: "150"                                    #Read length (bp). Default is set to 150 bp to mimic Illumina short-reads.
read_depth: "30"                                      #Desired read depth per parent.
genome_size: "2800000000"                             #Genome size. Required to convert read_depth to read count (-N) in wgsim.
error_rate: "0"                                       #Base error rate. Default set to 0 to avoid introducing any errors.
mutation_rate: "0"                                    #Mutation rate. Default set to 0 to avoid introducing any mutations.
indel_fraction: "0"                                   #Indel fraction. Default set to 0 to avoid introducing any indels.
indel_extension: "0"                                  #Indel extension probability. Default set to 0 to avoid indel extension. 

### Step 3: K-mer dictionary construction parameters

yak_kmer: "21"                                        #K-mer size used to build parental k-mer dictionaries.
yak_bloom_bits: "37"                                  #Bloom filter used to filter out singleton k-mers.

### Step 5: Scaffolding parameters

grouping_conf: "0.5"                                  #Minimum grouping confidence score (-i). RagTag option.
location_conf: "0.5"                                  #Minimum location confidence score (-a). RagTag option.
orientation_conf: "0.5"                               #Minimum orientation confidence score (-s). RagTag option.
```
