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


How many variants were called?

What kinds of variants are present?

Which calls look like true variants, and which look like errors?

Are the calls supported by the alignments?

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

# 4. Clean
make clean
```
