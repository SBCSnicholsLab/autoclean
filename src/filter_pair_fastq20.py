import time
import sys
from Bio import SeqIO
from Bio.SeqUtils import GC

left  = SeqIO.parse(sys.argv[1], 'fastq')
right  = SeqIO.parse(sys.argv[2], 'fastq')

outl   = open(sys.argv[1]+'_filtered20l.fq', 'w')		#adjust name/format
outr   = open(sys.argv[1]+'_filtered20r.fq', 'w')		#adjust name/format
count = 0
htcount = 0

t0 = time.time()

while True:

	if count == 100000:
		count = 0
		htcount += 1
		print "%d pairs written, %d sec." % (htcount*100000, time.time()-t0)
	try:
		lrecord=left.next()
	except StopIteration:
		break

	rrecord=right.next()

	ll=len(lrecord)
	
	if ll==151:					#adjust read length
		lc=0	
		for i in range(ll):
			if lrecord.letter_annotations['phred_quality'][i]<20: #adjust quality
				lc+=1
	
		if lc<=15:
			if GC(lrecord.seq) < 95:
				rl=len(rrecord)
				if rl==151:
					rc=0
					for i in range(rl):
						if rrecord.letter_annotations['phred_quality'][i]<20:
							rc+=1
					if rc<=15:
						if GC(rrecord.seq) < 95:				
							SeqIO.write(lrecord, outl, 'fastq') #adjust output format
							SeqIO.write(rrecord, outr, 'fastq') #adjust output format
							count += 1
outl.close()
outr.close()

print "%d pairs writiien on total. %d seconds." % (htcount*100000 + count, time.time()-t0)
