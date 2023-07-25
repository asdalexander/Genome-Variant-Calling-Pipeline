#!/bin/bash
########## SLURM HEADER START ##########
#SBATCH --time=02:00:00
#SBATCH --job-name=DeepVariant
#SBATCH --partition=Orion
#SBATCH --ntasks-per-node=18
#SBATCH --mem=24GB
########## SLURM HEADER END ##########

########## DESCRIPTION ##########
# This script uses Google's DeepVariant to call variants in SAM/BAM files against the reference genome. 
# This pipeline is configured to use either HaplotypeCaller or DeepVariant.

# For this variant caller, DeepVariant is confifured in a container using Singularity, 
# which operates similarly to Docker and was created for use in high performance and cluster computing environments. 

########## SCRIPT START ##########
echo "======================================================"
echo "Start Time  : $(date)"
echo "Submit Dir  : $SLURM_SUBMIT_DIR"
echo "Job ID/Name : $SLURM_JOBID / $SLURM_JOB_NAME"
echo "Num Tasks   : $SLURM_NTASKS total [$SLURM_NNODES nodes @ $SLURM_CPUS_ON_NODE CPUs/node]"
echo "======================================================"
echo ""

# Before running! 
# Pull deepvariant into container folder on the interactive node with: 
#   singularity pull docker://google/deepvariant
#   Must use interactive node, not slurm script (UNCC Sep 2022)

# Dir structure:
#   ~/DeepVariant
#       /output_data
#       /singularity-containers
#           /temp_dir
#           /cache_dir

# Load singularity to run DeepVariant Docker container
module load singularity

# Update this if running the pipeline from a different directory
TMP_PATH=/nobackup/mougeots_research/adam_alexander/pipeline

# Set IN, OUT, and REF dirs
IN_DIR=$TMP_PATH/04_Sort/02_output_data
OUT_DIR=$TMP_PATH/06_DeepVariant/output_data
REF_DIR=$TMP_PATH/00_Data/reference/GRCh38.fna

# Set singularity-specific directories, these will be used to bind
#   the container dirs to local dirs
SINGULARITY_CONTAINER_HOME=$TMP_PATH/06_DeepVariant/singularity-containers/deepvariant.sif
TEMP_DIR=$TMP_PATH/06_DeepVariant/singularity-containers/temp_dir
CACHE_DIR=$TMP_PATH/06_DeepVariant/singularity-containers/cache_dir

# Run the for loop over each file, I tried to run this for parallel samples but
#   kept receiving fatal interruptions with inconsistent errors
for each in $IN_DIR/C28*.rm_dups.bam; do 
    
    # Parse filenames
    in_name=${each#"$IN_DIR/"} 				#remove the directory prefix from the file
    out_name="${in_name/%.rm_dups.bam/}" 	#run sed replace to format output file name
    sample_name="${in_name/%.rm_dups.bam/}" #run sed replace to isolate sample name

    # Print job information to slurm-###.out    
    start_time=$(date)
    printf "\nStarting $SLURM_JOB_NAME for $sample_name at $start_time\n\n"

    # Make sample-specific temporary and cachedir for container binding
    mkdir "$TEMP_DIR/tempdir_$sample_name"
    TEMP_SAMPLE_DIR="$TEMP_DIR/tempdir_$sample_name"
    mkdir "$CACHE_DIR/cachedir_$sample_name"
    CACHE_SAMPLE_DIR="$CACHE_DIR/cachedir_$sample_name"

    # Run DeepVariant with Singularity
    singularity run \
    --bind /usr/lib/locale/:/usr/lib/locale/ \
    --bind $SINGULARITY_CACHEDIR:$CACHE_SAMPLE_DIR \
    --bind /tmp:$TEMP_SAMPLE_DIR \
    docker://google/deepvariant \
    /opt/deepvariant/bin/run_deepvariant \
    --model_type=WES \
    --ref="$REF_DIR" \
    --reads="$IN_DIR/$in_name" \
    --output_vcf="$OUT_DIR/$out_name".vcf.gz \
    --output_gvcf="$OUT_DIR/$out_name".g.vcf.gz \
    --intermediate_results_dir $TEMP_SAMPLE_DIR \
    --num_shards=$SLURM_CPUS_ON_NODE

    # Remove the file-specific temp and cache dirs
    rm -r $TEMP_SAMPLE_DIR
    rm -r $CACHE_SAMPLE_DIR

    # Print job information to slurm-###.out
    end_time=$(date)
    printf "\nFinished $SLURM_JOB_NAME for $sample_name at $end_time\n"
    printf "\nRuntime: $start_time - $end_time\n\n"
done

# Unload module
module unload singularity
