#!/bin/bash
########## SLURM HEADER START ##########
#SBATCH --time=20:00:00
#SBATCH --job-name=samtobam
#SBATCH --partition=Orion
#SBATCH --ntasks-per-node=24
#SBATCH --mem=48GB
########## SLURM HEADER END ##########

########## DESCRIPTION ##########
# The SAM file format is expensive with regard to usage of disk space. 
# To allow for quicker downstream processing and to save disk space, 
# this script converts each sample's SAM file format into a BAM file 
# format. 

# The script does not currently automatically delete the existing SAM-formatted file. 


########## SCRIPT START ##########
echo "======================================================"
echo "Start Time  : $(date)"
echo "Submit Dir  : $SLURM_SUBMIT_DIR"
echo "Job ID/Name : $SLURM_JOBID / $SLURM_JOB_NAME"
echo "Num Tasks   : $SLURM_NTASKS total [$SLURM_NNODES nodes @ $SLURM_CPUS_ON_NODE CPUs/node]"
echo "======================================================"
echo ""

module load samtools

#update this if running the pipeline from a different directory
TMP_PATH=/pipeline/absolute/directory

IN_DIR=$TMP_PATH/03_Align/01_output_data/
OUT_DIR=$TMP_PATH/03_Align/02_output_data/

for each in $IN_DIR/*.aligned.sam; do
    in_name=${each#"$IN_DIR/"} 					            #remove the directory prefix for the forward read file
    out_name="${in_name/%.aligned.sam/.aligned.bam}" 	    #run sed replace to format output file name

	printf "\n\nStarting sam to bam for $in_name\n\n"

    samtools view -bS "$IN_DIR/$in_name" > "$OUT_DIR/$out_name"

done

module unload samtools

echo ""
echo "======================================================"
echo "End Time   : $(date)"
echo "======================================================"

# queue next steps
# sbatch $TMP_PATH/04_Sort/01_AddOrReplaceReadGroups.sh
