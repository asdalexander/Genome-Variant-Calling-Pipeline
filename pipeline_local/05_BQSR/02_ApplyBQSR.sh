#!/bin/bash
########## SLURM HEADER START ##########
#SBATCH --time=20:00:00
#SBATCH --job-name=ApplyBQSR
#SBATCH --partition=Orion
#SBATCH --ntasks-per-node=24
#SBATCH --mem=48GB
########## SLURM HEADER END ##########

########## DESCRIPTION ##########
# 05_BQSR contains a series of four scripts which perform a GATK-recommended process known as
# "Base Quality Score Recalibration" 

# ApplyBQSR applies the table generated from the previous step, and generates a "recalibrated" SAM/BAM file with
# the recalibrated quality data added. 

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

GATK=#path/to/GATK/installation (ex: $TMP_PATH/tools/gatk/gatk-4.2.6.1/gatk)
IN_DIR=$TMP_PATH/04_Sort/03_output_data
OUT_DIR=$TMP_PATH/05_BQSR/02_output_data
TABLE_DIR=$TMP_PATH/05_BQSR/01_output_data
REF_DIR=$TMP_PATH/00_Data/reference/GRCh38.fna

module load anaconda3
source activate gatk

for each in $IN_DIR/*.fixed_tags.bam; do 
    in_name=${each#"$IN_DIR/"}                                  #remove the directory prefix for the forward read file
    out_name="${in_name/%.fixed_tags.bam/.recalibrated.bam}" 	#run sed replace to format output file name
    table_name="${in_name/%.fixed_tags.bam/.recal_1.table}"     #run sed replace to locate the recal table

    printf "\n\nStarting ApplyBQSR for $in_name\n\n"

    $GATK ApplyBQSR \
    -R $REF_DIR \
    -I "$IN_DIR/$in_name" \
    --bqsr-recal-file "$TABLE_DIR/$table_name" \
    -O "$OUT_DIR/$out_name"
done

module unload anaconda3

echo ""
echo "======================================================"
echo "End Time   : $(date)"
echo "======================================================"

# queue next steps
# sbatch $TMP_PATH/06_Call_Variants/01_HaplotypeCaller.sh
# sbatch $TMP_PATH/05_BQSR/03_BaseRecalibrator_2.sh
