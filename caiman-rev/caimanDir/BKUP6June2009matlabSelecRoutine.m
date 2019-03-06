
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
    % 2 compare the current image with the list of stored images
    %--------------------------------------------------------------------------------------------------
    %if ~any(cell2mat(strfind(oldImagesList,nameAndDate)))


        %--------------------------------------------------------------------------------------------------
        % the new name is contained inside newImageName
        %--------------------------------------------------------------------------------------------------

        %read email from file with similar name
        newImagesList3                       = strcat('http://carlos-reyes.staff.shef.ac.uk/caiman/imageUploads/',newImageName{kk,1}(1:end-9),'userEmail');
        try
            %set the internet preferences and get the email of the user
            setpref('Internet','SMTP_Server','mailhost.shef.ac.uk')
            setpref('Internet','E_mail','c.reyes@sheffield.ac.uk')
            lastDot                            = strfind(newImageName{kk,1}(1:end-14),'.');
            [userEmail,errs]                   = urlread(newImagesList3);

            %disp(errs)

            disp(userEmail)
            try
                %--------------------------------------------------------------------------------------------------
                % 3 the new name is contained inside newImageName
                %--------------------------------------------------------------------------------------------------

                imageLocation                  = strcat('http://carlos-reyes.staff.shef.ac.uk/caiman/imageUploads/',newImageName{kk,1});
                imageLocation2                 = 'http://carlos-reyes.staff.shef.ac.uk/caiman/imageUploads/6Image2.jpg';
                %disp(imageLocation);
                try
                    %testData = ulrwrite(imageLocation2,'testData.jpg');
                    [dataIn]                     = imread(imageLocation);
                catch
                    disp('error while reading');
                end
                [rows,cols,levs]                = size(dataIn);
                %[dataIn,s2]                     = imread(strcat('http://carlos-reyes.staff.shef.ac.uk/caiman/imageUploads/',newImageName{kk,1}));
                ImageName                       = newImageName{kk,1}(lastDot(end)+1:end-14);
                disp(ImageName);
                %disp(newImageName{kk,1}(end-1:end))
                %--------------------------------------------------------------------------------------------------
                % 3.1 once that image and email have been read, delete the files on the server
                %--------------------------------------------------------------------------------------------------
                
                [q1,q2]=urlread(strcat('http://carlos-reyes.staff.shef.ac.uk/caiman/clearOldFiles.php?idFileTC=',nameOfFile));                
                [q1,q2]=urlread(strcat('http://carlos-reyes.staff.shef.ac.uk/caiman/clearOldFiles.php?idFileTC=',nameOfUser));               
                
                %--------------------------------------------------------------------------------------------------
                % 4 Select the algorithm for processing MI - migration SH - shading PE - permeability
                %--------------------------------------------------------------------------------------------------
                switch newImageName{kk,1}(end-1:end)
                    case 'SH'
                        [dataOut]              = shadingCorrection(dataIn(1:end,1:end,:));
                        outputMessage          = strvcat('','The image with shading removed is attached.',''); %#ok<VCAT>

                    case 'MI'
                        [data_stats,dataOut]   = cellMigration(dataIn(1:1:end,1:1:end,:));
                        outputMessage{1}    = 'The image with boundaries of the cell migration is attached.';
                        outputMessage{3}    = strcat('Minimum Distance  = ',num2str(data_stats.minimumDist,4),' [pix]');
                        outputMessage{4}    = strcat('Maximum Distance  = ',num2str(data_stats.maxDist,4),' [pix]');
                        outputMessage{5}    = strcat('Average Distance  = ',num2str(data_stats.avDist,4),' [pix]');
                        outputMessage{6}    = strcat('Total Area  = ',num2str(data_stats.area(1)),' [pix]');
                        outputMessage{7}    = strcat('Relative Area  = ',num2str(data_stats.area(2),3),' [%]');
                        outputMessage{2}    = ' ';
                        outputMessage{8}    = ' ';
                        outputMessage{9}    = ' ';
                        outputMessage{10}   = ' ';
                    case 'VT'
                        disp('It reached the selection point')
                        %[dataOut]              = shadingCorrection(dataIn(1:end,1:end,:));
                        [finalRidges,finalStats,networkP,dataOut1,dataOut] =  scaleSpace(dataIn,scaleSpaceDims,1.75);
                        disp('It passed the routine')

		        outputMessage{1}    = 'The image with traced vasculature is attached.';
                        outputMessage{2}    = 'Top 10 vessels labelled in green, Top 11-50 in yellow and the rest in black.';
                        %outputMessage{4}    = strcat('Num. Vessels  = ',               num2str(networkP.numVessels,4),' [pix]');
                        %outputMessage{5}    = strcat('Total Length  = ',               num2str(networkP.totLength,4),' [pix]');
                        %outputMessage{6}    = strcat('Average Diameter   = ',          num2str(networkP.avDiameter,4),' [pix]');
                        %outputMessage{7}    = strcat('Average Length    = ',           num2str(networkP.avLength,4),' [pix]');
                        %outputMessage{8}    = strcat('Total Length (top 10)   = ',     num2str(networkP.totLength_top10,4),' [pix]');
                        %outputMessage{9}    = strcat('Average Diameter (top 10)   = ', num2str(networkP.avDiameter_top10,4),' [pix]');
                        %outputMessage{10}   = strcat('Average Length (top 10)    = ',  num2str(networkP.totLength_top10,4),' [pix]');
                        %outputMessage{3}    = ' ';
                        %outputMessage{11}   = ' ';
                        %outputMessage{12}   = ' ';

                    otherwise
                        %the case is not covered, generate an error
                        outputMessage          = 'The subroutine was not recognised.';

                end
                %prepare the results
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

                    %setpref('Internet','SMTP_Server','mailhost.shef.ac.uk')
                    %setpref('Internet','E_mail','c.reyes@sheffield.ac.uk')
                    %sendmail('c.reyes@sheffield.ac.uk','Results from Caiman',outputMessage);
                    %sendmail(userEmail,'Results from Caiman','outputMessage');
                catch
                    %getpref('Internet')
                    outputMessage = 'Email could not be sent!';
                   sendmail(userEmail,'Results from Caiman',outputMessage);

                end
            catch
                %file format not recognised
                outputMessage = 'The format of the image could not be read';
            end
        catch
            %         %email could not be read
            outputMessage = 'The email of the user could not be read';
        end
        %--------------------------------------------------------------------------------------------------
        % 6 save results (name) to the file of the processed images (only if successfull) and delete
        % image file
        %--------------------------------------------------------------------------------------------------
        %numOldImages = size(oldImagesList,1);
        %oldImagesList{numOldImages+1}=nameAndDate;
        %dlmwrite('imagesProcessed.txt',oldImagesList,'newline','unix','delimiter','');
        delete(imageNameOut);
        
    %end
    

    
    
    
%%    
end
%%
%--------------------------------------------------------------------------------------------------
% 7 delete the file of the images to process once all have been considered
%--------------------------------------------------------------------------------------------------

delete('imagesToProcess.txt')
