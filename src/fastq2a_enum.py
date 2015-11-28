

import sys

inhandle = open(sys.argv[1], 'r')
outhandle = open(sys.argv[1] + '_enum.fa', 'w')

c = 0

while True:

	line = inhandle.readline()

	if line == '': break

	outhandle.write('>%d_' % (c) + line)
	outhandle.write(inhandle.readline())
	inhandle.readline()
	inhandle.readline()

	c += 1

print 'Done.'

	
	
	
