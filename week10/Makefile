# === SRRs ===
SRR        := SRR12148167

# === DIRECTORIES ===
FASTQ_DIR  := fastq
QC_DIR     := qc
REPORT_DIR := report
GENOME_DIR := genome
BAM_DIR    := bam
PEAKS_DIR  := peaks

# === SETTINGS ===
THREADS    := 4

# === REFERENCE GENOME ===
GENOME_URL   := https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/005/845/GCF_000005845.2_ASM584v2/GCF_000005845.2_ASM584v2_genomic.fna.gz
GENOME_NAME  := MG1655
GENOME_FASTA := $(GENOME_DIR)/$(GENOME_NAME).fna.gz

# === SAMPLE ===
SAMPLE := SigmaD_OD0.2_rep1
BAM    := $(BAM_DIR)/$(SRR)_vs_$(GENOME_NAME).bam

# === READS ===
FASTQ_1    := $(FASTQ_DIR)/$(SRR)_1.fastq
FASTQ_2    := $(FASTQ_DIR)/$(SRR)_2.fastq

# === PEAK CALLING ===
BKG        := Input_OD0.2_rep1
BKG_SRR    := SRR12148187
BAM_BKG    := $(BAM_DIR)/$(BKG_SRR)_vs_$(GENOME_NAME).bam
PEAKS      := $(PEAKS_DIR)/$(SAMPLE)_peaks.narrowPeak
GENOME_SIZE := 4641652

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
  dry-run   Preview all steps without running them
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
	    -t $(BAM) -c $(BAM_BKG) -f BAMPE --outdir $(PEAKS_DIR)

dry-run:
	$(MAKE) all --dry-run
	@echo "Dry run complete — no commands were executed"

all: align peaks

batch:
	cat $(DESIGN) | $(PARALLEL) make SRR={run} SAMPLE={sample} BKG_SRR={bkg_srr} BKG={bkg} all

clean:
	rm -rf $(FASTQ_DIR) $(QC_DIR) $(REPORT_DIR) $(GENOME_DIR) $(BAM_DIR) $(PEAKS_DIR)

.PHONY: usage download genome index align flagstat qc report peaks all batch dry-run clean
