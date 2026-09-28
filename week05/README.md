# Homework Assignment 5: Generate a BAM file
<ins>Preliminary information:</ins>

Organism: *Genlisea aurea*, genome size = 63.6 Mb

Experiment from SRA website: SRX319576. Run: SRR929654

<img width="832" height="148" alt="image" src="https://github.com/user-attachments/assets/1ea5521a-e777-4df3-9511-8a2e0e8d79a8" />

### Estimate the N number of reads you should download to get a coverage of at least 10x. 
Need 10 bases of coverage for every base in the genome (genome size = 63.6 Mb). Read length = ~201.8 bases (total bases divided by total spots)) 

Number of reads = (Desired coverage * Genome size) / Read length

Number of reads = (10X * 63.6 Mb) / 201.8 bases

... 3,152,000 reads needed. This is well over the 1 million cutoff. :(

Since this is the smallest plant genome I could find, I will have to turn to a different organism. 

# Starting over: Preliminary information for new organism: 
Organism: *Ostreococcus tauri virus* (OtV1), a virus that infects a single-celled green algae. This algae is the smallest known free-living eukaryote on earth, with a diameter of only 0.8 micrometers (smaller than many bacteria)! The virus has a large double-stranded DNA genome. 

Genome size: 191,761 bp 

Genome Accession Number: FN386611.1

SRA Project Accession Number: PRJNA1345089 

SRA Experiment Number: SRX30942516

SRA Run: SRR35893209	

Paper that I pulled info from: Weynberg, K. D., Allen, M. J., Ashelford, K., Scanlan, D. J., & Wilson, W. H. (2009). From small hosts come big viruses: the complete genome of a second Ostreococcus tauri virus, OtV-1. Environmental microbiology, 11(11), 2821–2839. https://doi.org/10.1111/j.1462-2920.2009.01991.x

### Estimate the N number of reads you should download to get a coverage of at least 10x.
Desired coverage = 10x, genome size = 13Mb, read length = 147 (total bases / total spots). 

Number of reads = (Desired coverage * Genome size) / Read length 
N = (10 × 191,761) / 151
N ≈ 12,700 reads

This is well below 1 million, so I'll move forward with this. 

## Write a Makefile that aligns the reads and creates a BAM file.
I took my Makefile from last week and worked with Claude to fix some issues with it as well as adding the new information I needed for this week's assignment. 

<ins>Improvements:</ins>
* Restructured Makefile to have # —- all definitions above the line, all code below the line —-
* Added headers to everything
* Added `.DELETE_ON_ERROR:` to stop partial files from being left behind and having subsequent steps silently using bad data from a failed `fastq-dump`.
* Changed "Accession" to "SRR" for my own clarity of mind
* Incorporated Makefile's `define` block to clean up a bunch of "echo" commands I was seeing
* Reorganized some of the definitions to better fit into the categories of headers

<ins>Added for this week's assignment:</ins>
* Changed the SRR number and added N (number of reads) to the definitions (using the number I calculated from before)
* Added the reference genome URL, FASTQ_1 (first read file) and FASTQ_2 (second read file), a user-friendly name for the genome (Otv-1_REF), GENOME_FASTA = OtV-1_REF.fasta, and a user-friendly SAMPLE_NAME = OtV1_WGS
* Added BAM file name that combined both datasets: SRR35893209_vs_OtV-1.bam
* Indexed the reference genome
* Added commands for generating a BAM file

To run the Makefile: 
```
make flagstat
```

## Run a statistics report on the BAM file. What percent of the reads align? 
The `flagstat` command gives me a stats report, which is quite long. Here are some of the key numbers: 
* `22111 + 0 primary mapped (87.05% : N/A)` --> 87.05% of the reads aligned to the reference genome.
* `21044 + 0 properly paired (82.85% : N/A)` --> 82.85% of the reads aligned in the expected orientation and distance.
* `0 + 0 with mate mapped to a different chr` --> none of the reads mapped to a different chromosome, which makes sense since this is a virus without defined chromosomes. 

## Visualize the BAM file in IGV.
### What do the alignments look like? Do the reads show errors or variations?

Colored bases = mismatches, gray = bases match to reference genome. The reads do seem to have lots of variation and/or errors, judging from all the color that can be seen. Some are in consistent stripes (probably natural variation) across multiple lines, others seem to be a one-off difference, which may indicate errors: 
<img width="2276" height="1308" alt="image" src="https://github.com/user-attachments/assets/4aafdb19-0303-4226-b271-489b099fadfb" />

### Is the coverage uniform?
No, as indicated by the bumps and valleys in the top bar. The amount of variability depends on the area. 
<img width="2264" height="1302" alt="image" src="https://github.com/user-attachments/assets/60f751ea-a370-44e8-ac9e-a74556e1f554" />

Some areas have large gaps in coverage: 
<img width="2280" height="1328" alt="image" src="https://github.com/user-attachments/assets/c38df7f2-881c-4756-87b3-d7c2cab3c7fc" />

## Write a README.md that a reviewer can follow.
Reproducibility: 

(Bioinfo environment activated)
```
# 1. Clone the repository
git clone https://github.com/EXS5825/appbio-2026.git

# 2. Navigate to the week05 folder
cd appbio-2026/week05

# 3. Run the pipeline
make flagstat

# 4. Clean
make clean

```
