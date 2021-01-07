<?php

class iosimwriter {

	var $iogsimulation,$simname;

	public function __construct() {
		$this->simname="mysim";
	}
 
	public function writesimulation($file, $simulation) {
		// THIS IS ABSOLUTELY ESSENTIAL - DO NOT FORGET TO SET THIS
		@date_default_timezone_set("GMT");

		$writer = new XMLWriter();
		$writer->openMemory();
		$writer->startDocument('1.0');
		$writer->setIndent(4); 
		$writer->startElement('iosim');
		$writer->writeAttribute('filename', $file);

		$writer->startElement('simulation');
		$writer->writeAttribute('class', 'GenericSteerSimulation');
		$writer->writeAttribute('createmethod', '1');
		$writer->writeAttribute('name', $simname);
		$writer->writeAttribute('nprocs', '1');
		$writer->writeAttribute('simulantclass', 'AgentModel');
		$writer->writeAttribute('simulanttype', '0');

		$this->writeprops($writer);
		$this->writemetadata($writer);
		$this->writefileprops($writer);
 		$this->writesteps($writer);


                //end simulation
		$writer->endElement(); 
                //end iosim
		$writer->endElement();
 
		$simulationxml=outputMemory(true);
		$file=fopen($file,"w");
		fprintf($file,'%s',$simulationxml);
		fclose($file);
	}

	public function writeprops($writer) {
		$writer->startElement('props');
		$writer->writeAttribute('flag', '7');
		$writer->writeAttribute('name', 'simprops');

		$sim=$this->iogsimulation;
		$writer->writeAttribute('numprops', $sim->getnumprops());

		for ($i=0; $i=$sim->getnumprops(); $i++)
  		{
  			$prop=$sim->getparam($i);
  			$type=$prop->type;

			$writer->startElement('prop');
			$writer->writeAttribute('flag', '7');
			$writer->writeAttribute('index', $i);
			$writer->writeAttribute('name', $prop->name);

			switch($type)
			{
				case $type=="int" : {	                
		        				$writer->startElement('int',$prop->$value);
							$writer->endElement();
                                                        break;
		        		}
				case $type=="float" : {	                
		        				$writer->startElement('float',$prop->$value);
							$writer->endElement();
                                                        break;
		        		}

				case $type=="string" : {	                
		        				$writer->startElement('string',$prop->$value);
							$writer->endElement();
                                                        break;
		        		}

				case $type=="vec" : {	                
		        				$writer->startElement('vec',$prop->value);
							$writer->writeAttribute('size', $prop->size);

							$writer->endElement();
                                                        break;
		        		}

				case $type=="mat" : {	                
		        				$writer->startElement('mat',$prop->value);
							$writer->writeAttribute('rows', $prop->rows);
							$writer->writeAttribute('cols', $prop->cols);
							$writer->endElement();
                                                        break;
		        		}
			}

			$writer->endElement();
  		}
		$writer->endElement();
	}

	public function writemetadata($writer) {
		$writer->startElement('metadatalist');
		$sim=$this->iogsimulation;

		for ($i=0; $i=$sim->getnummetadata(); $i++)
  		{
  			$meta=$sim->getmetadata($i);
			$writer->startElement('metadata');
			$writer->writeAttribute('name', $meta->name);
			$writer->writeAttribute('property', $meta->property);
			$writer->endElement();
  		}
		$writer->endElement();

	}

	public function writefileprops($writer) {
		$writer->startElement('fileprops');
		$writer->writeAttribute('configfilename', 'configfile.xml');
		$writer->writeAttribute('configreadmethod', '1');
		$writer->writeAttribute('configwritemethod', '1');
		$writer->writeAttribute('simreadmethod', '1');
		$writer->writeAttribute('simwritemethod', '1');
		$writer->writeAttribute('statefilename', 'statefile.xml');
		$writer->writeAttribute('statereadmethod', '1');
		$writer->writeAttribute('statewritemethod', '1');
		$writer->endElement();
	}

	public function writesteps($writer) {
		$writer->startElement('steps','2');
		$writer->writeAttribute('configstepfreq', '1');
		$writer->writeAttribute('statestepfreq', '1');
		$writer->endElement();
	}
}


?>
