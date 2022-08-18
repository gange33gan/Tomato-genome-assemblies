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
## Creat working_dir
```
mkdir working_dir
```

## Using SURVIVOR convertAssemblytics  
Transform according to the type of SVs
```
#!/bin/bash
#SBATCH -p v6_384
#SBATCH -N 1
#SBATCH -n 1
conda activate survivor
cat accession.txt | while read i
do
        SURVIVOR convertAssemblytics {Assemblytics_results_Path}/test$i.SL4_0.Assemblytics_structural_variants.bed 50 ${working_dir}/t$i.SL4.0.Assemblytics.SVs.vcf
done
```

## Extract and sort vcf according to the type of SVs
```
cat accession.txt | while read i
do
        awk '{if($5=="<DEL>")print $0}' ${working_dir}/t$i.SL4.0.Assemblytics.SVs.vcf > ${working_dir}/t$i.SL4.0.Assemblytics.del.vcf
        awk '{if($5=="<INS>")print $0}' ${working_dir}/t$i.SL4.0.Assemblytics.SVs.vcf > ${working_dir}/t$i.SL4.0.Assemblytics.ins.vcf
        sort -k1,1 -k2,2n ${working_dir}/t$i.SL4.0.Assemblytics.del.vcf > ${working_dir}/t$i.SL4.0.Assemblytics.del.sorted.vcf
        sort -k1,1 -k2,2n ${working_dir}/t$i.SL4.0.Assemblytics.ins.vcf > ${working_dir}/t$i.SL4.0.Assemblytics.ins.sorted.vcf
done
```

## Prepare the name file  
```
cat accession.txt | while read i
do
        echo -e  "${working_dir}/t$i.SL4.0.Assemblytics.del.sorted.vcf" >> Del.vcf.name
        echo -e "${working_dir}/t$i.SL4.0.Assemblytics.ins.sorted.vcf" >> Ins.vcf.name
done
```
## Using SURVIVOR merge
Merge separately according to the type of SVs.  
```
#!/bin/bash
#SBATCH -p v6_384
#SBATCH -N 1
#SBATCH -n 1
conda activate survivor
SURVIVOR merge Del.vcf.name 1000 1 1 1 1 50 tomato.merged.del.vcf
SURVIVOR merge Ins.vcf.name 1000 1 1 1 1 50 tomato.merged.Ins.vcf
```
