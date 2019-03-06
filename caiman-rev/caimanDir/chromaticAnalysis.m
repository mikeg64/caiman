function [finalResults,extraData] = chromaticAnalysis (dataIn,sizeHue,sizeSat,sizeVal)

%crop 2 pixels on the edges
%dataIn                                                  = dataIn(3:end-2,3:end-2,:);

%subsample if necessary
[rows,cols,levs]                                        = size(dataIn);

if nargin==1
    sizeHue = 32;
    sizeSat = 32;
    sizeVal = 32;
end


if nargin==2
    sizeSat = sizeHue;
    sizeVal = sizeHue;
end

RCL                                                     = rows*cols*levs;

if (RCL)<1e6
    subSampL                                            = 1;
elseif (RCL)<4e6
    subSampL                                            = 2;
elseif (RCL)<12e6
    subSampL                                            = 4;
else
    subSampL                                            = 8;
end
dataIn2= reduceu(dataIn(1:subSampL:end,1:subSampL:end,:));

%% 

%transform from RGB to HSV
dataHSV                                                 = rgb2hsv(dataIn2);

%Obtain colour histogram on which the 2D and 3D calculations are based
[hs_im1,chrom3D_im1,dataHue,dataSaturation,dataValue]   = colourHist2(dataHSV,sizeHue,sizeSat,sizeVal); %#ok<NASGU>

%%
finalResults                                                = chrom3D_im1;

totElements                                                 = sum(chrom3D_im1(:));

% calculate 1D histograms
finalResultsValue                                       = squeeze(sum(sum(finalResults,1),2));
finalResultsHue                                         = squeeze(sum(sum(finalResults,1),3));
finalResultsSaturation                                  = squeeze(sum(sum(finalResults,2),3));


extraData.hueRatio                                          = ( sum(sum(sum(chrom3D_im1(1:sizeHue/2,:,:))))/totElements);
extraData.saturationRatio                                   = ( sum(sum(sum(chrom3D_im1(:,1:sizeSat/2,:))))/totElements);
extraData.valueRatio                                        = ( sum(sum(sum(chrom3D_im1(:,:,1:sizeVal/2))))/totElements);

% % For counting the number of non-zero values (and not the actual number of pixels 
% totElements                                                 = sum(chrom3D_im1(:)>0);
% extraData.hueRatio                                          = ( sum(sum(sum(chrom3D_im1(1:sizeHue/2,:,:)>0)))/totElements);
% extraData.saturationRatio                                   = ( sum(sum(sum(chrom3D_im1(:,1:sizeSat/2,:)>0)))/totElements);
% extraData.valueRatio                                        = ( sum(sum(sum(chrom3D_im1(:,:,1:sizeVal/2)>0)))/totElements);


%% Calculate Centroids



%Saturation and Value are direct as they are between 0-1
Y=(1:32)/32; Z=(1:32)/32;
extraData.centroid_Sat   = sum(Y'.*finalResultsSaturation)/sum(finalResultsSaturation);
extraData.centroid_Val   = sum(Z'.*finalResultsValue)/sum(finalResultsValue);

%Hue has to be calculated in the sector that the hue has a stronger component
%therefore rotate for 360 deg and find the sector of 180 deg with most weight
maxWeightSector(32)         = 0;
for k=1:32
    tempFinalResHue         = circshift(finalResultsHue',1-k);
    maxWeightSector(k)      = sum(tempFinalResHue(1:16));
end
[ang_1,ang_2]               = max( maxWeightSector);

relResultsHue               = circshift(finalResultsHue',1-ang_2);
%X1                          = circshift((1:32)',-ang_2);
X1                          =(1:32)';
tempCentroid                = rem(relResultsHue'*X1/sum(finalResultsHue)+ang_2-1,32);
extraData.centroid_Hue      = 360*tempCentroid/32; 





%Y=(1:32)/32; Z=(1:32)/32;
%if sum(finalResultsHue([1:8 25:32]))>sum(finalResultsHue([9:24]))
%    X2=[linspace(0,179,16) linspace(-180,0,16)] ;
%    extraData.centroid_Hue  = rem(360+sum(X2.*finalResultsHue)/sum(finalResultsHue),360);
%else
%    X1=linspace(0,359,32);
%    extraData.centroid_Hue  = sum(X1.*finalResultsHue)/sum(finalResultsHue);
%end
%extraData.centroid_Sat   = sum(Y'.*finalResultsSaturation)/sum(finalResultsSaturation);
%extraData.centroid_Val   = sum(Z'.*finalResultsValue)/sum(finalResultsValue);


