<?php

			$db = mysql_connect("localhost", "cs6cai_userReg","caimaN2009!");
			$could_connect=mysql_select_db("cs6cai_userReg",$db);

 			$useremail = $_POST['useremail'];
			$sql3 = "SELECT * FROM registration WHERE email ='$usersEmail'"; 
			// first check that field EMAIL has been filled with a registered name
			$result = mysql_query($sql3,$db);
			
			

			
			

?>