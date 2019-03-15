<?php

namespace assets;

class DB
{

	private $connection_resource = NULL;
	private $dbname = NULL;
	private $match_dbname = '/(?<=dbname=)[[:alnum:]_]+/';
	private $log = NULL;
	private $log_client = NULL;

	function __construct($string_connection = "dbname=postgres user=postgres")
	{
		$this->connection_resource = 
			pg_connect($string_connection);

		$this->string_connection = $string_connection;

		$this->stateDBName();

		$this->log = new Log($this->getDBName(), get_class());
		$this->log->echo($this->connection_resource);
	}
	
	public function allNonSelect($query, $values)
	{
		$query_result = false;
		$resource = $this->queryParams($query, $values);
		if ($resource !== false)
		{
			$query_result = true;
		}
		else
		{
			//
		}
		return $query_result;
	}

	public function select($select, $values = array())
	{
		$query_result = [];

		$resource = $this->queryParams($select, $values);

		if ($resource !== false)
		{
			$query_result = pg_fetch_all($resource);
		}
		return $query_result;
	}

	private function queryParams($query, $values)
	{
		return pg_query_params($this->connection_resource, $query, $values);
	}

	private function stateDBName()
	{	
		$matches = [];
		$this->dbname = preg_match($this->match_dbname, $this->string_connection, $matches);
	}

	public function getDBName()
	{
		return $this->dbname;
	}

}


?>

