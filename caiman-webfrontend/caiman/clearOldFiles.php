<?php

$fileToClear = $_GET['idFileTC'];
$timeToClear = $_GET['idTimeTC'];

$timeNow      		= time() + (0);
// $timeHourAgo      	= time() - (1*60*30);

if ($timeToClear)
{
     //$timeHourAgo      	= time() - (1*60*10);
     $timeHourAgo      	= $timeToClear;

}
else
{
     $timeHourAgo      	= time() - (1*60*15);
}

if ($fileToClear)
{
	//echo $fileToClear;
	$tempName = './imageUploads/'.$fileToClear;
	unlink($tempName);
}
else
{
	if ($handle = opendir('./imageUploads')) 
	{
	    /* This is the correct way to loop over the directory. */
	    while (false !== ($file = readdir($handle))) 
	    {
    		// do not analyse root directories
			if ($file != "." && $file != "..") 
			{
		        $uploaddir					= './imageUploads/';

		    	$tempName 		= $uploaddir . $file;
		    	$statFile		= stat($tempName);
				if ($statFile[9]<$timeHourAgo)
				{			
					//echo "$file is old";
					unlink($tempName);
				}
				else
				{ 
					//echo "$file is new";
				}
		    }
	    }
    	closedir($handle);	    
	}
}	
?>