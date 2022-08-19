import sys
ms,files,out=sys.argv
with open(files,'r')as f, open (out,"w") as w:
	for i in f.readlines():
		a,b,c = i.strip().split()
		b1 = int(b)-1
		print('{}\t{}\t{}'.format(a,b1,c),file=w)
