#!/bin/bash
#create and submit pbs scripts to breezy that will realign around local indels and call snps with haplotype caller
#created by KD Oct 30, 2014
#make pbs folder as well; it's not called but is at the end of the loop
#usage ./realign_snps_westgrid.sh

while read prefix
do
        echo "#!/bin/bash

#PBS -S /bin/bash
#PBS -l walltime=6:00:00
#PBS -l mem=23GB
#PBS -l nodes=1:ppn=1
#PBS -N "$prefix"_gatk
#PBS -M kdelmore@zoology.ubc.ca
#PBS -m bea

# make sure these folders exist and change the lane and barcode names depending on the project
clean_data="clean_data_trim"
sam="sam"
bam="bam"
lane="lane1"
runbarcode="C1JDVACXX"
log="logs"
gvcf="gvcf"
ref="ref/Taeniopygia_guttata.taeGut3.2.4.66.dna_rm.toplevel.fa"
realign.intervals="THB.realign.intervals"

# load and assign locations for executables
module load java

cd \$PBS_O_WORKDIR
JOBINFO="$prefix"_\${PBS_JOBID}
echo \"Starting run at: \`date\`\" >> \$JOBINFO

# realign around local indels

/global/software/gatk/gatk322/bin/gatk.sh -Xmx4g -T IndelRealigner \
-R \$ref \
-I \$bam/"$prefix".combo.bam \
-targetIntervals \$realign.intervals \
-o \$realign_indels/"$prefix".realigned.bam \
-log \$log/"$prefix".indelrealigner.log

# call snps with haplotype caller

/global/software/gatk/gatk322/bin/gatk.sh -Xmx23g -T HaplotypeCaller \
-R \$ref \
-l INFO \
-I \$realign_indels/"$prefix".realigned.bam \
--emitRefConfidence GVCF \
--max_alternate_alleles 2 \
-variant_index_type LINEAR \
-variant_index_parameter 128000 \
-o \$gvcf/"$prefix".gvcf.vcf \
-log \$log/"$prefix".haplotypecaller.log

echo \"Program finished with exit code \$? at: \`date\`\" >> \$JOBINFO" > pbs/$prefix.pbs

qsub -c s pbs/$prefix.pbs

done < prefix.list.lane1.realigner
