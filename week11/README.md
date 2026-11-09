# Homework Assignment 11: Evaluate Gene Expression
Use IGV to visualize the RNA-Seq alignments and coverages, then use visual inspection and assessment to answer questions. 

## Look at a wide region (millions of bases wide). How are the two sample types different?
<img width="2286" height="852" alt="image" src="https://github.com/user-attachments/assets/41828374-6beb-4047-ae41-d61b982985d9" />

The two things that immediately jump out to me are: 
* HBR and UHR samples have different distribution in gene expression; HBR is broader and seems to have more genes expressed across this wide region, while UHR less of a broad footprint but more of a dramatic spike in several locations. 
* The coverage scales are smaller for HBR but very consistent, while the coverage for UHR is much higher but also more variable. 

## Navigate across the genome. How consistent are the replicates?
The replicates for each set of samples seem very consistent with each other. 
<img width="1034" height="580" alt="image" src="https://github.com/user-attachments/assets/678c4f78-11f8-471e-8d8f-4013cb13c633" />

Almost indistinguishable for me. 
<img width="1932" height="594" alt="image" src="https://github.com/user-attachments/assets/4404c22b-ef54-4e7e-bd29-c3d86c3b0843" />

## Find a gene that is not expressed in any of the samples.
<img width="1694" height="666" alt="image" src="https://github.com/user-attachments/assets/adea6ac0-13da-4ece-abf2-c8435458f988" />
This gene (CRIP1P4) didn't have visible expression in any of the samples. When I looked it up, I found out it isn't really a functional gene, but a processed pseudogene (a non-functional copy of a protein-coding gene made when a mature messenger RNA (mRNA) transcript was reverse-transcribed into complementary DNA (cDNA) and inserted back into the genome at a new location). Interesting! 

## Find a gene that is very strongly expressed in all samples. What is its coverage?
<img width="222" height="415" alt="image" src="https://github.com/user-attachments/assets/16e5e75f-b8ea-430c-a85b-4ef8b9019008" />

This gene (RPL3, aka universal ribosomal protein uL3) seems to be strongly expressed in all samples, which would make sense because it is a necessary component of the 60S subunit of the eukaryotic ribosome. 

* Coverage for HBR: 64-76
* Coverage for UHR: 204-297. The coverage is way higher in the UHR samples (almost 4 times higher)! 

## Can you identify the transcripts that are expressed? Sometimes you can only exclude some candidates.
For the RPL3 gene from above:
<img width="1478" height="1230" alt="image" src="https://github.com/user-attachments/assets/0ae6c984-33de-4648-b058-1e4e250c7166" />
* There is only one transcript here that matches to the expression coverage areas and doesn't start outside the gene. All the rest can probably be ruled out since they start outside of the expression area. 

## Can you find a gene/transcript where the expression is clearly different between the two sample types? What is the fold change?
Here are a few areas where the expression is clearly different between the two sample types:
<img width="519" height="317" alt="image" src="https://github.com/user-attachments/assets/29c89509-6eb1-4a96-b998-94494e0e0cfc" />

Raw IGV estimate of the fold change at the pink spike: 
* HBR average = (4.21 + 4.26 + 3.96) / 3 = 4.14
* UHR average = (131 +82 +100) / 3 = 104.3
* 104.3 / 4.14 = ~25
* UHR roughly 25 times higher than HBR at that area

## Is the transcript upregulated or downregulated?
This transcript is upregulated in UHR when compared to HBR. 

## How certain are you that it is not a random fluctuation? Why? 
<img width="265" height="372" alt="image" src="https://github.com/user-attachments/assets/b157da65-af9f-4b69-8ad0-12ead36be195" />

I think random fluctuations would look more like the small changes I see on the left of this gene. These fluctuations are much lower in coverage and aren't visible in all samples. 

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

* Updated help target to "make counts" instead of "make count" (target is plural)
