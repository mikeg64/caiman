#!/bin/sh
#$ -cwd
#$ -l h_rt=01:00:00

/usr/local/bin/matlab -nodesktop -nosplash -nodisplay < matlabSelectRoutine.m > caimanResultsF


