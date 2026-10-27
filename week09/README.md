# Homework Assignment 9: Create an automated workflow
I am starting with the workflow that created a VCF file from [Week 7](https://github.com/EXS5825/appbio-2026/tree/main/week07). My `Makefile` from [Week 8](https://github.com/EXS5825/appbio-2026/tree/main/week08) was already fully automated for multiple samples, but the Week 7 Makefile has a simpler structure that I want to build off of. 

## Preliminary information
* **Organism:** *Ostreococcus tauri* virus
* **Project:** PRJNA1345089
* **Sequencing type:** Whole-genome sequencing
* **Associated Paper:** Thomy, J., Henri, J., Demory, D., Sanchez, F., Escande, M. L., Mirambeau, G., Grimsley, N., & Yau, S. (2026). Genomic analysis of Ostreococcus tauri-infecting viruses reveals a hypervariable region associated with host-virus interactions. *Virus evolution, 12*(1), veaf096. https://doi.org/10.1093/ve/veaf096

## Updating `Makefile` from Week 7
There were a few improvements to make first: 
* genome and index now depend on `$(GENOME_FASTA)` directly, so `Make` skips the download and indexing if the files already exist.
* `samtools sort -o $(BAM) && samtools index $(BAM)` replaces `--write-index`, producing a standard `.bai` index.
* `set -o pipefail` added to `align` so a silent `bwa mem` failure isn’t swallowed by the pipe.
* 8 usable cores (leaving 2 for the OS). Change from two jobs, 4 threads to `-j 4, THREADS=2` = 8 threads used. 

## Making the design file
Issues fixed: 
* head -10 includes the header row — with --header :, GNU parallel reads the first line as the header. But piping through head -10 first means you get the header + 9 data rows, not 10. So I used head -11 for 10 samples.

## Calling variants
I wanted to call variants simultaneously instead of merging them at the end --> pass all `BAM` files to `bcftools mpileup` at once and call variants across all samples simultaneously, producing a single multi-sample VCF.
* Had to add `COMBINED_VCF` variable and `call` target. 

## Reproducibility 
```
# 1. Clone the repository
git clone https://github.com/EXS5825/appbio-2026.git

# 2. Navigate to the week09 folder
cd appbio-2026/week09

# 3. Call variants for a single sample
make SRR=SRR35893209 SAMPLE_NAME=OtV09-573 variants

# 4. Run everything up to and including variant calling
make variants

# 5. Clean
make clean
```
