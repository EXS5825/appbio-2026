# === SAMPLES ===
# Add or remove SRR:SAMPLE pairs here 
SAMPLES := SRR35893209:OtV09-573 \
           SRR35893210:OtV09-570 \
           SRR35893211:OtV09-565 \
           SRR35893212:OtV09-559

# Parse into parallel lists
SRR_LIST    := $(foreach s,$(SAMPLES),$(word 1,$(subst :, ,$(s))))
SAMPLE_LIST := $(foreach s,$(SAMPLES),$(word 2,$(subst :, ,$(s))))

# Lookup helpers: $(call srr2sample,SRR) and $(call sample2srr,SAMPLE)
srr2sample  = $(word 2,$(subst :, ,$(filter $(1):%,$(SAMPLES))))
sample2srr  = $(word 1,$(subst :, ,$(filter %:$(1),$(SAMPLES))))

# === DIRECTORIES ===
FASTQ_DIR  := fastq
QC_DIR     := qc
REPORT_DIR := report
GENOME_DIR := genome
BAM_DIR    := bam
VCF_DIR    := vcf

# === SETTINGS ===
THREADS    := 4
N          := 12700

# === REFERENCE GENOME ===
GENOME_URL   := https://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=nuccore&id=FN386611&rettype=fasta&retmode=text
GENOME_NAME  := OtV-1_REF
GENOME_FASTA := $(GENOME_DIR)/$(GENOME_NAME).fasta

# === DERIVED FILE LISTS ===
FASTQ_1S := $(foreach srr,$(SRR_LIST),$(FASTQ_DIR)/$(srr)_1.fastq)
FASTQ_2S := $(foreach srr,$(SRR_LIST),$(FASTQ_DIR)/$(srr)_2.fastq)
BAMS     := $(foreach srr,$(SRR_LIST),$(BAM_DIR)/$(srr)_vs_$(GENOME_NAME).bam)

# === MULTI-SAMPLE VCF ===
JOINT_VCF   := $(VCF_DIR)/joint_vs_$(GENOME_NAME).vcf.gz
ANN         := -d 100 --annotate INFO/AD,FORMAT/DP,FORMAT/AD,FORMAT/ADF,FORMAT/ADR,FORMAT/SP
CALL        := --ploidy 2 --annotate FORMAT/GQ
JOINT_STATS := $(VCF_DIR)/joint_vs_$(GENOME_NAME).stats.txt

# === BEHAVIOR ===
.DELETE_ON_ERROR:

# === USAGE TEXT ===
define USAGE
Usage: make <target>

  Samples defined: $(SRR_LIST)

Targets:
  download  Fetch all FASTQ files from SRA
  genome    Fetch the reference genome FASTA
  index     Index the reference genome
  align     Align all samples to the reference genome
  flagstat  Print flagstat for all BAMs
  qc        Run FastQC on all FASTQ files
  report    Generate MultiQC report
  variants  Call variants jointly and produce an indexed VCF
  stats     Generate bcftools stats on the joint VCF
  clean     Remove all generated files
endef
export USAGE

# --- all definitions above the line, all code below the line ---

usage:
	@echo "$$USAGE"

# === DOWNLOAD ===
$(FASTQ_DIR)/%_1.fastq $(FASTQ_DIR)/%_2.fastq:
	mkdir -p $(FASTQ_DIR)
	fastq-dump -X $(N) --outdir $(FASTQ_DIR) --split-files $*

download: $(FASTQ_1S) $(FASTQ_2S)

# === GENOME ===
$(GENOME_FASTA):
	mkdir -p $(GENOME_DIR)
	curl -o $@ "$(GENOME_URL)"

genome: $(GENOME_FASTA)

# === INDEX ===
$(GENOME_FASTA).bwt: $(GENOME_FASTA)
	bwa index $(GENOME_FASTA)

index: $(GENOME_FASTA).bwt

# === ALIGN ===
$(BAM_DIR)/%_vs_$(GENOME_NAME).bam: \
    $(FASTQ_DIR)/%_1.fastq $(FASTQ_DIR)/%_2.fastq \
    $(GENOME_FASTA).bwt
	mkdir -p $(BAM_DIR)
	$(eval SM := $(call srr2sample,$*))
	bwa mem \
	    -R "@RG\tID:$*\tSM:$(SM)\tLB:$*_lib\tPL:ILLUMINA\tPU:$*" \
	    -t $(THREADS) \
	    $(GENOME_FASTA) $< $(word 2,$^) | \
	    samtools sort --write-index -o $@

align: $(BAMS)

# === FLAGSTAT ===
flagstat: $(BAMS)
	@for bam in $^; do \
	    echo "=== $$bam ==="; \
	    samtools flagstat $$bam; \
	done

# === QC ===
qc: $(FASTQ_1S) $(FASTQ_2S)
	mkdir -p $(QC_DIR)
	fastqc $^ --outdir $(QC_DIR) --threads $(THREADS)

# === REPORT ===
report: qc
	mkdir -p $(REPORT_DIR)
	multiqc $(QC_DIR) --outdir $(REPORT_DIR)

# === JOINT VARIANT CALLING ===
$(JOINT_VCF): $(BAMS) $(GENOME_FASTA)
	mkdir -p $(VCF_DIR)
	bcftools mpileup $(ANN) -O u -f $(GENOME_FASTA) $(BAMS) | \
	         bcftools call $(CALL) -mv -O u | \
	         bcftools norm -f $(GENOME_FASTA) -d all -O u | \
	         bcftools sort --write-index -O z -o $@

variants: $(JOINT_VCF)

# === STATS ===
$(JOINT_STATS): $(JOINT_VCF)
	bcftools stats $< > $@

stats: $(JOINT_STATS)

# === CLEAN ===
clean:
	rm -rf $(FASTQ_DIR) $(QC_DIR) $(REPORT_DIR) $(GENOME_DIR) $(BAM_DIR) $(VCF_DIR)

.PHONY: usage download genome index align flagstat qc report variants stats clean
