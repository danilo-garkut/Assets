<?php

namespace assets;

class Log
{
	private $where = "/tmp/debug.log";
	private $is_echo_turned_on = false;
	private $log_id = NULL; //or context
	
	function __construct($specific_where = NULL, $log_id = NULL)
	{
		if ($specific_where !== NULL)
		{
			$this->where = $specific_where;
		}
		if ($log_id !== NULL)
		{
			$this->log_id = $log_id;
		}
		if (isset($_SERVER["argc"], $_SERVER["argv"])) //So its CLI
		{
			$this->is_echo_turned_on = true;
//			$this->echo("Its CLI");
		}
	}

	public function log($matter, $label = "[label]")
	{
		file_put_contents
		(
			$this->where, 
			$this->commonOutput($matter, $label),
			FILE_APPEND
		);
	}

	public function echo($matter, $label = "[label]")
	{
		if ($this->is_echo_turned_on === false)
		{
			$this->log($matter, $label);
			return;
		}
		echo $this->commonOutput($matter, $label);
	}

	public function setLogPlace($which)
	{
		$this->where = $which;
	}

	private function commonOutput($matter, $label)
	{
		return ">>>>>>" . $label . ":" . $this->addLogID() . ":" .
			LowCohesion::makeNowDate() . "\n" .
			print_r($matter, true) . LowCohesion::checkClassics($matter) . "\n" .
			"<<<<<<" .
			"\n\n";
	}

	private function addLogID()
	{
		if ($this->log_id !== NULL)
		{
			return $this->log_id;
		}
		return "[log_id]";
	}


	public function turnOnEcho()
	{
		$this->is_echo_turned_on = true;
	}

	public function turnOffEcho()
	{
		$this->is_echo_turned_on = true;
	}

}

?>
