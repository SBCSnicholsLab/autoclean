

# Goes through paired FQ files and and writes out every record except is number
# is contained in <number file>

# USAGE python drop.py <left FQ> <right FQ> <number file>

import sys

lfile = open(sys.argv[1], 'r')
rfile = open(sys.argv[2], 'r')

nfile = open(sys.argv[3], 'r')

lout = open(sys.argv[1] + '_dropped.fq', 'w')
rout = open(sys.argv[2] + '_dropped.fq', 'w')

c = 0

drop = int(nfile.readline()[:-1])

while True:

	l0 = lfile.readline()

	if l0 == '': break 	#EOF

	if drop == c :		#if the record number is in drop file
		lfile.readline()
		lfile.readline()
		lfile.readline()

		rfile.readline()
		rfile.readline()
		rfile.readline()
		rfile.readline()

		drop_read = nfile.readline()

		if drop_read == '':
			drop = 0
		else:
			drop = int(drop_read[:-1])

	else:			#what normally happens
		
		lout.write(l0)
		lout.write(lfile.readline())
		lout.write(lfile.readline())
		lout.write(lfile.readline())

		rout.write(rfile.readline())
		rout.write(rfile.readline())
		rout.write(rfile.readline())
		rout.write(rfile.readline())
	
	c += 1
