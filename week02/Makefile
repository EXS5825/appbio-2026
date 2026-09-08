ACCESSION   := GCA_000441915.1
ZIP_FILE    := $(ACCESSION).zip
FASTA       := $(ACCESSION)_genomic.fna
GFF         := $(ACCESSION)_genomic.gff

# Check that the NCBI datasets tool is available
DATASETS := $(shell command -v datasets 2>/dev/null)

.PHONY: all fasta gff clean check_deps

all: check_deps $(FASTA) $(GFF)

check_deps:
ifndef DATASETS
	$(error "'datasets' CLI not found. Install it from https://www.ncbi.nlm.nih.gov/datasets/docs/v2/download-and-install/")
endif

$(ZIP_FILE):
	datasets download genome accession $(ACCESSION) --include genome,gff3 --filename $(ZIP_FILE)

$(FASTA): $(ZIP_FILE)
	unzip -p $(ZIP_FILE) "ncbi_dataset/data/$(ACCESSION)/*.fna" > $(FASTA)

$(GFF): $(ZIP_FILE)
	unzip -p $(ZIP_FILE) ncbi_dataset/data/$(ACCESSION)/genomic.gff > $(GFF)

clean:
	rm -f $(ZIP_FILE) $(FASTA) $(GFF)
