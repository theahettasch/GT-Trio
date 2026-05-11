
############################################
# Global configuration
############################################
import math

configfile: "config.yaml"
OUTDIR = config["out_dir"]


def calc_read_pairs(depth, genome, readlen):
    return int((depth * genome) / (2 * 2 * readlen))

############################################
#Final output
############################################

rule all:
    input:
        f"{OUTDIR}/assembly/offspring_assembly_chr_paternal.fasta",
        f"{OUTDIR}/assembly/offspring_assembly_chr_maternal.fasta"


############################################
# 1. Reconstruct parental sequences
############################################

rule reconstruct_sequences:
    output:
        pat_h1=f"{OUTDIR}/parent_data/paternal_sequence_hap1.fasta",
        pat_h2=f"{OUTDIR}/parent_data/paternal_sequence_hap2.fasta",
        mat_h1=f"{OUTDIR}/parent_data/maternal_sequence_hap1.fasta",
        mat_h2=f"{OUTDIR}/parent_data/maternal_sequence_hap2.fasta"
    input:
        ref=config["reference"],
        vcf=config["vcf"]
    threads: 2
    resources:
        mem_mb=10000
    params:
        pat_sample=config["pat_sample"],
        mat_sample=config["mat_sample"]
    conda:
        "envs/bcftools.yaml"
    log:
        "logs/reconstruct_parent_sequences.log"
    shell:
        """
        bash scripts/parent_sequence_reconstruction.sh \
            {input.ref} \
            {input.vcf} \
            {params.pat_sample} \
            {params.mat_sample} \
            {output.pat_h1} \
            {output.pat_h2} \
            {output.mat_h1} \
            {output.mat_h2}
        """

############################################
# 2. Simulate parental reads
############################################


rule simulate_reads:
    output:
        pat_fq=f"{OUTDIR}/parent_data/paternal_reads.fq.gz",
        mat_fq=f"{OUTDIR}/parent_data/maternal_reads.fq.gz"
    input:
        pat_h1=f"{OUTDIR}/parent_data/paternal_sequence_hap1.fasta",
        pat_h2=f"{OUTDIR}/parent_data/paternal_sequence_hap2.fasta",
        mat_h1=f"{OUTDIR}/parent_data/maternal_sequence_hap1.fasta",
        mat_h2=f"{OUTDIR}/parent_data/maternal_sequence_hap2.fasta"
    threads: 1
    resources:
        mem_mb=10000
    params:
        readlen=config["read_length"],
        error=config["error_rate"],
        mut=config["mutation_rate"],
        indel_f=config["indel_fraction"],
        indel_e=config["indel_extension"],
        readpairs=lambda wc: calc_read_pairs(
            int(config["read_depth"]),
            float(config["genome_size"]),
            int(config["read_length"])
        )
    conda:
        "envs/wgsim.yaml"
    log:
        "logs/read_simulation.log"
    shell:
        """
        bash scripts/read_simulation.sh \
            {input.pat_h1} \
            {input.pat_h2} \
            {input.mat_h1} \
            {input.mat_h2} \
            {output.pat_fq} \
            {output.mat_fq} \
            {params.readlen} \
            {params.readpairs} \
            {params.mut} \
            {params.indel_f} \
            {params.indel_e} \
            {params.error}
        """

############################################
# 3. Construct k-mer dictionaries from parental reads
############################################

rule build_parental_kmers:
    output:
        pat_k=f"{OUTDIR}/parent_data/paternal_count.yak",
        mat_k=f"{OUTDIR}/parent_data/maternal_count.yak"
    input:
        pat_reads=f"{OUTDIR}/parent_data/paternal_reads.fq.gz",
        mat_reads=f"{OUTDIR}/parent_data/maternal_reads.fq.gz"
    threads: 4
    resources:
        mem_mb=80000
    params:
        k=config["yak_kmer"],
        bloom=config["yak_bloom_bits"]
    conda:
        "envs/yak.yaml"
    log:
        "logs/yak_kmer_dictionaries.log"
    shell:
        r"""
        set -euo pipefail

        yak count \
        -o {output.pat_k} \
        -b{params.bloom} \
        -t{threads} \
        -k{params.k} \
        {input.pat_reads}

        yak count \
        -o {output.mat_k} \
        -b{params.bloom} \
        -t{threads} \
        -k{params.k} \
        {input.mat_reads}
    """

rule haplotype_assembly:
    output:
        hifiasm_hap1=f"{OUTDIR}/assembly/offspring_assembly_contig_paternal.fa",
        hifiasm_hap2=f"{OUTDIR}/assembly/offspring_assembly_contig_maternal.fa"
        #hifiasm_hap1=f"{OUTDIR}/hifiasm/offspring_assembly.hifiasm.asm.dip.hap1.p_ctg.fa",
        #hifiasm_hap2=f"{OUTDIR}/hifiasm/offspring_assembly.hifiasm.asm.dip.hap2.p_ctg.fa"
    input:
        offspring_reads=config["offspring_reads"],
        pat_k=f"{OUTDIR}/parent_data/paternal_count.yak",
        mat_k=f"{OUTDIR}/parent_data/maternal_count.yak"
    threads: 30
    resources:
        mem_mb=400000
    params:
        outdir=OUTDIR
    conda:
        "envs/hifiasm.yaml"
    log:
        "logs/haplotype_assembly.log"
    shell:
        """
        bash scripts/haplotype_assembly.sh \
            {input.offspring_reads} \
            {input.pat_k} \
            {input.mat_k} \
            {threads} \
            {params.outdir}
        """

rule scaffold_contigs:
    output:
        hap1=f"{OUTDIR}/assembly/offspring_assembly_chr_paternal.fasta",
        hap2=f"{OUTDIR}/assembly/offspring_assembly_chr_maternal.fasta"
    input:
        hifiasm_hap1=f"{OUTDIR}/assembly/offspring_assembly_contig_paternal.fa",
        hifiasm_hap2=f"{OUTDIR}/assembly/offspring_assembly_contig_maternal.fa",
        ref=config["reference"]
    threads: 4
    resources:
        mem_mb=80000
    params:
        outdir=OUTDIR
    conda:
        "envs/ragtag.yaml"
    log:
        "logs/scaffolding.log"
    shell:
        """
        bash scripts/scaffolding.sh \
            {input.hifiasm_hap1} \
            {input.hifiasm_hap2} \
            {input.ref} \
            {output.hap1} \
            {output.hap2} \
            {threads} \
            {params.outdir}
        """