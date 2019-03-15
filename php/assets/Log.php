<?php
namespace assets;

class Log
{
	private $where_base_block = __DIR__ . "/../../logs/"; //$this->setBaseDir() below
	private $default_where = "debug.log";
	private $where = NULL;
	private $is_echo_turned_on = false;
	private $log_id = NULL;
	
	function __construct($specific_where = NULL, $log_id = NULL)
	{
		$this->where = $this->default_where;
		if ($specific_where !== NULL)
		{
			$this->where = $specific_where;
		}
		if ($log_id !== NULL)
		{
			$this->log_id = $log_id;
		}
	}

	public function log($matter, $label = ":")
	{
		file_put_contents
		(
			$this->where(), 
			"\n" . $this->commonOutput($matter, $label),
			FILE_APPEND
		);
	}

	private function where()
	{
		return $this->where_base_block . $this->where;
	}

	public function echo($matter, $label = "++")
	{
		if ($this->is_echo_turned_on === false)
		{
			return;
		}
		echo $this->commonOutput($matter, $label);
	}

	public function setBaseDir($which)
	{
		$this->$where_base_block = $which;
	}

	private function commonOutput($matter, $label)
	{
		return ">>>>>>" . $label . ":" . $this->addLogID() . ":" .
			LowCohesion::makeNowDate() . "\n\n" .
			print_r($matter, true) . LowCohesion::checkClassics($matter) . "\n\n" .
			"<<<<<<" .
			"\n\n\n\n";
	}

	private function addLogID()
	{
		if ($this->log_id !== NULL)
		{
			return $this->log_id;
		}
		return "++";
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
