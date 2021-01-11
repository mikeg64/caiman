<?php
require_once('iome/iome.php');  //MKG 07/01/2021 only used for the myioservice definition server address and port

$myioservice = new ioservice;
//$myioservice->server = 'suilven.shef.ac.uk';
$myioservice->server = 'alligin.shef.ac.uk';

$myioservice->port = '60000';
$myioservice->id = 0;
$myioservice->method = 2;

//need correct write permission on target path
//$target_path="/var/www/html/uploads/";
//$target_path="/webusers/cs1mkg/public_html/iometest/uploads/";
$target_path="./imageUploads/";
//echo $target_path ;
//echo getcwd();

$timeval = time();
$oldname = $_FILES["userfile"]['name'];
$newname = $timeval . $_FILES["userfile"]['name'];
$_FILES["userfile"]['name']=$newname;

$target_path = $target_path.basename( $_FILES['userfile']['name']); 
//echo $target_path ;

// Before uploading images, check that the email has been registered
require_once('checkExistingEmail2.php');
//if ($myrow = mysql_fetch_array($result))
if (mysql_fetch_array($result)) 
{
	
	if(move_uploaded_file($_FILES['userfile']['tmp_name'], $target_path)) 
	{
		// It has uploaded correctly, proceed with processing and display
	        // display webpage
		require("headC.ece"); 
		require("../topCaiman.ece"); 
                sleep(30);
		?>

		<!-- *******************Display results with Caiman Web Format****************** -->

		<table id="contentContainer" summary="content layout table" cellpadding="0" cellspacing="0" border="0">
		<tr>
		  <!-- // local navigation -->
		  <?php require("../menuNavC.php"); ?>
		  <td id="bodyContainer">
		  <table style="text-align: left; width: 95%; margin-left: auto; margin-right: auto;"
		         border="0" cellpadding="2" cellspacing="2">
		  <tbody>
		    <tr>
		     <center>
			<h1>The file <i> 
                             <?php 
                                  //echo  basename( $_FILES['userfile']['name']); 
                                  echo  $oldname; 

                             ?> </i>
			has been uploaded successfully. <br /> 
			An email with the results will be sent soon.<i>
			  <br />  <br /> 
			</h1>

		     </center>  
		    </tr>
		    </tbody>
		    </table>
		   </td>
		</tr>
		</table>
		</div>
		<!-- footer start -->
		<?php require("../foot.html"); ?>
		<!-- ******************* End of Display results with Caiman Web Format****************** -->

		<?php

		//Image was uploaded successfully, proceed:
		//    1 write a text file with same name as image which will contain the email
		//    2 write record with ip address, email, and file name of the user:
							
		require("updateRecord.php"); 
	        // Delete old files (more than one hour)
		require("clearOldFiles.php"); 


	        //echo "The file ".  basename( $_FILES['userfile']['name']).  " has been uploaded";

		$imagefile = basename( $_FILES['userfile']['name']);
	 	if(!empty($_POST['useremail'])){
	        $useremail = $_POST['useremail'];
	        //echo "The user requesting is ".$useremail."\n\t";

        }
        $jobtype=0;
 	if(!empty($_POST['jobtype'])){
        $jobtype = $_POST['jobtype'];
        //echo "the job requested is ".$jobtype."\n";

        }
	   /*The following lines read the job template xml file*/
	   /*The %items%  in the jobfile content are replaced with
	   the variable parameters*/
	   /*we use the str_replace function to acheive this*/
	   /*str_replace — Replace all occurrences of the search string with the replacement string*/

	 $jobfile = file_get_contents  ( "iocaimanphp.xml");  //MKG 11/01/2020 reverted back to xml because xml reader in Matlab works
        $imagecontents = file_get_contents  ( $target_path);
        $tempjobfile = str_replace("%imagefile%", $imagefile, $jobfile);
        $temptjobfile = str_replace("%useremail%", $useremail, $tempjobfile);
        $jobfile = str_replace("%jobtype%", $jobtype, $temptjobfile);

        //submit the job to the server
        //when the job runs it will pull the binary image file from the ftp server
        //echo $imagefile ;
        //echo $jobtype;
	//$result=(string)setparamdouble($name,(float)$_POST['floatval'],$myioservice);
        submitsimulation($jobfile,$myioservice);
        //during testing we use the request to set up the job
        //this will not delete the directory when the job has completed
		//requestsimulation($jobfile,$myioservice);
		//runrequestedsimulation($jobfile,$myioservice);

	} 
	else
	{
		require("headC.ece"); 
		require("../topCaiman.ece"); 
		?>

		<!-- *******************Email not registered****************** -->

		<table id="contentContainer" summary="content layout table" cellpadding="0" cellspacing="0" border="0">
		<tr>
		  <!-- // local navigation -->
		  <?php require("../menuNavC.php"); ?>
		  <td id="bodyContainer">
		  <table style="text-align: left; width: 95%; margin-left: auto; margin-right: auto;"
		         border="0" cellpadding="2" cellspacing="2">
		  <tbody>
		    <tr>
		     <center>
			<h1>There was an error uploading the file, please try again!.<br /> 
						  <br />  <br /> 
			</h1>
		     </center>  
		    </tr>
		    </tbody>
		    </table>
		   </td>
		</tr>
		</table>
		</div>
		<!-- footer start -->
		<?php require("../foot.html"); ?>
		<!-- ******************* End of Display results with Caiman Web Format****************** -->
<?php
	}
}
else
{
		require("headC.ece"); 
		require("../topCaiman.ece"); 
		?>
		<!-- *******************Email not registered****************** -->

		<table id="contentContainer" summary="content layout table" cellpadding="0" cellspacing="0" border="0">
		<tr>
		  <!-- // local navigation -->
		  <?php require("../menuNavC.php"); ?>
		  <td id="bodyContainer">
		  <table style="text-align: left; width: 95%; margin-left: auto; margin-right: auto;"
		         border="0" cellpadding="2" cellspacing="2">
		  <tbody>
		    <tr>
		     <center>
			<h1>Your email has not been registered.<br />  You need to register your email once.
						  <br />  <br /> 
			</h1>
		     </center>  
		    </tr>
		    </tbody>
		    </table>
		   </td>
		</tr>
		</table>
		</div>
		<!-- footer start -->
		<?php require("../foot.html"); ?>
		<!-- ******************* End of Display results with Caiman Web Format****************** -->

<?php	
}
?>
