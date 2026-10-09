# Homework Assignment 7: Generate a VCF file
Start with the previous BAM `Makefile` and add additional steps to call variants. 

## Write a Makefile that calls variants and creates a VCF file.
Started with the `Makefile` from Week 5. 

Prompt to Claude (incorporating material from Biostar Handbook): 
I have the following Makefile: [attached Makefile from Week 6]

Add additional steps to call variants and create a VCF file following the same structure as before, using this framework: 
```
# The reference genome FASTA file.
FASTA=refs/genome.fa

# The BAM file of the aligned reads.
BAM=bam/alignment.bam

# The output VCF file.
VCF=vcf/variants.vcf.gz

# Annotation parameters for the mpileup command
ANN=-d 100 --annotate 'INFO/AD,FORMAT/DP,FORMAT/AD,FORMAT/ADF,FORMAT/ADR,FORMAT/SP'

# Call parameters for the call command
CALL=--ploidy 2 --annotate 'FORMAT/GQ' 

# Variant calling process.
bcftools mpileup ${ANN} -O u -f ${FASTA} ${BAM} | \
     bcftools call ${CALL} -mv -O u | \
     bcftools norm -f ${FASTA} -d all -O u | \
     bcftools sort --write-index -O z -o ${VCF}
```

Refining: 

## Run a statistics report on the VCF file.
How many variants were called?

What kinds of variants are present?

Which calls look like true variants, and which look like errors?

Are the calls supported by the alignments?

## Visualize the VCF file in IGV.
Include a screenshot of the VCF file in IGV. 

## Reproducibility
Include the commands needed to run the Makefile. 
