#!/bin/bash

#This script uses different software for quality control of genes, genome assembly and gene prediction for WGS.  

# ---------------------------------------------------------------
# Set your project name 
read -p "Enter the nickname for your current project: " PROJECT
cd WGS_$PROJECT && DIR=$(pwd)
cp ../0.env.sh ./meta/
cp ../1.base.sh ./meta/
cp ../2.analysis.sh ./meta/

# ---------------------------------------------------------------
# This step uses FastQC to perform quality control checks on input sequencing data, with the output directed to a specified directory; see documentation https://www.bioinformatics.babraham.ac.uk/projects/fastqc/
# This step uses Fastp to perform adapter detection, quality correction, and trimming on paired-end sequencing data, with output in HTML and JSON formats, and processed reads saved to a specified directory; see documentation https://github.com/OpenGene/fastp
# This step uses FastQC to perform quality control checks on the trimmed sequencing data, with the output directed to a specified directory
source activate base
conda activate qc

mkdir $DIR/result/fastqc
fastqc -o $DIR/result/fastqc $DIR/data/*.fastq.gz

mkdir $DIR/result/trimmed
fastp   --detect_adapter_for_pe \
        --overrepresentation_analysis \
        --correction \
        --cut_right \
        --thread 4 \
        --html $DIR/result/trimmed/${PROJECT}.fastp.html \
        --json $DIR/result/trimmed/${PROJECT}.fastp.json \
        -i $DIR/data/${PROJECT}_R1.fastq.gz -I $DIR/data/${PROJECT}_R2.fastq.gz \
        -o $DIR/result/trimmed/${PROJECT}_R1.trimmed.fastq.gz -O $DIR/result/trimmed/${PROJECT}_R2.trimmed.fastq.gz

mkdir $DIR/result/trimmed-fastqc
fastqc -o $DIR/result/trimmed-fastqc $DIR/result/trimmed/*.fastq.gz

# ---------------------------------------------------------------
# This step uses Unicycler to perform genome assembly on paired-end data, with output specified by -o, and input files defined by -1 and -2; see documentation https://github.com/rrwick/Unicycler
# This step uses QUAST to perform quality assessment, with the input assembly specified and output directed to a given directory; see documentation https://quast.sourceforge.net/
source activate base
conda activate unicycl

mkdir $DIR/result/unicycler
unicycler -o $DIR/result/unicycler \
        -1 $DIR/data/${PROJECT}_R1.fastq.gz -2 $DIR/data/${PROJECT}_R2.fastq.gz

mkdir $DIR/result/unicycler/quast
cd $DIR/result/unicycler/quast
quast $DIR/result/unicycler/assembly.fasta
cd $DIR

# --------------------------------------------------------------
# This step uses AUGUSTUS to perform gene prediction on an input assembly, specifying the species and strand orientation, with output directed to a specified directory; see documentation https://bioinf.uni-greifswald.de/augustus/
source activate base
conda activate annotation

mkdir $DIR/result/annotation
augustus --strand=both \
         --species=E_coli_K12 \
         $DIR/result/unicycler/assembly.fasta > $DIR/result/annotation/${PROJECT}.gff

# ---------------------------------------------------------------

echo "               YOUR ANALYSIS IS DONE!!!                   "
