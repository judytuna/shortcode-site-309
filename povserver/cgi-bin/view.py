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
name = str(form.getvalue('name'))

thumbpath = '../thumbnails/' + name + '.png'
imgpath = '../images/' + name + '.png'
outputpath = '../outputs/' + name + '.pov.output'
thumboutputpath = '../thumbnail_outputs/' + name + '.pov.output'

def readfile(path):
	s = ''
	try:
		f = open(path, 'r')
		s = f.read()
		f.close()
	except:
		s = 'file failed to open'
	return s

print '<h2>Thumbnail</h2>'
print '<img src = "' + thumbpath + '"/><br/><br/>'
print '<h2>Image</h2>'
print '<img src = "' + imgpath + '"/><br/><br/>'

print '<h2>Thumbnail Command Line Output</h2>'
print '<textarea rows=30 cols=80>'
print readfile(thumboutputpath)
print '</textarea>'

print '<h2>Image Command Line Output</h2>'
print '<textarea rows=30 cols=80>'
print readfile(outputpath)
print '</textarea>'


