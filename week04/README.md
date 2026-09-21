# Homework Assignment 4: Locate and download FASTQ files for the genome you chose.
Visit the SRA or ENA website and search for sequencing data deposited for the genome you chose in the previous assignment. Compile a short report describing how much data is available for your genome in the public scientific literature.

## Part 1: Assess the Experimental Evidence for the Genome
### 1) How "popular" is this genome? How many datasets are available?
My genome is *Genlisea aurea*, a carnivorous plant that has one of the smallest known plant genomes. 

This genome appears to be obscure, as only one group (Lomonosov Moscow State University) has ever sequenced it. The only two datasets from that group (a 623-bp library and a 413-bp library) were published in 2013. 

<kbd>
<img width="500" height="220" alt="image" src="https://github.com/user-attachments/assets/48e9539b-7ff5-46b6-b9d5-d76fc4200af6" />
</kbd>

<ins>Experiment Accession Numbers:<ins> 
- 623-bp library: SRX319576
- 413-bp library: SRX312272


### 2) What is the breakdown by sequencing strategy and platform (or some other attribute)?
Both of the libraries were sequenced using a paired-end short-read method (Illumina HiSeq 2000). 

### 3) What do you find interesting or surprising?
The coverage is very high for this genome: 

Coverage = Total bases / Genome Size

Coverage = 31 Gb / 63.6 Mb

Coverage = 487x

At first I was surprised by the high number, but later as I thought about it the coverage made more sense. This is the smallest known angiosperm genome, and Illumina gives deep coverage. This makes me feel better about their ability to resolve repetitive regions and produce a good reference genome. 

## Part 2: Download FASTQ files for an experiment
### Add commands to your Makefile so that it can download a subset of reads from the SRA based on an accession number. 
I will use the 623-bp dataset (SRR929654). My N parameter (the number of reads to download) will be the first 100,000. Following the Biostar Handbook: 
```
# Make the directory for the FASTQ files
mkdir -p fastq

# Obtain the first 100,000 reads
fastq-dump -X 100000 --outdir fastq --split-files SRR929654
```
Checked to see that everything was input properly in the Makefile: 
```
cat Makefile
```
Output: 
```
all:
	mkdir -p fastq
	fastq-dump -X 100000 --outdir fastq --split-files SRR929654
```
Looks good. 
### The Makefile should download the first N reads from an SRR accession.
Time to run the Makefile. 
```
make
```
Output: 
```
mkdir -p fastq
fastq-dump -X 100000 --outdir fastq --split-files SRR929654
Read 100000 spots for SRR929654
Written 100000 spots for SRR929654
```
### Place the files in directories named after the data type.
Look inside fastq directory: 
```
ls -lh fastq/
```
Output: 
```
total 107008
-rw-r--r--  1 exs5825  staff    26M Sep 20 21:05 SRR929654_1.fastq
-rw-r--r--  1 exs5825  staff    26M Sep 20 21:05 SRR929654_2.fastq
```
Looks right for paired-end reads (the .1 is the forward, the .2 the reverse) both the same size (26M). 

### Run a QC visualization on the downloaded reads to generate a report.
### Apply a QC method to the reads to see whether it makes a visual difference.
### Run a QC visualization on the trimmed reads to generate a report.
### Discuss whether the QC step made a difference.
### Make your Makefile generic enough to download reads from different sequencing platforms by changing the accession number alone.

#### Commit changes to Github (as a reference for myself in the future):
```
git add Makefile
git commit -m "Add target and SRR accession to Makefile"
git push
```
