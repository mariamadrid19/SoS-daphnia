# ##################################################
# R Script: Exploring Genetic Data from chr3.stats
# Goal: Learn to work with real genomic data in R
# Author: Maria Madrid
# Date: July 31st 2025
##################################################

### -------------------------------
### 1. Install and load libraries
### -------------------------------

# These lines install the necessary packages
# Run them once; then you can comment them out (add a # at the start of the line to comment them out)
install.packages("tidyverse")
install.packages("ggplot2")
install.packages("readr")
install.packages("scales")

library(tidyverse)
library(ggplot2)
library(readr)
library(scales)

### -------------------------------
### 2. Load the stats file
### -------------------------------

# Read the stats file you downloaded and placed in your Downloads folder
stats <- read.csv("chr3.stats")

# View the first few rows to understand the structure
head(stats)

### -------------------------------
### 3. Basic summary plots
### -------------------------------

# Histogram of FST values
ggplot(stats, aes(x = Fst_A1_B1)) +
  geom_histogram(binwidth = 0.01, fill = "steelblue", color = "black") +
  theme_minimal() +
  labs(title = "Distribution of FST values", x = "FST", y = "Count")

# Scatter plot of Pi in A1 vs B1
ggplot(stats, aes(x = pi_A1, y = pi_B1)) +
  geom_point(alpha = 0.5) +
  theme_minimal() +
  labs(title = "Genetic diversity (Pi) in A1 vs B1", x = "Pi A1", y = "Pi B1")

# Dxy across chromosome
ggplot(stats, aes(x = mid, y = dxy_A1_B1)) +
  geom_line(color = "darkgreen") +
  theme_minimal() +
  labs(title = "Dxy along scaffold_3", x = "Position", y = "Dxy")

### -------------------------------
### 4. Manhattan plot of FST
### -------------------------------

# Replace NA or negative FST values with 0
stats$Fst_A1_B1[is.na(stats$Fst_A1_B1) | stats$Fst_A1_B1 < 0] <- 0

# Manhattan plot coloring by FST value
ggplot(stats, aes(x = mid, y = Fst_A1_B1, color = Fst_A1_B1)) +
  geom_point() +
  scale_color_gradient(low = "black", high = "red") +
  theme_minimal() +
  labs(title = "Manhattan Plot of FST on Chromosome 3", x = "Genomic Position", y = "FST")

### -------------------------------
### 5. Identify high-FST regions
### -------------------------------

# Create a subset of regions with FST > 0.4
high_fst <- stats %>%
  filter(Fst_A1_B1 > 0.2)

# Save them as a variable called high_fst_bed
high_fst_bed <- high_fst %>% select(scaffold, start, end)
print(high_fst_bed)
