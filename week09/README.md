# Homework Assignment 9: Create an automated workflow
I am starting with the workflow that created a VCF file from [Week 7](https://github.com/EXS5825/appbio-2026/tree/main/week07). My `Makefile` from [Week 8](https://github.com/EXS5825/appbio-2026/tree/main/week08) was already fully automated for multiple samples, but the Week 7 Makefile has a simpler structure that I want to build off of. 

## Preliminary information
* Organism: *Ostreococcus tauri* virus
* Project: PRJNA1345089
* Sequencing type: Whole-genome sequencing

## Updating `Makefile` from Week 7
There were a few improvements to make first: 
* genome and index now depend on `$(GENOME_FASTA)` directly, so `Make` skips the download and indexing if the files already exist.
* `samtools sort -o $(BAM) && samtools index $(BAM)` replaces `--write-index`, producing a standard `.bai` index.
* `set -o pipefail` added to `align` so a silent `bwa mem` failure isn’t swallowed by the pipe.
* 8 usable cores (leaving 2 for the OS). Change from two jobs, 4 threads to `-j 4, THREADS=2` = 8 threads used. 

## Making the design file
Issues fixed: 
* head -10 includes the header row — with --header :, GNU parallel reads the first line as the header. But piping through head -10 first means you get the header + 9 data rows, not 10. So I used head -11 for 10 samples.

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
