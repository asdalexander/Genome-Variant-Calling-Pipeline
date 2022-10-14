#!/bin/bash
#SBATCH --time=20:00:00
#SBATCH --job-name=AddOrReplaceReadGroups
#SBATCH --partition=Orion
#SBATCH --ntasks-per-node=36
#SBATCH --mem=98GB

echo "======================================================"
echo "Start Time  : $(date)"
echo "Submit Dir  : $SLURM_SUBMIT_DIR"
echo "Job ID/Name : $SLURM_JOBID / $SLURM_JOB_NAME"
echo "Num Tasks   : $SLURM_NTASKS total [$SLURM_NNODES nodes @ $SLURM_CPUS_ON_NODE CPUs/node]"
echo "======================================================"
echo ""

#update this if running the pipeline from a different directory
TMP_PATH=/nobackup/mougeots_research/adam_alexander/pipeline

GATK=/nobackup/mougeots_research/adam_alexander/tools/gatk/gatk-4.2.6.1/gatk
IN_DIR=$TMP_PATH/03_Align/02_output_data
OUT_DIR=$TMP_PATH/04_Sort/01_output_data
REF_DIR=$TMP_PATH/00_Data/reference/GRCh38.fna

module load anaconda3
source activate gatk

for each in $IN_DIR/*.bam; do 

    in_name=${each#"$IN_DIR/"} #remove the directory prefix for the before file
    out_name="${in_name/%.aligned.bam/.added_rg.bam}" #rename file with new filename attributes
    sample_name="${in_name/%.aligned.bam/}" #rename file with new filename attributes

    printf "\n\nAddOrReplaceReadGroups for $in_name\n\n"

    $GATK AddOrReplaceReadGroups \
       -I "$IN_DIR/$in_name" \
       -O "$OUT_DIR/$out_name" \
       -ID $sample_name \
       -LB $sample_name \
       -PL "ILLUMINA" \
       -PU $sample_name \
       -SM $sample_name
done

module unload anaconda3

echo ""
echo "======================================================"
echo "End Time   : $(date)"
echo "======================================================"

# queue next steps
sbatch $TMP_PATH/04_Sort/02_MarkDuplicatesSpark.sh