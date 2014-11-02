#!/bin/bash
#script to realign around local indels and call snps with haplotype caller
#created by KD Oct 30, 2014
#usage ./realign_snps.sh

# make sure these folders exist and change the lane and barcode names depending on the project
clean_data="clean_data_trim"
sam="sam"
bam="bam"
lane="lane1"
runbarcode="C1JDVACXX"
log="logs"
gvcf="gvcf"
ref="ref/Taeniopygia_guttata.taeGut3.2.4.66.dna_rm.toplevel.fa"
realign.intervals=""

# tell it where the executables are
bwa='/Linux/bin/bwa-0.7.10'
picard='/SciBorg/array0/kdelmore/silu/tools/picard-tools-1.97'
samtools='/Linux/bin/samtools'
gatk='/Linux/GATK3'

while read prefix
do

#Realign around local indels
java -Xmx4g -jar $gatk/GenomeAnalysisTK.jar \
        -T IndelRealigner \
        -R $ref \
        -I $bam/$prefix.combo.bam \
        -targetIntervals $realign.intervals \
        -o $bam/$prefix.realign.bam \
        -log $log/$prefix.IndelRealigner.log

#Call GATK HaplotypeCaller
java -Xmx18g -jar $gatk/GenomeAnalysisTK.jar \
        -nct 8 \
        -l INFO \
        -R $ref \
        -log $log/$prefix.HaplotypeCaller.log \
        -T HaplotypeCaller \
        -I  $bam/$prefix.realign.bam \
        --emitRefConfidence GVCF \
        --max_alternate_alleles 2 \
        -variant_index_type LINEAR \
        -variant_index_parameter 128000 \
        -o $gvcf/$prefix.GATK.gvcf.vcf \

done < prefix.list.lane1.missing.realign
