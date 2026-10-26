# Homework Assignment 9: Create an automated workflow
I am starting with the workflow that created a VCF file from [Week 7](https://github.com/EXS5825/appbio-2026/tree/main/week07). My `Makefile` from [Week 8](https://github.com/EXS5825/appbio-2026/tree/main/week08) was already fully automated for multiple samples, but the Week 7 Makefile has a simpler structure that I want to build off of. 

## Preliminary information
* Organism: *Ostreococcus tauri* virus
* Project: PRJNA1345089
* Sequencing type: Whole-genome sequencing

Previously, I had used these SRR runs in [Week 8](https://github.com/EXS5825/appbio-2026/tree/main/week08):
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

## Updating `Makefile` from Week 7
There were a few improvements to make first: 
* genome and index now depend on `$(GENOME_FASTA)` directly, so `Make` skips the download and indexing if the files already exist.
* `samtools sort -o $(BAM) && samtools index $(BAM)` replaces `--write-index`, producing a standard `.bai` index.
* `set -o pipefail` added to `align` so a silent `bwa mem` failure isn’t swallowed by the pipe.
* 8 usable cores (leaving 2 for the OS). Change from two jobs, 4 threads to `-j 4, THREADS=2` = 8 threads used. 


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
