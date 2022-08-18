# Step.1 Row Assembly  
create and run contig.txt
```python
!/bin/bash
#SBATCH -p v6_384
#SBATCH -N 1
#SBATCH -n 60
conda activate NECAT
$ necat.pl config xxx.config.txt
$ necat.pl correct xxx.config.txt
$ necat.pl assemble xxx.config.txt
$ necat.pl bridge xxx.config.txt
```
# Step.2 Polish Process
Polishing genome after step.1 using short reads and long reads. This pipeline contains files:  
+ Short reads are Illumina reads after quality control by fastp  
+ Long reads are Nanopore reads after correcting by NECAT     

create and run xxx.run.cfg
```python  
#!/bin/bash
#SBATCH -p v6_384
#SBATCH -N 1
#SBATCH -n 30
$ nextPolish xxx.run.cfg  
```  
# Step.3 Chromosome-level scaffolds
The accessions are directly guided using the Heinz 1706 assembly by Ragtag.
```python
!/bin/bash
#SBATCH -p v6_384
#SBATCH -N 1
#SBATCH -n 10
conda activate ragtag
ragtag.py correct Heinz_1706.fasta query.fasta -t 10
ragtag.py scaffold Heinz_1706.fasta xxx.path.xxx/ragtag_output/ragtag.correct.fasta -t 10
```
