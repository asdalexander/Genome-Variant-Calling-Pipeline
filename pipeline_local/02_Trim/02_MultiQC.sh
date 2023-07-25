#!/bin/bash
########## SLURM HEADER START ##########
#SBATCH --time=2:00:00
#SBATCH --job-name=MultiQC
#SBATCH --partition=Orion
#SBATCH --ntasks-per-node=1
#SBATCH --mem=8GB
########## SLURM HEADER END ##########

########## DESCRIPTION ##########
# Run MultiQC on each of the trimmed FASTQ reads.
# Output can be used to compare quality of reads between 
# trimming of adapter sequences and low-quality reads.

########## SCRIPT START ##########
echo "======================================================"
echo "Start Time  : $(date)"
echo "Submit Dir  : $SLURM_SUBMIT_DIR"
echo "Job ID/Name : $SLURM_JOBID / $SLURM_JOB_NAME"
echo "Num Tasks   : $SLURM_NTASKS total [$SLURM_NNODES nodes @ $SLURM_CPUS_ON_NODE CPUs/node]"
echo "======================================================"
echo ""

module load multiqc

#update this if running the pipeline from a different directory
TMP_PATH=/pipeline/absolute/directory

IN_DIR=$TMP_PATH/02_Trim/01_output_data
OUT_DIR=$TMP_PATH/02_Trim/02_output_data/output_data

    printf "\n\nStarting MultiQC for original reads.\n\n"

    multiqc $IN_DIR -o $OUT_DIR

module unload multiqc
