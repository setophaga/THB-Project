#!/bin/bash
#script to trim data with trimmomatic
#created by KD Oct 30, 2014
#usage ./trim.sh

while read prefix
do
java -jar tools/trimmomatic-0.32/trimmomatic-0.32.jar PE -phred33 -threads 1 clean_data/"$prefix"_R1.fastq clean_data/"$prefix"_R2.fastq clean_data_trim/"$prefix"_R1.fastq clean_data_trim/"$prefix"_R1_unpaired.fastq clean_data_trim/"$prefix"_R2.fastq clean_data_trim/"$prefix"_R2_unpaired.fastq TRAILING:3 SLIDINGWINDOW:4:10 MINLEN:30
done < prefix.list.lane1.bwa
