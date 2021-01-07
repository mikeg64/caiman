<?php
// Function to check response time
function pingDomain($domain){
    $starttime = microtime(true);
    $file      = fsockopen ($domain, 80, $errno, $errstr, 10);
    $stoptime  = microtime(true);
    $status    = 0;

    if (!$file) $status = -1;  // Site is down
    else {
        fclose($file);
        $status = ($stoptime - $starttime) * 1000;
        $status = floor($status);
    }
    return $status;
}
?>


<?php
// Checksum calculation function
function icmpChecksum($data,$domain)
{
if (strlen($data)%2)
$data .= "\x00";
 
$bit = unpack('n*', $data);
$sum = array_sum($bit);
 
while ($sum >> 16)
$sum = ($sum >> 16) + ($sum & 0xffff);
 
return pack('n*', ~$sum);
}
// Making the package
$type= "\x08";
$code= "\x00";
$checksum= "\x00\x00";
$identifier = "\x00\x00";
$seqNumber = "\x00\x00";
$data= "Scarface";
$package = $type.$code.$checksum.$identifier.$seqNumber.$data;
$checksum = icmpChecksum($package); // Calculate the checksum
$package = $type.$code.$checksum.$identifier.$seqNumber.$data;
// And off to the sockets
$socket = socket_create(AF_INET, SOCK_RAW, 1);
socket_connect($socket, "www.google.com", null);
// If you're using below PHP 5, see the manual for the microtime_float
// function. Instead of just using the microtime() function.
$startTime = microtime(true);
socket_send($socket, $package, strLen($package), 0);
if (socket_read($socket, 255)) {
echo round(microtime(true) - $startTime, 4) .' seconds';
}
socket_close($socket);
?>



<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "DTD/xhtml1-transitional.dtd">
<html>
<body>
      <form action="<?php echo $_SERVER['PHP_SELF']; ?>" method="post" name="domain">
        Domain name:
        <table>
          <tr><td><input name="domainname" type="text" ></td></tr>
          <tr><td><input type="submit" name="submitBtn" value="Ping domain"></td></tr>
        </table>  
      </form>
<?php    
    // Check whether the for was submitted
    if (isset($_POST['submitBtn'])){
        $domainbase = (isset($_POST['domainname'])) ? $_POST['domainname'] : '';
        $domainbase = str_replace("http://","",strtolower($domainbase));
        
        echo '<table>';

        //$status = pingDomain($domainbase);
        $status = pingDomain($domainbase);
        if ($status != -1) echo "<tr><td>http://$domainbase is ALIVE ($status ms)</td><tr>";
        else               echo "<tr><td>http://$domainbase is DOWN</td><tr>";

         echo '</table>';
    }
?>
</body>   