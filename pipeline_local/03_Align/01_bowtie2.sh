#!/bin/bash
#SBATCH --time=20:00:00
#SBATCH --job-name=bowtie2
#SBATCH --partition=Orion
#SBATCH --ntasks-per-node=24
#SBATCH --mem=96GB

echo "======================================================"
echo "Start Time  : $(date)"
echo "Submit Dir  : $SLURM_SUBMIT_DIR"
echo "Job ID/Name : $SLURM_JOBID / $SLURM_JOB_NAME"
echo "Num Tasks   : $SLURM_NTASKS total [$SLURM_NNODES nodes @ $SLURM_CPUS_ON_NODE CPUs/node]"
echo "======================================================"
echo ""

module load bowtie2

#update this if running the pipeline from a different directory
TMP_PATH=/nobackup/mougeots_research/adam_alexander/pipeline

IN_DIR=$TMP_PATH/02_Trim/01_output_data
OUT_DIR=$TMP_PATH/03_Align/01_output_data/
REF_DIR=$TMP_PATH/00_Data/bowtie2_index

for each in $IN_DIR/*_R1_001_val_1.fq.gz; do
    in_name=${each#"$IN_DIR/"} 					                    #remove the directory prefix for the forward read file
    rev_name="${in_name/%_R1_001_val_1.fq.gz/_R2_001_val_2.fq.gz}" 	#run sed replace to show bwa the name of the reverse read file
	sample="${in_name/%_R1_001_val_1.fq.gz/}"						#run sed replace to isolate sample name for read group info
    out_name="${in_name/%_R1_001_val_1.fq.gz/.aligned.sam}" 	    #run sed replace to format output file name

	printf "\n\nStarting bowtie2 for $in_name\n\n"

	bowtie2 -p 24 				\
	-x $REF_DIR/GRCh38 			\
	-1 "$IN_DIR/$in_name" 		\
	-2 "$IN_DIR/$rev_name" 		\
	-S "$OUT_DIR/$out_name"
done

module unload bowtie2

echo ""
echo "======================================================"
echo "End Time   : $(date)"
echo "======================================================"

# queue next steps
sbatch $TMP_PATH/03_Align/02_sam_to_bam.sh