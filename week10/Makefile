# === SRR ===
SRR        := SRR35893209
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
GENOME_FASTA := $(GENOME_DIR)/OtV-1_REF.fasta
# === SAMPLE ===
SAMPLE_NAME  := OtV1_WGS
BAM          := $(BAM_DIR)/SRR35893209_vs_OtV-1.bam
# === READS ===
FASTQ_1    := $(FASTQ_DIR)/$(SRR)_1.fastq
FASTQ_2    := $(FASTQ_DIR)/$(SRR)_2.fastq
# === VARIANT CALLING ===
VCF        := $(VCF_DIR)/$(SAMPLE_NAME)_vs_$(GENOME_NAME).vcf.gz
ANN        := -d 100 --annotate INFO/AD,FORMAT/DP,FORMAT/AD,FORMAT/ADF,FORMAT/ADR,FORMAT/SP
CALL       := --ploidy 2 --annotate FORMAT/GQ
STATS      := $(VCF_DIR)/$(SAMPLE_NAME)_vs_$(GENOME_NAME).stats.txt
# === BEHAVIOR ===
.DELETE_ON_ERROR:
# === USAGE TEXT ===
define USAGE
Usage: make <target>
Targets:
  download  Fetch FASTQ files from SRA
  genome    Fetch the reference genome FASTA
  index     Index the reference genome
  align     Align reads to the reference genome
  flagstat  Generate a summary of the BAM file
  qc        Run FastQC on downloaded files
  report    Generate MultiQC report
  variants  Call variants and produce an indexed VCF
  stats     Generate bcftools statistics report on the VCF
  clean     Remove all generated files
endef
export USAGE
# --- all definitions above the line, all code below the line ---
usage:
	@echo "$$USAGE"
download:
	mkdir -p $(FASTQ_DIR)
	fastq-dump -X $(N) --outdir $(FASTQ_DIR) --split-files $(SRR)
genome:
	mkdir -p $(GENOME_DIR)
	curl -o $(GENOME_FASTA) "$(GENOME_URL)"
index: genome
	bwa index $(GENOME_FASTA)
align: download index
	mkdir -p $(BAM_DIR)
	bwa mem $(GENOME_FASTA) $(FASTQ_1) $(FASTQ_2) | \
	        samtools sort --write-index -o $(BAM)
flagstat: align
	samtools flagstat $(BAM)
qc: download
	mkdir -p $(QC_DIR)
	fastqc $(FASTQ_DIR)/$(SRR)*.fastq \
	       --outdir $(QC_DIR) \
	       --threads $(THREADS)
report: qc
	mkdir -p $(REPORT_DIR)
	multiqc $(QC_DIR) --outdir $(REPORT_DIR)
variants: align
	mkdir -p $(VCF_DIR)
	bcftools mpileup $(ANN) -O u -f $(GENOME_FASTA) $(BAM) | \
	         bcftools call $(CALL) -mv -O u | \
	         bcftools norm -f $(GENOME_FASTA) -d all -O u | \
	         bcftools sort --write-index -O z -o $(VCF)
stats: variants
	bcftools stats $(VCF) > $(STATS)
clean:
	rm -rf $(FASTQ_DIR) $(QC_DIR) $(REPORT_DIR) $(GENOME_DIR) $(BAM_DIR) $(VCF_DIR)
.PHONY: usage download genome index align flagstat qc report variants stats clean
