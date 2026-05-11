### User-defined input files and parameters (config.yaml)

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
