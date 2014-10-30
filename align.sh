#!/bin/bash
#script to align data with bwa, combine se and pe data with samtools and add RG for GATK
#created by KD Oct 30, 2014
#usage ./align.sh

# make sure these folders exist
clean_data="clean_data_trim"
sam="sam"
bam="bam"
lane="lane1"
runbarcode="C1JDVACXX"
log="logs"

# tell it where the executables are
bwa='/Linux/bin/bwa-0.7.10'
picardtools='/SciBorg/array0/kdelmore/silu/tools/picard-tools-1.97'
samtools='/Linux/bin/samtools'

while read prefix
do

## run bwa
$bwa mem -M ref/Taeniopygia_guttata.taeGut3.2.4.66.dna_rm.toplevel.fa $clean_data/"$prefix"_R1.fastq $clean_data/"$prefix"_R2.fastq > $sam/"$prefix".sam
$bwa mem -M ref/Taeniopygia_guttata.taeGut3.2.4.66.dna_rm.toplevel.fa $clean_data/"$prefix"_R1_unpaired.fastq > $sam/"$prefix".R1.unpaired.sam
$bwa mem -M ref/Taeniopygia_guttata.taeGut3.2.4.66.dna_rm.toplevel.fa $clean_data/"$prefix"_R2_unpaired.fastq > $sam/"$prefix".R2.unpaired.sam

## add read group headers, convert to bam, sort and index
java -Xmx2g -jar $picard/AddOrReplaceReadGroups.jar I=$sam/"$prefix".sam O=$bam/"$prefix".bam RGID=$lane RGPL=ILLUMINA RGLB=LIB."$prefix" RGSM="$prefix" RGPU=$runbarcode SORT_ORDER=coordinate CREATE_INDEX=TRUE
java -Xmx2g -jar $picard/AddOrReplaceReadGroups.jar I=$sam/"$prefix".R1.unpaired.sam O=$bam/"$prefix".R1.unpaired.bam RGID=$lane RGPL=ILLUMINA RGLB=LIB."$prefix" RGSM="$prefix" RGPU=$runbarcode SORT_ORDER=coordinate CREATE_INDEX=TRUE
java -Xmx2g -jar $picard/AddOrReplaceReadGroups.jar I=$sam/"$prefix".R2.unpaired.sam O=$bam/"$prefix".R2.unpaired.bam RGID=$lane RGPL=ILLUMINA RGLB=LIB."$prefix" RGSM="$prefix" RGPU=$runbarcode SORT_ORDER=coordinate CREATE_INDEX=TRUE

## merge se and pe bam files with samtools and index
$samtools merge $bam/"$prefix".combo.bam $bam/"$prefix".bam $bam/"$prefix".R1.unpaired.bam $bam/"$prefix".R2.unpaired.bam
$samtools index $bam/"$prefix".combo.bam

done < prefix.list.lane1.bwa
