#!/bin/bash
#SBATCH --time=12:00:00
#SBATCH --job-name=MultiQC
#SBATCH --partition=Orion
#SBATCH --ntasks-per-node=24
#SBATCH --mem=48GB

########## DESCRIPTION ##########
# Run MultiQC on the entire directory of FASTQC files generated from the previous step. 
# If manually triggering this script, you must wait for FastQC to complete for each of the original FASTQ files. 

echo "======================================================"
echo "Start Time   : $(date)"
echo "Submit Dir   : $SLURM_SUBMIT_DIR"
echo "Job ID/Name  : $SLURM_JOBID / $SLURM_JOB_NAME"
echo "Num Tasks    : $SLURM_NTASKS total [$SLURM_NNODES nodes @ $SLURM_CPUS_ON_NODE CPUs/node]"
echo "======================================================"
echo ""

module load multiqc

#update this if running the pipeline from a different directory
TMP_PATH=/pipeline/absolute/directory

IN_DIR=$TMP_PATH/01_QC/01_FastQC/output_data
OUT_DIR=$TMP_PATH/01_QC/02_MultiQC/output_data

    printf "\n\nStarting MultiQC for original reads\n\n"

    multiqc $IN_DIR -o $OUT_DIR

module unload multiqc

echo ""
echo "======================================================"
echo "End Time   : $(date)"
echo "======================================================"
