<?php

namespace assets;

class Result
{

	private $success = null;
	private $bundle = null;

	function __construct()
	{
		//
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
		if ($log)
		{
			Log::log($log["msg"], $log["label"]);
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
