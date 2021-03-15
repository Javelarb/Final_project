#!/bin/bash
#SBATCH --job-name=JA_DNA_alignment ## Name of the job. 
#SBATCH -A ecoevo283 ##account to charge 
#SBATCH -p standard ## partition/queue name 
#SBATCH --cpus-per-task=4 ## number of cores the job needs, can the programs you run make used of multiple cores?

module load bwa/0.7.8 
module load samtools/1.10 
module load bcftools/1.10.2 
module load java/1.8.0 
module load picard-tools/1.87

ref="../ref/dmel-all-chromosome-r6.13.fasta"

bwa mem -t 4 -M $ref final.contigs.fa | samtools view -bS - > contig_alignment.bam 
samtools sort contig_alignment.bam -o contig_alignment.sort.bam

java -jar /opt/apps/picard-tools/1.87/AddOrReplaceReadGroups.jar I=contig_alignment.sort.bam O=contig_alignment.RG.bam SORT_ORDER=coordinate RGPL=illumina RGPU=D109LACXX RGLB=Lib1 RGID=contig_alignment RGSM=contig_alignment VALIDATION_STRINGENCY=LENIENT 
samtools index contig_alignment.RG.bam
