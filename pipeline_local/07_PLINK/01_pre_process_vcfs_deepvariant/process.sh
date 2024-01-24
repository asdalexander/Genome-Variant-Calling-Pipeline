#!/bin/bash
########## SLURM HEADER START ##########
#SBATCH --time=00:30:00
#SBATCH --job-name=processVCFs
#SBATCH --partition=Orion
#SBATCH --ntasks-per-node=16
#SBATCH --mem=36GB
########## SLURM HEADER END ##########

########## DESCRIPTION ##########
# This script automates formatting of variant call files in .vcf format from DeepVariant 
# for use in PLINK2. Additional steps include filtering of called variants to include biallelic-only (a limitation of Plink 1.9 and FUMA),
# MAF of a certain frequency, and more. Be sure to adjust these for your specific use-case. 

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

IN_DIR=$TMP_PATH/06_DeepVariant/output_data
OUT_DIR=$TMP_PATH/07_PLINK/01_pre_process_vcfs_deepvariant/output_data
REF_DIR=$TMP_PATH/00_Data/reference/GRCh38.fna

module load anaconda3
source activate bcftools

# make a text file which shows the path to each available vcf
rm "$OUT_DIR/vcf_list.txt"
ls $IN_DIR/*.vcf.gz >> "$OUT_DIR/vcf_list.txt"


# bcftools merge is used to combine all vcfs
    bcftools merge \
    --threads 16 \
    --output "$OUT_DIR/merged.vcf" \
    --file-list "$OUT_DIR/vcf_list.txt"

# create a vcf with only the genotype retained
    bcftools annotate -x INFO,^FORMAT/GT "$OUT_DIR/merged.vcf" > "$OUT_DIR/genotype.vcf"
    sed -i 's/AOS_/AOS-/g' "$OUT_DIR/genotype.vcf"

conda deactivate bcftools
module unload anaconda3

# generate a genotype-only vcf with biallelic snps only (magma only takes biallelic)
module load vcftools 
    vcftools \
    --vcf "$OUT_DIR/genotype.vcf" \
    --min-alleles 2 \
    --max-alleles 2 \
    --maf 0.01 \
    --recode \
    --recode-INFO-all \
    --out "$OUT_DIR/biallelic_genotype"
module unload vcftools

# more formatting for plink, remove header lines with '##'
sed -i '/^##/ d' "$OUT_DIR/filtered_merged.recode.vcf"
sed -i 's/AOS_/AOS-/g' "$OUT_DIR/filtered_merged.recode.vcf"
