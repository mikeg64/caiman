<?php
if ($RImageUploaded == 1)  
{				 
 		$extendedImageNameR	= $uniqueImageName .".RGB_names";			//the name + IP + userEmail
		$originalImagNameR 	= $uploaddir . $extendedImageNameR;			// add the directory
		$extendedImageNameR2	= $uniqueImageName .".userEmail";			//the name + IP + userEmail
		$originalImagNameR2 	= $uploaddir . $extendedImageNameR2;			// add the directory
				$fpR = fopen($originalImagNameR, 'w');
				fwrite($fpR,$allNamesTogether);
			  	fclose($fpR);	
				$fpR2 = fopen($originalImagNameR2, 'w');
				fwrite($fpR2,$usersEmail);
			  	fclose($fpR2);	
}		
		
if ($GImageUploaded == 1)   
{				 
		$extendedImageNameG	= $uniqueImageNameB .".RGB_names";		//the name + IP + userEmail
		$originalImagNameG 	= $uploaddir . $extendedImageNameG;			// add the directory
		$extendedImageNameG2	= $uniqueImageNameB .".userEmail";			//the name + IP + userEmail
		$originalImagNameG2 	= $uploaddir . $extendedImageNameG2;			// add the directory
				$fpG = fopen($originalImagNameG, 'w');
				fwrite($fpG,$allNamesTogether);
			  	fclose($fpG);	
				$fpG2 = fopen($originalImagNameG2, 'w');
				fwrite($fpG2,$usersEmail);
			  	fclose($fpG2);	
}
		
if ($BImageUploaded == 1)  
{				 
		$extendedImageNameB	= $uniqueImageNameC .".RGB_names";		//the name + IP + userEmail
		$originalImagNameB 	= $uploaddir . $extendedImageNameB;			// add the directory
		$extendedImageNameB2	= $uniqueImageNameC .".userEmail";			//the name + IP + userEmail
		$originalImagNameB2 	= $uploaddir . $extendedImageNameB2;			// add the directory
				$fpB = fopen($originalImagNameB, 'w');
				fwrite($fpB,$allNamesTogether);
			  	fclose($fpB);	
				$fpB2 = fopen($originalImagNameB2, 'w');
				fwrite($fpB2,$usersEmail);
			  	fclose($fpB2);	
}			  	
			  	
			  	
				// waiting until file will be locked for writing (1000 milliseconds as timeout) 
				if ($fp = fopen($uploadRecordFile, 'a')) 
				{
					$startTime = microtime();
				  	do 
				  	{
				    	$canWrite = flock($fp, LOCK_EX);
				    	// If lock not obtained sleep for 0 - 100 milliseconds, to avoid collision and CPU load
				    	if(!$canWrite) usleep(round(rand(0, 100)*1000));
				  	} while ((!$canWrite)and((microtime()-$startTime) < 10000));
				
				  	//file was locked so now we can store information
				  	if ($canWrite) 
				  	{
				    	fwrite($fp,date("D d M Y g:i A",time())."; ".$usersIP."; ".$imageName."; ".$usersEmail."\n");
				    	flock($fp,LOCK_UN);
				  	} 
				  	fclose($fp);	
				}





?>				