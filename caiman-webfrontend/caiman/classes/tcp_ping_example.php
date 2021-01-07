<?php
print_r($_POST);
require_once "tcp_ping.class.php";
$pinger = new TcpPingWrapper();

$strAccept = isset($_SERVER['HTTP_ACCEPT']) ? $_SERVER['HTTP_ACCEPT'] : '';
$strUA = isset($_SERVER['HTTP_USER_AGENT']) ? $_SERVER['HTTP_USER_AGENT'] : '';
if (strpos($strAccept, "application/xhtml+xml") !== false || stristr($strUA, "validator") !== false)
{
    $content_type = 'application/xhtml+xml';
} 
else
{
    $content_type = 'text/html';
} 
header("Content-Type: " . $content_type . "; charset=utf-8;");
?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
      "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">

<html xmlns="http://www.w3.org/1999/xhtml"
      xml:lang="en">

  <head>
    <title>TCP Ping Example</title>
    <meta http-equiv="Content-Type" content="<?php echo $content_type?>; charset=utf-8;" />
    <meta name="description" content="TCP Ping example by Andronicus Riyono" />
    <meta name="keywords" content="andronicus, riyono, tcp ping, ping, tcp, php, sockets, socket" />
	<style type="text/css">
	   body {
	       font-family: "Trebuchet MS", Tahoma, Arial, Helvetica, sans-serif;	
	   }
	   a img {
	       border:0;	
	   }
	   table, tr, th, td {
	       border: 1px solid #039;
		   border-collapse: collapse;
	   }
	   th, td {
	       padding: .5em;
	   }
	</style>
  </head>
  <body> 
<?php
if (isset($_POST['multiple'])) {
    $_REQUEST['hosts'] = preg_split("/\s+/", $_POST['multiple'], 10, PREG_SPLIT_NO_EMPTY);
}
?>
<h1>Connectivity Ping</h1>
  <p>Enter up to 10 hostname or IP address you would like to ping on the textarea. One host or IP address per line. Hit the ping button to execute the TCP Connectivity Ping.</p>
  <p>The TCP Connectivity Ping will try to determine whether a host is alive or dead by sending NOOP Command to Common TCP Service (http, ftp, telnet, mail, in that order).</p>
  <form action="<?php echo $_SERVER['PHP_SELF']?>" method="post">
     <div><textarea id="multiple" name="multiple" rows="10" cols="40"><?php
	 if (isset($_POST['multiple'])) {
	     echo $_POST['multiple'];
	 }
	 ?></textarea></div>
	 <div><input id="submit" name="submit" type="submit" value="Ping" /></div>
  </form>
<?php
if (isset($_REQUEST['hosts']))
{
    $pinger->ReadFormInput();
    $pinger->Ping();
?>
<h2>Connectivity Ping Result</h2>
<h3>Text only (&lt;pre&gt; is used here)</h3>
<pre>
<?php
    $pinger->DisplayOutputAsText();
?>
</pre>


<h3>Ordinary HTML</h3>
<?php
    $pinger->DisplayOutputAsHtml();
?>

<h3>Ordinary HTML table</h3>
<?php
    $pinger->DisplayOutputAsHtmlTable();
?>

<h3>Fancy HTML table</h3>
<?php
    $pinger->DisplayOutputAsHtmlFancy();
?>

<?php
}
?>
    <p>
      <a href="http://validator.w3.org/check?uri=referer"><img
          src="http://riyono.com/images/valid-xhtml10.png"
          alt="Valid XHTML 1.0!" height="15" width="80" /></a>
    </p>
<address>Copyright (c) 2005 Andronicus Riyono &lt;nick@riyono.com&gt;</address>
  </body>
</html>
