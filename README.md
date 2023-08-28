# Variant Calling Pipeline

This Variant Calling pipeline is a comprehensive tool that processes FASTQ-formatted reads from either whole-genome or exome sequencing. Its functionality includes the production of quality control (QC) metrics from sequencing reads, alignment of reads to the human reference genome, execution of base quality score recalibration, and variant calling from aligned reads. 

## Running the Pipeline
This section outlines how to prepare the pipeline files and execute the pipeline.

### File Preparation
1. Place all FASTQ-formatted files in `../00_Data/original_reads` directory.
   - For paired-end reads, each forward and reverse file should have a suffix "_1" and "_2", respectively.
 
2. Download the necessary resource files using the scripts in the respective directories:
   - Download Bowtie2 index files (or manually create/place an index if using a different reference genome than GRCh38) at `../00_Data/bowtie2_index/DTN_get_index.sh`.
   
   - Download GRCh38 human reference genome (or use a different reference genome by placing the related *.fa file) at `../00_Data/reference/DTN_get_reference_genome.sh`.

### Execution
The pipeline should be executed sequentially, with each shell file being run in the specified order. It is necessary that each batch of samples completes before progressing to the next step. The respective sequence is denoted by the directory prefix, which is also reflected in respective subdirectories.

For instance, the first step would be to execute `../01_QC/01_FastQC/FastQC.sh`, then move on to `../01_QC/02_MultiQC/MultiQC.sh`.

Refer to the diagram below to understand the execution order of each shell file:

![VarCallPipeline drawio (1)](https://github.com/asdalexander/genome_variant_calling_pipeline/assets/95765425/4261af83-7fc5-4fa9-a6f1-45ddd95f958f)

### Project Enhancements
In future iterations of this pipeline, we aim to automate certain tasks that do not require manual intervention, allowing them to run concurrently. For instance, the execution of `00_Data`, `01_QC`, and `02_Trim` could then take place in parallel, followed by a serial execution of `03_Align` through `05_BQSR` as each individual sample is processed. Pauses will be implemented as needed, particularly in between steps that necessitate MultiQC for human review. Moreover, upon the completion of QualiMap for the entire batch, R-based analyses and charts will be generated to scrutinize potential batch effects in the population. 

## Tools and References
This project employed the following tools:
**FastQC**: Andrews, S. (2010). FastQC:  A Quality Control Tool for High Throughput Sequence Data [Online]. Available online at: http://www.bioinformatics.babraham.ac.uk/projects/fastqc/​

**MultiQC**: MultiQC: Summarize analysis results for multiple tools and samples in a single report Philip Ewels, Måns Magnusson, Sverker Lundin and Max Käller Bioinformatics (2016) doi: 10.1093/bioinformatics/btw354 PMID: 27312411​

**TrimGalore**: MARTIN, Marcel. Cutadapt removes adapter sequences from high-throughput sequencing reads. EMBnet.journal, [S.l.], v. 17, n. 1, p. pp. 10-12, may 2011. ISSN 2226-6089. Available at: <https://journal.embnet.org/index.php/embnetjournal/article/view/200>. Date accessed: 11 may 2023. doi:https://doi.org/10.14806/ej.17.1.200.

**Bowtie 2**: Langmead B, Salzberg S. Fast gapped-read alignment with Bowtie 2. Nature Methods. 2012, 9:357-359.​

**GATK Tools**: Van der Auwera GA & O'Connor BD. (2020). Genomics in the Cloud: Using Docker, GATK, and WDL in Terra (1st Edition). O'Reilly Media. ​

**DeepVariant**: A universal SNP and small-indel variant caller using deep neural networks. Nature Biotechnology 36, 983–987 (2018). Ryan Poplin, Pi-Chuan Chang, David Alexander, Scott Schwartz, Thomas Colthurst, Alexander Ku, Dan Newburger, Jojo Dijamco, Nam Nguyen, Pegah T. Afshar, Sam S. Gross, Lizzie Dorfman, Cory Y. McLean, and Mark A. DePristo. doi: https://doi.org/10.1038/nbt.4235​

**VCFTools**: The Variant Call Format and VCFtools, Petr Danecek, Adam Auton, Goncalo Abecasis, Cornelis A. Albers, Eric Banks, Mark A. DePristo, Robert Handsaker, Gerton Lunter, Gabor Marth, Stephen T. Sherry, Gilean McVean, Richard Durbin and 1000 Genomes Project Analysis Group, Bioinformatics, 2011​

**PLINK 2**: Chang CC, Chow CC, Tellier LCAM, Vattikuti S, Purcell SM, Lee JJ (2015) Second-generation PLINK: rising to the challenge of larger and richer datasets. GigaScience, 4.​

**FUMA Suite**: K. Watanabe, E. Taskesen, A. van Bochoven and D. Posthuma. Functional mapping and annotation of genetic associations with FUMA. Nat. Commun. 8:1826. (2017).​
