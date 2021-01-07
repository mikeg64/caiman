<?php
###################################################
// Ping Class supplied by Antido @ phpclasses.org #
// You are free to modify as you wish :)          #
//                                                #
// Ping? Pong!                                    #
###################################################

Class ping
{
	function site($ip,$text)
	{
		$cmd = shell_exec("ping -c 1 $ip");
		$ping_results = explode(",",$cmd);
		
			for($i=0;$i<count($ping_results)+1;$i++)
			{
				if(eregi ("time=(.*)", $ping_results[$i], $pingtime))
				{
				$pingtime = explode("ms",$pingtime[$i]);
				$pingtime = explode("time=",$pingtime[0]);
				$text     = str_replace("{site}",$ip,$text);
				$text     = str_replace("{time}",$pingtime[1],$text);
				print("$text");
				}
			}
	}
}
?>
