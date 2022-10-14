#!/bin/bash
#SBATCH --time=20:00:00
#SBATCH --job-name=BaseRecalibrator
#SBATCH --partition=Orion
#SBATCH --ntasks-per-node=8
#SBATCH --mem=48GB

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
IN_DIR=$TMP_PATH/05_BQSR/02_output_data
OUT_DIR=$TMP_PATH/05_BQSR/03_output_data
REF_DIR=$TMP_PATH/00_Data/reference/GRCh38.fna

module load anaconda3
source activate gatk

for each in $IN_DIR/*.recalibrated.bam; do 
    in_name=${each#"$IN_DIR/"} 					                    #remove the directory prefix for the forward read file
    out_name="${in_name/%.recalibrated.bam/.recal_2.table}" 	    #run sed replace to format output file name

    printf "\n\nStarting Secondary BaseRecalibrator for $file_name\n\n"

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
#sbatch $TMP_PATH/05_BQSR/04_AnalyzeCovariates.sh