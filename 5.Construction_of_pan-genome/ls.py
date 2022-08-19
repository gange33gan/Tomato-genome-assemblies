import sys,os
a = sys.argv[1]
i = "".join(a)
i = int(i)
os.system('ls Heinz_1706.t{}.total.PAVs.fa t{}.Heinz_1706.real.PAVs.filter.N.fa > merge.txt'.format(i-1,i))
