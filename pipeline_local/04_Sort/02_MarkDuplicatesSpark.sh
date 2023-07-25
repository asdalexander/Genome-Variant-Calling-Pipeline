#!/bin/bash
########## SLURM HEADER START ##########
#SBATCH --time=20:00:00
#SBATCH --job-name=MarkDuplicatesSpark
#SBATCH --partition=Orion
#SBATCH --ntasks-per-node=24
#SBATCH --mem=48GB
########## SLURM HEADER END ##########

########## DESCRIPTION ##########
# 04_Sort contains a series of five scripts which perform GATK-recommended steps to further process 
# reads before variant calling. 
# MarkDuplicatesSpark identifies duplicates within the reads and marks them for exclusion in
# downstream analysis. The Spark implementation of this tool additionally performs coordinate-sorting
# and significant improvements in processing speed. 

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
IN_DIR=$TMP_PATH/04_Sort/01_output_data
OUT_DIR=$TMP_PATH/04_Sort/02_output_data
REF_DIR=$TMP_PATH/00_Data/reference/GRCh38.fna

module load anaconda3
source activate gatk

for each in $IN_DIR/*.added_rg.bam; do 

    in_name=${each#"$IN_DIR/"} #remove the directory prefix for the before file
    out_name="${in_name/%.added_rg.bam/.rm_dups.bam}" #rename file with new filename attributes
    #metrics_name="${in_name/%.added_rg.bam/.libraryComplexity.txt}" #rename file with new filename attributes


    printf "\n\nStarting MarkDuplicatesSpark for $in_name\n\n"

    $GATK MarkDuplicatesSpark \
    -I "$IN_DIR/$in_name" \
    -O "$OUT_DIR/$out_name" 
    #-M "$OUT_DIR/$metrics_name"
done

module unload anaconda3

echo ""
echo "======================================================"
echo "End Time   : $(date)"
echo "======================================================"

# queue next steps
# sbatch $TMP_PATH/04_Sort/03_SetNmMdAndUqTags.sh
