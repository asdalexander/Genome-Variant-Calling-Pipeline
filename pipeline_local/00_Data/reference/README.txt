#!/bin/bash
########## SLURM HEADER START ##########
#SBATCH --time=2:00:00
#SBATCH --job-name=get_grch38
#SBATCH --partition=DTN
#SBATCH --mem=4GB
########## SLURM HEADER END ##########

########## DESCRIPTION ##########
# Download the GRCh38 reference genome. The GRCh38 human reference genome was chosen for alignment and variant calling. 
# The noalt version of this reference genome was chosen for this project. Below are links to more information on the reference genome chosen.

# Information on the no_alt_analysis_set from NCBI: 
# https://ftp.ncbi.nlm.nih.gov/genomes/all/GCA/000/001/405/GCA_000001405.15_GRCh38/seqs_for_alignment_pipelines.ucsc_ids/README_analysis_sets.txt

# More info on no_alt and BWA: 
# https://hgdownload.soe.ucsc.edu/goldenPath/hg38/bigZips/

# More info on no_alt from Heng Li's Blog:
# http://lh3.github.io/2017/11/13/which-human-reference-genome-to-use

########## SCRIPT START ##########
echo "======================================================"
echo "Start Time  : $(date)"
echo "Submit Dir  : $SLURM_SUBMIT_DIR"
echo "Job ID/Name : $SLURM_JOBID / $SLURM_JOB_NAME"
echo "Num Tasks   : $SLURM_NTASKS total [$SLURM_NNODES nodes @ $SLURM_CPUS_ON_NODE CPUs/node]"
echo "======================================================"
echo ""

wget ftp://ftp.ncbi.nlm.nih.gov/genomes/all/GCA/000/001/405/GCA_000001405.15_GRCh38/seqs_for_alignment_pipelines.ucsc_ids/GCA_000001405.15_GRCh38_no_alt_analysis_set.fna.gz

echo ""
echo "======================================================"
echo "JOB COMPLETE"
echo "End Time   : $(date)"
echo "======================================================"
