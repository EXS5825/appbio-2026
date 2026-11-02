# Homework Assignment 10: Peak Calling
## Preliminary information
Unfortunately the organisms that I've been using (*Genlisea aurea* plant or *Ostreococcus tauri* virus) for previous analyses do not have any ChIP-seq data available. I found a ChIP-seq project summarized below: 

* **New organism:** *Escherichia coli* K-12
* **Sequencing type:** ChIP-seq
* **Project:** PRJNA644195
* **Associated paper:** Krogh, T. J., Franke, A., Møller-Jensen, J., & Kaleta, C. (2020). Elucidating the Influence of Chromosomal Architecture on Transcriptional Regulation in Prokaryotes - Observing Strong Local Effects of Nucleoid Structure on Gene Regulation. *Frontiers in microbiology, 11*, 2002. https://doi.org/10.3389/fmicb.2020.02002


## Making the design file
I decided to focus on just one protein (SigmaD) and its control to start. 
```
run,sample,bkg_srr,bkg
SRR12148167,SigmaD_OD0.2_rep1,SRR12148187,Input_OD0.2_rep1
SRR12148177,Beta_OD0.2_rep1,SRR12148187,Input_OD0.2_rep1
```

## Makefile adaptation
Started with my `Makefile` from Week 7. Compared it with the `Makefile` in the Biostar handbook:
```
# Get the Makefile from the Biostar Handbook
curl -fsSL https://data.biostarhandbook.com/make/chipseq.2026.mk > Makefile
```
Made some changes to my `Makefile`:
* There were a couple places I had hardcoded values that should have been calling back to the definitions instead
* Replace variant calling with peak calling
* Add `SAMPLE` variable + read groups
* Add `design.csv` + `batch` target
* Add all target
* Add *Pseudomonas protegens* CHA0 genome size for `macs3 -g`
* Adjust the rest of the definitions for the new dataset (samples, SRR number, genome accession, etc.)

# Peak calling
How many peaks were called in the SigmaD sample?
```
wc -l peaks/SigmaD_OD0.2_rep1_peaks.narrowPeak peaks/SigmaD_OD0.2_rep2_peaks.narrowPeak
```
Replicate 1: 1028 peaks
Replicate 2: 1094 peaks

The peaks seem to agree between the replicates. Here's a visualization in IGV:
![alt text](image-2.png)

I had to run this to find peaks from replicate 1 that had no overlap in replicate 2: 
```
bedtools intersect -a peaks/SigmaD_OD0.2_rep1_peaks.narrowPeak \
                   -b peaks/SigmaD_OD0.2_rep2_peaks.narrowPeak -v | head
```
The ones that didn't match looked weaker. Example:
![alt text](image.png)


## Reproducibility: 
Make sure `deeptools` and `macs3` (MACS: Model-based Analysis for ChIP-Seq) are installed. 
```
pixi add deeptools

pixi add macs3
```

**To reproduce the analysis:**

(bioinfo environment activated)
```
# 1. Clone the repository
git clone https://github.com/EXS5825/appbio-2026.git

# 2. Navigate to the week10 folder
cd appbio-2026/week10

# 3. Run the Makefile
make all

# 4. Clean
make clean
```
