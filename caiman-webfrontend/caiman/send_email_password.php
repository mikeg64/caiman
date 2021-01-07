<?php
         
$subject = "Registration for Caiman at Sheffield University ";
$body = "Hello,\n\n Thank you for registering for Caiman, your new password is:\n\n$newPass \n\nPlease copy and paste it to the webpage";

$Name = "Caiman Registration"; //senders name
$userMail2="c.reyes@sheffield.ac.uk";


$header = "From: ". $Name . " <" . $userMail2 . ">\r\n"; //optional headerfields
        
         

   
        

         if (mail($usersEmail, $subject, $body, $header))
         {


               // keep track of people registering to CAIMAN
               $body2 = "This person has registered to CAIMAN:\n\n".$usersEmail ;

               mail($userMail2, $subject, $body2, $header);

 
            	printf("An email with the password has been sent to
            	%s\n",$usersEmail);
		?>
		Please re-type the password in the box below:<br /><br />
		<form name="validate" action="<?php echo $toValidate;?>" method="POST">
			<input type="hidden" name="user_email" value="<?php echo $usersEmail;?>">
			<input type="hidden" name="newPassword" value="<?php echo $newPass;?>">
			<b>Password: <b><br /> <input name="typedPass" type="text"><br />
			<input type="submit" name="validateP" value="Submit password">
		</form>
		<?php
         }
         else
         {
            printf("There was an error delivering the email, please try again.");
         }
?> 