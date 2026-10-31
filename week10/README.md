# Homework Assignment 10: Peak Calling
## Preliminary information
Unfortunately the organisms that I've been using (*Genlisea aurea* plant or *Ostreococcus tauri* virus) for previous analyses do not have any ChIP-seq data available. So I am going to switch organisms again. 

* **New organism:** Pseudomonas protegens CHA0, a gram-negative plant root-colonizing bacterium that produces R-tailocins (contractile phage tail-like particles) that specifically target closely related kin strains of other bacteria.
* **Sequencing type:** ChIP-seq
* **Project:** PRJEB83774
* **Associated paper:** Heiman, C. M., Antar, H., Fournes, F., Keel, C., & Vacheron, J. (2025). The repressor PrtR1 and the global H-NS-like regulators MvaT and MvaV enable the fine-tuning of R-tailocin expression in Pseudomonas protegens. *BMC microbiology, 25*(1), 286. https://doi.org/10.1186/s12866-025-03983-9

**Background information:**
Proteins of interest (all C-terminally V5-tagged for the anti-V5 antibody to pull down):
* PrtR1 --> LexA-like locus-specific repressor of the R-tailocin gene cluster
  * directly binds the promoter region of the cluster and represses its expression under non-inducing conditions; cleaved by activated RecA* upon DNA damage
* MvaT --> H-NS-like global regulator
  * a master regulator that indirectly influences R-tailocin expression; binds broadly to AT-rich regions across the genome
* MvaV --> H-NS-like global regulator
  * works in concert with MvaT as a heterodimer
* ParB --> cell cycle-associated protein known to bind near the origin of replication
  * used as a positive control 

Experimental setup:
* Control: CHA0 wild type without any V5-tagged protein — used as a negative control for non-specific immunoprecipitation
* Conditions:
  * Non-inducing: no mitomycin C (MMC)
  * Inducing: 9 µM mitomycin C (MMC) for 3 hours — triggers the SOS response and R-tailocin gene cluster expression

Key questions of the paper: 
* Where in the *P. protegens* CHA0 genome do PrtR1, MvaT, and MvaV bind?
* Does their binding pattern change between non-inducing and inducing (SOS-activated) conditions? 
* Do these regulators directly or indirectly control R-tailocin gene cluster expression?

## Making the design file
```
# Get the design file
bio search -H -csv PRJEB83774 > runinfo.csv

# Look at the design file
xan view runinfo.csv
```
Reformatted the information into a more helpful design file (added protein designation because labels were otherwise confusing): 
```
run,type,method,sample,protein
ERR14089387,V-V5,ChIP_Seq,ChIP_V-V5_I,MvaV
ERR14089385,R-V5,ChIP_Seq,ChIP_R-V5_NI,PrtR1
ERR14089388,V-V5,ChIP_Seq,ChIP_V-V5_NI,MvaV
ERR14089381,C,ChIP_Seq,ChIP_C_NI,Input
ERR14089382,T-V5,ChIP_Seq,ChIP_T-V5_I,MvaT
ERR14089383,R-V5,ChIP_Seq,ChIP_R-V5_I,PrtR1
ERR14089389,B-V5,ChIP_Seq,ChIP_B-V5_I,ParB
ERR14089390,T-V5,ChIP_Seq,ChIP_T-V5_NI,MvaT
ERR14089384,B-V5,ChIP_Seq,ChIP_B-V5_NI,ParB
ERR14089386,C,ChIP_Seq,ChIP_C_I,Input
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
* Add SAMPLE variable + read groups
* Add design.csv + batch target
* Add all target

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
```
