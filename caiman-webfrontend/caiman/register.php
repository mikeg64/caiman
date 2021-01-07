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
			require_once('classes/captcha_class/captcha.config.php');
			require_once('classes/captcha_class/captcha.class.php');
			$captcha =& new captcha($CAPTCHA_CONFIG);
			if (isset($_POST['image'])) 
			{

				require("registerProc.php");
			}
			else
			{
				require("registerInit.php");
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
