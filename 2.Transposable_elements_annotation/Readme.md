# Using EDTA  
The Extensive *de-novo* TE Annotator(EDTA) is applied to annotate TEs.
```python
#!/bin/bash
#SBATCH -p v6_384
#SBATCH -N 1
#SBATCH -n 20
conda activate EDTA
EDTA.pl --genome xxx.polished.fasta --step all --species others --anno 1 --evaluate 0 -t 20
```
# Using DeepTE  
Using DeepTE to classify unkown TEs.  

## Create working and output directories
```python
mkdir working_dir
mkdir output_dir
```

## Extract unknown TEs from tomato TEs library 
```python
grep "LTR/unknown" {EDTA_Output_PATH}/xxx.TElib.fa | sed 's/>//' | seqtk subseq {EDTA_Output_PATH}/xxx.TElib.fa - > working_dir/xxx.LTR.unknown.fa
```

## Run DeepTE
```python
#!/bin/bash
#SBATCH -N 1
#SBATCH -c 3
conda activate py36
python DeepTE.py -d working_dir -o output_dir -i working_dir/xxx.LTR.unknown.fa -sp P -m_dir {DeepTE_PATH}/Plants_model -fam LTR
```
