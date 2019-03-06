function [dataOut,dataOut2]                 = calculateDataOut(finalRidges,finalStats,dataOut)

% usual dimension check
[rows,cols,levs]                        =   size(dataOut);


%dataOut = dataOut (2:end-1,2:end-1,:);
%%
numRidges                               = size(finalStats,1);
top10                                   = max(1,numRidges-9):numRidges;
top50                                   = max(1,numRidges-49):numRidges-10;
finalRidges_50                          = imdilate(sum(ismember(finalRidges,finalStats(top50,4)),3),ones(2));
finalRidges_10                          = imdilate(sum(ismember(finalRidges,finalStats(top10,4)),3),ones(3));
finalRidges_all                         = (repmat(sum(finalRidges,3),[1 1 3]))>0;

%% Generate the Output image with the traces overlaid



%dataOut2=dataOut;
if isa(dataOut,'uint8')
    if levs>1;
        dataOutOr = dataOut;
        dataOut(:,:,1)                  = dataOutOr(:,:,1).*uint8(1-(finalRidges_50|finalRidges_10)) + uint8(finalRidges_10)*max(dataOut(:));
        dataOut(:,:,2)                  = dataOutOr(:,:,2).*uint8(1-(finalRidges_50|finalRidges_10)) + uint8(finalRidges_50)*max(dataOut(:));
        dataOut(:,:,3)                  = dataOut(:,:,3).*uint8(1-(finalRidges_50|finalRidges_10));


      %  dataOut(:,:,1)                  = dataOut(:,:,1).*uint8(1-finalRidges_10)  + uint8(finalRidges_10)*0.9*min(dataOut(:));
      %  dataOut(:,:,2)                  = dataOut(:,:,2).*uint8(1-finalRidges_50)  + uint8(finalRidges_50)*1.1*max(dataOut(:));
        dataOut2                        = dataOut;
        dataOut2                        = dataOut2.*uint8(1-finalRidges_all)  ;
    else
        dataOutOr = dataOut;

        dataOut(:,:,3)                  = dataOutOr;
        dataOut(:,:,2)                  = dataOutOr;
        
        dataOut(:,:,1)                  = dataOutOr.*uint8(1-(finalRidges_50|finalRidges_10)) + uint8(finalRidges_10)*max(dataOut(:));
        dataOut(:,:,2)                  = dataOutOr.*uint8(1-(finalRidges_50|finalRidges_10)) + uint8(finalRidges_50)*max(dataOut(:));
        dataOut(:,:,3)                  = dataOut(:,:,3).*uint8(1-(finalRidges_50|finalRidges_10));
        
        dataOut2                        = dataOut;
        dataOut2                        = dataOut2.*uint8(1-finalRidges_all(:,:,:)) ;

       % dataOut(:,:,3)                  = dataOut;
       % dataOut(:,:,1)                  = dataOut(:,:,1).*uint8(1-finalRidges_10)  + uint8(finalRidges_10)*1.1*max(dataOut(:));
       % dataOut(:,:,2)                  = dataOut(:,:,1).*uint8(1-finalRidges_50)  + uint8(finalRidges_50)*0.9*min(dataOut(:));
       % dataOut2                        = dataOut;
       % dataOut2                        = dataOut2.*uint8(1-finalRidges_all(:,:,:)) ;
    end
else
    if levs>1;
        dataOutOr = dataOut;

        dataOut(:,:,1)                  = dataOutOr(:,:,1).*(1-(finalRidges_50|finalRidges_10)) + uint8(finalRidges_10)*max(dataOut(:));
        dataOut(:,:,2)                  = dataOutOr(:,:,2).*(1-(finalRidges_50|finalRidges_10)) + uint8(finalRidges_50)*max(dataOut(:));
        dataOut(:,:,3)                  = dataOut(:,:,3).*(1-(finalRidges_50|finalRidges_10));

        dataOut(:,:,1)                  = dataOut(:,:,1).*(1-finalRidges_10)  + (finalRidges_10)*0.9*min(dataOut(:));
        dataOut(:,:,2)                  = dataOut(:,:,2).*(1-finalRidges_50)  + (finalRidges_50)*1.1*max(dataOut(:));
        dataOut2                        = dataOut;
        dataOut2                        = dataOut2.*uint8(1-finalRidges_all)  ;
    else

        dataOut(:,:,3)                  = dataOutOr;
        dataOut(:,:,2)                  = dataOutOr;
        
        dataOut(:,:,1)                  = dataOutOr.*(1-(finalRidges_50|finalRidges_10)) + uint8(finalRidges_10)*max(dataOut(:));
        dataOut(:,:,2)                  = dataOutOr.*(1-(finalRidges_50|finalRidges_10)) + uint8(finalRidges_50)*max(dataOut(:));
        dataOut(:,:,3)                  = dataOut(:,:,3).*(1-(finalRidges_50|finalRidges_10));
        
        dataOut2                        = dataOut;
        dataOut2                        = dataOut2.*(1-finalRidges_all(:,:,:)) ;


      %  dataOut(:,:,3)                  = dataOut;
      %  dataOut(:,:,1)                          = dataOut(:,:,1) .*(1-finalRidges_10)  + (finalRidges_10)*1.1*max(dataOut(:));
      %  dataOut(:,:,2)                          = dataOut(:,:,1) .*(1-finalRidges_50)  + (finalRidges_50)*0.9*min(dataOut(:));
      %  dataOut2                        = dataOut;
      %  dataOut2                        = dataOut2.*(1-finalRidges_all(:,:,:)) ;

    end
end
