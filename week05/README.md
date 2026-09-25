# Homework Assignment 5: Generate a BAM file
Preliminary information: 

Organism: *Genlisea aurea*.

Experiment from SRA website: SRX319576

Run: SRR929654

<img width="832" height="148" alt="image" src="https://github.com/user-attachments/assets/1ea5521a-e777-4df3-9511-8a2e0e8d79a8" />

# Estimate the N number of reads you should download to get a coverage of at least 10x. 
Need 10 bases of coverage for every base in the genome (genome size = 63.6 Mb). Read length = ~201.8 bases (total bases divided by total spots)) 

Number of reads = (Desired coverage * Genome size) / Read length

Number of reads = (10X * 63.6 Mb) / 201.8 bases

... 3,152,000 reads needed. This is well over the 1 million cutoff. 

Since this is the smallest plant genome I could find, I will have to turn to a different organism. 
