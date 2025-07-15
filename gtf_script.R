##################################################
# R Script: Plot gene structure in ROI
# Goal: Visualize gene models near a high-FST region
# Author: Maria Madrid
# Date: July 31st 2025
##################################################

### -------------------------------
### Load required libraries
### -------------------------------
# install.packages("ggplot2")
# BiocManager::install("rtracklayer")
# BiocManager::install("GenomicRanges")

library(ggplot2)
library(rtracklayer)
library(GenomicRanges)

# Load the GTF file (downloaded from https://www.ncbi.nlm.nih.gov/datasets/genome/GCA_030254905.1/)
gtf <- import("genomic.gtf")  # or use "genomic.gff"

# Define region of interest (based on FST > 0.4)
roi <- GRanges(seqnames = "scaffold_3",
               ranges = IRanges(start = 10100001, end = 10125000))

region_features <- subsetByOverlaps(gtf, roi)

# Optionally, filter for gene or exon features only
region_exons <- region_features[region_features$type %in% c("gene", "exon")]

# Convert to data frame
df <- as.data.frame(region_exons)

# Clean up gene names if available
df$gene_label <- df$gene_id

# Plot using ggplot2
ggplot(df[df$type == "exon", ], aes(xmin = start, xmax = end, y = gene_label)) +
  geom_rect(aes(xmin = start, xmax = end, ymin = as.numeric(factor(gene_label)) - 0.4,
                ymax = as.numeric(factor(gene_label)) + 0.4),
            fill = "skyblue", color = "black") +
  theme_minimal() +
  labs(title = "Gene Structure in Region Around High-FST Peak",
       x = "Genomic Position (bp)",
       y = "Gene") +
  theme(axis.text.y = element_text(size = 10))
