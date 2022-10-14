#!/bin/bash
#SBATCH --time=6:00:00
#SBATCH --job-name=get_reference
#SBATCH --partition=DTN
#SBATCH --mem=8gb

wget ftp://ftp.ncbi.nlm.nih.gov/genomes/all/GCA/000/001/405/GCA_000001405.15_GRCh38/seqs_for_alignment_pipelines.ucsc_ids/GCA_000001405.15_GRCh38_no_alt_analysis_set.fna.gz

