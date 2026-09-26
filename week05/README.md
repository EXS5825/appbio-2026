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
Organism: *Ostreococcus tauri*, a single-celled green algae. It is the smallest known free-living eukaryote on earth, with a diameter of only 0.8 micrometers (smaller than many bacteria)!

Genome size: 13Mb (https://www.biorxiv.org/content/10.64898/2026.07.24.739820v1.full)

Experiment from SRA website: SRX33676564

Run: SRR38913763

<img width="972" height="146" alt="image" src="https://github.com/user-attachments/assets/3937f505-fa87-4104-acee-c6ec9f09dcbf" />


### Estimate the N number of reads you should download to get a coverage of at least 10x.
Desired coverage = 10x, genome size = 13Mb, read length = 147 (total bases / total spots). 

Number of reads = (Desired coverage * Genome size) / Read length 

N = (10 × 13,000,000) / 147
N ≈ 884,354 reads

This is below 1 million, so I'll move forward with this genome and sequencing run. 
