________________________________________________________________________________________
________________________________________________________________________________________
________________________________________________________________________________________

The original library prep method used for the Mucositis Exome project was determined 
from documents available in the X: drive. These state that KAPA RT-PCR and NimbleGen v3
were used on an Illumina HiSeq2000 platform. 

UCSC table browser provides the interval lists for these prep methods. Since an exact 
library prep kit cannot be matched to a single kit in the Table Browser; multiple tracks
were merged into one file using the Merge Subtracks option in the table broswer. 

Since the interval list is used to restrict downstream analysis to expressed regions 
of the genome; if there are regions which were not intended to be sequenced with the 
original library prep method, these may show up as mapped in the final variant calls. 

Additionally, since UCSC only shows these library prep kits for hg19 and not GRCh38: a 
liftover was performed to convert the coordinated between the two reference genomes in 
the interval list. These are names hg19_interval_list and GRCh38_interval_list in this 
directory. 

UCSC Table Broswer Settings:
    https://genome.ucsc.edu/cgi-bin/hgTables

    Clade           Mammal
    Genome          Human
    Assembly        Feb 2009 (GRCh37/hg19)
    Group           Mapping and Sequencing
    Track           Exome Probesets
    Table           SeqCap EZ V3 P (SeqCap_EZ_Exome_v3_hg19_capture)
    Region          Genome 

    Subtrack Merge
        edit
            Subset of Subtracks to Merge
            ...select all subsets
            
            Merge Operation
            All SeqCap_EZ_Exome_v3_hg19_capture records, as well as all records from all other selected subtracks

    Output Format   BED - browser extensible data

UCSC Lift Genome Annnotations:
    https://genome.ucsc.edu/cgi-bin/hgLiftOver
    
    Original Genome     Human
    Original Assembly   Feb. 2009 (GRCh37/hg19)
    New Genome          Human
    New Assembly        Dec. 2013 (GRCh38/hg38)

    Input File          hg19_interval_list.bed.gz (unzipped file generated from UCSC Table Browser)

    CONVERSION STATS
    Converted 367770 Records, 376 Failed

    Converion failure file located in this directory.
________________________________________________________________________________________
________________________________________________________________________________________
________________________________________________________________________________________
