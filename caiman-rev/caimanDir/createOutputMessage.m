function outputMessage = createOutputMessage(caseRoutine,extraData)


%  30/10/2014 Modification to outputMessage construction
%           the SE routine failed to email results. This was caused by
%           sendmail being unable to concatenate the strings in the cell
%           array.
%           The reson for this was the ordering in the case statements
%           below. It is probably best to preallocate a cell array of
%           strings. When this is done out of order a blank cell is
%           inserted which cannot be processed by the string concatenator

switch caseRoutine
    case 'CH'
        %Chromatic analysis
        outputMessage{1}    = 'The chromatic analysis has been performed. The following ratios were calculated:';
        outputMessage{2}    = ' ';
        try

          outputMessage{3}    = strcat('Centroid - Hue                     = ',      num2str(extraData.centroid_Hue),'  [degrees] ');
          outputMessage{4}    = strcat('Centroid - Saturation            = ',      num2str(extraData.centroid_Sat),' ');
          outputMessage{5}    = strcat('Centroid - Value                   = ',      num2str(extraData.centroid_Val),' ');

          outputMessage{8}    = strcat('Hue Ratio                     = ',      num2str(extraData.hueRatio),' ');
          outputMessage{9}    = strcat('Saturation Ratio           = ',      num2str(extraData.saturationRatio),' ');
          outputMessage{10}   = strcat('Value Ratio                  = ',      num2str(extraData.valueRatio),' ');
          outputMessage{7}    = ' ';
          outputMessage{6} = ' ';

        catch
          outputMessage{3}    = strcat('Hue Ratio                     = ',      num2str(extraData.hueRatio),' ');
          outputMessage{4}    = strcat('Saturation Ratio           = ',      num2str(extraData.saturationRatio),' ');
          outputMessage{5}    = strcat('Value Ratio                  = ',      num2str(extraData.valueRatio),' ');     
          outputMessage{7}    = ' ';
        end
    case 'ME'
        %Merging colour channels
        outputMessage{1}    = 'The image with the RGB channels is attached.';
        outputMessage{2}    = ' ';
    case 'SH'
        %shading correction
        outputMessage{1}       = 'The image with shading removed is attached.';
        outputMessage{2}       = ' ';
    case 'LA'
        %shading correction
        outputMessage{1}       = 'The image with line artefacts removed is attached.';
        outputMessage{2}       = ' ';
    case 'QH'
        if exist('extraData','var')
            outputMessage{1}    = 'The image with heart sprouts has been quantified. Ratio is Sprouts / Total.';
            outputMessage{2}    =' ';           
            outputMessage{3}    = strcat('Heart   Area                = ',      num2str(extraData.HeartArea),' [pixels] ');
            outputMessage{4}    = strcat('Sprout Area                = ',      num2str(extraData.SproutArea),' [pixels]');
            outputMessage{5}    = strcat('Total   Area                = ',      num2str(extraData.totalArea),' [pixels]');
            outputMessage{6}    = strcat('Ratio of Areas            = ',      num2str(extraData.ratio),' ');
            outputMessage{7}    = ' ';
            outputMessage{8}    = strcat('Ratio of Areas (Polygon/(Polygon+Heart)) = ',      num2str(extraData.ratioPoly_Tot),' ');
            outputMessage{9}    = strcat('Ratio of Areas (Sprout/(Sprout+Polygon)) = ',      num2str(extraData.ratioSprouts_Poly),' ');
            outputMessage{10}    = ' ';
            outputMessage{11}    = ' ';
        end        
    case 'SE'
        if exist('extraData','var')
            data_stats          = extraData;
            outputMessage{1}    = 'The image with segmented endothelial cells is attached. Results are in pixels.';
            outputMessage{2}    =' ';
            outputMessage{3}    = strcat('Number of objects                     = ',      num2str(length(data_stats.statsObjects)),' ');
             outputMessage{4}    = strcat('Average Stained Area (exc. lumen)    = ',      num2str(mean( [data_stats.statsObjects.Area]')),' ');
             outputMessage{5}    = strcat('Average Vessel Area (inc. lumen)     = ',      num2str(mean( [data_stats.temp.FilledArea]')),' ');
             outputMessage{6}    = strcat('Average Perimeter                    = ',      num2str(mean( [data_stats.temp.Perimeter]')),' ');
             outputMessage{7}    = strcat('Number of objects with NumEuler<1 = ',      num2str(sum(  [data_stats.statsObjects.EulerNumber]'<1)),' ');
             outputMessage{8}    = strcat('Average Eccentricity                 = ',      num2str(mean( [data_stats.statsObjects.Eccentricity]')),' ');
             outputMessage{9}    = strcat('Average Wall thickness             = ',      num2str(mean( [data_stats.avThickness] )),' ');
             outputMessage{10}    = strcat('Average lumen/Vessel Area    = ',      num2str(mean( [data_stats.luVA] )),' ');           
             outputMessage{11}    =strcat('Average roundness                = ',      num2str(mean( [data_stats.roundness] )),' ');
             outputMessage{12}    = ' ';
             outputMessage{13}    = ' ';
             outputMessage{14}    = 'Note: Large images (>[2,000 x 1,000]) are subsampled due to limits in Memory Size ';
             outputMessage{15}    = ' ';


        else
            outputMessage{1}    = 'The image with segmented endothelial cells is attached.';
        end
        outputMessage{2}    = ' ';


    case 'MI'
        %Migration assays
        if exist('extraData','var')
            data_stats          = extraData;
            outputMessage{1}    = 'The image with boundaries of the cell migration is attached.';
            outputMessage{2}    =' ';          
            outputMessage{3}    = strcat('Total Area            = ',      num2str(data_stats.area(1)),' [pix]');
            outputMessage{4}    = strcat('Relative Area         = ',   num2str(data_stats.area(2),3),' [%]');
            if isfield(data_stats,'maxDist')
                outputMessage{5}    = strcat('Minimum Distance  = ',num2str(data_stats.minimumDist,4),' [pix]');
                outputMessage{6}    = strcat('Maximum Distance  = ',num2str(data_stats.maxDist,4),' [pix]');
                outputMessage{7}    = strcat('Average Distance  = ',num2str(data_stats.avDist,4),' [pix]');
                outputMessage{8}    = ' ';
                outputMessage{9}    = ' ';
                outputMessage{10}   = ' ';
            else
                outputMessage{5}    = ' ';
                outputMessage{6}    = 'Distances were not obtained as the wound appeared to be closed at least from one position. ';
                outputMessage{7}    = ' ';
                outputMessage{8}    = ' ';
            end
            outputMessage{2}    = ' ';
        else
            outputMessage{1}    = 'The image with cell migration is attached.';
            outputMessage{2}    = ' ';
        end
    case 'VT'
        %Vessel tracing
        if exist('extraData','var')
            networkP            = extraData;
            outputMessage{1}    = 'The image with traced vasculature is attached.';
            outputMessage{2}    = 'Top 10 vessels labelled in red, Top 11-50 in green and the rest in black.';
            outputMessage{3}    =' ';           
            outputMessage{4}    = strcat('Num. Vessels               = ', num2str(networkP.numVessels,4),' ');
            outputMessage{5}    = strcat('Total Length               = ', num2str(networkP.totLength,4),' [pix]');
            outputMessage{6}    = strcat('Average Diameter           = ', num2str(networkP.avDiameter,4),' [pix]');
            outputMessage{7}    = strcat('Average Length             = ', num2str(networkP.avLength,4),' [pix]');
            outputMessage{8}    = strcat('Total Length (top 10)      = ', num2str(networkP.totLength_top10,4),' [pix]');
            outputMessage{9}    = strcat('Average Diameter (top 10)  = ', num2str(networkP.avDiameter_top10,4),' [pix]');
            outputMessage{10}   = strcat('Average Length (top 10)    = ', num2str(networkP.avLength_top10,4),' [pix]');
            outputMessage{11}   = ' ';
            outputMessage{12}   = ' ';
            outputMessage{13}    = 'Note: Large images (>[2,000 x 1,000]) are subsampled due to limits in Memory Size ';
            outputMessage{14}    =' ';           
            outputMessage{15}    = ' ';
        else
            outputMessage{1}    = 'The image with traced vasculature is attached.';
            outputMessage{2}    = ' ';
        end
    case 'E1'
        % Error 1, email cannot be sent
        outputMessage{1}    = 'Email could not be sent!';
        outputMessage{2}    = ' ';
        outputMessage{3}    = ' ';
    case 'E2a'
        %Error 2 image could not be read
        outputMessage{1}    = 'Error in the first part of the iome E2a';
        outputMessage{2}    = ' ';
        outputMessage{3}    = ' ';
     case 'E2b'
        %Error 2 image could not be read
        outputMessage{1}    = 'E2b';
        outputMessage{2}    = ' ';
        outputMessage{3}    = ' ';
     case 'E2'
        %Error 2 image could not be read
        outputMessage{1}    = 'The format of the image could not be read';
        outputMessage{2}    = ' ';
        outputMessage{3}    = ' ';
    case 'E3'
        %Error 3 email of user not understood
        outputMessage{1}    = 'The email of the user could not be read';
        outputMessage{2}    = ' ';
        outputMessage{3}    = ' ';
    case 'E4'
        %Error 4 subroutine not recognised
        outputMessage{1}    = 'The subroutine was not recognised.';
        outputMessage{2}    = ' ';
        outputMessage{3}    = ' ';
    case 'E5'
        %Any other error
        outputMessage{1}    = 'There was an unrecognised error.';
        outputMessage{2}    = ' ';
        outputMessage{3}    = ' ';
    case 'EVT'
        %Any other error
        outputMessage{1}    = 'There was an error in the Vessel Tracing subroutine.';
        outputMessage{2}    = ' ';
        outputMessage{3}    = ' ';
    case 'ESE'
        %Any other error
        outputMessage{1}    = 'There was an error in the Endothelial Cell segmentation subroutine.';
        outputMessage{2}    = ' ';
        outputMessage{3}    = ' ';
    case 'ELA'
        %Any other error
        outputMessage{1}    = 'There was an error in the Line Artefact subroutine.';
        outputMessage{2}    = ' ';
        outputMessage{3}    = ' ';
    case 'EQH'
        %Any other error
        outputMessage{1}    = 'There was an error in the Quantification of Sprouts subroutine.';
        outputMessage{2}    = ' ';
        outputMessage{3}    = ' ';
    case 'EME'
        %Any other error
        outputMessage{1}    = 'There was an error in the Channel Merging subroutine.';
        outputMessage{2}    = ' ';
        outputMessage{3}    = ' ';
    case 'EMI'
        %Any other error
        outputMessage{1}    = 'There was an error in the Migration Measurement subroutine.';
        outputMessage{2}    = ' ';
        outputMessage{3}    = ' ';
    case 'ESH'
        %Any other error
        outputMessage{1}    = 'There was an error in the Shading subroutine.';
        outputMessage{2}    = ' ';
        outputMessage{3}    = ' ';
    case 'ECH'
        %Any other error
        outputMessage{1}    = 'There was an error in the Chromaticity subroutine.';
        outputMessage{2}    = ' ';
        outputMessage{3}    = ' ';
        
       
        
end
