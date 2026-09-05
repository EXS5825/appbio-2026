# Homework Assignment 2

## Select a genome of interest: *Genlisea aurea*. 

*Genlisea aurea* is a weird plant that has no roots, instead forming leaves (with no chlorophyll) under the soil and trapping and digesting protozoans with them. This rare carnivorous plant also has one of the smallest genomes in the entire plant kingdom. For comparison, the classic plant model *Arabidopsis thaliana* has a genome size of ~135Mb ... *Genlisea aurea*'s genome comes it at only 63.36 Mb (over 70 times smaller and comparable to bacterial genome sizes)! 

Chromosome count: n = 26

Accession number: GCA_000441915.1

## How the Makefile should be used:
Create the Makefile in the working directory, then tell pixi to run the Makefile. 
```
pixi run makefile
```
Output:
```
unzip -p GCA_000441915.1.zip ncbi_dataset/data/GCA_000441915.1/GCA_000441915.1_GenAur_1.0_genomic.fna > GCA_000441915.1_genomic.fna
(bioinfo)
```

Check out the files.
```
ls -lh
```
Output:
```
total 364120
-rw-r--r--  1 exs5825  staff    21M Sep  3 18:42 GCA_000441915.1.zip
-rw-r--r--  1 exs5825  staff    43M Sep  3 18:51 GCA_000441915.1_genomic.fna
-rw-r--r--  1 exs5825  staff   114M Sep  3 18:46 GCA_000441915.1_genomic.gff
-rw-r--r--  1 exs5825  staff   643B Sep  3 18:50 Makefile
```
Check to make sure the FASTA and GFF are reasonable sizes (43M and 114M, respectively).

## How many annotations are in the annotation file?
Count the number of genes in the file. 
```
awk '$3=="gene"' ./GCA_000441915.1_genomic.gff | wc -l
```
There are 17685 annotations in the GFF file. 

## How complete is this genomic build in your opinion?
This genomic build is a scaffold-level, which is moderately complete at the sequence level but lacks chromosome-level structure. 

I could run a BUSCO to look at sequence completeness, but considering that this carnivorous plant has such a small genome (likely with lots of areas deleted) I don't know that it would be an accurate way to assess the completeness of this build. 

## How tightly packed are the genes in this genome? 
Gene density = number of genes ÷ total genome size (Mb)

Gene density = 17685 ÷ 63.36 

≈ **279 genes/Mb**

This is much more tightly packed than humans (11-15 genes/Mb) but less tightly packed than bacteria (500-1000 genes/Mb) 

## Estimate the gene-to-gene distance via the browser.
It varies based on area. Some regions appear to have less than 100 base pairs between genes:
<img width="2272" height="558" alt="image" src="https://github.com/user-attachments/assets/ca0519d0-d399-4994-bec6-1170a71cf0fa" />

Other areas have wider gaps of more than 1000 base pairs: 
<img width="2252" height="542" alt="image" src="https://github.com/user-attachments/assets/c9db2904-9eb4-4291-8975-3a41aa4a1db3" />

Caveat: This genome is not well-annotated. Many of the genes are hypothetical rather than confirmed. 

## Pick a coordinate on the chromosome and visually inspect the sequence regions around it. Describe all six reading frames (codons) that the coordinate could be part of.
<img width="1582" height="986" alt="image" src="https://github.com/user-attachments/assets/11c794ca-9153-4088-a4ff-a17757084e9a" />

## Identify the type of feature displayed as a data track.
Gene annotation from the GFF file. 

## Color features by their strand orientation.
<img width="2256" height="752" alt="image" src="https://github.com/user-attachments/assets/7c4d866e-35ae-4ab4-95ab-d630dd746100" />
