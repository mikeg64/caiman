function BW3 =  closeOpenObjects(BW1)


%-------- regular size check and check input arguments
[rows,cols]=size(BW1);
%------ label input data to process objects by pairs, get major axis to determine the distances to other objects
[BW2,numInitialObjs]                                = bwlabel(BW1);
statsObjects0                                       = regionprops(BW2,'Area','BoundingBox');
BW3=zeros(rows,cols);
for countObjs=1:numInitialObjs
%%
    %----- process of joining close objects, analyse each against its closest object
    minCol                                          = max(1, -2+ floor(statsObjects0(countObjs).BoundingBox(1)));
    maxCol                                          = min(cols,minCol+4+statsObjects0(countObjs).BoundingBox(3));
    minRow                                          = max(1, -2+ floor(statsObjects0(countObjs).BoundingBox(2)));
    maxRow                                          = min(rows,minRow+4+statsObjects0(countObjs).BoundingBox(4));
%%    
   
    currentObject                                   = (BW2(minRow:maxRow,minCol:maxCol)==countObjs);
   % figure(1);surfdat(BW2==countObjs)
   % figure(2);surfdat(currentObject)
    boundariesCurrObj                               = (bwboundaries(currentObject,'noholes'));
    q1                                              = (-(bwdist(currentObject)));
    minq1                                           = min(q1(:));
    q1(1,:)                                         = minq1;q1(:,1)=minq1;q1(end,:)=minq1;q1(:,end)=minq1;
    q2                                              = watershed(q1);
    currObjectLinked                                = ((q2==0)|currentObject);
    boundariesLinkedObj                               = (bwboundaries(currObjectLinked,'noholes'));
    if (size(boundariesCurrObj{1},1)~=size(boundariesLinkedObj{1},1))
        %---boundaries are not the same, therefore link
        XY_current                                  = (boundariesCurrObj{1}(:,2)   + (rows)*(boundariesCurrObj{1}(:,1)-1));
        XY_linked                                   = (boundariesLinkedObj{1}(:,2)   + (rows)*(boundariesLinkedObj{1}(:,1)-1));
        BridgePixels                                = find(~ismember(XY_linked,XY_current));
        numPixelsBridge                             = size(BridgePixels,1);
        if numPixelsBridge<10
            %----- only link for small sections
            for k=1:numPixelsBridge
                currentObject(boundariesLinkedObj{1}(BridgePixels(k),1),  boundariesLinkedObj{1}(BridgePixels(k),2))    = 1;
                %-----dilate up down left right  to create a more solid junction
                currentObject(boundariesLinkedObj{1}(BridgePixels(k),1)+1,boundariesLinkedObj{1}(BridgePixels(k),2))    = 1;
                currentObject(boundariesLinkedObj{1}(BridgePixels(k),1),  boundariesLinkedObj{1}(BridgePixels(k),2)+1)  = 1;
                currentObject(boundariesLinkedObj{1}(BridgePixels(k),1)-1,boundariesLinkedObj{1}(BridgePixels(k),2))    = 1;
                currentObject(boundariesLinkedObj{1}(BridgePixels(k),1),  boundariesLinkedObj{1}(BridgePixels(k),2)-1)  = 1;
            end
            BW3(minRow:maxRow,minCol:maxCol) = BW3(minRow:maxRow,minCol:maxCol) + countObjs*((BW2(minRow:maxRow,minCol:maxCol)==countObjs|(currentObject)));
     else
            BW3(minRow:maxRow,minCol:maxCol) = BW3(minRow:maxRow,minCol:maxCol) +  countObjs*(currentObject);
           
        end
    else
            BW3(minRow:maxRow,minCol:maxCol) = BW3(minRow:maxRow,minCol:maxCol) +  countObjs*(currentObject);
        
    end
end