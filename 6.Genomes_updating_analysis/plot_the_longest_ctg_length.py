import sys
import matplotlib.pyplot as plt
n = 0.1
ax = plt.axes([0.1,0.1,0.9,0.9],xlim=([0,100]),ylim=([0,1]))
plt.axis('off')
ax.add_patch(plt.Rectangle((0,0.05),90,0.0000001,color='#000000'))
for i in range(10):
    ax.add_patch(plt.Rectangle((i*10,0.035),0.0000001,0.015,color='#000000'))
    plt.text(0+i*10,0,'{}Mb'.format(i*10),horizontalalignment='center',size=10,color='#000000')
for files in sys.argv[1:]:
    dictchr={}
    with open(files,'r')as fin:
        for i in fin.read().split('>')[1:]:
            name,ctg = i.strip().split('\n',1)
            ctg = ctg.replace('\n','').upper()
            dictchr[name]=ctg

    thelong=''
    themax=0
    for i in dictchr:
        listnon=[]
        listchr = dictchr[i].strip().split('N')
        for k in listchr:
            if k != '':
                if themax <= len(k):
                    themax = len(k)
                    thelong = i
    print('This file name {:^40}'.format(files))
    print('The longest contig was locating on Chromosome: {:^20}'.format(thelong))
    print('The length of this Chromosome {:^40}'.format(len(dictchr[thelong])))
    print('The longest contig length: {:^20}'.format(str(themax)))
    print('Percentage of the longest contig in this Chromosome: {:.2%}'.format(themax/len(dictchr[thelong])))
    ax1 = plt.axes([0,0.1+n,0.1,0.9],xlim=([0,1]),ylim=([0,1]))
    plt.axis('off')
    plt.text(1,0.03,files.split('.')[0],horizontalalignment='right',size=8,color='#000000')
    plt.text(1,0.01,thelong,horizontalalignment='right',size=8,color='#000000')
    listthechr = []
    for i in dictchr[thelong].strip().split('N'):
        if i != '':
            listthechr.append(len(i))
    ax = plt.axes([0.1,0.1+n,0.9,0.9],xlim=([0,100000000]),ylim=([0,1]))
    plt.axis('off')
    nor_color="#59deab"
    gap_color="#ababab"
    max_color="#046c44"
    x = 0
    for i in range(len(listthechr)):
        if i != len(listthechr)-1:
            if listthechr[i] == themax:
                ax.add_patch(plt.Rectangle((x,0.03),listthechr[i],0.015,color=max_color))
            else:
                ax.add_patch(plt.Rectangle((x,0.03),listthechr[i],0.015,color=nor_color))
            x = x+listthechr[i]
            ax.add_patch(plt.Rectangle((x,0),1000,0.015,color=gap_color))
            ax.add_patch(plt.Rectangle((x,0.03),1000,0.015,color='#FFFFFF'))
        else:
            if listthechr[i] == themax:
                ax.add_patch(plt.Rectangle((x,0.03),listthechr[i],0.015,color=max_color))
            else:
                ax.add_patch(plt.Rectangle((x,0.03),listthechr[i],0.015,color=nor_color))
            x = x+listthechr[i]
        plt.pause(0.1)
    n = n+0.1
plt.savefig("./the longest ctg.new.pdf",dpi=600)
plt.show()
