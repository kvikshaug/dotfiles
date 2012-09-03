#!/usr/bin/python
# coding: utf-8
import os, time, subprocess

sleeptime = 5 # seconds

# Hardcode
subprocess.call(["xsetbg", "-border", "black", "-center", "/home/murray/.bg/img/creative-flame.png"])

# Iterate
#i = 0
#while True:
#  files = os.listdir("/home/murray/.bg/img/")
#  if(i >= len(files)):
#    i = 0
#  subprocess.call(["xsetbg", "/home/murray/.bg/img/" + files[i]])
#  i += 1
#  time.sleep(sleeptime)

