<?php

			//$db = mysql_connect("localhost", "cs6cai_userReg","caimaN2009!");
			//$could_connect=mysql_select_db("cs6cai_userReg",$db);

 			//$useremail = $_POST['useremail'];
			//$sql3 = "SELECT * FROM registration WHERE email ='$useremail'"; 
			// first check that field EMAIL has been filled with a registered name
			//$result = mysql_query($sql3,$db);
			
			




$link = mysqli_connect("localhost", "cs6cai_userReg","caimaN2009!", "world");

/* check connection */
if (mysqli_connect_errno()) {
    printf("Connect failed: %s\n", mysqli_connect_error());
    exit();
}

$useremail = $_POST['useremail'];

$query = "SELECT * FROM registration WHERE email ='$useremail'";

if ($stmt = mysqli_prepare($link, $query)) {

    /* execute statement */
    mysqli_stmt_execute($stmt);

    /* bind result variables */
    mysqli_stmt_bind_result($stmt, $result);

    /* fetch values */
    while (mysqli_stmt_fetch($stmt)) {
        printf ("%s \n", $result);
    }

    /* close statement */
    mysqli_stmt_close($stmt);
}

/* close connection */
mysqli_close($link);

			

			
			

?>