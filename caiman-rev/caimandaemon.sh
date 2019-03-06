#!/bin/bash
#
# This is a script that will 
#     1 - read the content from a given web directory,
#     2 - scan for a pattern on the file names to verify that new files have been added to the web dir
#     3 - save the files that match to a text file, and 
#     4 - call a specific matlab script that will identify the appropriate subroutine and the Image it has to be applied to. 
#     5 - Once the matlab finishes, and writes to the webdirectory the results, the text file is deleted, and so the images (remotely)

COUNTER=0

while [ $COUNTER -lt 300 ]; do

  # read the remote directory in a webserver (no authentication) and write to a file
   lwp-request  http://carlos-reyes.staff.shef.ac.uk/caiman/imageUploads/ | grep "\.caiman\." > caimanDir/imagesToProcess.txt
   chmod 666 caimanDir/imagesToProcess.txt

  # read the remote directory in a webserver (use authentication) and write to a file
  # lwp-request -C getFromIceberg:caiman2009UL http://carlos-reyes.staff.shef.ac.uk/caiman/imageUploads/ | grep "\.caiman\." > caimanDir/imagesToProcess.txt
  # chmod 666 caimanDir/imagesToProcess/.txt
  # scan the file for a specific pattern with grep (as the file can be not found, incorrect password,...) 
  # and if a file name is found, call matlab otherwise sleep

   if  grep "\.caiman\."  caimanDir/imagesToProcess.txt
 
   then 
     cd caimanDir
     echo "Not Empty"

     # this line submits the matlab job as a batch process to the engine
     #   time="01:00:00"
     qsub mymatlabjob.sh 
     #   qsub  -l h_cpu=$time  /usr/local/bin/matlab -nodesktop -nosplash -nodisplay < matlabSelectRoutine.m
     #  rm matlabjob.*
     # When the matlab routine is finished, it will delete imagesToProcess, therefore, check if it is still there
     X=0
     while [ $X -eq 0 ]
     do
         #echo $X
         sleep 15
         if test -f  imagesToProcess.txt
         then
              #echo $X
              X=0
         else
              X=1
              #echo $X
         fi
     done

     cd ..
   else
     echo "Empty"
   fi
  # wait a little to re-start the process (and let files be uploaded at the server)
  sleep 120
  # increment the counter
  echo The counter is $COUNTER
  let COUNTER=COUNTER+1 

done
