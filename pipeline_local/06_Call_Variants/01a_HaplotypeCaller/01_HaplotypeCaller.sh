#!/bin/bash
########## SLURM HEADER START ##########
#SBATCH --time=12:00:00
#SBATCH --job-name=HaplotypeCaller
#SBATCH --partition=Orion
#SBATCH --ntasks-per-node=12
#SBATCH --mem=24GB
########## SLURM HEADER END ##########

########## DESCRIPTION ##########
# This script uses HaplotypeCaller to call variants in SAM/BAM files against the reference genome. 
# This pipeline is configured to use either HaplotypeCaller or DeepVariant.

########## SCRIPT START ##########
echo "======================================================"
echo "Start Time  : $(date)"
echo "Submit Dir  : $SLURM_SUBMIT_DIR"
echo "Job ID/Name : $SLURM_JOBID / $SLURM_JOB_NAME"
echo "Num Tasks   : $SLURM_NTASKS total [$SLURM_NNODES nodes @ $SLURM_CPUS_ON_NODE CPUs/node]"
echo "======================================================"
echo ""

module load anaconda3
source activate gatk

#update this if running the pipeline from a different directory
TMP_PATH=/pipeline/absolute/directory

GATK=#path/to/GATK/installation (ex: $TMP_PATH/tools/gatk/gatk-4.2.6.1/gatk)
IN_DIR=$TMP_PATH/05_BQSR/02_output_data
OUT_DIR=$TMP_PATH/06_Call_Variants/01_output_data
REF_DIR=$TMP_PATH/00_Data/reference/GRCh38.fna

for each in $IN_DIR/*.recalibrated.bam; do 
    in_name=${each#"$IN_DIR/"} 					            #remove the directory prefix for the forward read file
    out_name="${in_name/%.recalibrated.bam/.vcf.gz}" 	    #run sed replace to format output file name

    printf "\n\nStarting HaplotypeCaller for $in_name\n\n"

    $GATK HaplotypeCaller \
    -I "$IN_DIR/$in_name" \
    -R $REF_DIR \
    -O "$OUT_DIR/$out_name"
    
done

module unload anaconda3
