# Homework Assignment 10: Peak Calling
## Preliminary information
Unfortunately the organisms that I've been using (*Genlisea aurea* plant or *Ostreococcus tauri* virus) for previous analyses do not have any ChIP-seq data available. So I am going to switch organisms again. 

* **New organism:** *Xanthomonas campestris* pv *campestris*, a bacteria that infects various plants and also produces xanthan gum.
* **Sequencing type:** ChIP-seq
* **Project:** PRJNA492409
* **Associated paper:** Deng, C. Y., Zhang, H., Wu, Y., Ding, L. L., Pan, Y., Sun, S. T., Li, Y. J., Wang, L., & Qian, W. (2018). Proteolysis of histidine kinase VgrS inhibits its autophosphorylation and promotes osmostress resistance in Xanthomonas campestris. Nature communications, 9(1), 4791. https://doi.org/10.1038/s41467-018-07228-4

**Background information:**
* VgrS — the histidine kinase (HK)
  * Membrane-bound receptor
  * Autophosphorylates itself at His¹⁸⁶
  * Transfers the phosphoryl group to VgrR
  * Its sensor region is cleaved by Prc under osmostress
* VgrR — the response regulator (RR)
  * Receives the phosphoryl group from VgrS at Asp⁵¹
  * When phosphorylated (VgrR-P): binds certain promoters
  * When dephosphorylated (VgrR): binds a different set of promoters with higher affinity

This ChIP-seq database identifies genes with promoter regions bound by VgrR in X. campestris pv. campestris grown under osmostress conditions. The authors uploaded two samples: 
* WT + sorbitol ([SRX4726391](https://www.ncbi.nlm.nih.gov/sra/?term=SRX4726391))
  * prc protease is active, cleaves VgrS --> VgrR is dephosphorylated, and binds certain promoters
* Δprc + sorbitol ([SRX4726392](https://www.ncbi.nlm.nih.gov/sra/SRX4726392[accn]))
  * prc protease is deleted from the bacterial genome, VgrS stays intact --> VgrR stays phosphorylated, and binds different promoters

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
