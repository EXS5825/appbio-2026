# Homework Assignment 9: Create an automated workflow
I am starting with the workflow that created a VCF file from [Week 8](https://github.com/EXS5825/appbio-2026/tree/main/week08). This pipeline was already fully automated for multiple samples, but now I will add more samples and update it to run in parallel. 

## Preliminary information
* Organism: *Ostreococcus tauri* virus
* Project: PRJNA1345089
* Sequencing type: Whole-genome sequencing

Previously, I had used these SRR runs:
| SRR Number | Sample Name | Collection Area |
|------------|-------------|-----------------|
| SRR35893209 | OtV09-573 | La Palme lagoon (Mediterranean Sea near France) |
| SRR35893210 | OtV09-570 | Leucate lagoon (Mediterranean Sea near France) |
| SRR35893211 | OtV09-565 | La Palme lagoon (Mediterranean Sea near France) |
| SRR35893212 | OtV09-559 | La Palme lagoon (Mediterranean Sea near France) |

New SRR runs to add to get up to ten total samples: 
| SRR Number | Sample Name | Collection Area |
|------------|-------------|-----------------|
| SRR35893213 | OtV09-557 | La Palme lagoon (Mediterranean Sea near France) |
| SRR35893214 | OtV09-556 | Thau lagoon (Mediterranean Sea near France) |
| SRR35893215 | OtV06-4 | La Palme lagoon (Mediterranean Sea near France) |
| SRR35893216 | OtV06-12 | Thau lagoon (Mediterranean Sea near France) |
| SRR35893217 | OtV19-R | South Pacific Ocean near Chile |
| SRR35893218 | OtV-Sylt2-5 | North Sea near Germany |

I noticed the different collection areas this time around and thought it was interesting! 

Double-checked the new sample names: 
```
curl -s "https://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=sra&id=SRR35893213,SRR35893214,SRR35893215,SRR35893216,SRR35893217,SRR35893218&rettype=runinfo&retmode=csv" | cut -d',' -f1,12
```

## Updating `Makefile`
* Fixed a bug in the `download` section: the `download` rule produced two output files (paired-end reads), and originally `fastq-dump` would have tried to write twice (one for each of the output files) for the same sample if I had tried to run this process in parallel, corrupting the output. 

    Simple fix: Added `&:` to the end of this command, which tells Make “these two files come from one recipe, run it once.”: 
    ```
    $(FASTQ_DIR)/%_1.fastq $(FASTQ_DIR)/%_2.fastq &:
    ```

* Also made it easier to run just one sample from the Makefile if desired. Added this to the `Makefile`:
    ```
    sample: $(BAM_DIR)/$(call sample2srr,$(SAMPLE))_vs_$(GENOME_NAME).bam
    ```
    Which allows me to type: 
    ```
    make sample SAMPLE=OtV09-570
    ```
    Instead of: 
    ```
    make bam/SRR35893210_vs_OtV-1_REF.bam
    ```
* My `Makefile` already had a way to run the samples in parallel:
    ```
    make -j
    ```
    The number of parallel jobs is specified after -j, e.g. `make -j5`. 

## Reproducibility 
```
# 1. Clone the repository
git clone https://github.com/EXS5825/appbio-2026.git

# 2. Navigate to the week09 folder
cd appbio-2026/week09

# 3. Test one sample first
make sample SAMPLE=OtV09-570

# 4. Run everything up to and including variant calling
make variants

# 5. Clean
make clean
```
