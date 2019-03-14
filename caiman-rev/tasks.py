# -*- coding: utf-8 -*-
"""
Created on Fri Feb 22 03:01:04 2019

@author: mike
"""
#see comments on celery1.py
from celery import Celery
import os
import time
import subprocess

#app = Celery('tasks', broker='pyamqp://guest@localhost//')  #rabbitmq
app = Celery('tasks', broker='redis://localhost:6379/0')   #redis

@app.task
def runjob():
    print("running job")
    status=job()
    return status


def job():
  
                   #for system processes use subprocess
                   #https://docs.python.org/3.7/library/subprocess.html
                   
                   #for os commands use os module
                   #https://docs.python.org/3.7/library/os.html
                   
                    workingdir=str(time.clock())
    
                    #chdir(m_workingdir);
                    os.mkdir(workingdir)  

			   		#mkdir(jobdir.c_str(),0755);
					#sprintf(command,"cp -p iogenericsim.sh %s/iogenericsim.sh",jobdir.c_str());
                    command="cp -p iogenericsim.sh "+workingdir+"/iogenericsim.sh"
                    subprocess.run([command], shell=True)
					#system(command);
                    #sprintf(command,"cp -p simfile.xml %s/simfile.xml",jobdir.c_str());
                    command="cp -p simfile.xml "+workingdir+"/simfile.xml"
                    subprocess.run([command], shell=True)

					#system(command);
			   		#chdir(jobdir.c_str());
                    os.chdir(workingdir)
                    command="chmod a+x iogenericsim.sh"
			   		#system("chmod a+x iogenericsim.sh");
                    subprocess.run([command], shell=True)
    
                    #system("./iogenericsim.sh");
                    subprocess.run(["./iogenericsim.sh"], shell=True)
    
    
                    os.chdir("..")
    
                 	  # string sdelcommand="/bin/rm -rf ";
			   	  #sdelcommand.append(jobdir);
			   	  #chdir(m_workingdir);		   					   	  
			   	  #system(sdelcommand.c_str());
                    return 0
