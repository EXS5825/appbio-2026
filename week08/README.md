# Homework Assignment 8: Interpret a multisample VCF file
Starting with the previous `Makefile` in [Week 7](https://github.com/EXS5825/appbio-2026/tree/main/week07) that created a VCF file of one run from whole-genome sequencing of *Ostreococcus tauri* virus (PRJNA1345089). 

See the bottom of the assignment for reproducibility. 

## Sample runs
I kept my original SRR run (SRR35893209) and added three new ones: SRR35893210, SRR35893211, & SRR35893212. Fetched their sample names by running: 
```
curl -s "https://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=sra&id=SRR35893209,SRR35893210,SRR35893211,SRR35893212&rettype=runinfo&retmode=csv" |     cut -d',' -f1,12
```

Output:
```
SRR35893212,OtV09-559
SRR35893211,OtV09-565
SRR35893210,OtV09-570
SRR35893209,OtV09-573
```

## Updating definitions and targets for making a merged multisample VCF
**Added a new "Samples" group at the top of my Makefile:** 
```
# === SAMPLES ===
# Add or remove SRR:SAMPLE pairs here 
SAMPLES := SRR35893209:OtV09-573 \
           SRR35893210:OtV09-570 \
           SRR35893211:OtV09-565 \
           SRR35893212:OtV09-559
```
This combines the `SRR` and `Sample Name` groups from before. Makefile still feels like it's getting long, but consolidating here and there helps. 

**Parse out the SRR accessions and derive all file paths (expands the SAMPLES list into a flat list of just the SRR accessions):** 
```
SRR_LIST := $(foreach s,$(SAMPLES),$(word 1,$(subst :, ,$(s))))

FASTQ_1S := $(foreach srr,$(SRR_LIST),$(FASTQ_DIR)/$(srr)_1.fastq)
FASTQ_2S := $(foreach srr,$(SRR_LIST),$(FASTQ_DIR)/$(srr)_2.fastq)
BAMS     := $(foreach srr,$(SRR_LIST),$(BAM_DIR)/$(srr)_vs_$(GENOME_NAME).bam)
```
Needed because we don't have a single sample anymore. 

**Match sample name to SRR accession number and build the read group string**
```
srr2sample = $(word 2,$(subst :, ,$(filter $(1):%,$(SAMPLES))))
RG         = @RG\tID:$(1)\tSM:$(call srr2sample,$(1))\tLB:$(1)$(RG_LB_SUFFIX)\tPL:$(RG_PL)\tPU:$(1)
```
`RG` substitutes the SRR accession and sample name into the right positions in that tab-separated tag format that BAM files expect. 

## Updating Makefile commands for making a merged multisample VCF
**Change `fastq-dump` command to accomodate multiple SRR accessions**
```
$(FASTQ_DIR)/%_1.fastq $(FASTQ_DIR)/%_2.fastq:
	fastq-dump -X $(N) --outdir $(FASTQ_DIR) --split-files $*
```
Old version was a hardcoded rule. New version is a pattern rule that fires once per SRR accession automatically, rather than once for a single hardcoded $(SRR)

**Change `align` rule to align any SRR and tag it with the correct read group**
```
$(BAM_DIR)/%_vs_$(GENOME_NAME).bam: \
    $(FASTQ_DIR)/%_1.fastq $(FASTQ_DIR)/%_2.fastq \
    $(GENOME_FASTA).bwt
	bwa mem \
	    -R "$(call RG,$*)" \
	    ...
	    samtools sort --write-index -o $@
```
Original was hardcoded to a single `$(BAM)`. The new `$(call RG,$*)` injects the correct `SM` tag (sample name field) for each sample so the variant caller can tell them apart. 

**Simultaneous calling of variants from all BAMs**
```
bcftools mpileup $(ANN) -O u -f $(GENOME_FASTA) $(BAMS) | \
         bcftools call $(CALL) -mv -O u | \
```
`$(BAMS)` expands to all four BAMs, each labelled with distinct SM read group tag. Then `bcftools` produces a single multi-sample VCF with one column per sample. 

# Reproducibility: 
```
# 1. Clone the repository
git clone https://github.com/EXS5825/appbio-2026.git

# 2. Navigate to the week08 folder
cd appbio-2026/week08

# 3. Run the pipeline
make variants

# 4. Clean
make clean
```

Also found an article with a really cool picture of these massive viruses inside their tiny hosts (these algae cells are smaller than some bacteria!): https://enviromicro-journals.onlinelibrary.wiley.com/doi/full/10.1111/j.1462-2920.2009.01991.x. See Figure 1B. 
