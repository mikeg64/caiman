
<p style="text-align: justify;">  
In order to use the algorithms of the Caiman website, your email has to be validated. Once it is in the database you can use any of the algorithms of the webpage. Once you provide your email, a password will be emailed to you, you should then write this in the validation form to complete the registration. 
</p>
<!-- Input image upload dialogue Form specified here -->

<p style="text-align: justify;">Re-type the code on the image and  Press <b>Submit email</b> to continue.<br>
<br>
<br /><br />
<!-- The data encoding type, enctype, MUST be specified as below -->
   
<?php
	// include the classes for the captcha
	require_once('classes/captcha_class/captcha.config.php');
	require_once('classes/captcha_class/captcha.class.php');
	
	
	//Initialize the captcha object with our configuration options
	$captcha =& new captcha($CAPTCHA_CONFIG);
	$imgLoc = $captcha->create_captcha();
	?>
	<img src="<?php echo $imgLoc;?>" alt="This is a captcha-picture. It is used to prevent mass-access by robots." title=""><br>
	<form name="captcha" action="<?php echo $_SERVER['PHP_SELF'];?>" method="POST">
		<input type="hidden" name="image" value="<?php echo $imgLoc;?>">
		<input type="text" name="attempt" id="attempt" value="" size="20"><br>
		<b>Email: <b><br /> <input name="user_email" type="text"><br />
		<input type="submit" name="insertEmail" value="Submit Email">
	</form>
	
	
	

<br />

