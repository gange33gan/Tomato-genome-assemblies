#!/bin/bash

# Before running this script, some files have been generated and some script are same in 4.Identification_of_Presence-absence_variations_sequences
# for example, PAV.split.t$i.fa、t$i.fa.length.sorted.win500.txt

# Step1, we use Heinz_1706.fa as reference genome and align one of genome to Heinz_1706.fa, and merge Heinz_1706.fa and sequences of PAVs identified between them as basics of pan-genome
ls t1.Heinz_1706.real.PAVs.filter.N.fa Heinz_1706.fa > merge.txt
for i in $(cat merge.txt);do
	cat ${i}
	echo
done > ./Heinz_1706.t1.total.PAVs.fa

# Step2,other genomes were aligned to the pan-genome
cat accession.number.txt | while read i
do
	python bwa.py $i 
	samtools view -f 4 PAV.split.t$i.Heinz_1706.bam | awk '{print $1}' > t$i.chr.coords.txt
	cat t$i.chr.coords.txt | awk -F ':' '{print $1}' > t$i.chr.txt
	cat t$i.chr.coords.txt | awk -F ':' '{print $2}' | awk -F '-' '{print $1}' > t$i.coords.txt
	paste -d "\t" t$i.chr.txt t$i.coords.txt > t$i.unmapped.unsorted.bed
	sort -k 1,1 -k 2,2n t$i.unmapped.unsorted.bed > t$i.unmapped.sorted.bed
	python readjust.coord1.py t$i.unalign.sorted.bed t$i.unalign.sorted.readjust.bed
	perl get_the_detailed_mapping_information_from_bwa_bam_file.pl PAV.split.t$i.Heinz_1706.bam 0 > PAV.split.t$i.Heinz_1706.output.txt
	awk -v OFS="\t" '{if( ($5 > 0.8) && ($6 > 0.9)) print $1,$3,$4}' PAV.split.t$i.Heinz_1706.output.txt > PAV.t$i.dayu.id0.9.cover0.8.txt
	python readjust.coord2.py PAV.t$i.dayu.id0.9.cover0.8.txt PAV.t$i.dayu.id0.9.cover0.8.readjust.txt
	cat t$i.unalign.sorted.readjust.bed PAV.t$i.dayu.id0.9.cover0.8.readjust.txt > t$i.dayu.and.f4.coord.unsorted.txt
	sort -k 1,1 -k 2,2n t$i.dayu.and.f4.coord.unsorted.txt > t$i.dayu.and.f4.coord.sorted.txt
	bedtools merge -i t$i.dayu.and.f4.coord.sorted.txt > t$i.dayu.and.f4.coord.sorted.merge.txt
	bedtools subtract -a t$i.fa.length.sorted.win500.txt -b t$i.dayu.and.f4.coord.sorted.merge.txt -A > t$i.dayu.and.f4.coord.out.txt
	sort -k 1,1 -k 2,2n t$i.dayu.and.f4.coord.out.txt > t$i.dayu.and.f4.coord.out.sorted.txt
	bedtools merge -i t$i.dayu.and.f4.coord.out.sorted.txt > t$i.dayu.and.f4.coord.out.sorted.merge.txt
	python3 greater500bp.py t$i.dayu.and.f4.coord.out.sorted.merge.txt t$i.dayu.and.f4.coord.out.sorted.merge.500bp.txt
	cat t$i.dayu.and.f4.coord.out.sorted.merge.500bp.txt t$i.unalign.sorted.readjust.bed > t$i.PAVs.coords.txt
	sort -k 1,1 -k 2,2n t$i.PAVs.coords.txt > t$i.PAVs.coords.sorted.txt
	bedtools merge -i t$i.PAVs.coords.sorted.txt > t$i.PAVs.coords.sorted.merge.txt
	seqkit subseq --bed t$i.PAVs.coords.sorted.merge.txt -o t$i.Heinz_1706.real.PAVs.fa t$i.fa
	python filter.N.py t$i.Heinz_1706.real.PAVs.fa t$i.Heinz_1706.real.PAVs.filter.N.fa
	python ls.py $i
	for i in $(cat merge.txt);do
		cat ${i}
		echo
	done > Heinz_1706.t$i.total.PAVs.fa
done
