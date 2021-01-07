<?php 	session_start(); ?>
	

<?php	
	flush();
	require("headC.ece"); 
	require("../top.ece"); 
	
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
		$algorithmID = "PE";
		require("setFileNames.php"); 
		
		if ($imageName)		
		{
			if (move_uploaded_file($_FILES['userfile']['tmp_name'], $originalImagName)) 
			{
				//Image was uploaded successfully, proceed:
				//    1 write a text file with same name as image which will contain the email
				//    2 write record with ip address, email, and file name of the user:
								
				require("updateRecord.php"); 
				require("uploadSuccessful.ece"); 
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
		  	// description of the algorithm plus reference to publication
		  	require("docs/permeability.ece"); 		
		  	// Here the image is read and uploaded to a local folder
		  	//require("uploadForm.php"); 	
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
