#!/bin/bash
#SBATCH --time=00:20:00
#SBATCH --job-name=Plink20
#SBATCH --partition=Orion
#SBATCH --ntasks-per-node=12
#SBATCH --mem=36GB

#update this if running the pipeline from a different directory
TMP_PATH=/nobackup/mougeots_research/adam_alexander/pipeline

DEEPVARIANT_IN_DIR=$TMP_PATH/07_PLINK/01_pre_process_vcfs_deepvariant/output_data/biallelic_genotype.recode.vcf
HAPLOTYPE_IN_DIR=$TMP_PATH/07_PLINK/01_pre_process_vcfs_haplotype/output_data/biallelic_genotype.recode.vcf
OUT_DIR=$TMP_PATH/07_PLINK/02_plink20/output_data

UPDATE_SEX=$TMP_PATH/07_PLINK/phenotypes/update_sex
PHENOTYPES=$TMP_PATH/07_PLINK/phenotypes/phenotypes


echo "======================================================"
echo "Start Time  : $(date)"
echo "Submit Dir  : $SLURM_SUBMIT_DIR"
echo "Job ID/Name : $SLURM_JOBID / $SLURM_JOB_NAME"
echo "Num Tasks   : $SLURM_NTASKS total [$SLURM_NNODES nodes @ $SLURM_CPUS_ON_NODE CPUs/node]"
echo "======================================================"
echo ""

module load plink/2.00

# Purge existing files from output dir
rm $OUT_DIR/* 

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Plink vcf to binary (deepvariant)
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
plink2 \
--vcf $DEEPVARIANT_IN_DIR       `# INPUT:   Merged VCF` \
--double-id                     `# OPTION:  Sync FID and IID, necc. for interop betwn Plink 1.9-2.0` \
--make-pgen                     `# OUTPUT:  Plink2 binary files` \
--allow-extra-chr               `# OPTION:  Allow alternate chromosome names` \
--update-sex $UPDATE_SEX        `# INPUT:   Update plink binary files to include sex` \
--pheno $PHENOTYPES             `# INPUT:   Phenotype file` \
--pheno-name OM_24              `# FILTER:  Which phenotypes are included` \
--chr 1-22                      `# FILTER:  Restrict analysis to autosomes only` \
--pca meanimpute                `# OUTPUT:  PCA stats, meanimpute solves for high genotype missingness` \
--out $OUT_DIR/deepvariant

# Plink logistic association with covariates (deepvariant)
plink2                          \
--pfile $OUT_DIR/deepvariant    `# INPUT:   Plink binary files generated above` \
--double-id                     `# OPTION:  Sync FID and IID, necc. for interop betwn Plink 1.9-2.0` \
--chr 1-22                      `# FILTER:  Restrict analysis to autosomes only` \
--covar $PHENOTYPES             \
--covar-name Myeloablative      \
--glm                           `# OUTPUT:  Linear/Logistic regression, association analysis (wo Prin. Comps. as covars)` \
--ci 0.95                       `# OPTION:  Output confidence interval with assoc file` \
--pfilter 1                     `# FILTER:  Remove 'NA' p-values` \
--adjust                        `# OUTPUT:  Adjusted correction stats for multiple testing` \
--make-bed                      \
--out $OUT_DIR/deepvariant_withCovars

# Create an input file for SNP2GENE
awk '{print $1 " " $2 " " $10 " " $15}' \
"$OUT_DIR/deepvariant_withCovars.OM_24.glm.logistic.hybrid" >\
"$OUT_DIR/deepvariant_wCovars.logit"

# Create an input file for Query Kaviar
awk '{print $1 " " $2}' \
"$OUT_DIR/deepvariant_withCovars.OM_24.glm.logistic.hybrid" >\
"$OUT_DIR/deepvariant_wCovars.dbsnpRef"


# Plink logistic association without covariates (deepvariant)
plink2                          \
--pfile $OUT_DIR/deepvariant    \
--double-id                     \
--chr 1-22                      \
--glm allow-no-covars           \
--ci 0.95                       \
--pfilter 1                     \
--adjust                        \
--make-bed                      \
--out $OUT_DIR/deepvariant_noCovars

# Create an input file for SNP2GENE
awk '{print $1 " " $2 " " $10 " " $15}' \
"$OUT_DIR/deepvariant_noCovars.OM_24.glm.logistic.hybrid" >\
"$OUT_DIR/deepvariant_noCovars.logit"

# Create an input file for Query Kaviar
awk '{print $1 " " $2}' \
"$OUT_DIR/deepvariant_noCovars.OM_24.glm.logistic.hybrid" >\
"$OUT_DIR/deepvariant_noCovars.dbsnpRef"


# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Plink vcf to binary (haplotypecaller)
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
plink2                      \
--vcf $HAPLOTYPE_IN_DIR     \
--double-id                 \
--make-pgen                 \
--allow-extra-chr           \
--update-sex $UPDATE_SEX    \
--pheno $PHENOTYPES         \
--pheno-name OM_24          \
--chr 1-22                  \
--pca meanimpute            \
--out $OUT_DIR/haplotype

# Plink logistic association with covariates (haplotypecaller)
plink2                      \
--pfile $OUT_DIR/haplotype  \
--double-id                 \
--chr 1-22                  \
--covar $PHENOTYPES         \
--covar-name Myeloablative  \
--glm                       \
--ci 0.95                   \
--pfilter 1                 \
--adjust                    \
--make-bed                  \
--out $OUT_DIR/haplotype_withCovars

# Create an input file for SNP2GENE
awk '{print $1 " " $2 " " $10 " " $15}' \
"$OUT_DIR/haplotype_withCovars.OM_24.glm.logistic.hybrid" >\
"$OUT_DIR/haplotype_wCovars.logit"

# Create an input file for Query Kaviar
awk '{print $1 " " $2}' \
"$OUT_DIR/haplotype_withCovars.OM_24.glm.logistic.hybrid" >\
"$OUT_DIR/haplotype_wCovars.dbsnpRef"


# Plink logistic association without covariates (haplotypecaller)
plink2                      \
--pfile $OUT_DIR/haplotype  \
--double-id                 \
--chr 1-22                  \
--glm allow-no-covars       \
--ci 0.95                   \
--pfilter 1                 \
--adjust                    \
--make-bed                  \
--out $OUT_DIR/haplotype_noCovars

# Create an input file for SNP2GENE
awk '{print $1 " " $2 " " $10 " " $15}' \
"$OUT_DIR/haplotype_noCovars.OM_24.glm.logistic.hybrid" >\
"$OUT_DIR/haplotype_noCovars.logit"

# Create an input file for Query Kaviar
awk '{print $1 " " $2}' \
"$OUT_DIR/haplotype_noCovars.OM_24.glm.logistic.hybrid" >\
"$OUT_DIR/haplotype_noCovars.dbsnpRef"

