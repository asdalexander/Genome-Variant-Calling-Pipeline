#!/bin/bash
########## SLURM HEADER START ##########
#SBATCH --time=20:00:00
#SBATCH --job-name=BaseRecalibrator
#SBATCH --partition=Orion
#SBATCH --ntasks-per-node=24
#SBATCH --mem=48GB
########## SLURM HEADER END ##########

########## DESCRIPTION ##########
# 05_BQSR contains a series of four scripts which perform a GATK-recommended process known as
# "Base Quality Score Recalibration" 

# This series of steps adds an adjusted quality score based on predicted quality error added into the 
# sequencing data by different sequencing machines.
# For BQSR, only quality score information is needed. To see all effects BQSR corrects for, see 
# GATK4 documentation on the process. 

# BaseRecalibrator takes coordinate-sorted SAM/BAM files and generates a recalibration table 
# to be used in downstream BQSR steps. No recaliration is performed yet. 


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
OUT_DIR=$TMP_PATH/05_BQSR/01_output_data
REF_DIR=$TMP_PATH/00_Data/reference/GRCh38.fna

module load anaconda3
source activate gatk

IN_DIR=$TMP_PATH/04_Sort/03_output_data

for each in $IN_DIR/*.fixed_tags.bam; do 
    in_name=${each#"$IN_DIR/"} 					            #remove the directory prefix for the forward read file
    out_name="${in_name/%.fixed_tags.bam/.recal_1.table}" 	    #run sed replace to format output file name

    printf "\n\nStarting Primary BaseRecalibrator for $in_name\n\n"

    $GATK BaseRecalibrator \
    -I "$IN_DIR/$in_name" \
    -R $REF_DIR \
    --known-sites $TMP_PATH/00_Data/known_sites/1000G_omni2.5.hg38.vcf.gz \
    --known-sites $TMP_PATH/00_Data/known_sites/Homo_sapiens_assembly38.dbsnp138.vcf \
    --known-sites $TMP_PATH/00_Data/known_sites/hapmap_3.3.hg38.vcf.gz \
    --known-sites $TMP_PATH/00_Data/known_sites/Homo_sapiens_assembly38.known_indels.vcf.gz \
    --known-sites $TMP_PATH/00_Data/known_sites/Mills_and_1000G_gold_standard.indels.hg38.vcf.gz \
    -O "$OUT_DIR/$out_name" 
    #-L /nobackup/mougeots_research/adam_alexander/aos_test/00_data/target_intervals/GRCh38_interval_liftover.bed \

done

module unload anaconda3

echo ""
echo "======================================================"
echo "End Time   : $(date)"
echo "======================================================"

# queue next steps
# sbatch $TMP_PATH/05_BQSR/02_ApplyBQSR.sh
