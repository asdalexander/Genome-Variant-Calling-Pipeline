#!/bin/bash
#SBATCH --time=6:00:00
#SBATCH --job-name=generate_ref_index_dict
#SBATCH --partition=Orion
#SBATCH --ntasks-per-node=4
#SBATCH --mem=10GB

#Create the index and dictionary files required by GATK tools

#Create index
module load samtools
samtools faidx GRCh38.fna
module unload samtools

#Create dictionary
module load picard
picard CreateSequenceDictionary R=GRCh38.fna
module unload picard