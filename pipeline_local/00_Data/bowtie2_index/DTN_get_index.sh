#!/bin/bash
########## SLURM HEADER START ##########
#SBATCH --time=2:00:00
#SBATCH --job-name=get_bwa_index
#SBATCH --partition=DTN
#SBATCH --mem=4GB
########## SLURM HEADER END ##########

echo "======================================================"
echo "Start Time  : $(date)"
echo "Submit Dir  : $SLURM_SUBMIT_DIR"
echo "Job ID/Name : $SLURM_JOBID / $SLURM_JOB_NAME"
echo "Num Tasks   : $SLURM_NTASKS total [$SLURM_NNODES nodes @ $SLURM_CPUS_ON_NODE CPUs/node]"
echo "======================================================"
echo ""

########## DESCRIPTION ##########
# Download the index files required by the BWA aligner. This set of files is sourced from the same
# NCBI FTP site as the GRCh38.fna reference file and will only work with the *_noalt genome version, 
# see ftp source for additional index versions. Index can also be created using create_index.sh in the
# source directory. 

########## SCRIPT START ##########
wget https://ftp.ncbi.nlm.nih.gov/genomes/all/GCA/000/001/405/GCA_000001405.15_GRCh38/seqs_for_alignment_pipelines.ucsc_ids/GCA_000001405.15_GRCh38_no_alt_analysis_set.fna.bowtie_index.tar.gz


echo ""
echo "======================================================"
echo "JOB COMPLETE"
echo "End Time   : $(date)"
echo "======================================================"
