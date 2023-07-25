#!/bin/bash
########## SLURM HEADER START ##########
#SBATCH --time=20:00:00
#SBATCH --job-name=MQC-QualiMap
#SBATCH --partition=Orion
#SBATCH --ntasks-per-node=18
#SBATCH --mem=36GB
########## SLURM HEADER END ##########

########## DESCRIPTION ##########
# 04_Sort contains a series of five scripts which perform GATK-recommended steps to further process 
# reads before variant calling. 
# MultiQC generates summary-level stats across the QC reports of a population of samples. 

########## SCRIPT START ##########
echo "======================================================"
echo "Start Time  : $(date)"
echo "Submit Dir  : $SLURM_SUBMIT_DIR"
echo "Job ID/Name : $SLURM_JOBID / $SLURM_JOB_NAME"
echo "Num Tasks   : $SLURM_NTASKS total [$SLURM_NNODES nodes @ $SLURM_CPUS_ON_NODE CPUs/node]"
echo "======================================================"
echo ""

#update this if running the pipeline from a different directory
TMP_PATH=/pipeline/absolute/directory

IN_DIR=$TMP_PATH/04_Sort/04a_output_data
OUT_DIR=$TMP_PATH/04_Sort/04b_output_data

module load multiqc

    printf "\n\nStarting MultiQC for QualiMap Results\n\n"
    multiqc $IN_DIR -o $OUT_DIR

module unload multiqc
