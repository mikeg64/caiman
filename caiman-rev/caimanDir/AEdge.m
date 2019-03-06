
matCommandDir=dir('matCommand');

if size(matCommandDir,1)>2
    %this means that there is a true file besides . and ..
    for counterN=1:size(matCommandDir,1)
       if matCommandDir(counterN).name(1)~='.'
           %b=imread(strcat('matCommand/',matCommandDir(counterN).name));
           scriptName=matCommandDir(counterN).name(1:9);
           imageName=matCommandDir(counterN).name(11:end);
           [s1,s2]=urlwrite(strcat('http://tumour-microcirculation.group.shef.ac.uk/migration/imageUploads/',imageName),'testImage');
          b=imread('testImage');
          if scriptName=='edgeCells'
                [st3,b1a,b2a,b3a]=edgeCells(b(100:end,1:end,:));
               
         else

          end
	  textNameOut=strcat('txt_',imageName(1:end-4),'.jpg');
          [rowsImage,colsImage,xxx]=size(b);
          minDist=st3.minimumDist;
          maxDist=st3.maxDist;
          averDist=st3.avDist;
          coverArea=st3.area(2);
          fid=fopen(textNameOut,'w+');
          fprintf(fid,'%5g\n %5g\n %5g\n %1.2f\n %5g\n %5g\n',rowsImage,colsImage,averDist,coverArea,minDist,maxDist);
          fclose(fid);
         imageNameOut=strcat('out_',imageName);
          imwrite(b1a,imageNameOut,'jpg');
          tmw=ftp('tmc.group.shef.ac.uk','md6tmc','dt5bhwkm');
          cd(tmw,'public_html/migration/imageUploads');
          mput(tmw,imageNameOut);
          mput(tmw,textNameOut);
          close(tmw);
          delete(imageNameOut);
          delete(textNameOut);
          delete(strcat('matCommand/',matCommandDir(counterN).name));
       end
    end
end
