
function dataOut = removeLineArtifact(dataIn)


%%
[rows,cols,levs]=size(dataIn);

if levs>3
    dataIn=(dataIn(:,:,1:3));
    levs=3;
end
%R=1:rows;
%C=1:cols;

%analyse per orientation, but only do it for the  central region, discard 5 lines/columns at the edges

data2= dataIn(7:end-6,7:end-6,:);

for k=1:levs
    % rows have to be split into odd and even frames
    rMeanData11 = (mean(data2(1:2:end,:,k),2));
    rMeanData12 = (mean(data2(2:2:end,:,k),2));

    rMeanData21 = diff(rMeanData11);
    rMeanData22 = diff(rMeanData12);

    %detect peaks at +-3std

    rPeaksLevel = 3*std([rMeanData21;rMeanData22]);

    rMeanData31 = rMeanData21.*((rMeanData21>rPeaksLevel)|(rMeanData21<-rPeaksLevel));
    rMeanData32 = rMeanData22.*((rMeanData22>rPeaksLevel)|(rMeanData22<-rPeaksLevel));


    %To correct the artifact down the rows, add inverted signal:


    rCorrFactor1= cumsum([zeros(4,1) ;rMeanData31;zeros(3,1)])*ones(1,cols);
    rCorrFactor2= cumsum([zeros(4,1) ;rMeanData32;zeros(3,1)])*ones(1,cols);


    dataOut(1:2:rows,:,k)   = (double(dataIn(1:2:end,:,k))-rCorrFactor1);
    dataOut(2:2:rows,:,k)   = (double(dataIn(2:2:end,:,k))-rCorrFactor2);
    %% now deal with the artefacts in the columns

    %cMeanData1 = (mean(data2(:,:,k),1));
    %cMeanData2 = diff(cMeanData1);


    %cPeaksLevel = 3*std(cMeanData2);
    %cMeanData3  = cMeanData2.*((cMeanData2>cPeaksLevel)|(cMeanData2<-cPeaksLevel));
    %cCorrFactor = ones(rows,1)*[zeros(1,6)  cMeanData3 zeros(1,7)];


    dataOutLPF = imfilter(dataOut(:,:,k),gaussF(2,5,1),'replicate');
    cMeanData1 = (mean(dataOut(:,:,k),1));
    cMeanData2 = (mean(dataOutLPF,1))-cMeanData1;


    cPeaksLevel = 3*std(cMeanData2);

    cMeanData3  = cMeanData2.*((cMeanData2>cPeaksLevel)|(cMeanData2<-cPeaksLevel));

    cCorrFactor = ones(rows,1)*cMeanData3;

    dataOut(:,:,k)          = dataOut(:,:,k)  + cCorrFactor;
    dataOut(:,:,k) = imfilter(dataOut(:,:,k),gaussF(3,3,1),'replicate');

end


dataOut(dataOut>255)=255;
dataOut(dataOut<0)=0;

 
if isa(dataIn,'uint8')
    dataOut=uint8(dataOut);
end


% %%
% figure(1)
% imagesc(dataO2(:,:,1:3))
% figure(2)
% imagesc(CarlosLine3(:,:,1:3))

%plot(mean(CarlosLine3(2:2:end,:,1)))