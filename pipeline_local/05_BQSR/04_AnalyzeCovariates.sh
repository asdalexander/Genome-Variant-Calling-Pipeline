#!/bin/bash
########## SLURM HEADER START ##########
#SBATCH --time=24:00:00
#SBATCH --job-name=analyzecovar
#SBATCH --partition=Orion
#SBATCH --ntasks-per-node=16
#SBATCH --mem=32GB
########## SLURM HEADER END ##########

########## DESCRIPTION ##########
# 05_BQSR contains a series of four scripts which perform a GATK-recommended process known as
# "Base Quality Score Recalibration" 

# AnalyzeCovariates generates a QC report using both the before and after sets of recalibration data.

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
BEFORE_DIR=$TMP_PATH/05_BQSR/01_output_data
AFTER_DIR=$TMP_PATH/05_BQSR/03_output_data
OUT_DIR=$TMP_PATH/05_BQSR/04_output_data
REF_DIR=$TMP_PATH/00_Data/reference/GRCh38.fna

module load anaconda3
source activate gatk

for each in $BEFORE_DIR/*.recal_1.table; do 
    before_name=${each#"$BEFORE_DIR/"}                          #remove the directory prefix for the before file
    after_name="${before_name/%.recal_1.table/.recal_2.table}"  #remove the directory prefix, and run sed replace for the after file
    output_name="${before_name/%.recal_1.table/.recal_stats}"   #clean up the file name for the output csv

    printf "\n\nStarting AnalyzeCovariates for $before_name\n\n"

    $GATK AnalyzeCovariates \
    -before "$BEFORE_DIR/$before_name" \
    -after "$AFTER_DIR/$after_name" \
    -csv "$OUT_DIR/$output_name.csv" \
    -plots "$OUT_DIR/$output_name.pdf"
done

module unload anaconda3
