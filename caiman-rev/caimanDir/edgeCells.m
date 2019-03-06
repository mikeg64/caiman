function [Res_stats,Res_colour,Res_gray,Res_Cells]=edgeCells(dataIn,toPlot);
%function [Res_stats,Res_colour,Res_gray,Res_Cells]=edgeCells(dataIn,toPlot);
%
%-------- this function plots a 3D group of tracks that have been generated with trackRBC.m
%-------------------------------------------------------------------------------------
%------  Author :   Constantino Carlos Reyes-Aldasoro                       ----------
%------             Postdoc  Sheffield University                           ----------
%------             http://tumour-microcirculation.group.shef.ac.uk         ----------
%------  27 November 2007   ---------------------------
%----------------------------------------------------
% input data:       dataIn: an image with cells or the name of an image to be read
% output data:      areaCovered     [total;relative] between boundaries of the cells
%                   Res_colour      an image equal to dataIn but with the area highlighted
%                   errT            [A;B;A+B] error of approximation of straight lines

%------ no input data is received, error -------------------------
%------ at least 2 parameters are required
if nargin <1     help edgeCells; areaCovered=[]; return;  end;
%tic;
if ~exist('toPlot') toPlot=0; end
%------ arguments received revision   ----------------------------
if isa(dataIn,'char')
    b=imread(dataIn);
    fname=dataIn;
else
    b=dataIn;
    fname='Image';
end
%t0=toc;tic;
%fname='6control1.bmp';
%fname=   'Image16.bmp';

%b=imread('6control1.bmp');
%b=imread('Image16.bmp');
%b=imread('6Image3.bmp');
%b=imread('6control3.bmp');

%------ usual dimension check
[rows,cols,levs]    = size(b);

%------ three filters to be used  f1=HPF, f2,f3=LPF
f1                  = gaussF(rows,cols,1,floor(rows/50),floor(cols/50),1,floor(rows/2),floor(cols/2),1);
f1                  = f1/max(f1(:));
f2                  = gaussF(15,15,1);
f3                  = gaussF(3,3,1);

%bGrey=double(rgb2gray(b));

%------ transform into Fourier to High Pass Filter
bf                  = fftshift(fft2(double(b)));
%bf                  = fftshift(fft2((bGrey)));

%----- inverse transform filtered signals
bHP1a               = abs(ifft2(((1-f1).*bf(:,:,1))));
bHP2a               = abs(ifft2(((1-f1).*bf(:,:,2))));
bHP3a               = abs(ifft2(((1-f1).*bf(:,:,3))));

%----- LPF the filtered signals as a Local Energy Function to consolidate the variation
bHP1                = conv2(bHP1a,f2,'same');
bHP2                = conv2(bHP2a,f2,'same');
bHP3                = conv2(bHP3a,f2,'same');

%----- remove minimum and combine 3 colour layers
bHP1                = (bHP1-min(bHP1(:)))+(bHP2-min(bHP2(:)))+(bHP3-min(bHP3(:)));
%----- Crop edges to avoid boundary conditions
bHP1                = bHP1(20:end-19,20:end-19);
%t1=toc;tic;

%----- To determine a threshold level for the segmentation two methods are used:
%-----   a) calculate the histogram and find the first local minimum; it should be a good estimate
%-----        of the separation of background/objects
%-----   b) that boundary that contains 85% of the pixels of the image
%----- Use the lower of the two
% 
% %-----  b) histogram and 85%
% levThres            = 0.85;
% [y1,x1]             = hist(bHP1(:),150); 
% yy1= cumsum(y1)/sum(y1);
% y1_85               = yy1>levThres;
% xx1                 = ceil(x1(y1_85>0));
% 
% %-----  Use a quad tree to reduce size and consolidate means
% [y1,x1]=hist2d(reduceu(bHP1(1:2.^floor(log2(rows)),1:2.^floor(log2(cols))),6),30,0);
% %-----  a) first local minimum (after peak of pixels around zero)
% y1diff              = diff(y1);         ydif1               = sign(y1diff);
% ydif_plus1          =(ydif1==1);        ydif_minus1         =(ydif1==-1);ydif_zero           =(ydif1==0);
% ydif_11             =ydif_plus1(2:end)+ydif_minus1(1:end-1);ydif_101            =ydif_plus1(3:end)+ydif_zero(2:end-1)+ydif_minus1(1:end-2);
% 
% %ydif_1to1           = (-ydif1(1:end-1) +ydif1(2:end));
% xdif1               = find(ydif_11==2);xdif2               = find(ydif_101==3);
% %ydif_1to0to1        = (-ydif1(1:end-2) +ydif1(2:end));
% if numel(xdif1)==0
%     %-----  b) histogram and 85%
%     levThres            = 0.65;    [y1,x1]             = hist(bHP1(:),150);    yy1= cumsum(y1)/sum(y1);    y1_85               = yy1>levThres;    xx1                 = ceil(x1(y1_85>0));    xdif2=xx1(1);
% end
% if numel(xdif2)==0    xdif2=x1(end-1);end
% 
% 
% %----- Threshold to be used
% %thres               = min(xx1(1),ceil(x1(xdif1(1)+2)));
% thres               = ceil(x1(min(xdif1(1),xdif2(1))+2));

%when the QT is constructed, it is necessary to use a 2^n dimension to avoid averaging with edge artifacts
%therefore, generated a linspace between first and last point of bHP1 (it is different from input!) of  2^n dims
[rowsbHP1,colsbHP1]=size(bHP1);
rowVector=linspace(1,rowsbHP1,2.^floor(log2(rowsbHP1)));
colVector=linspace(1,colsbHP1,2.^floor(log2(colsbHP1)));
reduced_bHP1=interp2(bHP1,colVector,rowVector');
min_bHP1=min(reduced_bHP1(:));
reduced_bHP1=reduced_bHP1-min_bHP1;
max_bHP1=max(reduced_bHP1(:));
reduced_bHP1=reduced_bHP1/max_bHP1;

%better to use the average of Otsu's method for   several levels of QT.
for k=3:6
    thres2(k-2)=graythresh(reduceu(reduced_bHP1,k));
    %thres3(k-2)=255*graythresh(reduceu(bHP1(1:2.^floor(log2(rows)),1:2.^floor(log2(cols))),k)/255);
end
thres2=thres2*max_bHP1+min_bHP1;
thres=min(thres2);


%----- Binary image that captures cells due to high frequency variation
bCELLS(:,:,1)       = (bHP1>(thres));

%----- Find the main orientation of the 'gap' in the cells, 
%----- this will be used to create oriented morphological operators
angleRange=[0:10:179];
[TraceCells]=traceTransform(bCELLS(1:4:end,1:4:end),angleRange,[-1 1]);
%----- the main orientation will be given by the angle with MAXIMUM variation
%t2=toc;tic;

for k=1:18
    ttt=squeeze(TraceCells(:,k,9));             % this trace contains the average value of the trace
    ttt(squeeze(TraceCells(:,k,11))==0)=[];      % this discards those positions outside the image
    tracesStd(k)=std(ttt);                          % get Std as an indication of variation
end
[maxVar,indVar]=max(tracesStd);
angOrientation=angleRange(indVar);

sizeOperator=max(10,round(min(rows,cols)/40));
SE01=strel('line',sizeOperator,angOrientation);
SE02=strel('line',sizeOperator,90+angOrientation);

%----- expand the structural element 
nhood1=getnhood(SE01);
nhood1=(conv2(double(nhood1),gaussF(3,3,1))>0);
nhood2=getnhood(SE02);
nhood2=(conv2(double(nhood2),gaussF(3,3,1))>0);

SE2=strel(nhood2);      %----- this is parallel to the cut of the cells
SE1=strel(nhood1);      %-----     this is perpendicular               


%----- the image is morphologically 'closed' to fill in holes and gaps
%[RadCells2]        = floor(100*conv2(radon(bCELLS,[0:180]),f3,'same'));
%Peaks_RadCells2    = houghpeaks(RadCells2,1);
%SE0=strel('line',floor(min(rows,cols)/20),90+(Peaks_RadCells2(1,2)));
%bCELLS2             = (imclose(bCELLS,strel('disk',5)));
bCELLS2             = (imclose(bCELLS,SE2));
bCELLS2             = (imclose(bCELLS2,SE1));
bCELLS2a            = imfill(bCELLS2,'holes');
%----- The eroding element must be oriented with respect to main orientation of bCELLS2
%----- Then it is eroded considerably to generate 2 main regions, and leave open space between
%----- it may be the case that imfill fills the whole image, do not use in that case
if sum(bCELLS2a(:))==(rows*cols)
    %bCELLS3             = (imopen(bCELLS2,strel('rectangle',[40,10])));
    bCELLS3             = (imopen(bCELLS2,SE1));
%    bCELLS3=bCELLS2;
else
    %bCELLS3             = (imopen(bCELLS2a,strel('rectangle',[40,10])));
    bCELLS3             = (imopen(bCELLS2a,SE1));
%    bCELLS3=bCELLS2a;
end
%bCELLS3             = (imopen(bCELLS3 ,strel('rectangle',[10,40])));
%bCELLS3             = (imopen(bCELLS3,SE2));
%----- The edges of the region are obtained
bCELLS4             = zerocross(bCELLS3-0.5);
%----- a small blur is used to get a better estimation later on
bCELLS5             = conv2(double(bCELLS4),f3,'same');
%----- all edges are labeled to find the longest two which should be the boundaries of the regions
bCELLS6             = bwlabel(bCELLS5>0);
rp6                 = regionprops(bCELLS6,'majoraxislength','perimeter');
[in1,in2]           = sort([rp6.MajorAxisLength]);
%----- keep only the two largest lines and thin them with a Skeleton
bCELLS7a            = bwmorph(bCELLS6==in2(end),'skel',Inf);
bCELLS7b            = bwmorph(bCELLS6==in2(end-1),'skel',Inf);
%----- pad the results to compensate for the earlier crop
bCELLS8a            = padData(bCELLS7a,19,[2 2],1);
bCELLS8b            = padData(bCELLS7b,19,[2 2],1);
%t3=toc;tic;

%----- this process will obtain the sets that describe the coordinates of the boundaries previously obtained
%----- find determines the non-zero elements (sequential) and these are rearranged into rows and columns
xyCELLSa            = find(bCELLS8a);
rowsA               = 1+floor(xyCELLSa/rows);
colsA               = rem(xyCELLSa-1,rows)+1;
xyCELLSb            = find(bCELLS8b);
rowsB               = 1+floor(xyCELLSb/rows);
colsB               = rem(xyCELLSb-1,rows)+1;

%----- in order to find the distance between each pair of points points are repeated into two matrices:
%-----  [[n,1] [n,1] [n,1] ...   ]  for A  and [[1,m] [1,m] [1,m] ...   ] for B
matRA               = repmat(rowsA,[1,size(rowsB,1)]);
matCA               = repmat(colsA,[1,size(rowsB,1)]);
matRB               = repmat(rowsB',[size(rowsA,1),1]);
matCB               = repmat(colsB',[size(rowsA,1),1]);

%----- distance matrix is calculated
distBetPoints       = sqrt(((matRA-matRB).^2)+((matCA-matCB).^2  ) );
%----- minimum distance between lines is calculated
[minimumDist1,q1]       = min(distBetPoints);
[minimumDist2,q3]       = min(distBetPoints');

[minimumDist,q2]        = min(minimumDist1);
%----- maximum distance (of the minimum set is calculated (if needed)
maxDist                 = max([max(min(distBetPoints)) max(min(distBetPoints'))   ]);
Res_stats.minimumDist   = minimumDist;
Res_stats.maxDist       = maxDist;
Res_stats.avDist        = mean([minimumDist1 minimumDist2]);
%t4=toc;tic;

%--------------- Image of boundaries is transformed with a Radon to estimate strongest lines
%[R3,xp]             = radon(bCELLS5(1:end,1:end),[0:180]);
[R3,xp]             = radon(bCELLS7a(1:end,1:end),[0:180]);
R2                  = conv2(R3,gaussF(3,3,1),'same');
R1                  = floor(R2*100);
%----- P will contain the 2 strongest peaks from the Radon transform which correspond to 2
%----- straight lines that best adjusted to the lines of bCELLS5 in the format [dist1 ang1;dist2 ang2]
P(1,:)              = houghpeaks(R1,1);
[R3,xp]             = radon(bCELLS7b(1:end,1:end),[0:180]);
R2                  = conv2(R3,gaussF(3,3,1),'same');
R1                  = floor(R2*100);
%----- P will contain the 2 strongest peaks from the Radon transform which correspond to 2
%----- straight lines that best adjusted to the lines of bCELLS5 in the format [dist1 ang1;dist2 ang2]
P(2,:)              = houghpeaks(R1,1);

if size(P,1)<2
    beep;
    warning('Only one line obtained from the Radon transform, things may not be right');
else
    %---- everything in the Radon is calculated and rotated with respect to the centre:
    c0          = floor(cols/2);
    r0          = floor(rows/2);
    %---- the distance FROM CENTRE is calculated
    distA       = xp(P(1,1));%c0-(P(1,1)+min(xp));
    distB       = xp(P(2,1));%c0-(P(2,1)+min(xp));
    %---- angles of rotation of each line
    thetaA      = -pi*P(1,2)/180;
    thetaB      = -pi*P(2,2)/180;
    %----- Rotation Matrices for each line
    matRotA     = [cos(thetaA) sin(thetaA); -sin(thetaA) cos(thetaA)];
    matRotB     = [cos(thetaB) sin(thetaB); -sin(thetaB) cos(thetaB)];
    %----- Each line will be rotated to approximate it to the lines from the transform
    t_A         = [matRotA*[rowsA-c0 colsA-r0]']';
    t_B         = [matRotB*[rowsB-c0 colsB-r0]']';
    %----- estimate approximate error to the lines of the transform
    errA1       = ((t_A(:,1)      -distA));
   % errA2       = ((t_A(:,1)      -distB));
    errB1       = ((t_B(:,1)      -distB));
    %errB2       = ((t_B(:,1)      -distA));
    %----- adjust one line to its closest set of points
    %if ((mean(abs(errA1)))>(mean(abs(errA2))))&((mean(abs(errB1)))>(mean(abs(errB2))))
    %    errA    = errA2;
    %    errB    = errB2;
    %elseif ((mean(abs(errA1)))<(mean(abs(errA2))))&((mean(abs(errB1)))<(mean(abs(errB2))))
        errA    = errA1;
        errB    = errB1;
    %else
    %    beep;
    %end
    %----- total errors
    errTotA     = mean(abs(errA));
    errTotB     = mean(abs(errB));
    errT        = [errTotA;errTotB;errTotA+errTotB];
    %[errTotA errTotB errT]

    %----- if errors are substracted, the lines should be straight
    t_A2(:,1)   = t_A(:,1)-errA;
    t_A2(:,2)   = t_A(:,2);
    t_B2(:,1)   = t_B(:,1)-errB;
    t_B2(:,2)   = t_B(:,2);
    %----- de-rotate to create lines for plot
    matRotA2    = [cos(-thetaA) sin(-thetaA); -sin(-thetaA) cos(-thetaA)];
    matRotB2    = [cos(-thetaB) sin(-thetaB); -sin(-thetaB) cos(-thetaB)];
    %----- the new lines to be used for the plot
    t_AA        = [matRotA2*t_A2']' +repmat([c0 r0],size(t_A2,1),1);
    t_BB        = [matRotB2*t_B2']' +repmat([c0 r0],size(t_B2,1),1);
end

%plot(P(:,2),P(:,1),'s','color','green')
Res_stats.error     = errT;
%t5=toc;tic;

%----- calculate the area between lines. The Lines should not intersect (they come from a bwlabel)
%----- but they can have small holes inside so blurr to thicken, then label the complement to obtain areas
Area2A          = bwlabel(1-(conv2(double(bCELLS7a),f3,'same')>0));
Area2B          = bwlabel(1-(conv2(double(bCELLS7b),f3,'same')>0));
%------ there are 4 combinations, one should be an empty set, the common area is the complement to that
A1_B1           = sum(sum((Area2A==1)&(Area2B==1)));
A1_B2           = sum(sum((Area2A==1)&(Area2B==2)));
A2_B1           = sum(sum((Area2A==2)&(Area2B==1)));
A2_B2           = sum(sum((Area2A==2)&(Area2B==2)));
%------ determine which combination is the empty one and pad with SAME to get final area
if A1_B1==0
    commonArea  = padData((Area2A==2)&(Area2B==2),19,[2 2],1);
elseif A1_B2==0
    commonArea  = padData((Area2A==2)&(Area2B==1),19,[2 2],1);
elseif A2_B1==0
    commonArea  = padData((Area2A==1)&(Area2B==2),19,[2 2],1);
elseif A2_B2==0
    commonArea  = padData((Area2A==1)&(Area2B==1),19,[2 2],1);
end

%------ calculate area covered between lines
totArea         = sum(commonArea(:));relArea=totArea/rows/cols;
areaCovered     = [totArea;relArea];
Res_stats.area      = areaCovered;
%------ merge commonArea with original image to plot
Res_colour      = b;Res_colour(:,:,3)=Res_colour(:,:,3).*(1+0.5*uint8(commonArea));
Res_gray        = double(sum(Res_colour(:,:,:),3)).*(1-0.5*(commonArea));

%----overlay lines on image

for k=1:size(rowsB,1)
     Res_colour(colsB(k),rowsB(k),:)=[255 255 255];
end
for k=1:size(rowsA,1)
     Res_colour(colsA(k),rowsA(k),:)=[255 255 255];
end
slopeM=(rowsA(q1(q2))-rowsB(q2))/(colsA(q1(q2))-colsB(q2));
interceptB=rowsB(q2)-slopeM*colsB(q2);

tabPoints=max(abs((rowsA(q1(q2))-rowsB(q2))),abs( colsA(q1(q2))-colsB(q2)  )  );
xxx=linspace(colsB(q2),colsA(q1(q2)),tabPoints);
yyy=linspace(rowsB(q2),rowsA(q1(q2)),tabPoints);

for k=1:tabPoints
Res_colour(round(xxx(k)),round(yyy(k)),:)=[255 0 0 ];
end





if toPlot==1
    titName         = strcat('Image: ',fname,'. Area covered:  ',num2str(relArea,3), '[%], Minimum Distance: ',num2str(minimumDist,4),' [pix]');
    %--------------- Plotting of first figure in colour
    figure
    hold off
    imshow(Res_colour);title(titName,'fontsize',15)
    hold on
    %--------------- Boundaries found
    plot(rowsA,colsA,'w.');plot(rowsB,colsB,'y.')
    %--------------- Line of minimum distance
    plot([rowsA(q1(q2)) rowsB(q2)],[colsA(q1(q2)) colsB(q2)],'b') ;
    %--------------- Lines estimated from Radon
    if size(P,1)==2
        plot(t_AA(:,1),t_AA(:,2),'r');
        plot(t_BB(:,1),t_BB(:,2),'m');
    end

    figure
    hold off
    surfdat(Res_gray);title(titName,'fontsize',15);colormap(gray);
    hold on
    %--------------- Lines estimated from Radon
    if size(P,1)==2
        plot(t_AA(:,1),t_AA(:,2),'k');
        plot(t_BB(:,1),t_BB(:,2),'k');
    end%--------------- Boundaries found
    plot(rowsA,colsA,'wo','markersize',2);plot(rowsB,colsB,'wo','markersize',2);
    %--------------- Line of minimum distance
    plot([rowsA(q1(q2)) rowsB(q2)],[colsA(q1(q2)) colsB(q2)],'-o','linewidth',3,'color',0.72*[1 1 1],'markersize',9) ;

    axis equal
    axis tight

end

Res_Cells(:,:,1)=bHP1;
Res_Cells(:,:,2)=bCELLS;
Res_Cells(:,:,3)=bCELLS2;
Res_Cells(:,:,4)=bCELLS2a;
Res_Cells(:,:,5)=bCELLS3;
Res_Cells(:,:,6)=bCELLS4;
Res_Cells(:,:,7)=bCELLS5;
Res_Cells(:,:,8)=bCELLS6;
Res_Cells(:,:,9)=bCELLS7a;
Res_Cells(:,:,10)=bCELLS7b;
%Res_Cells(:,:,11)=bCELLS8a;
%Res_Cells(:,:,12)=bCELLS8b;
%t6=toc;tic;

 clear a* A* x* t* r* q* n* e* f* i* k* l* m* c* S* T* b* d* P* R1 R2 R3 s*
%[t0 t1 t2 t3 t4 t5 t6]
