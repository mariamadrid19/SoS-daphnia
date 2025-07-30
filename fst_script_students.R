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
# You only need to run them once! After that, you can comment them out.
# Uncomment the lines below (delete the # at the start of the line) and run them if you haven't installed the packages yet

# install.packages("tidyverse")
# install.packages("ggplot2")
# install.packages("readr")
# install.packages("scales")

# Now load the libraries so we can use their functions
library(tidyverse)
library(ggplot2)
library(readr)
library(scales)

### -------------------------------
### 2. Load the stats file
### -------------------------------

# This file contains the statistics for chromosome 3 that you downloaded
# Replace "FILL_IN" with the correct file name (make sure it's in your working directory!)
stats <- read.csv("FILL_IN")

# Tip: If you're not sure what the file is called, check your Downloads folder or use the Files tab in RStudio.

# View the first few lines of the data to understand the structure, this will show you the name of all the columns
# You will need to know these names for the next steps! 
head(stats)

### -------------------------------
### 3. Basic summary plots
### -------------------------------

# Let's visualize the distribution of FST values.
# What does the shape of this histogram tell us?
ggplot(stats, aes(x = FILL_IN)) +  # Fill in the name of the FST column (hint: it's the 9th column of the stats variable)
  geom_histogram(binwidth = 0.01, fill = "steelblue", color = "black") + # you can change the colors, if you want. Go crazy!
  theme_minimal() +
  labs(title = "Distribution of FST values", x = "FST", y = "Count")

# Let's compare genetic diversity in the two populations.
# Each dot is a window of the genome.
ggplot(stats, aes(x = FILL_IN, y = FILL_IN)) +  # Fill in the Pi columns for A1 and B1
  geom_point(alpha = 0.5) +
  theme_minimal() +
  labs(title = "Genetic diversity (Pi) in A1 vs B1", x = "Pi A1", y = "Pi B1")

# Dxy measures how different the populations are across the genome
ggplot(stats, aes(x = mid, y = FILL_IN)) +  # Fill in the Dxy column (y) (hint: the 17th column)
  geom_line(color = "darkgreen") +
  theme_minimal() +
  labs(title = "Dxy along scaffold_3", x = "Position", y = "Dxy")

### -------------------------------
### 4. Manhattan plot of FST
### -------------------------------

# First, we clean up the data by removing NA or negative FST values
# These might be errors or missing data
stats$Fst_A1_B1[is.na(stats$Fst_A1_B1) | stats$Fst_A1_B1 < 0] <- 0

# Now we make a Manhattan plot to see where FST is highest
ggplot(stats, aes(x = mid, y = Fst_A1_B1, color = Fst_A1_B1)) +
  geom_point() +
  scale_color_gradient(low = "black", high = "red") +
  theme_minimal() +
  labs(title = "Manhattan Plot of FST on Chromosome 3", x = "Genomic Position", y = "FST")

# 🔍 What do you notice? Are there any peaks? What might they mean?

### -------------------------------
### 5. Identify high-FST regions
### -------------------------------

# Let's extract only the regions that show high differentiation (FST > 0.2).
# Feel free to change this threshold and see what happens!
high_fst <- stats %>%
  filter(Fst_A1_B1 > 0.2)

# From these high-FST windows, we create a BED-like table (scaffold, start, end)
# This format is useful if we want to look at nearby genes later
high_fst_bed <- high_fst %>%
  select(FILL_IN, FILL_IN, FILL_IN)  # Replace with the correct column names for scaffold, start, and end

# Print your new table!
print(high_fst_bed)

# ✨ Try this: how many high-FST windows did you find?
# hint: use nrow(high_fst_bed)
