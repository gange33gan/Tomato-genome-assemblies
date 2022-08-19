import sys
ms,files,out=sys.argv
with open(files,'r')as f, open (out,"w") as w:
	for i in f.readlines():
		a,b,c = i.strip().split()
		if int(c)-int(b) >= 500:
		print('{}\t{}\t{}'.format(a,b,c),file=w)
