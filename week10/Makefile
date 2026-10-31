# === SRR ===
SRR        := ERR14089388

# === DIRECTORIES ===
FASTQ_DIR  := fastq
QC_DIR     := qc
REPORT_DIR := report
GENOME_DIR := genome
BAM_DIR    := bam
PEAKS_DIR    := peaks

# === SETTINGS ===
THREADS    := 4

# === REFERENCE GENOME ===
GENOME_URL   := https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/900/560/965/GCF_900560965.1_PPRCHA0/GCF_900560965.1_PPRCHA0_genomic.fna.gz
GENOME_NAME  := CHA0
GENOME_FASTA := $(GENOME_DIR)/$(GENOME_NAME).fna.gz

# === SAMPLE ===
SAMPLE := ChIP_V-V5_NI
BAM          := $(BAM_DIR)/$(SRR)_vs_$(GENOME_NAME).bam

# === READS ===
FASTQ_1    := $(FASTQ_DIR)/$(SRR)_1.fastq
FASTQ_2    := $(FASTQ_DIR)/$(SRR)_2.fastq

# === PEAK CALLING ===
BKG        := ChIP_C_NI
BKG_SRR    := ERR14089381
BAM_BKG    := $(BAM_DIR)/$(BKG_SRR)_vs_$(GENOME_NAME).bam
PEAKS      := $(PEAKS_DIR)/$(SAMPLE)_peaks.narrowPeak
GENOME_SIZE := 6.86e6

# === BEHAVIOR ===
DESIGN   := design.csv
PARALLEL := parallel --eta --colsep , --header : --jobs 2 --lb
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
  peaks     Call peaks and produce an indexed peak file
  all       Run align and peaks
  batch     Run all samples from design.csv in parallel
  clean     Remove all generated files
endef
export USAGE

# --- all definitions above the line, all code below the line ---

usage:
	@echo "$$USAGE"
download:
	mkdir -p $(FASTQ_DIR)
	fastq-dump --outdir $(FASTQ_DIR) --split-files $(SRR)
genome: $(GENOME_FASTA)
$(GENOME_FASTA):                                       
	mkdir -p $(GENOME_DIR)
	curl -fsSL $(GENOME_URL) | gunzip | bgzip > $@
	samtools faidx $@

index: genome
	bwa index $(GENOME_FASTA)
align: download index
	mkdir -p $(BAM_DIR)
	bwa mem \
	    -R "@RG\tID:$(SRR)\tSM:$(SAMPLE)\tLB:$(SRR)_lib\tPL:ILLUMINA\tPU:$(SRR)" \
	    -t $(THREADS) \
	    $(GENOME_FASTA) $(FASTQ_1) $(FASTQ_2) | \
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

peaks: $(PEAKS)
$(BAM_BKG): $(GENOME_FASTA).bwt
	mkdir -p $(BAM_DIR)
	fastq-dump --outdir $(FASTQ_DIR) --split-files $(BKG_SRR)
	bwa mem \
	    -R "@RG\tID:$(BKG_SRR)\tSM:$(BKG)\tLB:$(BKG_SRR)_lib\tPL:ILLUMINA\tPU:$(BKG_SRR)" \
	    -t $(THREADS) \
	    $(GENOME_FASTA) $(FASTQ_DIR)/$(BKG_SRR)_1.fastq $(FASTQ_DIR)/$(BKG_SRR)_2.fastq | \
	    samtools sort --write-index -o $@

$(PEAKS): $(BAM) $(BAM_BKG)
	mkdir -p $(PEAKS_DIR)
	macs3 callpeak -g $(GENOME_SIZE) -n $(SAMPLE) \
	    -t $(BAM) -c $(BAM_BKG) --outdir $(PEAKS_DIR)

all: align peaks

batch:
	cat $(DESIGN) | $(PARALLEL) make SRR={run} SAMPLE={sample} all

clean:
	rm -rf $(FASTQ_DIR) $(QC_DIR) $(REPORT_DIR) $(GENOME_DIR) $(BAM_DIR) $(PEAKS_DIR)
.PHONY: usage download genome index align flagstat qc report peaks all batch clean
