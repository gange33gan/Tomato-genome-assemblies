# Step.1 Raw Assembly  
Create and run contig.txt  
$i mean different tomato accessions
```python
!/bin/bash
#SBATCH -p v6_384
#SBATCH -N 1
#SBATCH -n 60
conda activate NECAT
$ necat.pl config t$i.config.txt
$ necat.pl correct t$i.config.txt
$ necat.pl assemble t$i.config.txt
$ necat.pl bridge t$i.config.txt
```
The raw contigs are obtained after step 1. 
# Step.2 Polish Process
Polishing raw contigs using short reads and long reads by NextPolish.  
This pipeline contains files:  
+ Short reads are Illumina reads after quality control by fastp  
+ Long reads are Nanopore reads after correction by NECAT     

Create and run t$i.run.cfg
```python  
#!/bin/bash
#SBATCH -p v6_384
#SBATCH -N 1
#SBATCH -n 30
${NextPolish_PATH}/nextPolish t$i.run.cfg  
```  
The polished contigs are obtained after step 2.
# Step.3 Final Assembly
The accessions are directly guided using the Heinz 1706 assembly by Ragtag.
```python
!/bin/bash
#SBATCH -p v6_384
#SBATCH -N 1
#SBATCH -n 10
conda activate ragtag
ragtag.py correct Heinz_1706.fasta t$i.polished.fasta -t 10
ragtag.py scaffold Heinz_1706.fasta ${Ragtag_PATH}/ragtag_output/ragtag.correct.fasta -t 10
```
The chromosome-level scaffolds are obtained.
