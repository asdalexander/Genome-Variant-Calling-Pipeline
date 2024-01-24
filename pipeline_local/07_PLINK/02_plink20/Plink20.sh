#!/bin/bash
#SBATCH --time=00:20:00
#SBATCH --job-name=Plink20
#SBATCH --partition=Orion
#SBATCH --ntasks-per-node=12
#SBATCH --mem=36GB

# Update TMP_PATH if running the pipeline from a different directory
TMP_PATH=/projects/mougeots_research/adam_alexander/pipeline

# Update to change PLINK output file prefix
OUT_NAME=caseLEUKEMIAyOM24_controlOTHER_DeepVariant
PHENO_NAME=case_LEUKEMIA_subsetOM

VCF_IN_DIR=$TMP_PATH/07_PLINK/01_pre_process_vcfs_deepvariant/output_data/biallelic_genotype.recode.vcf
OUT_DIR=$TMP_PATH/07_PLINK/02_plink20/caseLEUKEMIAyOM24_controlOTHER_DeepVariant
UPDATE_SEX=$TMP_PATH/07_PLINK/phenotypes/update_sex
PHENOTYPES=$TMP_PATH/07_PLINK/phenotypes/phenotypes_leukOM24_OM01

# Print SLURM job info
echo "======================================================"
echo "Start Time  : $(date)"
echo "Submit Dir  : $SLURM_SUBMIT_DIR"
echo "Job ID/Name : $SLURM_JOBID / $SLURM_JOB_NAME"
echo "Num Tasks   : $SLURM_NTASKS total [$SLURM_NNODES nodes @ $SLURM_CPUS_ON_NODE CPUs/node]"
echo "======================================================"
echo ""

module load plink/2.00

# PLINK convert VCF to PLINK binary files
plink2 \
--vcf $VCF_IN_DIR               `# INPUT:   Merged VCF` \
--double-id                     `# OPTION:  Sync FID and IID, necc. for interop betwn Plink 1.9-2.0` \
--make-pgen                     `# OUTPUT:  Plink2 binary files` \
--allow-extra-chr               `# OPTION:  Allow alternate chromosome names` \
--update-sex $UPDATE_SEX        `# INPUT:   Update plink binary files to include sex` \
--pheno $PHENOTYPES             `# INPUT:   Phenotype file` \
--pheno-name $PHENO_NAME        `# FILTER:  Which phenotypes are included` \
--keep $PHENOTYPES \
--chr 1-22                      `# FILTER:  Restrict analysis to autosomes only` \
--maf 0.01 \
--out $OUT_DIR/"$OUT_NAME"

# PLINK run logistic association without covariates
plink2                          \
--pfile $OUT_DIR/$OUT_NAME      \
--double-id                     \
--chr 1-22                      \
--glm allow-no-covars           \
--ci 0.95                       \
--pfilter 1                     \
--adjust                        \
--make-bed                      \
--out $OUT_DIR/$OUT_NAME
