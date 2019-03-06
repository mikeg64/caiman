Original caiman distribution including matlab compiled run time version of caimansaasexample.m

Get the caiman matlab runtime distribution from google drive using curl
curl -L "https://drive.google.com/open?id=10fNUbxrI66Ea5vIbH_p-no-_ly92qazE" > caiman-MATLAB_Runtime.tgz

Get the caiman mcr folder
curl -L "https://drive.google.com/open?id=1y3sVCf2Jb18I9rC4UIeXO9bBhLrKQvce" > caimanmcr.tgz
tar -zxvf caimanmcr.tgz


On the target computer, append the following to your LD_LIBRARY_PATH environment variable:  
/home/mike/tools/caiman_MATLAB_Runtime/v95/runtime/glnxa64:/home/mike/tools/caiman_MATLAB_Runtime/v95/bin/glnxa64:/home/mike/tools/caiman_MATLAB_Runtime/v95/sys/os/glnxa64:/home/mike/tools/caiman_MATLAB_Runtime/v95/extern/bin/glnxa64  


If MATLAB Runtime is to be used with MATLAB Production Server, you do not need to modify the above environment variable. 


