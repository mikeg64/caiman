<?php

class iostack {
 
	private $stk = array();
 
	public function __construct() {
	}
 
	public function push($data) {
		array_push($this->stk, $data);
	}
 
	public function pop() {
		return array_pop($this->stk);
	}
 
}


/*$s = new iostack();
 
$s->push("strawberry");
$s->push("milkshake");
 
echo $s->pop();
echo "\n";
echo $s->pop();*/

?>
