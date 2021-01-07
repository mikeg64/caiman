<?php 	session_start(); ?>
	

<?php	
	flush();
	require("headC.ece"); 
	require("../topCaiman.ece"); 
	
?>

<!-- Local Content -->

<table id="contentContainer" summary="content layout table" cellpadding="0" cellspacing="0" border="0">
<tr>
  <!-- // local navigation -->
  <?php require("../menuNavC.php"); ?>

  <td id="bodyContainer">

  <table style="text-align: left; width: 95%; margin-left: auto; margin-right: auto;"
         border="0" cellpadding="2" cellspacing="2">
  <tbody>
    <tr>
       <td style="vertical-align: top;">
       <div style="text-align: justify;"> </div>
       <br>


<?php
		//		------------------------- Specific Webpage Code -------------------------------
		$algorithmID = "ME";
		require("setFileNames.php"); 

	     $imageNameB		    = basename($_FILES['userfile2']['name']);  	//The name the user provided
	     $imageNameC		    = basename($_FILES['userfile3']['name']);  	//The name the user provided

		
		if (($imageName)||($imageNameB)||($imageNameC)  )
		{

	  	   require_once('classes/class.strings.php');
		   $isValidName =Strings::validateFileName($imageName);
		   if ($isValidName)
		   {
		
			// Before uploading images, check that the email has been registered
			require_once('checkExistingEmail.php');
			if ($myrow = mysql_fetch_array($result)) 
			{
	             $RImageUploaded      = 0;
	             $GImageUploaded      = 0;
	             $BImageUploaded      = 0;

			     $uniqueImageNameB		= $usersIP.".".$imageNameB;			//the name + IP address
			     $extendedImageNameB	= $uniqueImageNameB .".caiman.".$algorithmID;	//the name+IP+code+algorithm ID
			     $originalImagNameB		= $uploaddir . $extendedImageNameB;		// add the directory

			     $uniqueImageNameC		= $usersIP.".".$imageNameC;			//the name + IP address
			     $extendedImageNameC	= $uniqueImageNameC .".caiman.".$algorithmID;	//the name+IP+code+algorithm ID
			     $originalImagNameC		= $uploaddir . $extendedImageNameC;		// add the directory
			     $allNamesTogether 	    = '';
				if (move_uploaded_file($_FILES['userfile']['tmp_name'],  $originalImagName)) 
				{
	 				$RImageUploaded =1;
				    $allNamesTogether 	    = $allNamesTogether.'@R@'.$originalImagName;
				}
				if (move_uploaded_file($_FILES['userfile2']['tmp_name'], $originalImagNameB)) 
				{		 
					$GImageUploaded =1;    
				    $allNamesTogether 	    = $allNamesTogether.'@G@'.$originalImagNameB;
				    				}
				if (move_uploaded_file($_FILES['userfile3']['tmp_name'], $originalImagNameC)) 
				{		 
					$BImageUploaded =1;
				    $allNamesTogether 	    = $allNamesTogether.'@B@'.$originalImagNameC;
				}
				if (($RImageUploaded == 1)||($GImageUploaded == 1) ||($BImageUploaded == 1)  )
				{				 
         			//AT least one image  was uploaded successfully, proceed:
					//    0 check for more images, it can be 3
					require("saveRGBNames.php");
					//    1 write a text file with same name as image which will contain the email
					//    2 write record with ip address, email, and file name of the user:
					//require("updateRecord.php"); 
					// Display to which email the results will be sent
					require("uploadSuccessful.ece"); 
					// Delete old files (more than one hour)
					require("clearOldFiles.php"); 
					//echo $allNamesTogether;
			    }					 
				
				else
				{
					// upload un successful. try again
					require("uploadUnSuccessful.ece"); 
				}
			}
			else
			{
				//echo $usersEmail;
				echo '<p><br>Your email has not been registered. You need to register your email once. ';
				//echo $myrow;
				//echo $result;
			}



		   }
		   else
		   {
	 		echo '<h1>File name invalid</h1><p><br>The name of the file contains characters that are not allowed.<br> Please resubmit with only A-Z, 0-9 and underscore (_), no spaces, no other characters, only one dot as in <i>Image24.jpg</i>';	
		   }

		}

		else
		{
		  	// description of the algorithm plus reference to publication
		  	require("docs/mergeRGB.ece"); 		
		  	// Here the image is read and uploaded to a local folder
		  	require("uploadForm3.php"); 	
		}
		//		------------------------- Specific Webpage Code -------------------------------
	  	?>


    		
	  </td>
    </tr>
    </tbody>
    </table>
</tr>
</table>

</div>
<!-- // Local Content -->
<!-- footer start -->

<?php require("../foot.html"); ?>

<br>
<br>
</body>
</html>
