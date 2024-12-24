#!/bin/bash

<<PURPOSE
(1) This script creates three different conda environments -namely "qc", "unicycl", "annotation"- with various programmes.
(2) This script is a valuable resource for anyone performing whole genomic sequencing, enhancing research and exploring genetic data.
(3) Contact: taiyeba.ardra@northsouth.edu 
PURPOSE

# YOU MUST HAVE ANACONDA INSTALLED.

# We are activating the source command so that the environments prior to Anaconda gets installed properly. 
# Conda update
source activate base
conda update --yes conda

# Conda channels
# A channel is where conda looks for packages (package refers to a collection of program files) 
conda config --add channels defaults
conda config --add channels bioconda
conda config --add channels conda-forge

# -------------------------------
# For quality trimming and quality assessment of reads
# QC environment
conda create --yes -n qc fastp fastqc 
# fastp removes the duplicated reads 
# fastqc is used to quality control check on raw sequence data
# For more information, please visit https://www.bioinformatics.babraham.ac.uk/projects/fastqc/
#                                    https://academic.oup.com/bioinformatics/article/34/17/i884/5093234  

# -------------------------------
# For genome assembly (process of reconstructing the complete sequence of an organism's genome from fragmented pieces of sequencing data) 
# Unicycler environment
# quast is used to evaluate and assess the quality of genome assemblies by providing detailed statistics
conda create --yes -n unicycl quast
source activate base
conda activate unicycl
conda install bioconda::unicycler --yes
# unicycler can combine short and long reads to produce high-quality genome assemblies
# For more information, please visit https://pmc.ncbi.nlm.nih.gov/articles/PMC5481147/

# --------------------------------
# For gene prediction (process of identifying protein-coding genes, RNA genes, and regulatory elements within a genome)
# Structural annotation environment
conda create --yes -n annotation
source activate base
conda activate annotation
conda install bioconda/label/cf201901::augustus --yes
# augustus is particularly effective for predicting protein-coding genes.

echo "Necessary installations are done!"
