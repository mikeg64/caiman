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
		$algorithmID = "CH";
		require("setFileNames.php"); 
		
		if ($imageName)		
		{

	  	   require_once('classes/class.strings.php');
		   $isValidName =Strings::validateFileName($imageName);
		   if ($isValidName)
		   {

			// Before uploading images, check that the email has been registered
			require_once('checkExistingEmail.php');
			if ($myrow = mysql_fetch_array($result)) 
			{
				if (move_uploaded_file($_FILES['userfile']['tmp_name'], $originalImagName)) 
				{
					//Image was uploaded successfully, proceed:
					//    1 write a text file with same name as image which will contain the email
					//    2 write record with ip address, email, and file name of the user:
									
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
	 		echo '<h1>File name invalid</h1><p><br>The name of the file contains characters that are not allowed.<br> Please resubmit with only A-Z, 0-9 and underscore (_), no spaces, no other characters, only one dot as in <i>Image24.jpg</i>';	
		   }


		}
		else
		{
?>
<tr>
<?php
		  	// description of the algorithm plus reference to publication
		  	require("docs/chromat.ece"); 		
		  	// Here the image is read and uploaded to a local folder
?>
</tr>
<tr>
<td>
<?php
		  	require("uploadFormCH.php"); 	
			?>
</td>
<td style="vertical-align: top;">
			<!-- <br /><br /> -->
			<img src="images/chromaticity.jpg"
			alt="Segmentation of Endothelial Cells from Images Stained through Immunohistochemistry" width="510"> <br>
</td>
</tr>

			<?php

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
