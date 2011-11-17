#!/usr/bin/python

import cgi
import random
import time
import os

DIR = 'renderer/'
JOBSFILE = 'renderer/jobs'


print "Content-Type: text/html"
print

# Create instance of FieldStorage 
form = cgi.FieldStorage() 

# Get data from fields
code = str(form.getvalue('code'))


def push_file(path):
	f = open(JOBSFILE, 'r')
	s = f.read()
	f.close()
	f = open(JOBSFILE, 'w')
	s = s.strip()
	if s:
		s += '\n'
	f.write( s + path + '\n' )
	f.close()


def exists(path):
	try:
		f = open(path, 'r')
		f.close()
	except:
		return False
	return True


def random_path():
	s = ''
	for i in range(0, 9):
		s += str(random.randint(0, 9))
	return s + '.pov', s


def unique_path():
	path, number = random_path()
	while exists(path):
		path = random_path()
	return path, number


def queue_pov(code):
	path, number = unique_path()
	outpath = DIR + path
	f = open(outpath, 'w')
	f.write(code)
	f.close()
	push_file(path)
	return path, number


outpath, number = queue_pov(code)
filename = outpath.replace('.pov', '.png')
path = '../images/' + filename

print "<html><head><title></title></head><body>rendering...<br/>"
print "An image called " + filename + "<br/>"
print 'View results <a href = "view.py?id=' + number + '">here</a>.'

print "</body></html>"


