#!/usr/bin/python

import cgi
import os
import hashlib

DIR = 'renderer/'
JOBSFILE = 'renderer/jobs'
SCDIR = '../shortcode/'

print "Content-Type: text/html"
print

# Create instance of FieldStorage 
form = cgi.FieldStorage() 

# Get data from fields
code = str(form.getvalue('code'))
name = str(form.getvalue('name'))
key = str(form.getvalue('key'))
ini = str(form.getvalue('ini'))
thumbnailini = str(form.getvalue('thumbnailini'))

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

# Make a new pov file for the short code in the render directory,
# also the ini files, and the backup copy of the shortcode
def queue_pov(code, ini, thumbnailini, name):
	for path, content in [(DIR + name + '.pov', code), (SCDIR + name + '.pov', code), (DIR + name + '.ini', ini), (DIR + name + '_thumbnail.ini', thumbnailini)]:
		f = open(path, 'w')
		f.write(content)
		f.close()
	push_file(name + '.pov')
	return path


print "<html><head><title></title></head><body>rendering...<br/>"

if key == hashlib.sha256(name + '#bananas23').hexdigest():
	queue_pov(code, ini, thumbnailini, name)
	filename = name + '.png'
	print "Request received to render image: " + filename + "<br/>"
	print 'View results <a href = "view.py?id=' + name + '">here</a>.'
else:
	print "Request recieved with invalid key.  Denied."

print "</body></html>"


