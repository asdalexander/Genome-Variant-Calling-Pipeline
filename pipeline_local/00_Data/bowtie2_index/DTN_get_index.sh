#!/bin/bash
#SBATCH --time=2:00:00
#SBATCH --job-name=get_bwa_index
#SBATCH --partition=DTN
#SBATCH --mem=8GB

#Get the index files required by the BWA aligner, this set of files is sourced from the same
#NCBI FTP site as the GRCh38.fna reference file and will only work with the *_noalt version. 

wget https://ftp.ncbi.nlm.nih.gov/genomes/all/GCA/000/001/405/GCA_000001405.15_GRCh38/seqs_for_alignment_pipelines.ucsc_ids/GCA_000001405.15_GRCh38_no_alt_analysis_set.fna.bowtie_index.tar.gz