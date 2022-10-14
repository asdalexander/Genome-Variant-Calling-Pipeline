#!/bin/bash
#SBATCH --time=18:00:00
#SBATCH --job-name=SetNmMdAndUqTags
#SBATCH --partition=Orion
#SBATCH --ntasks-per-node=36
#SBATCH --mem=96GB

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
IN_DIR=$TMP_PATH/04_Sort/02_output_data
OUT_DIR=$TMP_PATH/04_Sort/03_output_data
REF_DIR=$TMP_PATH/00_Data/reference/GRCh38.fna

module load anaconda3
source activate gatk

for each in $IN_DIR/*.rm_dups.bam; do 

    in_name=${each#"$IN_DIR/"} #remove the directory prefix for the before file
    out_name="${in_name/%.rm_dups.bam/.fixed_tags.bam}" #rename file with new filename attributes

    printf "\n\nStarting SetNmMdAndUqTags for $in_name\n\n"

    $GATK SetNmMdAndUqTags \
    -R $REF_DIR \
    -I "$IN_DIR/$in_name" \
    -O "$OUT_DIR/$out_name"
done

module unload anaconda3

echo ""
echo "======================================================"
echo "End Time   : $(date)"
echo "======================================================"

# queue next steps
sbatch $TMP_PATH/05_BQSR/01_BaseRecalibrator_1.sh
sbatch $TMP_PATH/04_Sort/04_QualiMap.sh