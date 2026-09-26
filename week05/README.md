# Homework Assignment 5: Generate a BAM file
<ins>Preliminary information:</ins>

Organism: *Genlisea aurea*.

Genome size: 63.6 Mb

Experiment from SRA website: SRX319576

Run: SRR929654

<img width="832" height="148" alt="image" src="https://github.com/user-attachments/assets/1ea5521a-e777-4df3-9511-8a2e0e8d79a8" />

### Estimate the N number of reads you should download to get a coverage of at least 10x. 
Need 10 bases of coverage for every base in the genome (genome size = 63.6 Mb). Read length = ~201.8 bases (total bases divided by total spots)) 

Number of reads = (Desired coverage * Genome size) / Read length

Number of reads = (10X * 63.6 Mb) / 201.8 bases

... 3,152,000 reads needed. This is well over the 1 million cutoff. :(

Since this is the smallest plant genome I could find, I will have to turn to a different organism. 

# Starting over: Preliminary information for new organism: 
Organism: *Ostreococcus tauri virus* (OtV1), a virus that infects a single-celled green algae. This algae is the smallest known free-living eukaryote on earth, with a diameter of only 0.8 micrometers (smaller than many bacteria)! The virus has a large double-stranded DNA genome. 

Genome size: 191,761 bp (DOI: 10.1111/j.1462-2920.2009.01991.x)

Experiment from SRA website: SRX30942516

Run: SRR35893209	

Paper that I pulled info from: Weynberg, K. D., Allen, M. J., Ashelford, K., Scanlan, D. J., & Wilson, W. H. (2009). From small hosts come big viruses: the complete genome of a second Ostreococcus tauri virus, OtV-1. Environmental microbiology, 11(11), 2821–2839. https://doi.org/10.1111/j.1462-2920.2009.01991.x

### Estimate the N number of reads you should download to get a coverage of at least 10x.
Desired coverage = 10x, genome size = 13Mb, read length = 147 (total bases / total spots). 

Number of reads = (Desired coverage * Genome size) / Read length 
N = (10 × 191,761) / 151
N ≈ 12,700 reads

This is well below 1 million, so I'll move forward with this genome and sequencing run. 

## Write a Makefile that aligns the reads and creates a BAM file.
I assume this is in addition to downloading the reads from the SRA database. 

## Run a statistics report on the BAM file.
What percent of the reads align?

## Visualize the BAM file in IGV.
What do the alignments look like? Do the reads show errors or variations?

Is the coverage uniform?

Include a screenshot of the BAM file in IGV.

## Write a README.md that a reviewer can follow.
Include the commands needed to run the Makefile. 
