#!/bin/bash

# We used Heinz_1706.fa as reference genome and splited tomato genomes(as t$i.fa)

# Step1, split tomato genomes and slide window on the genomes
#perl *.pl *.fasta bin_size step_size output
perl split_sequence_into_bins.pl t$i.fa 500 100 PAV.split.t$i.fa

# Step2, calculate the length of each chromosome and contig of genomes,slide window on the genomes
perl cal_chr.length.pl t$i.fa > t$i.fa.length.txt
sed -i "s/Name: //" t$i.fa.length.txt
sed -i "s/Length: //" t$i.fa.length.txt
sort -k 1,1 -k 2,2n t$i.fa.length.txt > t$i.fa.length.sorted.txt
bedtools makewindows -g t$i.fa.length.sorted.txt -w 500 > t$i.fa.length.sorted.win500.txt

# Step3, build index by BWA
bwa index Heinz_1706.fa

# Step4, Use BWA to align and use Samtools to convert sam to bam format
bwa mem -t 20 -w 500 -M Heinz_1706.fa PAV.split.t$i.fa | samtools view -b -o PAV.split.t$i.Heinz_1706.bam

# Step5, extract and sort the coordinates of reads unmapped to reference genome
samtools view -f 4 PAV.split.t$i.Heinz_1706.bam | awk '{print $1}' > t$i.chr.coords.txt
cat t$i.chr.coords.txt | awk -F ':' '{print $1}' > t$i.chr.txt
cat t$i.chr.coords.txt | awk -F ':' '{print $2}' | awk -F '-' '{print $1}' > t$i.coords.txt
paste -d "\t" t$i.chr.txt t$i.coords.txt > t$i.unmapped.unsorted.bed
sort -k 1,1 -k 2,2n t$i.unmapped.unsorted.bed > t$i.unmapped.sorted.bed

# Step6, adjust the coordinates in t$i.unmapped.sorted.bed
python readjust.coord1.py t$i.unalign.sorted.bed t$i.unalign.sorted.readjust.bed

# Step7, use perl script to get the alignment information of bam
#perl *.pl *fasta mapping qualiy > output
perl get_the_detailed_mapping_information_from_bwa_bam_file.pl PAV.split.t$i.Heinz_1706.bam 0 > PAV.split.t$i.Heinz_1706.output.txt

# Step8, extract the coordinates of genomes with coverage greater than 0.8 and consistency greater than 0.9,adjust the coordinates
awk -v OFS="\t" '{if( ($5 > 0.8) && ($6 > 0.9)) print $1,$3,$4}' PAV.split.t$i.Heinz_1706.output.txt > PAV.t$i.dayu.id0.9.cover0.8.txt
python readjust.coord2.py PAV.t$i.dayu.id0.9.cover0.8.txt PAV.t$i.dayu.id0.9.cover0.8.readjust.txt

# Step9, merge unmapped.bed of step6 and the step8 file, and sort
cat t$i.unalign.sorted.readjust.bed PAV.t$i.dayu.id0.9.cover0.8.readjust.txt > t$i.dayu.and.f4.coord.unsorted.txt
sort -k 1,1 -k 2,2n t$i.dayu.and.f4.coord.unsorted.txt > t$i.dayu.and.f4.coord.sorted.txt
bedtools merge -i t$i.dayu.and.f4.coord.sorted.txt > t$i.dayu.and.f4.coord.sorted.merge.txt

# Step10, pick out PAVs in alignment, sort and merge them. determine if PAVs are greater than 500bp 
bedtools subtract -a t$i.fa.length.sorted.win500.txt -b t$i.dayu.and.f4.coord.sorted.merge.txt -A > t$i.dayu.and.f4.coord.out.txt
sort -k 1,1 -k 2,2n t$i.dayu.and.f4.coord.out.txt > t$i.dayu.and.f4.coord.out.sorted.txt
bedtools merge -i t$i.dayu.and.f4.coord.out.sorted.txt > t$i.dayu.and.f4.coord.out.sorted.merge.txt
python3 greater500bp.py t$i.dayu.and.f4.coord.out.sorted.merge.txt t$i.dayu.and.f4.coord.out.sorted.merge.500bp.txt

# Step11, cat two PAVs together
cat t$i.dayu.and.f4.coord.out.sorted.merge.500bp.txt t$i.unalign.sorted.readjust.bed > t$i.PAVs.coords.txt
sort -k 1,1 -k 2,2n t$i.PAVs.coords.txt > t$i.PAVs.coords.sorted.txt
bedtools merge -i t$i.PAVs.coords.sorted.txt > t$i.PAVs.coords.sorted.merge.txt
seqkit subseq --bed t$i.PAVs.coords.sorted.merge.txt -o t$i.Heinz_1706.real.PAVs.fa t$i.fa

# Step12, determine that the number of gaps in each sequence does not exceed 50% of the length
python filter.N.py t$i.Heinz_1706.real.PAVs.fa t$i.Heinz_1706.real.PAVs.filter.N.fa
