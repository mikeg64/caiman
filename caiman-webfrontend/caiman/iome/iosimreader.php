<?php

class iosimreader {

	$iogsimulation;
        $currentprop;
	$currentelement;
	public function __construct($iosim) {
		$this->iogsimulation=$iosim;

	}
 
	public function readsimulation($file, $simulation) {

		if (!($fp=@fopen($file, "r")))
			die ("Couldn't open XML.");
		$usercount=0;
		$userdata=array();
		$state='';
		if (!($xml_parser = xml_parser_create()))
			die("Couldn't create parser.");

		xml_set_element_handler($xml_parser,"startElementHandler","endElementHandler");
		xml_set_character_data_handler( $xml_parser, "characterDataHandler");
		while( $data = fread($fp, 4096)){
		if(!xml_parse($xml_parser, $data, feof($fp))) {
					break;}}
			xml_parser_free($xml_parser);

	}

	function startElementHandler ($parser,$name,$attrib){

	switch ($name) {
		case $name=="metadata" : {
                        $this->currentelement="metadata";	                
		        $name = $attrib["name"];
		        $prop = $attrib["content"];
			$iogsimulation->addmetadata($name, $prop);
		        break;
		        }
		case $name=="prop" : {
			$this->currentelement="prop";
                        $prop = new ioparam();
			$prop->flag = $attrib["flag"];
			$prop->id = $attrib["index"];
			$prop->name = $attrib["name"];
			$this->currentprop=$prop;

		        break;
		        }

		case $name=="int" : {	                
		        $currentprop->type="int";		        
		        break;
		        }
		case $name=="float" : {	                
		        $currentprop->type="float";		        
		        break;
		        }

		case $name=="string" : {	                
		        $currentprop->type="string";		        
		        break;
		        }

		case $name=="vec" : {	                
		        $currentprop->type="vec";		        
		        break;
		        }

		case $name=="mat" : {	                
		        $currentprop->type="mat";		        
		        break;
		        }

		}
	}

	function endElementHandler ($parser,$name){
		
	
	}

	function characterDataHandler ($parser, $data) {
	    if( $currentelement=="prop" )
			$prop=$this->currentprop
			$prop->value=$data 
	}

}


?>
