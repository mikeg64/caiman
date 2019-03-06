function   [dataOut,nameFileBlueBlue,nameFileGreen,nameFileRed]              = mergeRGBchannels(newImageName)


RGBName             = strcat(newImageName(1:end-9),'RGB_names');
RGBImagesListName   = strcat('http://carlos-reyes.staff.shef.ac.uk/caiman/imageUploads/',RGBName);
[RGBImagesList,errs]= urlread(RGBImagesListName); %#ok<NASGU>

numElems            = length(RGBImagesList);
isRed               = strfind(RGBImagesList,'@R@');
isGreen             = strfind(RGBImagesList,'@G@');
isBlue              = strfind(RGBImagesList,'@B@');
%dataOut(1,1,3)=0;
if ~isempty(isBlue)
    nameFileBlue     = RGBImagesList(isBlue+4:numElems);
    numElems        = isBlue-1;
    imageLocation   = strcat('http://carlos-reyes.staff.shef.ac.uk/caiman',nameFileBlue);
    [dataB]         = imread(imageLocation);
    dataOut(:,:,3)  = dataB;
    [q1,q2]=urlread(strcat('http://carlos-reyes.staff.shef.ac.uk/caiman/clearOldFiles.php?idFileTC=',nameFileBlue(15:end))); %#ok<NASGU>
    [q1,q2]=urlread(strcat('http://carlos-reyes.staff.shef.ac.uk/caiman/clearOldFiles.php?idFileTC=',strcat(nameFileBlue(15:end-9),'RGB_names'))); %#ok<NASGU>
    [q1,q2]=urlread(strcat('http://carlos-reyes.staff.shef.ac.uk/caiman/clearOldFiles.php?idFileTC=',strcat(nameFileBlue(15:end-9),'userEmail'))); %#ok<NASGU>
else
    nameFileBlue  = [];
    dataOut(rows,cols,3)=0;dataOut=uint8(dataOut);
end

if ~isempty(isGreen)
    nameFileGreen   = RGBImagesList(isGreen+4:numElems);
    numElems        = isGreen-1;
    imageLocation   = strcat('http://carlos-reyes.staff.shef.ac.uk/caiman',nameFileGreen);
    [dataG]         = imread(imageLocation);
    dataOut(:,:,2)  = dataG;
    [q1,q2]=urlread(strcat('http://carlos-reyes.staff.shef.ac.uk/caiman/clearOldFiles.php?idFileTC=',nameFileGreen(15:end))); %#ok<NASGU>
    [q1,q2]=urlread(strcat('http://carlos-reyes.staff.shef.ac.uk/caiman/clearOldFiles.php?idFileTC=',strcat(nameFileGreen(15:end-9),'RGB_names'))); %#ok<NASGU>
    [q1,q2]=urlread(strcat('http://carlos-reyes.staff.shef.ac.uk/caiman/clearOldFiles.php?idFileTC=',strcat(nameFileGreen(15:end-9),'userEmail'))); %#ok<NASGU>
else
   nameFileGreen = [];
end

if ~isempty(isRed)
    nameFileRed     = RGBImagesList(isRed+4:numElems);
    numElems        = isRed-1; %#ok<NASGU>
    imageLocation   = strcat('http://carlos-reyes.staff.shef.ac.uk/caiman',nameFileRed);
    [dataR]         = imread(imageLocation);
    dataOut(:,:,1)  = dataR;
    [q1,q2]=urlread(strcat('http://carlos-reyes.staff.shef.ac.uk/caiman/clearOldFiles.php?idFileTC=',nameFileRed(15:end))); %#ok<NASGU>
    [q1,q2]=urlread(strcat('http://carlos-reyes.staff.shef.ac.uk/caiman/clearOldFiles.php?idFileTC=',strcat(nameFileRed(15:end-9),'RGB_names'))); %#ok<NASGU>
    [q1,q2]=urlread(strcat('http://carlos-reyes.staff.shef.ac.uk/caiman/clearOldFiles.php?idFileTC=',strcat(nameFileRed(15:end-9),'userEmail'))); %#ok<NASGU>
else
   nameFileRed =[];
end
