# Homework Assignment 12
Setup: Make sure the required tools are active.  
(bioinfo environment activated)
```
# Add HISAT2 and featureCounts to the bioinfo environment
pixi add hisat2 subread
```

## Prompting the AI
I tweaked the rules for coding with AI slightly. Here are my rules: 
```
# Rules for writing code

Summarize what the program does at the start of the code.

List parameters for input, output, and other tunable values at the top of the script. Use a separation like so: 
# --- all definitions above the line, all code below the line ---

Write tunable parameters in capital letters so it is obvious what the user ought to change. 

# Input gene counts
COUNT_FILE = "results/gene_counts.csv"

# Output PCA plot
PCA_PLOT = "results/pca.pdf"

# P-value threshold
PVAL = 0.05

Add a comment to each parameter. 

After each step print messages to inform the user what is happening:

# Loading gene counts from: results/gene_counts.csv
# Saving PCA plot to: results/pca.pdf

Plots should be saved as PDF format by default.
```
## Prompt that I used to generate the script: 
I found that asking Claude what might be unclear about my initial prompts was helpful for refining further prompts and making them more clear. Here is the promopt I eventually settled on for the VS code editor: 

```
Using the @Makefile and @design.csv, write an R script to src/combine_gene_counts.r.

## Context
I ran `make batch` which used featureCounts to generate per-sample count files.
Inspect the Makefile to find the output path pattern for these files.

featureCounts output files have this structure:
- Line 1: a comment starting with `#` — skip it
- Line 2: a header with columns: Geneid, Chr, Start, End, Strand, Length, <bam filename>
- Lines 3+: data rows

Only the Geneid and the final count column (the .bam filename column) are needed.
Drop Chr, Start, End, Strand, and Length — the output will be used as direct input to DESeq2 which requires a plain integer count matrix.

## Task
Write an R script that:
1. Reads all featureCounts output files matching the output path pattern in the Makefile
2. Parses each file as described above
3. Renames each sample column by stripping the file extension from the 
   count filename and matching it against the `sample` column in design.csv.
4. Combines all samples into a single count matrix (genes as rows, samples as columns)
5. Writes the result to results/gene_counts.csv with gene names as the first column

## Requirements
- Stop with an informative error (stop()) if any expected files are missing
- Stop with an informative error if the sample names in design.csv don't match 
  the files found on disk
```

## Spot-Checking
Once I had my R script and ran it successfully, I ran some spot checks to make sure the R script accurately read the count value from each individual sample file and placed it in the right column of the combined matrix. Everything matched up. 

Tree:
```
.
├── Makefile
├── bam
│   ├── HBR_1.bam
│   ├── HBR_1.bam.csi
│   ├── HBR_2.bam
│   ├── HBR_2.bam.csi
│   ├── HBR_3.bam
│   ├── HBR_3.bam.csi
│   ├── UHR_1.bam
│   ├── UHR_1.bam.csi
│   ├── UHR_2.bam
│   ├── UHR_2.bam.csi
│   ├── UHR_3.bam
│   └── UHR_3.bam.csi
├── bw
│   ├── HBR_1.bw
│   ├── HBR_2.bw
│   ├── HBR_3.bw
│   ├── UHR_1.bw
│   ├── UHR_2.bw
│   └── UHR_3.bw
├── counts
│   ├── HBR_1.txt
│   ├── HBR_1.txt.summary
│   ├── HBR_2.txt
│   ├── HBR_2.txt.summary
│   ├── HBR_3.txt
│   ├── HBR_3.txt.summary
│   ├── UHR_1.txt
│   ├── UHR_1.txt.summary
│   ├── UHR_2.txt
│   ├── UHR_2.txt.summary
│   ├── UHR_3.txt
│   └── UHR_3.txt.summary
├── design.csv
├── fasta
│   ├── chr22.genome.fa
│   ├── chr22.genome.fa.1.ht2
│   ├── chr22.genome.fa.2.ht2
│   ├── chr22.genome.fa.3.ht2
│   ├── chr22.genome.fa.4.ht2
│   ├── chr22.genome.fa.5.ht2
│   ├── chr22.genome.fa.6.ht2
│   ├── chr22.genome.fa.7.ht2
│   ├── chr22.genome.fa.8.ht2
│   └── chr22.transcripts.fa
├── fastq
│   ├── HBR_1_R1.fq
│   ├── HBR_2_R1.fq
│   ├── HBR_3_R1.fq
│   ├── UHR_1_R1.fq
│   ├── UHR_2_R1.fq
│   └── UHR_3_R1.fq
├── gtf
│   └── chr22.gtf
├── results
│   └── gene_counts.csv
└── src
    └── combine_gene_counts.r

```

# Comparing with IGV visualization
Last week, I identified RPL3 (ribosomal protein 3) as highly expressed in IGV. 
<img width="1614" height="678" alt="image" src="https://github.com/user-attachments/assets/a8c12a22-c70f-4a6f-8ea2-72b8878bc767" />

To see if RPL3 (Ensembl Gene ID: ENSG00000100316) was also highly expressed in this week's count matrix: 
```
cat counts/*.txt | grep ENSG00000100316 | cut -f 7
```
Output: 
```
656
759
718
4010
2403
3034
```
Looks very highly expressed! Especially when compared to my random spot counts from earlier. 

# Reproducibility
Make sure the required tools/environments are active.  

```
# Generate per-sample counts
make batch

# Run the script
Rscript src/combine_gene_counts.r

# Clean
make clean
```
