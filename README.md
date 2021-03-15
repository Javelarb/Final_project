# Final project

In my lab, we sequence DNA metagenomes to study the microbiome.  

Often times, when we are interested in the genome of a specific organism we have to assemble the metagenomes.  

This allows us to get strain/function from microbes that are not well characterized or that may be specific to an environment.  

For my project, I co-assembled all of the DNA seq samples together to try and "build" a new drosophila reference genome to assess the de novo assembly performance. 

## Steps:
I began by creating a comma separated list of all the DNA seq samples to input into the assembler, MEGAHIT.  
The default parameters were mostly used with the exception of a minimum contig length of 1000.  

`
module load megahit/1.2.9

#creates a comma sep list of fastq files.
READ1=`cat prefixes.txt | sed 's/$/_1.fq.gz,/' | sed '$ s/.$//' | tr -d '\n'`
READ2=`cat prefixes.txt | sed 's/$/_2.fq.gz,/' | sed '$ s/.$//' | tr -d '\n'`

megahit -1 ${READ1} -2 ${READ2} -t 32 --min-contig-len 1000
`

Next, I recorded some assembly stats using bbmap.  

`
A       C       G       T       N       IUPAC   Other   GC      GC_stdev
0.2875  0.2132  0.2131  0.2861  0.0000  0.0000  0.0000  0.4264  0.0415

Main genome scaffold total:             22040
Main genome contig total:               22040
Main genome scaffold sequence total:    112.239 MB
Main genome contig sequence total:      112.239 MB      0.000% gap
Main genome scaffold N/L50:             3651/7.837 KB
Main genome contig N/L50:               3651/7.837 KB
Main genome scaffold N/L90:             14537/2.135 KB
Main genome contig N/L90:               14537/2.135 KB
Max scaffold length:                    230.897 KB
Max contig length:                      230.897 KB
Number of scaffolds > 50 KB:            67
% main genome in scaffolds > 50 KB:     4.13%


Minimum         Number          Number          Total           Total           Scaffold
Scaffold        of              of              Scaffold        Contig          Contig
Length          Scaffolds       Contigs         Length          Length          Coverage
--------        --------------  --------------  --------------  --------------  --------
    All                 22,040          22,040     112,238,833     112,238,833   100.00%
    500                 22,040          22,040     112,238,833     112,238,833   100.00%
   1 KB                 22,040          22,040     112,238,833     112,238,833   100.00%
 2.5 KB                 13,058          13,058      97,602,481      97,602,481   100.00%
   5 KB                  6,666           6,666      74,892,089      74,892,089   100.00%
  10 KB                  2,463           2,463      45,661,353      45,661,353   100.00%
  25 KB                    377             377      14,973,885      14,973,885   100.00%
  50 KB                     67              67       4,634,795       4,634,795   100.00%
 100 KB                      7               7         907,176         907,176   100.00%
`
Then, I aligned my final_contigs.fa to the reference drosophila genome provided to us for the class.

`
ref="../ref/dmel-all-chromosome-r6.13.fasta"

bwa mem -t 4 -M $ref final.contigs.fa | samtools view -bS - > contig_alignment.bam
samtools sort contig_alignment.bam -o contig_alignment.sort.bam

java -jar /opt/apps/picard-tools/1.87/AddOrReplaceReadGroups.jar I=contig_alignment.sort.bam O=contig_alignment.RG.bam SORT_ORDER=coordinate RGPL=illumina RGPU=D109LACXX RGLB=Lib1 RGID=contig_alignment RGSM=contig_alignment VALIDATION_STRINGENCY=LENIENT
samtools index contig_alignment.RG.bam
`

Lastly, I used the week 4 code to produce a bigwig track and used cyverse.org to host my own track.  

My track link is: https://data.cyverse.org/dav-anon/iplant/home/julya/contig_alignment.RG.bam.bw

## Exploration of assembly in the UCSC genome browser

After some reading and playing around, I discovered how to visualize the coverage of my assembly.

The coverage for the chromosomes was:

`
80.04% coverage on chr4.  
86.05% coverage on chrX.  
0.96% coverage on chrY.  
83.85% coverage on chr3r.  
80.04% coverage on chr3l.  
77.96% coverage on chr2r.  
86.63% coverage on chr2l.  
`

I think the abscence of chr Y coverage means that these were female (not a fly guy)?  

Overall, I think this means the assembly performance is pretty good on average.  
I'm sure it can be improved by tweaking the parameters, reducing the minimum contig length, and increasing the sequencing depth.  

