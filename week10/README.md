# Homework Assignment 10: Peak Calling
## Preliminary information
Unfortunately the organisms that I've been using (*Genlisea aurea* plant or *Ostreococcus tauri* virus) for previous analyses do not have any ChIP-seq data available. So I am going to switch organisms again. 

* **New organism:** Pseudomonas protegens CHA0, a gram-negative plant root-colonizing bacterium that produces R-tailocins — contractile phage tail-like particles that specifically target closely related kin strains of other bacteria. R-tailocin production leads to lysis of the producing cells and must therefore be tightly regulated.
* **Sequencing type:** ChIP-seq
* **Project:** PRJEB83774
* **Associated paper:** Heiman, C. M., Antar, H., Fournes, F., Keel, C., & Vacheron, J. (2025). The repressor PrtR1 and the global H-NS-like regulators MvaT and MvaV enable the fine-tuning of R-tailocin expression in Pseudomonas protegens. *BMC microbiology, 25*(1), 286. https://doi.org/10.1186/s12866-025-03983-9

**Background information:**
Proteins of interest (all C-terminally V5-tagged):
* PrtR1 — LexA-like locus-specific repressor of the R-tailocin gene cluster; directly binds the promoter region of the cluster and represses its expression under non-inducing conditions; cleaved by RecA* upon DNA damage
* MvaT — H-NS-like global regulator; acts as a master regulator that indirectly influences R-tailocin expression; binds broadly to AT-rich regions across the genome
* MvaV — H-NS-like global regulator; works in concert with MvaT as a heterodimer
* ParB — cell cycle-associated protein used as a positive control (known to bind near the origin of replication)

Experimental setup:
* Control: CHA0 wild type without any V5-tagged protein — used as a negative control for non-specific immunoprecipitation
* Conditions:
 * Non-inducing: no mitomycin C (MMC)
 * Inducing: 9 µM mitomycin C (MMC) for 3 hours — triggers the SOS response and R-tailocin gene cluster expression

Overall question of the paper: Where in the *P. protegens* CHA0 genome do PrtR1, MvaT, and MvaV bind, and does their binding pattern change between non-inducing and inducing (SOS-activated) conditions? Do these regulators directly or indirectly control R-tailocin gene cluster expression?

## Making the design file
```
# Get the design file
bio search -H -csv PRJNA492409 > runinfo.csv

# Look at the design file
xan view runinfo.csv
```
Only shows the two ChIP-seq samples:
```
┌───┬───────────────┬──────────────────┬───┬──────────┬───────────────────────────────┐
│ - │ run_accession │ sample_accession │ … │ fastq_u… │ info                          │
├───┼───────────────┼──────────────────┼───┼──────────┼───────────────────────────────┤
│ 0 │ SRR7888762    │ SAMN10102209     │ … │ ['https… │ 322 MB, 342 MB files; 6.3 mi… │
│ 1 │ SRR7888763    │ SAMN10102208     │ … │ ['https… │ 341 MB, 357 MB files; 6.7 mi… │
└───┴───────────────┴──────────────────┴───┴──────────┴───────────────────────────────┘
```
Reformatted the information into a more helpful design file: 
```
run,type,method,sample
SRR7888762,CvgrR-his,ChIP_Seq,ChIP_WT_CvgrR-his
SRR7888763,CvgrR-his,ChIP_Seq,ChIP_DLTPrc_CvgrR-his
```


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
