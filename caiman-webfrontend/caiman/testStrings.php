<?php
 	session_start();
	flush();

  	$str1="teAa sdfasdf.jpg";
        $str2="does not comply";
  	require_once('classes/class.strings.php');
	$isValidName =Strings::validateFileName($str1);
	if ($isValidName)
	{
	 	echo $str1; 
	}
	else
	{
	 	echo $str2; 	
	}

?>