# autoclean
Is a set of scripts to clean raw NGS data. This was used to clean v2 NextSeq data showing a messed up GC distribution (which turned out to be due to Truseq adapter contaminations). It takes FASTQ and outputs FASTQ.

**USAGE** ./filtering.sh \<left-hand FASTQ\> \<right-hand FASTQ\> \<BLAST db\>

## Current workflow:

**Quaility filering** is done by sub script ```filter_pair_fastq20.py```. Only read pairs with phred quality over 20 at over 90% of bases will be kept. Also, read length need to be 151nt.

**Conversion to FASTA** is done by ```fastq2a_enum.py```. Both FASTQ files will be converted to FASTA with a running number preceding the original read names. The files will be concatenated.

**BLASTn against contaminants** is using a blast library to be specified when running the main script (not included).

**Extraction from BLAST output** is done with ```cut``` to get the first column of the BLASTn output (which contains the FASTA names' running numbers). Numbers are then sorted and duplicates removed.

**Filtering the FASTQ files** done with subscript ```drop.py``` which goes through the FASTQs and write every record (counting) to a new file dropping the numbers of lines that correspond to BLAST hits.

**Deletion of temp files.**



## Dependencies

* BLAST+
* ```cut```, ```sort```, and ```uniq``` (UNIX tools)
* python2 with Biopython
