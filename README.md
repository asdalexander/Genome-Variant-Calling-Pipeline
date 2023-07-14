# Variant Calling Pipeline

This variant calling pipeline accepts FASTQ-formatted reads from whole-genome or exome sequencing as input, and will generate quality metrics from sequencing reads, align reads to the human reference genome, perform base quality score recalibration, and call variants for each sample aligned to the reference genome.

## Running the Pipeline in its Current State 
### Downloading and preparing pipeline files 
- All FASTQ-formatted files should be placed in ../00_Data/original_reads. If using paried-end reads, be sure each forward and reverse file are labelled with the suffix "_1" and "_2", respectively. 
- Resource files need to be downloaded using the scripts in corresponding directories, these include:
  - Bowtie2 index files (../00_Data/bowtie2_index/DTN_get_index.sh). An index can be manually created or placed in this directory if using a reference genome different than GRCh38. 
  - GRCh38 human reference genome (../00_Data/reference/DTN_get_reference_genome.sh). A different reference genome can be used by placing the corresponding *.fa file in this directory.

### Running the pipeline
- Pipeline steps should be executed one-at-a-time by running each shell file in order and waiting for the batch of samples to complete before moving to the next step. Each step is indicated by the directory prefix. Subdirectories also follow these prefixes. 
  - For example: ../01_QC/01_FastQC/FastQC.sh is executed, then ../01_QC/02_MultiQC/MultiQC.sh
- A diagram outlining the order in which each shell file should be executed is shown below.
![VarCallPipeline drawio](https://github.com/asdalexander/variant_calling_pipeline/assets/95765425/6c1b2417-03d8-4298-b440-0efe4a043f73)

### Future State
- Certain tasks which do not require human intervention will be automated to run in parallel.
- For example: executing 00_Data, 01_QC, and 02_Trim in parallel, then running 03_Align through 05_BQSR in series as each individual sample is processed, pausing between steps where MultiQC is involved to allow for human review.


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
