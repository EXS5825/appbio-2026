# Homework Assignment 10: Peak Calling
## Preliminary information
Unfortunately the organisms (*Genlisea aurea* plant or *Ostreococcus tauri* virus) that I've been using for previous analyses do not have any ChIP-seq data available. So I am going to switch organisms again. 

* **New organism:** *Xanthomonas campestris*, a bacteria that infects various plants and also produces xanthan gum.
* **Sequencing type:** ChIP-seq
* **Project:** PRJNA492409
* **Associated paper:** Deng, C. Y., Zhang, H., Wu, Y., Ding, L. L., Pan, Y., Sun, S. T., Li, Y. J., Wang, L., & Qian, W. (2018). Proteolysis of histidine kinase VgrS inhibits its autophosphorylation and promotes osmostress resistance in Xanthomonas campestris. Nature communications, 9(1), 4791. https://doi.org/10.1038/s41467-018-07228-4


Adjusted coverage to 333k to account for larger genome size. 

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
