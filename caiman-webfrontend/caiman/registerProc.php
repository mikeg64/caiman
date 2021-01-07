<?php

$usersEmail  = $_POST['user_email'];
$toValidate = "validate2.php";



require_once('classes/captcha_class/captcha.config.php');
require_once('classes/captcha_class/captcha.class.php');

	//Initialize the captcha object with our configuration options
	$captcha =& new captcha($CAPTCHA_CONFIG);


if (isset($_POST['image'])) 
{
    switch($captcha->validate_submit($_POST['image'],$_POST['attempt']))
    {

        // form was submitted with incorrect key
        case 0:
            	echo "<script>alert('Invalid Code');</script>";
            	echo '<p><br>Sorry. Your code was incorrect.';
            	echo '<br><br><a href="'.$_SERVER['PHP_SELF'].'">Try AGAIN</a></p>';
            break;

        // form was submitted and has valid key
        case 1:
        	
        	
			require_once('checkExistingEmail2.php');


			//$db = mysql_connect("localhost", "cs6cai_userReg","caimaN2009!");
			//$could_connect=mysql_select_db("cs6cai_userReg",$db);
			//echo $could_connect;
			//$sql3 = "SELECT * FROM registration WHERE email ='$usersEmail'"; 
			// first check that field EMAIL has been filled with a registered name
			//$result = mysql_query($sql3,$db);
			//if ($myrow = mysql_fetch_array($result)) 
                        if (mysql_fetch_array($result)) 
			{
				echo '<p><br>Your email has already been registered. You can use Caiman. ';
			}
			else
			{
				// include the classes for the password and the captcha
				include('classes/password/class.password.php');
				// generate password include uppercase, lowercase & number
				$pas = new password();
				$newPass = $pas->generate() ;
				require("send_email_password.php");

				?>				
				
				


				<?php



			} 
		break;            
	}
}
else 
{
	require("register.php");
}

?>
