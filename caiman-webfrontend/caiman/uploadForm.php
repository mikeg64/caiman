<!-- Input image upload dialogue Form specified here -->

<p style="text-align: justify;">You can upload an image of maximum size <b>900 kb</b> of the following formats (ONLY) <i>TIFF, BMP, GIF, JPEG, </i> or <i>PNG</i>. The name of the file must <b>ONLY</b> contain letters uppercase and lowercase (<b>a-z, A-Z</b>) and underscore (<b>_</b>). Any other characters such as <b>-, +, %, ^</b> and <b>blank</b> spaces may create problems. A single dot can be used to distinguish the name of the file, from the extension (e.g. Image24_a.jpg is acceptable).
<br />
Press <b>Send file</b> to continue.<br>
<br />
<br /><br />
<!-- The data encoding type, enctype, MUST be specified as below -->
<form enctype="multipart/form-data"
      action="<?php echo $_SERVER['PHP_SELF'] ?>"
      method="post">
      <p><b>Email: <b> <br />
      <input name="user_email" type="text"></p>
      <!-- MAX_FILE_SIZE must precede the file input field -->
      <input     name="MAX_FILE_SIZE" value="1599000" type="hidden">
      <!-- Name of input element determines name in $_FILES array -->
      <p><b>Input image: </b><br />
      <input name="userfile" type="file"> <input value="Send File" type="submit"></p>
</form>
<br />

