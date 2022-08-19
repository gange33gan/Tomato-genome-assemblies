import sys,os
a = sys.argv[1]
i = "".join(a)
i = int(i)
os.system('bwa index Heinz_1706.t{}.total.PAVs.fa '.format(i-1))
os.system('bwa mem -t 40 -w 500 -M Heinz_1706.t{}.total.PAVs.fa PAV.split.t{}.fa | samtools view -b -o ./PAV.split.t{}.Heinz_1706.bam '.format(i-1,i,i))
