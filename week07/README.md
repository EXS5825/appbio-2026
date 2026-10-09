# Homework Assignment 7: Generate a VCF file
Start with the previous BAM `Makefile` and add additional steps to call variants. I am still working with the *Ostreococcus tauri* virus (OtV1), a large ds-DNA virus that infects a single-celled green algae (one of the smallest known eukaryotes).

**Information about the virus:**

Genome size: 191,761 bp

Genome Accession Number: FN386611.1

SRA Project Accession Number: PRJNA1345089

SRA Experiment Number: SRX30942516

SRA Run: SRR35893209

## Write a Makefile that calls variants and creates a VCF file.
Started with the `Makefile` from [Week 5](https://github.com/EXS5825/appbio-2026/tree/main/week05). Incorporated material from Biostar Handbook for variant calling. 

**Prompt to Claude:**

I have the following Makefile: [attached Makefile from Week 6]. Add additional steps to call variants and create a VCF file following the same structure as before, using this framework: 
```
# The reference genome FASTA file.
FASTA=refs/genome.fa

# The BAM file of the aligned reads.
BAM=bam/alignment.bam

# The output VCF file.
VCF=vcf/variants.vcf.gz

# Annotation parameters for the mpileup command
ANN=-d 100 --annotate 'INFO/AD,FORMAT/DP,FORMAT/AD,FORMAT/ADF,FORMAT/ADR,FORMAT/SP'

# Call parameters for the call command
CALL=--ploidy 2 --annotate 'FORMAT/GQ' 

# Variant calling process.
bcftools mpileup ${ANN} -O u -f ${FASTA} ${BAM} | \
     bcftools call ${CALL} -mv -O u | \
     bcftools norm -f ${FASTA} -d all -O u | \
     bcftools sort --write-index -O z -o ${VCF}
```

Refining: 
* Found and fixed a bug with the `ANN` variable.


**Summary of additions/changes (in my own words, so I may not be as precise as Claude):**
* In "definitions":
     * Added `VCF_DIR    := vcf` to "Directories"
     * Added `variants: Call variants and produce an indexed VCF` to "Targets"
     * Added a new section called "Variant Calling"
```
 # === VARIANT CALLING ===
VCF        := $(VCF_DIR)/$(SAMPLE_NAME)_vs_$(GENOME_NAME).vcf.gz
ANN        := -d 100 --annotate INFO/AD,FORMAT/DP,FORMAT/AD,FORMAT/ADF,FORMAT/ADR,FORMAT/SP
CALL       := --ploidy 2 --annotate FORMAT/GQ
```

* In the code section:

```
xvariants: align
	mkdir -p $(VCF_DIR)
	bcftools mpileup $(ANN) -O u -f $(GENOME_FASTA) $(BAM) | \
	         bcftools call $(CALL) -mv -O u | \
	         bcftools norm -f $(GENOME_FASTA) -d all -O u | \
	         bcftools sort --write-index -O z -o $(VCF)
```

## Run a statistics report on the VCF file.
Add bcftools stats to Makefile as new target:
* in the variables section `STATS := $(VCF_DIR)/$(SAMPLE_NAME)_vs_$(GENOME_NAME).stats.txt`
```
# new target
stats: variants
    bcftools stats $(VCF) > $(STATS)
```
* `stats` added to both the usage text and `.PHONY`.

To run the statistics report: 
```
make stats
```

### How many variants were called?
```
Lines   total/split/joined/realigned/mismatch_removed/dup_removed/skipped: 4265/0/0/21/0/1/0
```
* 4265 total lines processed
* 21 realigned
* 1 duplicate removed

= **4264 total variants called.**

### What kinds of variants are present?
```
grep "^SN" vcf/OtV1_WGS_vs_OtV-1_REF.stats.txt
```
This gives me the number of SNPs, indels, etc. 

Output: 
```
SN	0	number of samples:	1
SN	0	number of records:	4264
SN	0	number of no-ALTs:	0
SN	0	number of SNPs:	4235
SN	0	number of MNPs:	0
SN	0	number of indels:	29
SN	0	number of others:	0
SN	0	number of multiallelic sites:	4
SN	0	number of multiallelic SNP sites:	4
```
The vast majority of the variants are profiled as SNPs, with a few indels making up the rest. 
* 4,235 SNPs = 99.3% of variants
* 29 indels = 0.7% of variants
* 0 MNPs or others

### Which calls look like true variants, and which look like errors?

### Are the calls supported by the alignments?

## Visualize the VCF file in IGV.
Include a screenshot of the VCF file in IGV. 

## Reproducibility
(Bioinfo environment activated)
```
# 1. Clone the repository
git clone https://github.com/EXS5825/appbio-2026.git

# 2. Navigate to the week07 folder
cd appbio-2026/week07

# 3. Run everything up to and including variant calling
make variants

# 4. Optionally, run the statistics report. 
make stats

# 5. Clean
make clean
```
