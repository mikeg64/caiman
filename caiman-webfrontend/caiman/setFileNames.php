<?php
		//$_SESSION['algorithm'] 	= 'shading';
		//$_SESSION['usersIP']   	= $_SERVER['REMOTE_ADDR'];
		//$_SESSION['time']     	= time();
		$usersIP   			= $_SERVER['REMOTE_ADDR'];
		$usersEmail   			= $_POST[user_email];
		
		// this is the directory where the images will be stored
		$uploaddir			= './imageUploads/';
		$resultsdir			= './imageResults/';

		//this is the file where a record of all users is kept
		$uploadRecordFile 		= "./imageRecord/uploadRecord.txt";

		// There are 2 ways to access this subroutine:
		//			1: **input dialogue ** 	   	no new image has been uploaded,  
		//			2: **Displayed results**   	Display the image and results 
		// 										in this case, $modifyInputImage  exists 
	
		// This is the file manipulation definition of ** NAMES **, 
		//     where the files will be stored and under which names
		//     all images will go to a subdirectory called     /imageUploads/   
		$imageName			= basename($_FILES['userfile']['name']);  	//The name the user provided
		$uniqueImageName		= $usersIP.".".$imageName;			//the name + IP address
		$extendedImageName		= $uniqueImageName .".caiman.".$algorithmID;	//the name + IP + code + algorithm ID
		$originalImagName 		= $uploaddir . $extendedImageName;		// add the directory
		$extendedImageName2		= $uniqueImageName .".userEmail";		//the name + IP + userEmail
		$originalImagName2 		= $uploaddir . $extendedImageName2;		// add the directory
?>