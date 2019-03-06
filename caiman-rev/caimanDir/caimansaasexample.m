
%-------- Script that will do all the image processing inside SUILVEN ----------------------------
%--------       1 Reads the images to process (this list has been generated at the unix command line)
%--------       2 Loop over the List of images, compare with the ones that have been processed before
%--------       3 If they are new, then Read the images themselves from the webserver otherwise skip
%--------       4 Select the particular algorithm to run: shading, migration, ...
%--------       5 Email the results to the user
%--------       6 Write a list with the images already processed         
%--------       7 Delete the list of images to process                   

%--------------------------------------------------------------------------------------------------
%   1   set and open IOME settings
%--------------------------------------------------------------------------------------------------

path(path,'../caimanDir')
%open the file generated
%portfile = 'ioserverinfo.txt';                            %add comment if  we are not running standalone
%portfile = 'ioserverinfo.txt';                      %remove comment if  we are not running standalone
portfile                = 'mysim0_port.txt';
fd                      = fopen(portfile);
%res = mfscanf(fd,'%d %d %s')
res                     = textscan(fd,'%d %s');
fclose(fd);
%port                   = res(1) id = res(2) hostname = res(3)
%elist                  = iome(res(3),res(1),res(2));
elist                   = iome('localhost',res{1},0);
%readsimulation('simfile.xml',elist);

setpref('Internet','SMTP_Server','mailhost.shef.ac.uk');
%setpref('Internet','E_mail','m.griffiths@sheffield.ac.uk');
setpref('Internet','E_mail','reyesaldasoro@gmail.com ');


%--------------------------------------------------------------------------------------------------
%   2   get the parameters from the server
%--------------------------------------------------------------------------------------------------

try
    userEmail           = getparamstring('useremail',elist);
    imageFile           = getparamstring('imagefile',elist);
    jobtype             = getparamstring('jobtype',elist);
    outputCode          = jobtype;
    disp(userEmail);
catch
    display('Failed to get parameters from local iome server');
    exitiome(elist);
    exitiome(elist);
    exit();       
end



%--------------------------------------------------------------------------------------------------
% 3 the input file is read from imageFile
%--------------------------------------------------------------------------------------------------

try
    %myftp = ftp('cpaneldev.shef.ac.uk','cs1mkg','*******');
    %cd(myftp,'public_html/iometest/uploads');
    %mget(myftp, imageFile);
    %delete(myftp, imageFile);
    %close(myftp);
    %testData = ulrwrite(imageLocation2,'testData.jpg');
    [dataIn]                            = imread(imageFile);
    [rows,cols,levs]                    = size(dataIn); %#ok<NASGU>
    ImageName                           = imageFile;
catch
    outputCode                          = 'E2';
    disp('error while reading');
end



%--------------------------------------------------------------------------------------------------
% 4 Select the algorithm for processing MI - migration SH - shading PE - permeability VT - Vessel
% Tracing, ME - Merge of RGB Channels
%--------------------------------------------------------------------------------------------------
if ~strcmp(outputCode(1),'E')
        switch outputCode
%             case 'ME'
%                 try
%                     [dataOut,nameFileBlue,nameFileGreen,nameFileRed]    = mergeRGBchannels(newImageName{kk,1}(1:end,1:end,:));
%                 catch
%                     outputCode              = 'EME';
%                 end
            case 'SH'
                try
                    [dataOut]               = shadingCorrection(dataIn(1:end,1:end,:));
                    %outputMessage = 'Shading Correction Completed Successfuly';
                catch
                    outputCode              = 'ESH';
                end
            case 'MI'
                try
                    %dataOut = dataIn;
                    [data_stats,dataOut]    = cellMigration(dataIn(1:1:end,1:1:end,:));
                    %extraData               = data_stats;
                catch
                    outputCode              = 'EMI';
                end
            case 'VT'
                try
                    dataOut = dataIn;
                    %scaleSpaceDims          = 1:10;
                    %[finalRidges,finalStats,networkP,dataOut1,dataOut] =  scaleSpaceLowMem(dataIn,scaleSpaceDims,1.75);
                    %extraData               = networkP;
                catch
                    outputCode              = 'EVT';
                end
            otherwise
                %the case is not covered, generate an error
                outputCode                  = 'E4';
        end
        if ~exist('extraData','var')
            outputMessage       = createOutputMessage(outputCode);
        else
            outputMessage       = createOutputMessage(outputCode,extraData);

        end
        [q1,q2]=urlread('http://caiman.shef.ac.uk/caiman/clearOldFiles.php?idTimeTC=10');
end

%email output to user
if ~strcmp(outputCode(1),'E')
             %prepare the results only if there were no errors on the way
            imageNameOut                   = strcat(ImageName,'.jpg');
            if isa(dataOut,'uint8')
                imwrite(dataOut,imageNameOut,'jpg');

            else
                imwrite(dataOut/255,imageNameOut,'jpg');
            end
            %--------------------------------------------------------------------------------------------------
            % 5 email results to the user
            %--------------------------------------------------------------------------------------------------
            try
                sendmail(userEmail,'Results from Caiman',outputMessage,{imageNameOut});
            catch
                %getpref('Internet')
                outputCode                  = 'E1';
                outputMessage               = createOutputMessage(outputCode);
                sendmail(userEmail,'Results from Caiman',outputMessage);                
            end
            %--------------------------------------------------------------------------------------------------
            % 6 delete image file
            %--------------------------------------------------------------------------------------------------
            delete(imageNameOut);   
else
            outputMessage                   = createOutputMessage(outputCode);
            sendmail(userEmail,'Results from Caiman ',outputMessage);    
end

try
   exitiome(elist);
catch
   display('Unable to close IOME'); 
end

try
    exitiome(elist);
catch
    display('iome server closed!');
end

exit();

