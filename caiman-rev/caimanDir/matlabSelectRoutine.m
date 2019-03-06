
%-------- Script that will do all the processing inside ICEBERG ----------------------------
%--------       1 Reads the images to process (this list has been generated at the unix command line)
%--------       2 Loop over the List of images, compare with the ones that have been processed before
%--------       3 If they are new, then Read the images themselves from the webserver otherwise skip
%--------       4 Select the particular algorithm to run: shading, migration, ...
%--------       5 Email the results to the user
%--------       6 Write a list with the images already processed         
%--------       7 Delete the list of images to process                   

%--------------------------------------------------------------------------------------------------
%   1   read the text file where the names of the files stored in the web directory have been saved
%--------------------------------------------------------------------------------------------------

%%
  clear;
newImagesList                               = textread('imagesToProcess.txt','%s','delimiter', '\n');
%oldImagesList                               = textread('imagesProcessed.txt','%s','delimiter', '\n');
numImages                                   = size(newImagesList,1);
%       if there are any names inside the list proceed to analyse the names and if there are any suitable images, load

%%
for kk=1:numImages

%%
    %  remove extra characters from the names
    initStr                                 = strfind(newImagesList{kk,1},'a href=');
    if isempty(initStr)
        initStr                             = strfind(newImagesList{kk,1},'A HREF=');
    end
    finStr                                  = strfind(newImagesList{kk,1}(initStr(1)+8:end),'">');
    %this selects the actual name of the image (with postcript of the caiman webpage)
    newImageName{kk,1}                      = newImagesList{kk}(initStr(1)+8:initStr(1)+6+finStr); %#ok<AGROW>
    if strcmp(newImageName{kk,1}(1:2),'./')
        newImageName{kk,1}                  = newImageName{kk,1}(3:end); %#ok<AGROW>
    end
    initDate                                = strfind(newImagesList{kk,1},'</a>');
    if isempty(initDate)
        initDate                            = strfind(newImagesList{kk,1},'</A>');
    end
    dateString                              = newImagesList{kk}(initDate+5:end);
    %remove white spaces from start and end of the date
    while strcmp(dateString(1),' ')
        dateString                          = dateString(2:end);
    end
    while strcmp(dateString(end),' ')
        dateString                          = dateString(1:end-1);
    end
    nameOfFile                              = newImageName{kk,1};
    nameOfUser                              = strcat(newImageName{kk,1}(1:end-9),'userEmail');
    nameAndDate                             = strcat(nameOfFile,dateString);
    %disp(nameAndDate)
%%
    %--------------------------------------------------------------------------------------------------
    % 2 compare the current image with the list of RGB images already processed do not enter cycle
    %--------------------------------------------------------------------------------------------------
    doNotEnterCycle = 0;
    
    if exist('nameFileBlue','var')
        if strcmp(nameOfFile,nameFileBlue(15:end))
            doNotEnterCycle = 1;
        end        
    end
    if exist('nameFileGreen','var')
        if strcmp(nameOfFile,nameFileGreen(15:end))
            doNotEnterCycle = 1;
        end        
    end
    if exist('nameFileRed','var')
        if strcmp(nameOfFile,nameFileRed(15:end))
            doNotEnterCycle = 1;
        end        
    end
    
    if (doNotEnterCycle==0)


        %--------------------------------------------------------------------------------------------------
        % the new name is contained inside newImageName
        %--------------------------------------------------------------------------------------------------

        %read email from file with similar name
        newImagesList3                          = strcat('http://carlos-reyes.staff.shef.ac.uk/caiman/imageUploads/',newImageName{kk,1}(1:end-9),'userEmail');
        try
            %set the internet preferences and get the email of the user
            setpref('Internet','SMTP_Server','mailhost.shef.ac.uk')
            setpref('Internet','E_mail','c.reyes@sheffield.ac.uk')
            lastDot                             = strfind(newImageName{kk,1}(1:end-14),'.');
            [userEmail,errs]                    = urlread(newImagesList3);
            disp(userEmail)
        catch
            outputCode                          = 'E3';
        end
        %--------------------------------------------------------------------------------------------------
        % 3 the new name is contained inside newImageName
        %--------------------------------------------------------------------------------------------------

        imageLocation                           = strcat('http://carlos-reyes.staff.shef.ac.uk/caiman/imageUploads/',newImageName{kk,1});
        outputCode = newImageName{kk,1}(end-1:end);
        try
            %testData = ulrwrite(imageLocation2,'testData.jpg');
            [dataIn]                            = imread(imageLocation);
            [rows,cols,levs]                    = size(dataIn);
            ImageName                           = newImageName{kk,1}(lastDot(end)+1:end-14);
            disp(ImageName);
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
                    case 'ME'
                        try
                            [dataOut,nameFileBlue,nameFileGreen,nameFileRed]    = mergeRGBchannels(newImageName{kk,1}(1:end,1:end,:));
                        catch
                            outputCode              = 'EME';
                        end
                    case 'SH'
                        try
                            [dataOut]               = shadingCorrection(dataIn(1:end,1:end,:));
                        catch
                            outputCode              = 'ESH';
                        end
                    case 'MI'
                        try
                            [data_stats,dataOut]    = cellMigration(dataIn(1:1:end,1:1:end,:));
                            extraData               = data_stats;
                        catch
                            outputCode              = 'EMI';
                        end
                    case 'VT'
                        try
                            scaleSpaceDims          = 1:10;
                            [finalRidges,finalStats,networkP,dataOut1,dataOut] =  scaleSpaceLowMem(dataIn,scaleSpaceDims,1.75);
                            extraData               = networkP;
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
        end
        %--------------------------------------------------------------------------------------------------
        % 3.1 once that image(s) and email have been read and processed, delete the files on the server
        %--------------------------------------------------------------------------------------------------

        [q1,q2]=urlread(strcat('http://carlos-reyes.staff.shef.ac.uk/caiman/clearOldFiles.php?idFileTC=',nameOfFile)); %#ok<NASGU>
        [q1,q2]=urlread(strcat('http://carlos-reyes.staff.shef.ac.uk/caiman/clearOldFiles.php?idFileTC=',nameOfUser));

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
                outputCode              = 'E1';
                outputMessage       = createOutputMessage(outputCode);
                sendmail(userEmail,'Results from Caiman',outputMessage);                
            end
            %--------------------------------------------------------------------------------------------------
            % 6 delete image file
            %--------------------------------------------------------------------------------------------------
            delete(imageNameOut);
        else
            %there was an error somewhere on the way, delete all files that are more than 10 minutes old
            [q1,q2]=urlread('http://carlos-reyes.staff.shef.ac.uk/caiman/clearOldFiles.php?idTimeTC=10'); %#ok<NASGU>
        end               
    end
   
%%    
end
%%
%--------------------------------------------------------------------------------------------------
% 7 delete the file of the images to process once all have been considered
%--------------------------------------------------------------------------------------------------

delete('imagesToProcess.txt')
