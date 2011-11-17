#!/usr/bin/python

JOBSFILE = 'jobs'

import random
import time
import os


def file_exists(path):
	try:
		f = open(path, 'r')
		f.close()
	except:
		return False
	return True

def pop_file():
	f = open(JOBSFILE, 'r')
	l = f.readlines()
	f.close()
	
	path = ''
	if len(l) > 0:
		path = l[0]
		path = path.strip()
	
	f = open(JOBSFILE, 'w')
	f.write(''.join(l[1:]))
	f.close()
	
	return path

def do_command(command):
	print command
	os.system(command)

def default_output(path):
	f = open(path, 'w')
	f.write("Image will render shortly.")
	f.close()

def loop():
        start_time = time.time()
	while time.time() - start_time < 3660.0: # an hour and one minute
		path = pop_file()
		if path:
			if not os.fork():
				thumbnail_opt = path.replace('.pov', '_thumbnail.ini')
				opt = path.replace('.pov', '.ini')
				
				if not file_exists(thumbnail_opt):
					thumbnail_opt = '+H150 +W200'
				
				if not file_exists(opt):
					opt = '+H600 +W800'
				
				thumbnail_output_path = '../../thumbnail_outputs/' + path + '.output'
				output_path = '../../outputs/' + path + '.output'
				
				default_output(thumbnail_output_path)
				default_output(output_path)
				
				do_command('povray ' + thumbnail_opt + ' +O../../thumbnails/ ' + path + ' 2> ' + thumbnail_output_path)
				do_command('povray ' + opt + ' +O../../images/ ' + path + ' 2> ' + output_path)
				do_command('rm -f ' + path)
				break
		time.sleep(1)


loop()


