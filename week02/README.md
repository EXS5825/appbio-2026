# Homework Assignment 2
## Select a genome of interest: *Genlisea aurea*. 

*Genlisea aurea* is a weird plant that has no roots, instead forming leaves (with no chlorophyll) under the soil and trapping and digesting protozoans with them. This rare carnivorous plant also has one of the smallest genomes in the entire plant kingdom. For comparison, the classic plant model *Arabidopsis thaliana* has a genome size of ~135Mb ... *Genlisea aurea*'s genome comes it at only 63.36 Mb (over 70 times smaller and comparable to bacterial genome sizes)! 

Accession number: GCA_000441915.1

## Process:
### Installed the NCBI datasets CLI tool using pixi: 
```
pixi global install ncbi-datasets-cli
```
Output:
```
$ pixi global install ncbi-datasets-cli
└── ncbi-datasets-cli: 18.36.0 (installed)
    └─ exposes: dataformat, datasets
```
### Made a makefile in my desired directory
```
nano makefile
```
Entered my code into the makefile. 

Run the makefile. 
```
pixi run make
```
