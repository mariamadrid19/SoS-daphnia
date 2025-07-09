##################################################
# R Script: Exploring Genetic Data from chr1.vcf.gz
# Goal: Learn to work with real genomic data in R
# Author: Maria Madrid
# Date: July 31st 2025
##################################################

### -------------------------------
### 1. Install and load libraries
### -------------------------------

# These lines install the necessary packages
# Run them once; then you can comment them out (add a # at the start of the line to comment them out)
install.packages("vcfR")
install.packages("ggplot2")

# Load the libraries
library(vcfR)
library(ggplot2)

### -------------------------------
### 2. Load the VCF file
### -------------------------------

# Change the path below if needed
vcf_file <- "chr1.vcf.gz" 
vcf <- read.vcfR(vcf_file)

# Quick summary of the VCF contents
summary(vcf)

### -------------------------------
### 3. View genotype data
### -------------------------------

# Extract the genotype matrix
genotypes <- extract.gt(vcf)

# Show the first few rows
head(genotypes)

# These look like: 0/0, 0/1, 1/1 = homozygous ref, heterozygous, homozygous alt

### -------------------------------
### 4. Visualize missing data per individual
### -------------------------------

# Calculate the proportion of missing genotypes for each sample
missing_per_sample <- apply(is.na(genotypes), 2, mean)

# Turn into a data frame for plotting
missing_df <- data.frame(sample = names(missing_per_sample),
                         missing = missing_per_sample)

# Plot it!
ggplot(missing_df, aes(x = sample, y = missing)) +
  geom_col(fill = "steelblue") +
  coord_flip() +
  theme_minimal() +
  labs(title = "Missing Genotype Data per Individual",
       x = "Sample",
       y = "Proportion Missing")

### -------------------------------
### 5. Plot allele frequency distribution
### -------------------------------

# Calculate allele frequencies for each SNP
# Note: This is a quick approximation
af_matrix <- vcfR::maf(vcf, element = 2)  # "maf" = minor allele frequency

# Convert to data frame
af_df <- data.frame(maf = af_matrix)

# Plot histogram of minor allele frequencies
ggplot(af_df, aes(x = maf)) +
  geom_histogram(binwidth = 0.05, fill = "darkgreen", color = "white") +
  theme_minimal() +
  labs(title = "Minor Allele Frequency Distribution",  # <-- Students can edit this title
       x = "Minor Allele Frequency",
       y = "Number of SNPs")

### -------------------------------
### Done!
### -------------------------------

# This script gave you a look into how genetic data is structured and explored before analysis!
# You’ve worked with real SNP data from Daphnia magna and visualized genetic variation.
