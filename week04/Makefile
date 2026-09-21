ACCESSION := SRR929654
FASTQ_DIR := fastq
QC_DIR    := qc
REPORT_DIR := report

all: download

download:
	mkdir -p $(FASTQ_DIR)
	fastq-dump -X 100000 --outdir $(FASTQ_DIR) --split-files $(ACCESSION)

qc: download
	mkdir -p $(QC_DIR)
	fastqc $(FASTQ_DIR)/$(ACCESSION)_1.fastq \
	       $(FASTQ_DIR)/$(ACCESSION)_2.fastq \
	       --outdir $(QC_DIR) \
	       --threads 4

report: qc
	mkdir -p $(REPORT_DIR)
	multiqc $(QC_DIR) --outdir $(REPORT_DIR)

clean:
	rm -rf $(FASTQ_DIR) $(QC_DIR) $(REPORT_DIR)

.PHONY: all download qc report clean
