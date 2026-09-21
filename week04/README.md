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
My prompt to Claude: "I have a Makefile [attached my original from above] that downloads the first 100,000 reads from a sequencing run. How do I run a QC visualization on the downloaded reads to generate a report?"

Claude's output: 
```
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
```
Seems understandable and not overly complicated. 

### Apply a QC method to the reads to see whether it makes a visual difference. Run a QC visualization on the trimmed reads to generate a report.
Needed to install multiqc first. 
```
pixi add multiqc
```
Once it was successfully installed, run the report. 
```
pixi run make report
```
Output: 
```
mkdir -p fastq
fastq-dump -X 100000 --outdir fastq --split-files SRR929654
Read 100000 spots for SRR929654
Written 100000 spots for SRR929654
mkdir -p qc
fastqc fastq/SRR929654_1.fastq \
       fastq/SRR929654_2.fastq \
       --outdir qc \
       --threads 4
null
null
Started analysis of SRR929654_1.fastq
Approx 5% complete for SRR929654_1.fastq
Approx 10% complete for SRR929654_1.fastq
Approx 15% complete for SRR929654_1.fastq
Approx 20% complete for SRR929654_1.fastq
Approx 25% complete for SRR929654_1.fastq
Approx 30% complete for SRR929654_1.fastq
Approx 35% complete for SRR929654_1.fastq
Approx 40% complete for SRR929654_1.fastq
Approx 45% complete for SRR929654_1.fastq
Approx 50% complete for SRR929654_1.fastq
Approx 55% complete for SRR929654_1.fastq
Approx 60% complete for SRR929654_1.fastq
Approx 65% complete for SRR929654_1.fastq
Approx 70% complete for SRR929654_1.fastq
Approx 75% complete for SRR929654_1.fastq
Approx 80% complete for SRR929654_1.fastq
Approx 85% complete for SRR929654_1.fastq
Approx 90% complete for SRR929654_1.fastq
Started analysis of SRR929654_2.fastq
Approx 5% complete for SRR929654_2.fastq
Approx 95% complete for SRR929654_1.fastq
Approx 100% complete for SRR929654_1.fastq
Approx 10% complete for SRR929654_2.fastq
Analysis complete for SRR929654_1.fastq
Approx 15% complete for SRR929654_2.fastq
Approx 20% complete for SRR929654_2.fastq
Approx 25% complete for SRR929654_2.fastq
Approx 30% complete for SRR929654_2.fastq
Approx 35% complete for SRR929654_2.fastq
Approx 40% complete for SRR929654_2.fastq
Approx 45% complete for SRR929654_2.fastq
Approx 50% complete for SRR929654_2.fastq
Approx 55% complete for SRR929654_2.fastq
Approx 60% complete for SRR929654_2.fastq
Approx 65% complete for SRR929654_2.fastq
Approx 70% complete for SRR929654_2.fastq
Approx 75% complete for SRR929654_2.fastq
Approx 80% complete for SRR929654_2.fastq
Approx 85% complete for SRR929654_2.fastq
Approx 90% complete for SRR929654_2.fastq
Approx 95% complete for SRR929654_2.fastq
Approx 100% complete for SRR929654_2.fastq
Analysis complete for SRR929654_2.fastq
mkdir -p report
multiqc qc --outdir report

/// MultiQC 🔍 v1.35

       file_search | Search path: /Users/exs5825/Desktop/BMMB_852/week04/appbio-2026/week04/qc
         searching | ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 100% 4/4  
            fastqc | Found 2 reports
     write_results | Data        : report/multiqc_data
     write_results | Report      : report/multiqc_report.html
           multiqc | MultiQC complete
```
Then viewed the report:
```
open report/multiqc_report.html
```
### Discuss whether the QC step made a difference.
Based on the QC report, the data looks really good! 

Mean quality scores:
<img width="1924" height="1006" alt="image" src="https://github.com/user-attachments/assets/438e1e5f-5f41-4091-9c9b-1e954ec34431" />

The lowest point on this graph is still solidly in the green! 

Per Sequence Quality scores: 
<img width="1928" height="986" alt="image" src="https://github.com/user-attachments/assets/4d396547-0d8a-43df-9e89-a48917f4d4ed" />

The vast majority of reads here are in the high-quality range. The data are unlikely to benefit from being trimmed in this case, as a trimmer would discard almost none of these reads anyway. 

### Make your Makefile generic enough to download reads from different sequencing platforms by changing the accession number alone.
My prompt to Claude: Is this Makefile [attached Makefile from QC visualization] generic enough to download reads from different sequencing platforms by changing the accession number alone? 

Claude's output [summarized]: 
Pros to this Makefile: 
* Changing ACCESSION alone will correctly download any SRA run — fastq-dump handles Illumina, PacBio, Nanopore, etc.
* -X 100000 (read limit) is platform-agnostic.
* multiqc is broadly compatible.

Cons to this Makefile: 
* --split-files and hardcoded _1/_2 suffixes — this is the biggest issue. --split-files produces _1.fastq/_2.fastq only for paired-end reads. Single-end runs (common in older Illumina, PacBio, Nanopore) produce just ACCESSION.fastq with no numeric suffix, so the fastqc command silently fails to find its inputs.
* fastqc itself — FastQC is designed for short reads. It runs on long-read files without crashing, but the output is largely meaningless for PacBio/Nanopore. If cross-platform QC is a goal, you'd want NanoPlot or PycoQC for long reads.
* 4 threads hardcoded — minor, but worth parameterising.

I prioritized fixing the first issue. I like fastqc a lot, so I decided to keep it since it. 

Claude's summary of the changes: "The key change is $(ACCESSION)*.fastq — the glob matches _1/_2 for paired-end, the bare accession for single-end, and even _1/_2/_3 for the occasional three-read layout (e.g. 10x Chromium with index reads), so you can swap accessions freely without touching anything else."

#### Final changes were committed to Github (included this as a reference for myself in the future) :
```
git add Makefile
git commit -m "have a nice day!"
git push
```
