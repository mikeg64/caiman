#!/bin/bash
#$ -l h_rt=01:00:00
# following line required to initialise modules correctly
#otherwise need to hardcode matlab execution line
source /usr/share/Modules/init/bash
echo $0 'is the command'
module load apps/matlab/2013a

IOME_SIMNAME="mysim"
iogs initiome null $IOME_SIMNAME null  &
sleep 10
IOME_WSPORT=`cat ${IOME_SIMNAME}0_port.txt`
echo port is $IOME_WSPORT
iogs readsimulation simfile.xml 0 $IOME_WSPORT localhost
IMFILE=`iogs getparam string imagefile 0 $IOME_WSPORT localhost`

echo $IMFILE > "jobid.out"
JOBID=`cut -c 1-10 jobid.out`
rm jobid.out
 
#echo "s/%imagefile%/$IMFILE/" > sed.in
echo "Processing file $IMFILE at `date`" > imfile.log
echo `which matlab` >> imfile.log
echo $LD_LIBRARY_PATH >> imfile.log
echo $PATH >> imfile.log

#matlab -nosplash -nodisplay  < caimansaasexample.m 
matlab -nosplash -nodisplay  -r caimansaasexample 
#/usr/local/packages5/matlab_r2009a/bin/matlab -nosplash -nodisplay  -r caimansaasexample

#cp imfile.log ../testresults/
#cp *.e* ../testresults/
#cp *.o* ../testresults/

#copy result archive to fastdata
#will be deleted after 90 days
mkdir /fastdata/cs6cai/caiman/$JOBID
cp -r * /fastdata/cs6cai/caiman/$JOBID/.
cp -r *.* /fastdata/cs6cai/caiman/$JOBID/.


