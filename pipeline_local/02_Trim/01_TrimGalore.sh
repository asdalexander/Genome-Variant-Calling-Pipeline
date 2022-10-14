#!/bin/bash
#SBATCH --time=24:00:00
#SBATCH --job-name=TrimGalore
#SBATCH --partition=Orion
#SBATCH --ntasks-per-node=16
#SBATCH --mem=96GB

echo "======================================================"
echo "Start Time  : $(date)"
echo "Submit Dir  : $SLURM_SUBMIT_DIR"
echo "Job ID/Name : $SLURM_JOBID / $SLURM_JOB_NAME"
echo "Num Tasks   : $SLURM_NTASKS total [$SLURM_NNODES nodes @ $SLURM_CPUS_ON_NODE CPUs/node]"
echo "======================================================"
echo ""

module load anaconda3
source activate trim_galore

#update this if running the pipeline from a different directory
TMP_PATH=/nobackup/mougeots_research/adam_alexander/pipeline

IN_DIR=$TMP_PATH/00_Data/original_reads
OUT_DIR=$TMP_PATH/02_Trim/01_output_data

for each in $IN_DIR/*_R1_001.fastq.gz;do
    in_name=${each#"$IN_DIR/"} 					                #remove the directory prefix for the forward read file
    rev_name="${in_name/%_R1_001.fastq.gz/_R2_001.fastq.gz}" 	#run sed replace to show trim galore the name of the reverse read file

    printf "\n\nStarting Trim Galore for $in_name\n\n"

	trim_galore \
	--paired \
	--output_dir $OUT_DIR \
	--fastqc \
	--cores 16 \
	"$IN_DIR/$in_name" \
    "$IN_DIR/$rev_name" 
	
done

module unload anaconda3

echo ""
echo "======================================================"
echo "End Time   : $(date)"
echo "======================================================"

# queue next steps
sbatch $TMP_PATH/03_Align/01_bowtie2.sh
sbatch $TMP_PATH/02_Trim/02_MultiQC.sh