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
Add `bcftools stats` to Makefile as new target:
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
```
# Look at the ts/tv ratio
grep "^TSTV" vcf/OtV1_WGS_vs_OtV-1_REF.stats.txt
```
A <--> G and C <--> T transitions are much more chemically likely than transversions (purine replaced by pyrimidine). The expected ration would be ~2, but if it's closer to 1 then many calls may be errors. 

Result:  
```
TSTV  id  ts    tv    ts/tv  ts(1st ALT)  tv(1st ALT)  ts/tv(1st ALT)
TSTV  0   3060  1179  2.60   3060         1175         2.60
```
The ts/tv ratio = 2.60, which is good. Supports that the majority of SNPs are true variants. 

```
# Check depth distribution
grep "^DP" vcf/OtV1_WGS_vs_OtV-1_REF.stats.txt
```
As a result of subsampling reads (only 12,700 for ~10X coverage), I have a low-depth tail with some variants only being supported by 1-5 reads: 
```
DP  0  1   0  0.000000  83   1.946529
DP  0  2   0  0.000000  65   1.524390
DP  0  3   0  0.000000  40   0.938086
DP  0  4   0  0.000000  64   1.500938
DP  0  5   0  0.000000  48   1.125704
```
* Depth 1: 83 variants
* Depth 2: 65 variants
* Depth 3: 40 variants
* Depth 4: 64 variants
* Depth 5: 48 variants
* Total: 300 variants below 5x depth

The distribution rises and peaks around depths 13-18:
```
DP  0  13  0  0.000000  227  5.323640
DP  0  14  0  0.000000  278  6.519700
DP  0  15  0  0.000000  247  5.792683
DP  0  16  0  0.000000  240  5.628518
DP  0  17  0  0.000000  274  6.425891
DP  0  18  0  0.000000  278  6.519700
```
This low-depth tail should be reduced if I was using the full dataset, so for right now it's fine. 

```
# Check quality score distribution
grep "^QUAL" vcf/OtV1_WGS_vs_OtV-1_REF.stats.txt
```
Output of interest:
```
QUAL  id  quality  snps  ts    tv   indels
QUAL  0   225.4    3083  2308  775  2
```
3083 of SNPs (nearly 72% of calls) are at the maximum QUAL score of 225.4. Gives confidence in real biological variation. 

### Are the calls supported by the alignments?

## Visualize the VCF file in IGV.
Coverage looks consistent across the very zoomed-out genome (cyan):
<img width="2294" height="518" alt="image" src="https://github.com/user-attachments/assets/bd32bcc1-ea69-419d-8553-a473b23cba7d" />

### Are the calls supported by the alignments?
Variants from the VCF (dark blue track at the top) are consistent with the variants seen in the alignment. 
<img width="2276" height="1482" alt="image" src="https://github.com/user-attachments/assets/94bf8b33-4e27-421b-a299-b3bab425f38a" />

## Reproducibility
(Bioinfo environment activated)
```
# 1. Clone the repository
git clone https://github.com/EXS5825/appbio-2026.git

# 2. Navigate to the week07 folder
cd appbio-2026/week07

# 3. Run everything up to and including variant calling
make variants

--------- Optional for fun! ---------

# 4. Run the statistics report
make stats

# 5. Index the reference genome for IGV
samtools faidx genome/OtV-1_REF.fasta

# 6. Index the BAM file for IGV
samtools index bam/SRR35893209_vs_OtV-1.bam

# 7. Open IGV and load the following files:
#    - Reference genome: Genomes → Load Genome from File
#      genome/OtV-1_REF.fasta
#    - Alignments: File → Load from File
#      bam/SRR35893209_vs_OtV-1.bam
#    - Variants: File → Load from File
#      vcf/OtV1_WGS_vs_OtV-1_REF.vcf.gz
#    Navigate to a region of interest, e.g.:
#      FN386611:50000-51000

------------------------------------

# 8. Clean
make clean
```
