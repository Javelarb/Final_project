#!/bin/bash
#SBATCH --job-name=JA_genome_assembly 
#SBATCH -A ecoevo283 
#SBATCH -p standard 
#SBATCH --cpus-per-task=32

module load megahit/1.2.9

#creates a comma sep list of fastq files.
READ1=`cat prefixes.txt | sed 's/$/_1.fq.gz,/' | sed '$ s/.$//' | tr -d '\n'`
READ2=`cat prefixes.txt | sed 's/$/_2.fq.gz,/' | sed '$ s/.$//' | tr -d '\n'`

megahit -1 ${READ1} -2 ${READ2} -t 32 --min-contig-len 1000
