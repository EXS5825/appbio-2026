# Makefile for downloading GCA_000441915.1 genome files from NCBI
#
# Install the datasets CLI
pixi global install ncbi-datasets-cli
#
# Downloads the genomic FASTA and GFF3 annotation files using the
# NCBI Datasets CLI (https://www.ncbi.nlm.nih.gov/datasets/docs/v2/download-and-install/)
# or, as a fallback, via direct FTP/HTTPS URLs.
#
# Usage:
#   make          – download both FASTA and GFF
#   make fasta    – download only the FASTA
#   make gff      – download only the GFF
#   make clean    – remove all downloaded files

ACCESSION   := GCA_000441915.1

# --- NCBI Datasets CLI paths (preferred) -----------------------------------
DATASETS    := datasets          # assumes `datasets` is on PATH
DATALINK    := datalink          # companion tool (optional, used for URLs)

ZIP_FILE    := $(ACCESSION).zip
UNZIP_DIR   := ncbi_dataset

# Final output file names
FASTA       := $(ACCESSION)_genomic.fna
GFF         := $(ACCESSION)_genomic.gff

# ---------------------------------------------------------------------------
.PHONY: all fasta gff clean

all: $(FASTA) $(GFF)

# --- Download both files via NCBI datasets CLI in one zip ------------------
$(ZIP_FILE):
	@echo ">>> Downloading genome package for $(ACCESSION) ..."
	$(DATASETS) download genome accession $(ACCESSION) \
		--include genome,gff3 \
		--filename $(ZIP_FILE)

# --- Extract FASTA ----------------------------------------------------------
$(FASTA): $(ZIP_FILE)
	@echo ">>> Extracting FASTA ..."
	unzip -p $(ZIP_FILE) \
		"$(UNZIP_DIR)/data/$(ACCESSION)*/$(ACCESSION)_*_genomic.fna" \
		> $(FASTA)
	@echo "    Written: $(FASTA)"

# --- Extract GFF ------------------------------------------------------------
$(GFF): $(ZIP_FILE)
	@echo ">>> Extracting GFF ..."
	unzip -p $(ZIP_FILE) \
		"$(UNZIP_DIR)/data/$(ACCESSION)*/genomic.gff" \
		> $(GFF)
	@echo "    Written: $(GFF)"

fasta: $(FASTA)
gff:   $(GFF)

# --- Clean up ---------------------------------------------------------------
clean:
	@echo ">>> Removing downloaded files ..."
	rm -f $(ZIP_FILE) $(FASTA) $(GFF)
	rm -rf $(UNZIP_DIR)
