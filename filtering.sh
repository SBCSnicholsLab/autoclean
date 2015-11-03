#!/bin/bash

# takes two FQ files and a blast library
# quality-filters, then blasts agains library and removes hit reads

# USAGE: ./filtering.sh <left FQ> <right FQ> <BLAST db>

if [ $# -ne 3 ]
then
	echo 'Wrong number of arguments supplied.'
	echo 'USAGE: ./filtering.sh <left FQ> <right FQ> <BLAST db>'
	exit
fi

# left and right hand reads (FASTQ)
LFILE=$1
RFILE=$2

# contaminations (FASTA)
CONTAM=$3



# the scripts are in:
SCRIPTS=bin/

echo "Running filtering on $LFILE and $RFILE using contaminations \
listed in the BLAST library $CONTAM"

echo "Running \"filter_pair_fastq20.py\""

date +%y%m%d_%H%M%S > ${LFILE}.log
echo 'Running "filter_pair_fastq20.py"' >> ${LFILE}.log

python ${SCRIPTS}filter_pair_fastq20.py $LFILE $RFILE

echo "Converting to FASTA and enumerating"
date +%y%m%d_%H%M%S >> ${LFILE}.log
echo "Converting to FASTA and enumerating" >> ${LFILE}.log
echo "Left hand file"
python ${SCRIPTS}fastq2a_enum.py ${LFILE}_filtered20l.fq
echo "Right hand file"
python ${SCRIPTS}fastq2a_enum.py ${LFILE}_filtered20r.fq

echo "Concatenating enumerated FASTAs"

cat ${LFILE}_filtered20l.fq_enum.fa ${LFILE}_filtered20r.fq_enum.fa > ${LFILE}_conc.fa



echo "BLASTing for contaminations in $CONTAM"
date +%y%m%d_%H%M%S >> ${LFILE}.log
echo "BLASTing for contaminations in $CONTAM" >> ${LFILE}.log

blastn -db $CONTAM -query ${LFILE}_conc.fa -outfmt 6 -out ${LFILE}_conc.bln -num_alignments 1


echo "Extracting hit reads, sorting, removing duplicates"
date +%y%m%d_%H%M%S >> ${LFILE}.log
echo "Extracting hit reads, sorting, removing duplicates" >> ${LFILE}.log

cut -d '_' -f 1 ${LFILE}_conc.bln | sort -n | uniq > ${LFILE}_remove

date +%y%m%d_%H%M%S >> ${LFILE}.log
echo "Going through quality-filtered FQs and dropping lines with BLAST hits" >> ${LFILE}.log
echo "Going through quality-filtered FQs and dropping lines with BLAST hits"

python ${SCRIPTS}drop.py ${LFILE}_filtered20l.fq ${LFILE}_filtered20r.fq ${LFILE}_remove

date +%y%m%d_%H%M%S >> ${LFILE}.log
echo "Removing temporary files" >> ${LFILE}.log
echo "Removing temporary files"

rm ${LFILE}_filtered20r.fq ${LFILE}_filtered20l.fq ${LFILE}_filtered20l.fq_enum.fa \
${LFILE}_filtered20r.fq_enum.fa ${LFILE}_conc.fa ${LFILE}_conc.bln ${LFILE}_remove

date +%y%m%d_%H%M%S >> ${LFILE}.log
echo "Done." >> ${LFILE}.log
echo "Done."


exit 0


