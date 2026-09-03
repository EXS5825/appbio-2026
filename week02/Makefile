ACCESSION   := GCA_000441915.1
ZIP_FILE    := $(ACCESSION).zip
UNZIP_DIR   := ncbi_dataset
FASTA       := $(ACCESSION)_genomic.fna
GFF         := $(ACCESSION)_genomic.gff

.PHONY: all fasta gff clean

all: $(FASTA) $(GFF)

$(ZIP_FILE):
	datasets download genome accession $(ACCESSION) --include genome,gff3 --filename $(ZIP_FILE)

$(FASTA): $(ZIP_FILE)
	unzip -p $(ZIP_FILE) ncbi_dataset/data/$(ACCESSION)/$(ACCESSION)_GenAur_1.0_genomic.fna > $(FASTA)

$(GFF): $(ZIP_FILE)
	unzip -p $(ZIP_FILE) ncbi_dataset/data/$(ACCESSION)/genomic.gff
