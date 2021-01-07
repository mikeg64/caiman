<?php
	//$fp2 = fopen($originalImagName2, 'w');
	//fwrite($fp2,$usersEmail);
	//fclose($fp2);	
        $uploadRecordFile 			= "./imageRecord/uploadRecord.txt";
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

                        $usersIP   				= $_SERVER['REMOTE_ADDR'];
                        $useremail              = $_POST['useremail'];
                        $imagefile              = basename( $_FILES['userfile']['name']);
                        $jobtype                = $_POST['jobtype'];

			fwrite($fp,date("D d M Y g:i A",time()).";  ".$jobtype."; ".$usersIP."; ".$imagefile."; ".$useremail." \n");
			flock($fp,LOCK_UN);
		} 
		fclose($fp);	
	}
?>				