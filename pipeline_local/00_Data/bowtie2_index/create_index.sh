#!/bin/bash
#SBATCH --time=120:00:00
#SBATCH --job-name=generate_bwa_index
#SBATCH --partition=Orion
#SBATCH --ntasks-per-node=32
#SBATCH --mem=100GB

#Create the index files required by the BWA aligner

IN_DIR=/nobackup/mougeots_research/adam_alexander/exome_pipeline/00_Data/reference/GRCh38.fna
OUT_DIR=/nobackup/mougeots_research/adam_alexander/exome_pipeline/00_Data/bowtie2_index

module load bowtie2

cd IN_DIR

bowtie2-build \
$IN_DIR

mv *.bt2 $OUT_DIR