#!/bin/bash
########## SLURM HEADER START ##########
#SBATCH --time=18:00:00
#SBATCH --job-name=FastQC
#SBATCH --partition=Orion
#SBATCH --ntasks-per-node=12
#SBATCH --mem=12GB
########## SLURM HEADER END ##########

########## DESCRIPTION ##########
# Run FastQC on each of the original FASTQ reads.

########## SCRIPT START ##########
echo "======================================================"
echo "Start Time  : $(date)"
echo "Submit Dir  : $SLURM_SUBMIT_DIR"
echo "Job ID/Name : $SLURM_JOBID / $SLURM_JOB_NAME"
echo "Num Tasks   : $SLURM_NTASKS total [$SLURM_NNODES nodes @ $SLURM_CPUS_ON_NODE CPUs/node]"
echo "======================================================"
echo ""

module load fastqc

#update this if running the pipeline from a different directory
TMP_PATH=/pipeline/absolute/directory

IN_DIR=$TMP_PATH/00_Data/original_reads
OUT_DIR=$TMP_PATH/01_QC/01_FastQC/output_data

for each in $IN_DIR/*.fastq.gz;do
    in_name=${each#"$IN_DIR/"}          #remove the directory prefix for the before file
    out_name="${in_name/%.in/.out}" 	#run sed replace for the after file

    printf "\n\nStarting FastQC for $in_name\n\n"
	fastqc $each -o $OUT_DIR/
done

module unload fastqc

echo ""
echo "======================================================"
echo "End Time   : $(date)"
echo "======================================================"

# queue next steps
# sbatch $TMP_PATH/02_Trim/01_TrimGalore.sh
# sbatch $TMP_PATH/01_QC/02_MultiQC/MultiQC.sh
