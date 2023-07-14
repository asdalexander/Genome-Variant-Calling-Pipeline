# Variant Calling Pipeline

This variant calling pipeline was assembled for use in a research setting in order to process FASTQ-formatted reads from exome sequencing, and call variants against the GRCh38 human reference genome.

## Running the Pipeline in its Current State 
- FASTQ-formatted files are placed in ../00_Data/original_reads
- Resource files are downloaded using the scripts in corresponding directories, these include:
  - Bowtie2 index files (../00_Data/bowtie2_index/DTN_get_index.sh)
  - GRCh38 human reference genome (../00_Data/reference/DTN_get_reference_genome.sh)
- Pipeline steps should be executed one-at-a-time by running each shell file in order and waiting for the batch of samples to complete before moving to the next step. Each step is indicated by the directory prefix. Subdirectories also follow these prefixes. 
  - For example: ../01_QC/01_FastQC/FastQC.sh is executed, then ../01_QC/02_MultiQC/MultiQC.sh

## Future State
- Ideally this will be automated so that eligible tasks that can be run in parallel. A diagram of this state is shown below. 


## Tools Used and Sources
#### FastQC:
Andrews, S. (2010). FastQC:  A Quality Control Tool for High Throughput Sequence Data [Online]. Available online at: http://www.bioinformatics.babraham.ac.uk/projects/fastqc/​

#### MultiQC:
MultiQC: Summarize analysis results for multiple tools and samples in a single report Philip Ewels, Måns Magnusson, Sverker Lundin and Max Käller Bioinformatics (2016) doi: 10.1093/bioinformatics/btw354 PMID: 27312411​

#### TrimGalore
MARTIN, Marcel. Cutadapt removes adapter sequences from high-throughput sequencing reads. EMBnet.journal, [S.l.], v. 17, n. 1, p. pp. 10-12, may 2011. ISSN 2226-6089. Available at: <https://journal.embnet.org/index.php/embnetjournal/article/view/200>. Date accessed: 11 may 2023. doi:https://doi.org/10.14806/ej.17.1.200.

#### Bowtie 2:
Langmead B, Salzberg S. Fast gapped-read alignment with Bowtie 2. Nature Methods. 2012, 9:357-359.​

#### GATK Tools:
Van der Auwera GA & O'Connor BD. (2020). Genomics in the Cloud: Using Docker, GATK, and WDL in Terra (1st Edition). O'Reilly Media. ​

#### DeepVariant:
A universal SNP and small-indel variant caller using deep neural networks. Nature Biotechnology 36, 983–987 (2018). Ryan Poplin, Pi-Chuan Chang, David Alexander, Scott Schwartz, Thomas Colthurst, Alexander Ku, Dan Newburger, Jojo Dijamco, Nam Nguyen, Pegah T. Afshar, Sam S. Gross, Lizzie Dorfman, Cory Y. McLean, and Mark A. DePristo. doi: https://doi.org/10.1038/nbt.4235​

#### VCFTools:
The Variant Call Format and VCFtools, Petr Danecek, Adam Auton, Goncalo Abecasis, Cornelis A. Albers, Eric Banks, Mark A. DePristo, Robert Handsaker, Gerton Lunter, Gabor Marth, Stephen T. Sherry, Gilean McVean, Richard Durbin and 1000 Genomes Project Analysis Group, Bioinformatics, 2011​

#### PLINK 2:
Chang CC, Chow CC, Tellier LCAM, Vattikuti S, Purcell SM, Lee JJ (2015) Second-generation PLINK: rising to the challenge of larger and richer datasets. GigaScience, 4.​

#### FUMA Suite:
K. Watanabe, E. Taskesen, A. van Bochoven and D. Posthuma. Functional mapping and annotation of genetic associations with FUMA. Nat. Commun. 8:1826. (2017).​

#### Mucositis Pathobiology
Sonis ST. The pathobiology of mucositis. Nat Rev Cancer. 2004 Apr;4(4):277-84. doi: 10.1038/nrc1318. PMID: 15057287.
