# Homework Assignment 11
# Makefile adaptation
Started with the example Makefile from the Biostar handbook: 
```
# Example RNA-seq Makefile
curl -fsSL https://data.biostarhandbook.com/make/rnaseq.hisat.2026.mk > Makefile
```
Small changes/fixes:
* Updated the targets in `.PHONY`
* Noticed there were duplicate design file definitions, so I deleted the second occurance. 

  <img width="317" height="216" alt="image" src="https://github.com/user-attachments/assets/6077746f-fd18-4d41-b64a-1ce974017bb9" /> 
  
## Reproducibility
```
# Add HISAT2 and featureCounts to the bioinfo environment
pixi add hisat2 subread
```
(bioinfo environment)
```

```
