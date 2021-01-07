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


	  	<!-- description of the registration process -->
		  	
		  	
		  	
       <h1> Registration for Caiman </h1>

		<?php
			$usersEmail  = $_POST['user_email'];
			$newPass  	= $_POST['newPassword'];
			$typedPass  = $_POST['typedPass'];
			//echo $usersEmail; ?> <br /> <?php
			//echo $newPass; ?> <br /> <?php
			//echo $typedPass ?> <br /> <?php
			if (strcmp($newPass,$typedPass)==0)
			{
				// echo "correct pass";
				//$db = mysql_connect("localhost", "cs6cai_userReg","caimaN2009!");
				//$could_connect=mysql_select_db("cs6cai_userReg",$db);
				////echo $could_connect;
				//$sql3 = "INSERT INTO registration (email) VALUES ('$usersEmail')"; 
				//// first check that field EMAIL has been filled with a registered name
				//$result = mysql_query($sql3,$db);


		$link = mysqli_connect("localhost", "cs6cai_userReg","caimaN2009!", "world");

		/* check connection */
		if (mysqli_connect_errno()) {
    		printf("Connect failed: %s\n", mysqli_connect_error());
    		exit();
		}

		

		$query = "INSERT INTO registration (email) VALUES ('$usersEmail')";

		if ($stmt = mysqli_prepare($link, $query)) {

    		/* execute statement */
    		mysqli_stmt_execute($stmt);

    		/* bind result variables */
    		mysqli_stmt_bind_result($stmt, $result);

    		/* fetch values */
    		//while (mysqli_stmt_fetch($stmt)) {
    		//    printf ("%s \n", $result);
    		//}

    		/* close statement */
    		mysqli_stmt_close($stmt);
		}

		/* close connection */
		mysqli_close($link);






				?> Your email has been registered. <br /> <br />You can use Caiman now. <?php



			}
			else
			{
				echo "Incorrect password, please verify.";
			}



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
