<?php

namespace assets;

//It will be less static

class Log
{
	private $where_base_block = __DIR__ . "/../../logs/"; //$this->setBaseDir() below
	private $default_where = "debug.log";
	private $where = NULL;
	private $is_echo_turned_on = false;
	private $log_id = "";
	
	function __construct($specific_where = NULL, $log_id = NULL)
	{
		$this->where = $this->default_where;
		if ($specific_where !== NULL)
		{
			$this->where = $specific_where . ".$where";
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

	public function echo($matter, $label = ":")
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
			self::makeNowDate() . "\n\n" .
			print_r($matter, true) . self::checkClassics($matter) . "\n\n" .
			"<<<<<<" .
			"\n\n\n\n";
	}

	private function addLogID()
	{
		if ($this->log_id !== NULL)
		{
			return $this->log_id;
		}
		return "";
	}

	public function makeNowDate($style = "H:i:s d/m/Y")
	{
		return date($style);
	}

	public static function checkClassics($matter)
	{
		$extra = null;
		if ($matter === null)
		{
			$extra = ">NULL<";
		}
		else if ($matter === true)
		{
			$extra = ">TRUE<";
		}
		else if ($matter === false)
		{
			$extra = ">FALSE<";
		}
		else if ($matter === "")
		{
			$extra = ">EMPTY_STRING<";
		}
		return $extra;
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
