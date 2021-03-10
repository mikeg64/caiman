
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
%disabled the e-mail send
% added lines to generate textfile

try
   %tttt1=pwd;disp(tttt1)
   %path(path,'../caimanDir')
   %open the file generated
   
   %
   %nolonger needed because we parse a json file with the simulation
   %parameters
   
   %portfile = 'ioserverinfo.txt';                            %add comment if  we are not running standalone
   %portfile = 'ioserverinfo.txt';                      %remove comment if  we are not running standalone
   %portfile                = 'mysim0_port.txt';
   %fd                      = fopen(portfile);
   %res = mfscanf(fd,'%d %d %s')
   %res                     = textscan(fd,'%d %s');
   %fclose(fd);
   %port                   = res(1) id = res(2) hostname = res(3)
   %elist                  = iome(res(3),res(1),res(2));
   %elist                   = iome('localhost',res{1},0);
   %readsimulation('simfile.xml',elist);

  %setpref('Internet','SMTP_Server','imap.gmail.com'); %MKG university of sheffield now uses gmail old mailhost disabled end of february 2018
  % setpref('Internet','SMTP_Server','smtp-relay.gmail.com'); %MKG university of sheffield now uses gmail old mailhost disabled end of february 2018
   %setpref('Internet','SMTP_Server','mailhost.shef.ac.uk');
  % setpref('Internet','E_mail','m.griffiths@sheffield.ac.uk');
   %setpref('Internet','E_mail','c.reyes@sheffield.ac.uk');
catch
    outputCode                          = 'E2a';
end

%--------------------------------------------------------------------------------------------------
%   2   get the parameters from the server
%--------------------------------------------------------------------------------------------------

try
    
    xDoc = xmlread('simfile.xml');
    props=xDoc.getElementsByTagName('prop');

    pemail=props.item(0);
    userEmail           = strip(char(pemail.getTextContent));
 
    pimageFile=props.item(1);
    imageFile           = strip(char(pimageFile.getTextContent));
 
    pjobtype=props.item(2);
    jobtype             = strip(char(pjobtype.getTextContent));

  
    outputCode          = jobtype;
    disp(userEmail);
    disp(imageFile);
catch
    outputCode                          = 'E2b';
    display('Failed to parse parameters from job XML file');
    %exitiome(elist);
    %exitiome(elist);
    exit();       
end



%
% . This version used to read json format
%

% try
%     
%     jsontext = fileread("simfile.json");
%     simdat = jsondecode(jsontext);
% 
%     
%     
%     simdat.jobtype
%     
%     userEmail           = simdat.useremail;
%     imageFile           = simdat.imagefile;
%     jobtype             = simdat.jobtype;
%     outputCode          = jobtype;
%     disp(userEmail);
%     disp(imageFile);
% catch
%     outputCode                          = 'E2b';
%     display('Failed to parse parameters from job json file');
%     %exitiome(elist);
%     %exitiome(elist);
%     exit();       
% end





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
    
%[dataIn]                            = imread(strcat('http://caiman.group.shef.ac.uk/caiman/imageUploads/',imageFile));
    %[dataIn]                            = imread(strcat('http://caiman.shef.ac.uk/caiman/uploads/',imageFile));
    [dataIn]                            = imread(strcat(imageFile));
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

                    [rows,cols,levs]                = size(dataIn);
                    RCL                             = rows*cols*levs;
                    if (RCL)<1e6
                        subSampL=1;
                    elseif (RCL)<3e6
                        subSampL=2;
                    elseif (RCL)<12e6
                        subSampL=4;
                    else
                        subSampL=8;
                    end
                    [dataOutS,errSurfaceS]          = shadingCorrection(dataIn(1:subSampL:end,1:subSampL:end,:));

		    if subSampL==1
                        errSurfaceS2                 = errSurfaceS;
                    else
                        filtG = gaussF(3,3,1);
                        for counterL=1:levs
                            errSurfaceS2(:,:,counterL)  = imfilter(expandu(errSurfaceS(:,:,counterL),log2(subSampL)),filtG); %#ok<AGROW>
                        end
                    end
                    dataOut                         = double(dataIn)-errSurfaceS2(1:rows,1:cols,:);
                    avChannels                      = mean(mean(dataOut));
                    maxAvChannel                    = max(avChannels);
                    for counterL=1:levs
                        dataOut(:,:,counterL)       = maxAvChannel*(dataOut(:,:,counterL)/avChannels(counterL));
                    end
                    dataOut(dataOut>255)            = 255;
                    dataOut(dataOut<0)              = 0;
                    %[dataOut]               = shadingCorrection(dataIn(1:end,1:end,:));
                    %outputMessage = 'Shading Correction Completed Successfuly';
                catch
                    outputCode              = 'ESH';
                end
            case 'SE'
                try

                    [rows,cols,levs]                = size(dataIn);
                    RCL                             = rows*cols*levs;
                    if (RCL)<4e6
                        subSampL=1;
                        dataIn2 = dataIn; 
                    elseif (RCL)<8e6
                        subSampL=2;
                        dataIn2= reduceu(dataIn);
                    elseif (RCL)<12e6
                        subSampL=4;
                        dataIn2= reduceu(dataIn,2);
                    else
                        subSampL=8;
                        dataIn2= reduceu(dataIn,3);
                    end
                    [finalCells,statsObjects,dataOut]       = regionGrowingCells(dataIn2);
                    %[finalCells,statsObjects,dataOut]       = regionGrowingCells(dataIn(1:subSampL:end,1:subSampL:end,:));                    
                    if (RCL)<4e6
                        %finalCells=finalCells;
                    elseif (RCL)<8e6
                        finalCells              = expandu(finalCells);
                        finalCells              = (finalCells(1:rows,1:cols,:));
                        statsObjects            = regionprops(finalCells, 'Eccentricity','Area','EulerNumber');
                        borderCells1            = zeros(rows,cols,3);
                        borderCells1(:,:,2)     = imdilate(zerocross(-0.5+(finalCells>0)),ones(3)) ;
                        borderCells2            = repmat(borderCells1(:,:,2),[1 1 3]);
                        dataOut                 = ((dataIn).*uint8(1-borderCells2) + 105.*uint8(borderCells1));
                    elseif (RCL)<12e6
                        finalCells              = expandu(finalCells,2);
                        finalCells              = (finalCells(1:rows,1:cols,:));
                        statsObjects            = regionprops(finalCells, 'Eccentricity','Area','EulerNumber');
                        borderCells1            = zeros(rows,cols,3);
                        borderCells1(:,:,2)     = imdilate(zerocross(-0.5+(finalCells>0)),ones(3)) ;
                        borderCells2            = repmat(borderCells1(:,:,2),[1 1 3]);
                        dataOut                 = ((dataIn).*uint8(1-borderCells2) + 105.*uint8(borderCells1));
                    else
                        finalCells              = expandu(finalCells,3);
                        finalCells              = (finalCells(1:rows,1:cols,:));
                        statsObjects            = regionprops(finalCells, 'Eccentricity','Area','EulerNumber');
                        borderCells1            = zeros(rows,cols,3);
                        borderCells1(:,:,2)     = imdilate(zerocross(-0.5+(finalCells>0)),ones(3)) ;
                        borderCells2            = repmat(borderCells1(:,:,2),[1 1 3]);
                        dataOut                 = ((dataIn).*uint8(1-borderCells2) + 105.*uint8(borderCells1));


                    end


                    [avThickness,stdThickness,propLumen]    = findWallThickness(finalCells);
                    tempProps                               = regionprops(finalCells,'Perimeter','FilledArea','EquivDiameter');
                    %statsObjects.avThickness                = avThickness;
                    %statsObjects.stdThickness               = stdThickness;
                    %statsObjects.propLumen                  = propLumen;
                    extraData.statsObjects                  = statsObjects;
                    extraData.avThickness                   = avThickness;
                    extraData.temp                          = tempProps;
                    st2P                                = [tempProps.Perimeter]';
                    st2A                                = [statsObjects.Area]';
                    st2FA                               = [tempProps.FilledArea]';
                    if st2FA>0
                        st2RA                               = ((st2FA-st2A)./st2FA)';
                        extraData.luVA                  = mean(st2RA);
                        extraData.roundness             = mean(st2P./(sqrt(4*pi*st2FA)));
                    else
                        extraData.luVA                  = 0;
                        extraData.roundness             = 0;
                    end 
                    finalResults = finalCells;
                catch
                    outputCode              = 'ESE';
                end
            case 'LA'
                try
                    %dataOut = dataIn;
                    dataOut                 = removeLineArtifact(dataIn);
                catch
                    outputCode              = 'ELA';
                end
            case 'CH'
                try
                    [finalResults,extraData]            = chromaticAnalysis(dataIn);
                catch
                    outputCode              = 'ECH';
                end
            case 'QH'
                try
                    %dataOut = dataIn;
                    extraData               = quantifyHeartSprouts(dataIn);
                catch
                    outputCode              = 'EQH';
                end
            case 'MI'
                try
                    %dataOut = dataIn;
                    [data_stats,dataOut]    = cellMigration(dataIn(1:1:end,1:1:end,:));
                    extraData               = data_stats;
                catch
                    outputCode              = 'EMI';
                end
            case 'VT'
                try
		    %dataOut= dataIn;

%% Subsample necessary to avoid out of memory problems
                    [rows,cols,levs]                = size(dataIn);
                    RCL                             = rows*cols*levs;
                    if (RCL)<1e6
                        subSampL=0;
                    elseif (RCL)<4e6
                        subSampL=1;
                    elseif (RCL)<12e6
                        subSampL=2;
                    else
                        subSampL=3;
                    end
                    dataIn2= uint8(reduceu(dataIn,subSampL));

%% vessel tracing by scale space
                    
		    %dataOut= dataIn;
                    scaleSpaceDims          = 1:10;
                    [finalRidges2,finalStats2,networkP2,dataOut1,dataOut2] =  scaleSpaceLowMem(dataIn2,scaleSpaceDims,1.75);
                    %[finalRidges,finalStats,networkP,dataOut1,dataOut] =  scaleSpaceLowMem(dataIn,scaleSpaceDims,1.75);
%% expand results to original sizes                    
                    
                    if (RCL)<1e6
                        dataOut                 = dataOut2;
                        extraData               = networkP2;
                        finalRidges             = finalRidges2;
                        finalStats              = finalStats2;  
                    else

                    
%% recalculate finalRidges expand to original dimensions
                        for counterL = 1:10
                            q0                                          = (((finalRidges2(:,:,counterL))));
                            q1                                          = ((expandu(q0,subSampL)));
                            finalRidges(:,:,counterL)                   = (q1);
                        end
                        fRidges2d                                       = (max(finalRidges(:,:,:),[],3));
                        fRidges2d3                                      = fRidges2d.*(bwmorph(fRidges2d,'thin',subSampL));
                        actualLength                                    = regionprops(fRidges2d3,'perimeter','area');
                    
%% recalculate finalStats and networkP 

                        %numRidges                                       = size(finalStats,1);

                        finalStats(:,[1 4])                             = finalStats2(:,[1 4]); 
                        finalStats(:,[  3 5])                           = finalStats2(:,[ 3 5])*2^subSampL;                     
                        numRidges                                       = size(finalStats,1);
                        finalStats(:,2)                                 = ceil([actualLength(1:numRidges).Perimeter]/2);
                        %numRidges                                       = size(finalStats,1);
                        top10                                           = max(1,numRidges-9):numRidges;
                        top50                                           = max(1,numRidges-49):numRidges-10;
                        indexTop10                                      = finalStats(top10,4);

                        extraData.numVessels                            = numRidges;
                        extraData.totLength                             = sum(finalStats(:,2));
                        extraData.avDiameter                            = mean(finalStats(:,5));
                        extraData.avLength                              = mean(finalStats(:,2));
                        extraData.totLength_top10                       = sum(finalStats(indexTop10,2));
                        extraData.avDiameter_top10                      = mean(finalStats(indexTop10,5));
                        extraData.avLength_top10                        = mean(finalStats(indexTop10,2));                    
                    
%% recalculate dataOut                    
                        dataOut(:,:,1)                                  = expandu(dataOut2(:,:,1),subSampL);
                        dataOut(:,:,2)                                  = expandu(dataOut2(:,:,2),subSampL);
                        dataOut(:,:,3)                                  = expandu(dataOut2(:,:,3),subSampL);
                        dataOut                                         = uint8(dataOut);
                    end
                    clear finalResults;
                    finalResults = finalRidges;
                    %finalResults{1} = finalRidges;
                    %finalStats = finalStats(:,[1  2 5]);
                    %finalResults{2} = finalStats;



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
        [q1,q2]=urlread('http://caiman.group.shef.ac.uk/caiman/clearOldFiles.php?idTimeTC=10');
end

%email output to user
if ~strcmp(outputCode(1),'E')
             %prepare the results only if there were no errors on the way
            %if there is a dataOut, prepare the image to attach, otherwise just send the email
            if exist('dataOut','var')
              %imageNameOut                   = strcat(ImageName,'.jpg');
              imageNameOut                   = strcat('final_',ImageName);

              if isa(dataOut,'uint8')
                  if strcmp(imageNameOut(end-2:end),'tif')
                    imwrite(dataOut,imageNameOut,'tif','resolution',150); 
                  elseif strcmp(imageNameOut(end-2:end),'png')
                    imwrite(dataOut,imageNameOut,'png');                                     
                  else
                    imwrite(dataOut,imageNameOut,'jpg');
                  end
              else
                  if strcmp(imageNameOut(end-2:end),'tif')
                    imwrite(dataOut/255,imageNameOut,'tif','resolution',150);
                  elseif strcmp(imageNameOut(end-2:end),'png')
                    imwrite(dataOut/255,imageNameOut,'png');                    
                  else
                    imwrite(dataOut/255,imageNameOut,'jpg');
                  end
              end
              %--------------------------------------------------------------------------------------------------
              % 5 email results to the user
              %--------------------------------------------------------------------------------------------------
              try
               if exist('finalResults','var')
                    dataNameOut                   = strcat(ImageName(1:end-4),'.mat');
                    save(dataNameOut,'finalResults');
                    
                    fileID = fopen('outputmsg.txt','w');
            	     fprintf(fileID,'Results from Caiman %s %s %s\n',outputMessage{1}, imageNameOut, dataNameOut);
	    	     fclose(fileID);                

                    
                    
                    
                    %sendmail(userEmail,'Results from Caiman',outputMessage,{imageNameOut,dataNameOut});
                    %sendmail(userEmail,'Results from Caiman',outputMessage,{imageNameOut});                    
                else
                
                     fileID = fopen('outputmsg.txt','w');
            	     fprintf(fileID,'Results from Caiman %s %s \n',outputMessage{1}, imageNameOut);
	    	     fclose(fileID);                

                
                
                     %sendmail(userEmail,'Results from Caiman',outputMessage,{imageNameOut});
                 end 
             catch
                  %getpref('Internet')
                  outputCode                  = 'E1';
                  outputMessage               = createOutputMessage(outputCode);
                  
                  
                fileID = fopen('outputmsg.txt','w');
            	fprintf(fileID,'Results from Caiman %s\n',outputMessage{1});
	    	fclose(fileID);                

                  
                  %sendmail(userEmail,'Results from Caiman',outputMessage);                
              end
            else
               if exist('finalResults','var')
                    dataNameOut                   = strcat(ImageName(11:end-4),'.mat');
                    save(dataNameOut,'finalResults');
                     fileID = fopen('outputmsg.txt','w');
                   fprintf(fileID,'Results from Caiman %s, %s\n',outputMessage{1},dataNameOut);
	            fclose(fileID);
                    %sendmail(userEmail,'Results from Caiman',outputMessage,{dataNameOut});                    
               else
                       fileID = fopen('outputmsg.txt','w');
            		fprintf(fileID,'Results from Caiman %s\n',outputMessage{1});
	    		fclose(fileID);                
                   %sendmail(userEmail,'Results from Caiman',outputMessage);
               end           
            end
            %--------------------------------------------------------------------------------------------------
            % 6 delete image file
            %--------------------------------------------------------------------------------------------------
            %delete(imageNameOut);   %commented out by MKG 18/01/2020%
else
            outputMessage                   = createOutputMessage(outputCode);
            fileID = fopen('outputmsg.txt','w');
            fprintf(fileID,'%s\n',outputMessage{1});
	    fclose(fileID);
            %sendmail(userEmail,'Results from Caiman ',outputMessage);    
end


%no longer required iome server not needed
% try
%    exitiome(elist);
% catch
%    display('Unable to close IOME'); 
% end
% 
% try
%     exitiome(elist);
% catch
%     display('iome server closed!');
% end

%exit();

