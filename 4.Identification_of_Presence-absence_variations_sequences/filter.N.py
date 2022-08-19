import sys,re,os
ms,files,out = sys.argv
with open (files,"r") as fin, open (out,"w") as w:
	seq={}
	for i in fin.read().split('>'):
		if i != "":
			name,fa = i.split('\n',1)
			fa = fa.replace('\n','')
			seq[name]=fa
			size=len(fa)
			n=fa.count("N")+fa.count("n")
			percent_N=(n)/size
			if percent_N < 0.5:
				print (">{}".format(i),end="",file=w)
			else:
				pass
