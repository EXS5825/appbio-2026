# Homework Assignment 8: Interpret a multisample VCF file
Starting with the previous `Makefile` in [Week 7](https://github.com/EXS5825/appbio-2026/tree/main/week07) that created a VCF file of one run from whole-genome sequencing of *Ostreococcus tauri* virus (PRJNA1345089). 

I kept my original SRR run (SRR35893209) and added three new ones: SRR35893210, SRR35893211, & SRR35893212. Fetched their sample names by running: 
```
curl -s "https://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=sra&id=SRR35893209,SRR35893210,SRR35893211,SRR35893212&rettype=runinfo&retmode=csv" |     cut -d',' -f1,12
```

Output:
```
SRR35893212,OtV09-559
SRR35893211,OtV09-565
SRR35893210,OtV09-570
SRR35893209,OtV09-573
```

Added a new "Samples" group at the top: 
```
# === SAMPLES ===
# Add or remove SRR:SAMPLE pairs here 
SAMPLES := SRR35893209:OtV09-573 \
           SRR35893210:OtV09-570 \
           SRR35893211:OtV09-565 \
           SRR35893212:OtV09-559
```
