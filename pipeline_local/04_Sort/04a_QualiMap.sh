#!/bin/bash
########## SLURM HEADER START ##########
#SBATCH --time=24:00:00
#SBATCH --job-name=QualiMap
#SBATCH --partition=Orion
#SBATCH --ntasks-per-node=8
#SBATCH --mem=96GB
########## SLURM HEADER END ##########

########## DESCRIPTION ##########
# 04_Sort contains a series of five scripts which perform GATK-recommended steps to further process 
# reads before variant calling. 
# QualiMap generates a series of informative quality control information on how well reads were mapped to 
# the reference genome. These reports can then be used in MultiQC to generate summary-level stats across
# a population of samples. 

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

QMAP=#path/to/QualiMap/installation (ex: $TMP_PATH/tools/qualimap_v2.2.1/qualimap)
IN_DIR=$TMP_PATH/04_Sort/03_output_data
OUT_DIR=$TMP_PATH/04_Sort/04a_output_data

for each in $IN_DIR/*.fixed_tags.bam; do 

    in_name=${each#"$IN_DIR/"} #remove the directory prefix for the before file
    out_name="${in_name/%.fixed_tags.bam/_quality}" #rename file with new filename attributes

    printf "\n\nStarting QualiMap for $in_name\n\n"

    $QMAP \
    bamqc -bam "$IN_DIR/$in_name" \
    -outdir "$OUT_DIR/$out_name"

done

echo ""
echo "======================================================"
echo "End Time   : $(date)"
echo "======================================================"

# queue next steps
# sbatch $TMP_PATH/04_Sort/04b_MultiQC.sh
