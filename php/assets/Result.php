<?php

namespace assets;

class Result
{

	private $success = null;
	private $bundle = null;
	private $Log = null;

	function __construct()
	{
		//
		$this->Log = new Log;
		$this->success = false;
		$this->bundle = 
		[
			"initialized" => false
		];

	}

	public function success($bundle)
	{
		$this->commonForBothSuccessAndFail($bundle);
		$this->success = true;
	}
	
	public function fail($bundle, $log = false)
	{
		$this->commonForBothSuccessAndFail($bundle);
		$this->success = false;
		if ($log === true)
		{
			$this->Log($log["msg"], $log["label"]);
		}
	}

	private function commonForBothSuccessAndFail($bundle)
	{
		$this->bundle = $bundle;
	}

	public function encode()
	{
		return json_encode
		(
			[
				"success" => $this->success,
				"bundle" => $this->bundle
			]
		);
	}





}


?>
