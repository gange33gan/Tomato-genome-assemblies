# Using EDTA  
The Extensive *de-novo* TE Annotator(EDTA) is applied to annotate TEs.
```python
#!/bin/bash
#SBATCH -p v6_384
#SBATCH -N 1
#SBATCH -n 20
conda activate EDTA
EDTA.pl --genome t$i.polished.fasta --step all --species others --anno 1 --evaluate 0 -t 20
```
# Using DeepTE  
Using DeepTE to classify unkown TEs in LTR-RTs.  

## Create working and output directories
```python
mkdir working_dir
mkdir output_dir
```

## Extract unknown LTR-RTs and known LTR-RTs from tomato TEs library 
```python
grep "LTR/unknown" ${EDTA_Output_PATH}/t$i.TElib.fa | sed 's/>//' | seqtk subseq ${EDTA_Output_PATH}/t$i.TElib.fa - > working_dir/t$i.LTR.unknown.fa
grep -v "LTR/unknown" ${EDTA_Output_PATH}/t$i.TElib.fa | sed 's/>//' | seqtk subseq ${EDTA_Output_PATH}/t$i.TElib.fa - > working_dir/t$i.LTR.known.fa
```

## Run DeepTE
```python
#!/bin/bash
#SBATCH -N 1
#SBATCH -c 3
conda activate py36
python DeepTE.py -d working_dir -o output_dir -i ${working_dir}/t$i.LTR.unknown.fa -sp P -m_dir ${DeepTE_PATH}/Plants_model -fam LTR
```
The opt_DeepTE.fasta are obtained.

## Rename results of DeepTE classification  
```python
sed 's/LTR\/unknown__ClassI_LTR_Copia/LTR\/Copia/' ${output_dir}/opt_DeepTE.fasta | sed 's/LTR\/unknown__ClassI_LTR_Gypsy/LTR\/Gypsy/' | sed 's/LTR\/unknown__ClassI_LTR/LTR\/unknown/' > ${output_dir}/opt_DeepTE.LTR.unknown.fa
```
## Merge with known LTR-RTs  
```python
 cat ${working_dir}/t$i.LTR.known.fa ${output_dir}/opt_DeepTE.LTR.unknown.fa >  ${working_dir}/t$i.fa.mod.EDTA.TElib.new.fa
 ```  
 # Run anno module of EDTA  
 Delete the original TElib.fa and soft-link its new TElib.fa to the EDTA.final folder, and run
 ```python
 #!/bin/bash
#SBATCH -p v6_384
#SBATCH -N 1
#SBATCH -n 20
conda activate EDTA
EDTA.pl --genome t$i.polished.fasta --step anno --species others --anno 1 --evaluate 0 --overwrite 1 -t 20
```
