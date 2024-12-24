#!/bin/bash

<<PURPOSE
(0) Assumption: The WGS project uses paired-end NGS reads in fastq.gz format.
(1) This script creates a working directory for running the WGS analyses pipeline from.
(2) This script is a valuable resource for anyone performing whole genomic sequencing, enhancing research and exploring genetic data.
(3) Contact: taiyeba.ardra@northsouth.edu 
PURPOSE

# This script creates folders, file names and sets the location as per your data.

read -p "Enter a nick name for your current project: " PROJECT
read -p "Enter the folder location of your raw data (illumina paired-end data in fastq.gz format): " LOCATION
read -p "Enter the file name of the forward read data: " FOR
read -p "Enter the file name of the reverse read data: " REV

mkdir WGS_$PROJECT && cd WGS_$PROJECT 
DIR=$(pwd)
mkdir data meta result
cd $DIR/data
cp $LOCATION/$FOR .  && echo "Forward reads have been transferred successfully!"
cp $LOCATION/$REV .  && echo "Reverse reads have been transferred successfully!"
mv ${FOR} ${PROJECT}_R1.fastq.gz && mv ${REV} ${PROJECT}_R2.fastq.gz && echo "The files are also renamed successfully"
