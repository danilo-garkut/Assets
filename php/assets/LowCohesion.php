<?php

namespace assets;

include("DB.php");
include("Log.php");
include("Result.php");

class LowCohesion
{

	public static function makeNowDate($style = "H:i:s d/m/Y")
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

	public static function autoload($paths)
	{
		$Log = new Log();
		spl_autoload_register
		(
			(
				function ($paths)
				{
					$autoload = function ($class) use ($paths)
					{
						$Log->log($class, "Need to autoload");
						$invert_bar = preg_replace('/\\\/', "/", $class);
						$Log->log($invert_bar, "InvertedBars");
						foreach($paths as $key => $value)
						{
							$expected = $value . "/" . $invert_bar . ".php";							
							if (file_exists($expected) === true)
							{
								include($expected);
							}
						}
					}
					return $autoload;
				}
			)($paths);
		);
	}

}


?>
