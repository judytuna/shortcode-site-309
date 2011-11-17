#!/usr/bin/python

import cgi
import random
import time
import os

DIR = 'renderer/'
JOBSFILE = 'renderer/jobs'

print "Content-Type: text/plain"
print

# Create instance of FieldStorage 
form = cgi.FieldStorage() 

# Get data from fields
name = str(form.getvalue('name'))

thumbpath = '../thumbnails/' + name + '.png'
imgpath = '../images/' + name + '.png'
thumboutputpath = '../thumbnail_outputs/' + name + '.pov.output'
outputpath = '../outputs/' + name + '.pov.output'

def file_exists(path):
        try:
                f = open(path, 'r')
                f.close()
        except:
                return False
        return True

thumb_status = 'no output'
img_status = 'no output'

if file_exists(thumboutputpath):
	thumb_status = 'thumbnail parsing'

if file_exists(thumbpath):
	thumb_status = 'thumbnail ready'

if file_exists(outputpath):
	img_status = 'image parsing'

if file_exists(imgpath):
	img_status = 'image ready'

print thumb_status
print img_status

