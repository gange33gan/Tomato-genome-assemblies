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
```python
