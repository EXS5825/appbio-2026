# Homework Assignment 2
## Select a genome of interest: *Genlisea aurea*. 

*Genlisea aurea* is a weird plant that has no roots, instead forming leaves (with no chlorophyll) under the soil and trapping and digesting protozoans with them. This rare carnivorous plant also has one of the smallest genomes in the entire plant kingdom. For comparison, the classic plant model *Arabidopsis thaliana* has a genome size of ~135Mb ... *Genlisea aurea*'s genome comes it at only 63.36 Mb (over 70 times smaller and comparable to bacterial genome sizes)! 

Chromosome count: n = 26

Accession number: GCA_000441915.1

### How many annotations are in the annotation file?
Count the number of genes in the file. 
```
awk '$3=="gene"' ./GCA_000441915.1_genomic.gff | wc -l
```
There are 17685 annotations in the GFF file. 

### How complete is this genomic build in your opinion?
This genomic build is a scaffold-level, which is moderately complete at the sequence level but lacks chromosome-level structure. 

I could run a BUSCO to look at sequence completeness, but considering that this carnivorous plant has such a small genome (likely with lots of areas deleted) I don't know that it would be an accurate way to assess the completeness of this build. 

## How the Makefile should be used:
Tell pixi to run the Makefile. 
```
pixi run makefile
```
Output:
unzip -p GCA_000441915.1.zip ncbi_dataset/data/GCA_000441915.1/GCA_000441915.1_GenAur_1.0_genomic.fna > GCA_000441915.1_genomic.fna
(bioinfo) 

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

