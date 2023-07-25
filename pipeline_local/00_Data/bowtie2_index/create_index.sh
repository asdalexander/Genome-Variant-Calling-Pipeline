#!/bin/bash
########## SLURM HEADER START ##########
#SBATCH --time=24:00:00
#SBATCH --job-name=generate_bwa_index
#SBATCH --partition=Orion
#SBATCH --ntasks-per-node=24
#SBATCH --mem=48GB
########## SLURM HEADER END ##########

########## DESCRIPTION ##########
# Create the index files required by the BWA aligner

########## SCRIPT START ##########
echo "======================================================"
echo "Start Time  : $(date)"
echo "Submit Dir  : $SLURM_SUBMIT_DIR"
echo "Job ID/Name : $SLURM_JOBID / $SLURM_JOB_NAME"
echo "Num Tasks   : $SLURM_NTASKS total [$SLURM_NNODES nodes @ $SLURM_CPUS_ON_NODE CPUs/node]"
echo "======================================================"
echo ""


# Set the TMP_PATH directory
TMP_PATH=/pipeline/absolute/directory

IN_DIR=$TMP_PATH/00_Data/reference/GRCh38.fna
OUT_DIR=$TMP_PATH/00_Data/bowtie2_index

# Load bowtie2 (bowtie2 must be installed)
module load bowtie2

# Change directory into IN_DIR and begin bowtie2-build process on files in the IN_DIR
cd IN_DIR

bowtie2-build \
$IN_DIR

# Move bowtie2 index files (those ending in .bt2) to OUT_DIR 
mv *.bt2 $OUT_DIR


echo ""
echo "======================================================"
echo "JOB COMPLETE"
echo "End Time   : $(date)"
echo "======================================================"
