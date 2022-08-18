# Identification of SVs between tomato accessions and Heinz 1706
## Run Nucmer  
```
#!/bin/bash
#SBATCH -p v6_384
#SBATCH -N 1
#SBATCH -n 10
export PATH=/public1/home/sc80041/miniconda3/bin:$PATH
source activate mummer
nucmer --maxmatch -l 100 -c 500 Heinz_1706.fasta .t$i.polished.fa -p t$i.SL4.0
```
## Gzip the delta file
```
gzip t$i.SL4.0.delta
```
## Upload delta.gz file to Assemblytics

# Merge SVs at population level using the results from Assemblytics by SURVIVOR
## Using SURVIVOR bedtovcf
```
#!/bin/bash
#SBATCH -p v6_384
#SBATCH -N 1
#SBATCH -n 1
conda activate survivor
```



## Using SURVIVOR merge
```
#!/bin/bash
#SBATCH -p v6_384
#SBATCH -N 1
#SBATCH -n 1
conda activate survivor
```
