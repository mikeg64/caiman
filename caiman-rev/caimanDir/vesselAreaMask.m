function [relAreaCovered,dataOut3]=vesselAreaMask(fRidges,fStats,dataIn,indexRidges)



if ~exist('indexRidges','var')
    numRidges                           = max(fRidges(:));
    indexRidges                         = 1:numRidges;
else
    numRidges                           = length(indexRidges);
end
[rows,cols,levs]                        = size(fRidges); %#ok<NASGU>

fRidgeDilated (rows,cols)               = 0;

% % loop over each thickness (level of fRidges)
% for ridgeToView=1:levs
%     fRidgesSelected                 = (fRidges(:,:,ridgeToView));
%     fRidges2D_1                     = fRidgesSelected;
%     avThickK                        = strel('disk', round(2.4*ridgeToView/2), 8);
%     fRidgeDilated                   = fRidgeDilated+imdilate(fRidges2D_1,avThickK );
% end

fRidges2D                               = sum(fRidges,3);

% loop over each ridge
for counterRidges=1:numRidges
    ridgeToView = indexRidges (counterRidges);
   % if ismember(ridgeToView,indexRidges)
        %select ridge
        fRidges2D_1                         = (fRidges2D==ridgeToView);
        fRidgesProps                        = regionprops(double(fRidges2D_1),'area','boundingbox');
        try
            sizeCurrRidge                       = fRidgesProps.Area; %sum(fRidges2D_1(:));
        catch
            beep;
            %qqq=1;
        end
        %calculate the thickness of the ridge
        radiusOfKernel                      = round(fStats(ridgeToView,5)/2);
        avThickK                            = strel('disk', radiusOfKernel, 0);
        %avThickK2                           = strel('disk', max(radiusOfKernel-2,1), 0);
        rDims                               =max(1,floor(fRidgesProps.BoundingBox(2))-radiusOfKernel-1):min(rows,ceil(fRidgesProps.BoundingBox(2))+fRidgesProps.BoundingBox(4)+radiusOfKernel+1);
        cDims                               =max(1,floor(fRidgesProps.BoundingBox(1))-radiusOfKernel-1):min(cols,ceil(fRidgesProps.BoundingBox(1))+fRidgesProps.BoundingBox(3)+radiusOfKernel+1);
        if (sizeCurrRidge>(2*radiusOfKernel-1))
            currRidgeRed                    = bwmorph(fRidges2D_1(rDims,cDims),'spur',radiusOfKernel-1);
            currRidgeDil                    = imdilate(currRidgeRed,avThickK);
            fRidgeDilated(rDims,cDims)      = fRidgeDilated(rDims,cDims)+currRidgeDil;
        else
            fRidgeDilated(rDims,cDims)      = fRidgeDilated(rDims,cDims)+imdilate(bwmorph(fRidges2D_1(rDims,cDims),'shrink','inf'),avThickK);
        end
        %     %detect the end points, remove the dilated endpoint to reduce the extension of final dilated ridge
        %     [EndPointsRidge,EndP2,numEndP]      = EndPoints(fRidges2D_1); %#ok<NASGU>
        %
        % %     while (numEndP>2)
        % %         fRidges2D_1                     = bwmorph(fRidges2D_1,'spur',1);
        % %         [EndPointsRidge,EndP2,numEndP]  = EndPoints(fRidges2D_1);
        % %         disp(strcat('asdfa,',ridgeToView))
        % %     end
        %     %proceed to dilate endpoints
        %     EndPointsDilated                    = imdilate(EndPointsRidge,avThickK2 );
        %     %remove dilated endpoints from the original line
        %     reducedRidge2D                      = fRidges2D_1&(1-EndPointsDilated);
        %     if (sum(reducedRidge2D(:))>0)
        %         fRidgeDilated                   = fRidgeDilated+imdilate(reducedRidge2D,avThickK );
        %     else
        %
        %         fRidgeDilated                   = fRidgeDilated+imdilate(fRidges2D_1,avThickK2 );
        %         disp(ridgeToView);
        %     end
        %imagesc(fRidgeDilated)
    %end
end


relAreaCovered                          = sum(fRidgeDilated(:)>0)/rows/cols;

if exist('dataIn','var')
    dataIn2                         = double(dataIn);
    dataIn2(2:end-1,2:end-1,1)      = dataIn2(2:end-1,2:end-1,1).*(1-(0.2*(fRidgeDilated>0)));
    dataIn2                         = uint8(dataIn2);
    fRidges2D                       = (sum(fRidges,3));
    fRidges2DFlat                   = (fRidges2D>0);

    dataOut3                        = dataIn2;
    dataOut3(2:end-1,2:end-1,1)     = dataOut3(2:end-1,2:end-1,1).*uint8(1-(fRidges2DFlat))  ;
    dataOut3(2:end-1,2:end-1,2)     = dataOut3(2:end-1,2:end-1,2).*uint8(1-(fRidges2DFlat))  ;

end




%% %

%imagesc(dO104)