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


print "<html><head><title></title></head>"
print "<body> something in the body"
print "</body></html>"


