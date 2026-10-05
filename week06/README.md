# Homework Assignment 6: Evaluate Structural Variants
Visually evaluate existing alignments make your best guess at what kind of variation is present. For each sample, provide a paragraph with your best description of the genomic variation relative to the reference genome.

## Sample 1
For Sample 1, I first noticed two areas with small insertions:  
<img width="1944" height="982" alt="image" src="https://github.com/user-attachments/assets/3462388f-4370-4c6e-9a8b-aa9bdc3c7ddb" />

I also saw several SNPs: 
<img width="1852" height="1060" alt="image" src="https://github.com/user-attachments/assets/fc51f121-b057-48dd-a247-010e82b59f46" />
Some of which were consistent across all reads with uniform coverage. 

Otherwise, there were other various small variations (the red/blue sections) but no large deletions or other significant structural arrangements. 

## Sample 2
Sample 2 had a lot more going on.
<img width="1932" height="1262" alt="image" src="https://github.com/user-attachments/assets/f75452be-a47a-4fec-bd71-0322c5998503" />

Overall, there seem to be lots of small insertions and deletions, especially SNPs. They are spread fairly evenly across this genome. The mismatches were much more sparse in sample 1, whereas here they almost seem everywhere. This could point to a highly mutated genome, or perhaps contamination of the sample/sequencing error. The ends seemed especially divergent, but I'm less likely to trust the ends of the sequencing runs, as errors are more common here. 
<img width="320" height="134" alt="image" src="https://github.com/user-attachments/assets/f05fbae9-d535-4f68-9cd1-8c60edff4c0c" />

## Sample 3
Compared to sample two, this one has much higher coverage: 
<img width="126" height="286" alt="image" src="https://github.com/user-attachments/assets/106bc234-b83f-4904-98b9-465f1958976d" />

As well as the coverage being less uniform: 
<img width="2278" height="1260" alt="image" src="https://github.com/user-attachments/assets/10a24232-7856-43a3-ad66-c09dad8751cd" />
There's a lot more coverage to the left with those big peaks. There also seem to be a lot of green sections clustered here. Clicking on one of the green sections reveals that the pair orientation is "R1F2", not F1R2 as expected. 
<img width="518" height="552" alt="image" src="https://github.com/user-attachments/assets/11929a23-4220-4816-9ea9-6c810686aca8" />
This points to a structural inversion!

## Sample 4
This one has teal/blue areas that jump out immediately. 
<img width="1960" height="944" alt="image" src="https://github.com/user-attachments/assets/c082db57-e811-4bab-a6f8-1b5a79234316" />

The teal reads are F1F2 --> both reads are pointing forward, which seems like a tandem duplication. 

Medium blue reads: R2R1 --> both reads are pointing backwards, which also seems like a tandem duplication in the opposite direction. 

Dark blue reads: F2R1 --> Normal orientation, insert size is smaller than expected (-437) ... breakpoint-spanning reads? They also seem to be at the ends of the teal/medium blue portions, which would support this idea.  

These patterns are consistent across coverage. 

There seem to be two tandem duplication events here, shown by the two distinct paired patterns of the teal/medium blue reads showing tandem duplications in opposite directions.   
<img width="1192" height="934" alt="image" src="https://github.com/user-attachments/assets/23d4603e-588c-41cc-88cc-ce4494f41715" />

## Sample 5
This one has some Christmas-colored mismatches. 
<img width="1966" height="934" alt="image" src="https://github.com/user-attachments/assets/88837db6-7dac-4dfd-b59a-22680b7b291c" />
Red reads --> normal F2R1 orientation but a much bigger insert size than expected. Looks like a large deletion. 

Green reads --> wrong orientation (R2F1) + large span seems like an inverted segment. 

Blue reads --> normal orientation but soft-clipped mates, so probably a breakpoint junction. 

Scattered SNPs also visible across the rest of the genome. 

Overall, looks like a complex structural rearrangement happened here with lots of different variations. 
