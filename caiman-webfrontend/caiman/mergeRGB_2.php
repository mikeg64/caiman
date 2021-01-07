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
		
		if ($imageName)
		{		
			// Before uploading images, check that the email has been registered
			require_once('checkExistingEmail.php');
			if ($myrow = mysql_fetch_array($result)) 
			{
				if (move_uploaded_file($_FILES['userfile']['tmp_name'], $originalImagName)) 
				{
					//Image was uploaded successfully, proceed:
					//    0 check for more images, it can be 3
					//    1 write a text file with same name as image which will contain the email
					//    2 write record with ip address, email, and file name of the user:

					if (!empty($_FILES['userfile2']['tmp_name'])) 
					{
                                             
					     $imageNameB		= basename($_FILES['userfile2']['name']);  	//The name the user provided

					     $uniqueImageNameB		= $usersIP.".".$imageNameB;			//the name + IP address
					     $extendedImageNameB	= $uniqueImageNameB .".caiman.".$algorithmID;	//the name+IP+code+algorithm ID
					     $originalImagNameB		= $uploaddir . $extendedImageNameB;		// add the directory
echo $originalImagNameB;
					     move_uploaded_file($_FILES['userfile2']['tmp_name'], $originalImagNameB);
					} 
					if (!empty($_FILES['userfile3']['tmp_name'])) 
					{
                                             
					     $imageNameC		= basename($_FILES['userfile3']['name']);  	//The name the user provided
					     $uniqueImageNameC		= $usersIP.".".$imageNameC;			//the name + IP address
					     $extendedImageNameC	= $uniqueImageNameC .".caiman.".$algorithmID;	//the name+IP+code+algorithm ID
					     $originalImagNameC		= $uploaddir . $extendedImageNameC;		// add the directory

echo $originalImagNameC;
					     move_uploaded_file($_FILES['userfile3']['tmp_name'], $originalImagNameC);
					} 



									
					require("updateRecord.php"); 

					// Display to which email the results will be sent
					require("uploadSuccessful.ece"); 

					// Delete old files (more than one hour)
					require("clearOldFiles.php"); 
				
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
		  	// description of the algorithm plus reference to publication
		  	require("vesselT.ece"); 		
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
