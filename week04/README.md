# Homework Assignment 4: Locate and download FASTQ files for the genome you chose.
Visit the SRA or ENA website and search for sequencing data deposited for the genome you chose in the previous assignment. Compile a short report describing how much data is available for your genome in the public scientific literature.

## Experimental Evidence for the Genome
### 1) How "popular" is this genome? How many datasets are available?
My genome is *Genlisea aurea*, a carnivorous plant that has one of the smallest known plant genomes. 

This genome appears to be obscure, as only one group (Lomonosov Moscow State University) has ever sequenced it. The only two datasets from that group (a 623-bp library and a 413-bp library) were published in 2013. 

<kbd>
<img width="500" height="220" alt="image" src="https://github.com/user-attachments/assets/48e9539b-7ff5-46b6-b9d5-d76fc4200af6" />
</kbd>

<ins>Accession numbers:<ins> 
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
