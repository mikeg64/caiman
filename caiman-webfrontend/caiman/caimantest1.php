<html>
 <head>
  <title>CAIMAN PHP Test</title>
 </head>
 <body>


<?php echo '<p>This is the CAIMAN test.</p>';  


//phpinfo();

echo $_SERVER['HTTP_USER_AGENT'];
?>

<?php
if (strpos($_SERVER['HTTP_USER_AGENT'], 'Mozilla') !== FALSE) {
    echo 'You are using Mozilla.<br />';
}
?>

<form enctype="multipart/form-data"
      action="submitcaimanjob.php"
      method="post">
      <p><b>Email: <b> <br />
      <input name="useremail" type="text"></p>
      <!-- MAX_FILE_SIZE must precede the file input field -->
      <input     name="MAX_FILE_SIZE" value="2000000" type="hidden">
      <!-- Name of input element determines name in $_FILES array -->
      <p><b>Input image: </b><br />
      <input name="userfile" type="file"><br />
        MergeRGBChannels...........:
	<input type="radio"
	name="jobtype" value="ME">
	<br>
	Shading Correction.........:
	<input type="radio" name="jobtype" value="SH">
	<br>
	Migration..................:
	<input type="radio" name="jobtype" value="MI">
	<br>
	Scale Space Dimensions.....:
	<input type="radio" name="jobtype" value="VT">
	<br>
 
      <input value="Send File" type="submit"></p>
</form>


 </body>
</html>
