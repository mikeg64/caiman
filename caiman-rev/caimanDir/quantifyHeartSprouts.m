function [extraData,dataOut2] = quantifyHeartSprouts (dataIn)
%the heart has been manually delineated in the blue channel while the sprouts have been drawn in the red
%channel

%Heart area must be predominantly blue, in tiffs this is not a problem but with jpgs there may be
%blurring or colours that are not above 250...
HeartArea               = (dataIn(:,:,3)>130)&((dataIn(:,:,2)+dataIn(:,:,1))<200);
SproutArea              = (dataIn(:,:,1)>130)&((dataIn(:,:,2)+dataIn(:,:,3))<200);

extraData.HeartArea     =  sum(sum(HeartArea));
extraData.SproutArea    =  sum(sum(SproutArea));
extraData.totalArea     =  extraData.SproutArea+extraData.HeartArea;
extraData.ratioSprout_Tot         =  extraData.SproutArea/(extraData.totalArea);

%dataOut(:,:,1)              = HeartArea;
%dataOut(:,:,2)              = SproutArea;
%dataL                       = (dataOut(:,:,2)+imfill(dataOut(:,:,1),'holes')*2);
%q                           = regionprops(dataL,'area','convexhull','conveximage','boundingbox');
%qq1                         = zeros(size(dataL));
%dimsR                       = (floor(q(1).BoundingBox(2)):floor(q(1).BoundingBox(2)-1)+q(1).BoundingBox(4));
%dimsC                       = (floor(q(1).BoundingBox(1)):floor(q(1).BoundingBox(1))+q(1).BoundingBox(3)-1);

%if dimsR(1) == 0; dimsR = dimsR+1; end
%if dimsC(1) == 0; dimsC = dimsC+1; end

%qq1(dimsR,dimsC)=q(1).ConvexImage;


%convexHullSprouts           = (~(dataL(:,:,1)==2)&qq1);

%extraData.ratioPoly_Tot     = extraData.HeartArea  / sum(qq1(:)|HeartArea(:));
%extraData.ratioSprouts_Poly = extraData.SproutArea / sum(convexHullSprouts(:));

%%
%HeartAreaP                  = imdilate(zerocross(HeartArea-0.5),ones(3));
%convexHullSproutsP          = imdilate(zerocross(convexHullSprouts-0.5),ones(3));
%%

%dataOut2(:,:,1)              = dataIn(:,:,1);
%dataOut2(:,:,2)              = uint8(double(dataIn(:,:,2)).*(1-convexHullSproutsP) + convexHullSproutsP);
%dataOut2(:,:,3)              = uint8(double(dataIn(:,:,2)).*(1-HeartAreaP) + HeartAreaP);

