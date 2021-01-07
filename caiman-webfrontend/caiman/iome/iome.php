<?php



class ioservice {

    var $server, $port, $id, $method;

     //$method=0 default using system call
     //$method=1 using zend developed client plugin
     //$method=2 using nusoap

     function client()
	{
	   $server='http://'.$this->server.':'.$this->port.'/';
           $client = new SoapClient(NULL,
		array(
		"location" => $server,
		"uri"      => "urn:IoSteerWS",
		"style"    => SOAP_RPC,
		"use"      => SOAP_ENCODED
		   ));
            return $client;
	}     

}


function stringtovec($stringvar, $vsize, $separator)
{
    $vec=split($separator, $stringvar);
    return $vec;
}

function vectostring($vec, $separator)
{
    for($i=0; $i < $vsize ; $i++)
    {
        if($i == $vsize-1)
        {        
		$vecstring = $temp.$vec[ $i ];
	        $temp=$vecstring;
	}
	else
        {
		$vecstring = $temp.$vec[ $i ].$separator;
	        $temp=$vecstring;
	}
    }   
    return $vecstring;

}

function newvec($vsize)
{   
    for($i=0; $i < $vsize ; $i++)
    {
	$vec[ $i ]=0;
    }   
    return $vec;
}

function newmat($nr,$nc)
{
    for($i=0; $i < $nr ; $i++)
    {
	for($j=0; $j < $nc ; $j++)
    	{
		$mat[$i][$j]=0;
	}
    }   
    return $mat;

}

function vec2mat($vec, $nr,$nc)
{
    $vsize=count($vec);
    $mat = newmat($nr, $nc);
    $vc=0;
    for($i=0; $i < $nr ; $i++)
    {
	for($j=0; $j < $nc ; $j++)
    	{
		$mat[$i][$j]=$vec[$vc];
                $vt=$vc+1;
                $vc=$vt;
                if($vc > $vsize)
                {
			return $mat;
                }
	}
    }   
    return $mat;
}

function mat2vec($mat)
{
    $r = count($mat,0);
    $c = (count($mat,1)/count($mat,0))-1;

    $vsize=$r*$c;
    $vc=0;
    for($i=0; $i < $r ; $i++)
    {
	    for($j=0; $j < $c ; $j++)
	    {
		$vec[ $vc ]=$mat[$i][$j];
                $temp = $vc + 1;
                $vc = $temp;
            }
    }   
    return $vec;
}

function addparamint( $name, $val , $ioservice)
{	
      $server='http://'.$ioservice->server.':'.$ioservice->port.'/';

      if ($ioservice->method == 1){
                $request = "addparam int ".$name." ".$val." 7 ".$ioservice->id ." ".$ioservice->port ." ".$ioservice->server ;				
                $result = iophp($request);
	}
        elseif ($ioservice->method == 0)
	{
                $request = "ioclient addparam int ".$name." ".$val." 7 ".$ioservice->id ." ".$ioservice->port ." ".$ioservice->server ;		
                $result=system($request);
	}
        elseif ($ioservice->method == 2)
	{
		$iflag=7;		
		$client = $ioservice -> client();
		//$result=$client->__call(
		$result=$client->__soapCall(			
			"addparamint",array(new SoapParam($name,"name"),new SoapParam($val,"value"),new SoapParam($iflag,"iflag"),new SoapParam($ioservice->id,"id")),array("uri" => "urn:IoSteerWS","soapaction"=>"urn:IoSteerWS#addparamint"));

	}
      return $result;
}


function setparamint( $name, $val , $ioservice)
{	
      $server='http://'.$ioservice->server.':'.$ioservice->port.'/';

      if ($ioservice->method == 1){
                $request = "setparam int ".$name." ".$val." ".$ioservice->id ." ".$ioservice->port ." ".$ioservice->server ;	          	
                $result = iophp($request);
	}
        elseif ($ioservice->method == 0)
	{
                $request = "ioclient setparam int ".$name." ".$val." ".$ioservice->id ." ".$ioservice->port ." ".$ioservice->server ;
				
                $result=system($request);
	}
        elseif ($ioservice->method == 2)
	{
		$client = $ioservice -> client();
		//$result=$client->__call(
		$result=$client->__soapCall(			
			"setparamint",
			array(new SoapParam($name,"name"),new SoapParam($val,"value"),
		              new SoapParam($ioservice->id,"id")),
			array("uri" => "urn:IoSteerWS","soapaction" => "urn:IoSteerWS#setparamint"));

	}
      return $result;
}

function getparamint( $name , $ioservice)
{	
      $server='http://'.$ioservice->server.':'.$ioservice->port.'/';
      
      if ($ioservice->method == 1){
                $request = "getparam int ".$name." ".$ioservice->id ." ".$ioservice->port ." ".$ioservice->server ;	
                //echo $request ;	
                $result = iophp($request);
	}
        elseif ($ioservice->method == 0)
	{
                $request = "ioclient getparam int ".$name." ".$ioservice->id ." ".$ioservice->port ." ".$ioservice->server ;	
               	
                $result=system($request);
	}
        elseif ($ioservice->method == 2)
	{
		$client = $ioservice -> client();
		//$result=$client->__call(
		$result=$client->__soapCall(			
			"getparamint",
			array(new SoapParam($name,"name"),
		              new SoapParam($ioservice->id,"id")),
			array("uri" => "urn:IoSteerWS","soapaction" => "urn:IoSteerWS#getparamint"));

	}
      return $result;
}


function addparamdouble( $name, $val , $ioservice)
{	
      $server='http://'.$ioservice->server.':'.$ioservice->port.'/';

      if ($ioservice->method == 1){
                $request = "addparam double ".$name." ".$val." 7 ".$ioservice->id ." ".$ioservice->port ." ".$ioservice->server ;				
                $result = iophp($request);
	}
        elseif ($ioservice->method == 0)
	{
                $request = "ioclient addparam double ".$name." ".$val." 7 ".$ioservice->id ." ".$ioservice->port ." ".$ioservice->server ;		
                $result=system($request);
	}
        elseif ($ioservice->method == 2)
	{
		$iflag=7;		
		$client = $ioservice -> client();
		//$result=$client->__call(
		$result=$client->__soapCall(			
			"addparamdouble",
			array(new SoapParam($name,"name"),new SoapParam($val,"value"),new SoapParam($iflag,"iflag"),new SoapParam($ioservice->id,"id")),array("uri" => "urn:IoSteerWS","soapaction"=>"urn:IoSteerWS#addparamdouble"));

	}
      return $result;
}


function setparamdouble( $name, $val , $ioservice)
{	
      $server='http://'.$ioservice->server.':'.$ioservice->port.'/';

      if ($ioservice->method == 1){
                $request = "setparam double ".$name." ".$val." ".$ioservice->id ." ".$ioservice->port ." ".$ioservice->server ;	          	
                $result = iophp($request);
	}
        elseif ($ioservice->method == 0)
	{
                $request = "ioclient setparam double ".$name." ".$val." ".$ioservice->id ." ".$ioservice->port ." ".$ioservice->server ;
				
                $result=system($request);
	}
        elseif ($ioservice->method == 2)
	{
		$client = $ioservice -> client();
		//$result=$client->__call(
		$result=$client->__soapCall(			
			"setparamdouble",
			array(new SoapParam($name,"name"),new SoapParam($val,"value"),
		              new SoapParam($ioservice->id,"id")),
			array("uri" => "urn:IoSteerWS","soapaction" => "urn:IoSteerWS#setparamdouble"));

	}
      return $result;
}

function getparamdouble( $name , $ioservice)
{	
      $server='http://'.$ioservice->server.':'.$ioservice->port.'/';
      
      if ($ioservice->method == 1){
                $request = "getparam double ".$name." ".$ioservice->id ." ".$ioservice->port ." ".$ioservice->server ;	
                //echo $request ;	
                $result = iophp($request);
	}
        elseif ($ioservice->method == 0)
	{
                $request = "ioclient getparam double ".$name." ".$ioservice->id ." ".$ioservice->port ." ".$ioservice->server ;	
               	
                $result=system($request);
	}
        elseif ($ioservice->method == 2)
	{
		$client = $ioservice -> client();
		//$result=$client->__call(
		$result=$client->__soapCall(			
			"getparamdouble",
			array(new SoapParam($name,"name"),
		              new SoapParam($ioservice->id,"id")),
			array("uri" => "urn:IoSteerWS","soapaction" => "urn:IoSteerWS#getparamdouble"));

	}
      return $result;
}

function addparamstring( $name, $val , $ioservice)
{	
      $server='http://'.$ioservice->server.':'.$ioservice->port.'/';

      if ($ioservice->method == 1){
                $request = "addparam string ".$name." ".$val." 7 ".$ioservice->id ." ".$ioservice->port ." ".$ioservice->server ;				
                $result = iophp($request);
	}
        elseif ($ioservice->method == 0)
	{
                $request = "ioclient addparam string ".$name." ".$val." 7 ".$ioservice->id ." ".$ioservice->port ." ".$ioservice->server ;		
                $result=system($request);
	}
        elseif ($ioservice->method == 2)
	{
		$client = $ioservice -> client();
		//$result=$client->__call(
		$result=$client->__soapCall(			
			"addparamstring",
			array(new SoapParam($name,"name"),new SoapParam($val,"value"),new SoapParam(7,"iflag"),
		              new SoapParam($ioservice->id,"id")),
			array("uri" => "urn:IoSteerWS","soapaction" => "urn:IoSteerWS#addparamstring"));

	}
      return $result;
}


function setparamstring( $name, $val , $ioservice)
{	
      $server='http://'.$ioservice->server.':'.$ioservice->port.'/';

      if ($ioservice->method == 1){
                $request = "setparam string ".$name." ".$val." ".$ioservice->id ." ".$ioservice->port ." ".$ioservice->server ;	          	
                $result = iophp($request);
	}
        elseif ($ioservice->method == 0)
	{
                $request = "ioclient setparam string ".$name." ".$val." ".$ioservice->id ." ".$ioservice->port ." ".$ioservice->server ;
				
                $result=system($request);
	}
        elseif ($ioservice->method == 2)
	{
		$client = $ioservice -> client();
		//$result=$client->__call(
		$result=$client->__soapCall(			
			"setparamstring",
			array(new SoapParam($name,"name"),new SoapParam($val,"value"),
		              new SoapParam($ioservice->id,"id")),
			array("uri" => "urn:IoSteerWS","soapaction" => "urn:IoSteerWS#setparamstring"));

	}
      return $result;
}

function getparamstring( $name , $ioservice)
{	
      $server='http://'.$ioservice->server.':'.$ioservice->port.'/';

      if ($ioservice->method == 1){
                $request = "getparam string ".$name." ".$ioservice->id ." ".$ioservice->port ." ".$ioservice->server ;		
                $result = iophp($request);
	}
        elseif ($ioservice->method == 0)
	{
                $request = "ioclient getparam string ".$name." ".$ioservice->id ." ".$ioservice->port ." ".$ioservice->server ;		
                $result=system($request);
	}
        elseif ($ioservice->method == 2)
	{
		$client = $ioservice -> client();
		//$result=$client->__call(
		$result=$client->__soapCall(			
			"getparamstring",
			array(new SoapParam($name,"name"),
		              new SoapParam($ioservice->id,"id")),
			array("uri" => "urn:IoSteerWS","soapaction" => "urn:IoSteerWS#getparamstring"));

	}
      return $result;
}


function runsimulation( $simfile , $outfile, $ioservice)
{	
      $server='http://'.$ioservice->server.':'.$ioservice->port.'/';

      if ($ioservice->method == 1){
                $request = "runsimulation ".$simfile." ".$outfile." ".$ioservice->id ." ".$ioservice->port ." ".$ioservice->server ;		
                $result = iophp($request);
	}
        elseif ($ioservice->method == 0)
	{
                $request = "iogs runsimulation ".$simfile." ".$outfile." ".$ioservice->id ." ".$ioservice->port ." ".$ioservice->server ;		
                $result=system($request);
	}
        elseif ($ioservice->method == 2)
	{
		$client = $ioservice -> client();
		//$result=$client->__call(
		$result=$client->__soapCall(			
			"runsimulation",
			array(new SoapParam($simfile,"simfilecontent"),
		              new SoapParam($ioservice->id,"id")),
			array("uri" => "urn:IoSteerWS","soapaction" => "urn:IoSteerWS#runsimulation"));

	}
      return $result;
}

function submitsimulation( $simfile , $ioservice)
{	
      $server='http://'.$ioservice->server.':'.$ioservice->port.'/';

      if ($ioservice->method == 1){
                $request = "submitsimulation string ".$simfile." ".$ioservice->id ." ".$ioservice->port ." ".$ioservice->server ;		
                $result = iophp($request);
	}
        elseif ($ioservice->method == 0)
	{
                $request = "iogs submitsimulation string ".$simfile." ".$ioservice->id ." ".$ioservice->port ." ".$ioservice->server ;		
                $result=system($request);
	}
        elseif ($ioservice->method == 2)
	{
		$client = $ioservice -> client();
		//$result=$client->__call(
		$result=$client->__soapCall(			
			"submitsimulation",
			array(new SoapParam($simfile,"simfilecontent")),
			array("uri" => "urn:IoSteerWS","soapaction" => "urn:IoSteerWS#submitsimulation"));

	}
      return $result;
}

function requestsimulation( $simfile , $ioservice)
{	
      $server='http://'.$ioservice->server.':'.$ioservice->port.'/';

      if ($ioservice->method == 1){
                $request = "requestsimulation string ".$simfile." ".$ioservice->id ." ".$ioservice->port ." ".$ioservice->server ;		
                $result = iophp($request);
	}
        elseif ($ioservice->method == 0)
	{
                $request = "iogs requestsimulation string ".$simfile." ".$ioservice->id ." ".$ioservice->port ." ".$ioservice->server ;		
                $result=system($request);
	}
        elseif ($ioservice->method == 2)
	{
		$client = $ioservice -> client();
		//$result=$client->__call(
		$result=$client->__soapCall(			
			"requestsimulation",
			array(new SoapParam($simfile,"simfilecontent")),
			array("uri" => "urn:IoSteerWS","soapaction" => "urn:IoSteerWS#requestsimulation"));

	}
      return $result;
}

function runrequestedsimulation( $ioservice)
{	
      $server='http://'.$ioservice->server.':'.$ioservice->port.'/';

      if ($ioservice->method == 1){
                $request = "runrequestedsimulation string ".$ioservice->id ." ".$ioservice->port ." ".$ioservice->server ;		
                $result = iophp($request);
	}
        elseif ($ioservice->method == 0)
	{
                $request = "iogs requestedsimulation string ".$ioservice->id ." ".$ioservice->port ." ".$ioservice->server ;		
                $result=system($request);
	}
        elseif ($ioservice->method == 2)
	{
		$client = $ioservice -> client();
		//$result=$client->__call(
		$result=$client->__soapCall(			
			"runrequestedsimulation",
			array(new SoapParam($ioservice->id,"isimid")),
			array("uri" => "urn:IoSteerWS","soapaction" => "urn:IoSteerWS#runrequestedsimulation"));

	}
      return $result;
}

function simulationstatus( $ioservice)
{	
      $server='http://'.$ioservice->server.':'.$ioservice->port.'/';

      if ($ioservice->method == 1){
                $request = "simulationstatus string ".$ioservice->id ." ".$ioservice->port ." ".$ioservice->server ;		
                $result = iophp($request);
	}
        elseif ($ioservice->method == 0)
	{
                $request = "iogs simulationstatus string ".$ioservice->id ." ".$ioservice->port ." ".$ioservice->server ;		
                $result=system($request);
	}
        elseif ($ioservice->method == 2)
	{
		$client = $ioservice -> client();
		//$result=$client->__call(
		$result=$client->__soapCall(			
			"simulationstatus",
			array(new SoapParam($ioservice->id,"isimid")),
			array("uri" => "urn:IoSteerWS","soapaction" => "urn:IoSteerWS#simulationstatus"));

	}
      return $result;
}

function setsimulationstatus( $newstatus, $ioservice)
{	
      $server='http://'.$ioservice->server.':'.$ioservice->port.'/';

      if ($ioservice->method == 1){
                $request = "setsimulationstatus string ".$newstatus." ".$ioservice->id ." ".$ioservice->port ." ".$ioservice->server ;		
                $result = iophp($request);
	}
        elseif ($ioservice->method == 0)
	{
                $request = "iogs setsimulationstatus string ".$newstatus." ".$ioservice->id ." ".$ioservice->port ." ".$ioservice->server ;		
                $result=system($request);
	}
        elseif ($ioservice->method == 2)
	{
		$client = $ioservice -> client();
		//$result=$client->__call(
		$result=$client->__soapCall(			
			"setsimulationstatus",
			array(new SoapParam($ioservice->id,"isimid"),new SoapParam($newstaus,"newstatus")),
			array("uri" => "urn:IoSteerWS","soapaction" => "urn:IoSteerWS#setsimulationstatus"));

	}
      return $result;
}

function getsimulationresults( $outfile , $ioservice)
{	
      $server='http://'.$ioservice->server.':'.$ioservice->port.'/';

      if ($ioservice->method == 1){
                $request = "getsimulationresults string ".$outfile." ".$ioservice->id ." ".$ioservice->port ." ".$ioservice->server ;		
                $result = iophp($request);
	}
        elseif ($ioservice->method == 0)
	{
                $request = "iogs getsimulationresults string ".$outfile." ".$ioservice->id ." ".$ioservice->port ." ".$ioservice->server ;		
                $result=system($request);
	}
        elseif ($ioservice->method == 2)
	{
		$client = $ioservice -> client();
		//$result=$client->__call(
		$result=$client->__soapCall(			
			"getsimulationresults",
			array(new SoapParam($ioservice->id,"isimid")),
			array("uri" => "urn:IoSteerWS","soapaction" => "urn:IoSteerWS#getsimulationresults"));

	}
      return $result;
}

?>
