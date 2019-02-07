function brazilianCPFAssertion(nro)
{
	var stringed = nro.toString();

	while(stringed.length < 11)
	{
		var aside = "0" + stringed;
		stringed = aside;
	}

	var prepare = stringed.match(/^\d{9}(?=\d{2}$)/);

	//I have heard there are some which are smaller in length although
	if (prepare === null)
	{
		return false;
	}

	var snro = prepare[0];

	var weights = [];

	for (var i = 11 ; i >= 2; i--)
	{
		weights.push(i);
	}

	var first_digit_calc = fillInInteger(snro, [], weights, 1);
	var sum = reduceBySum(first_digit_calc);
	var first_digit = someSpecificCalc(sum);

	snro += first_digit; //String concat

	var second_digit_calc = fillInInteger(snro, [], weights, 0);
	sum = reduceBySum(second_digit_calc);
	var second_digit = someSpecificCalc(sum);

	snro += second_digit;
	
	var so_then = [snro.match(/\d{2}$/)[0], stringed.match(/\d{2}$/)[0]];

	console.log(so_then);

	return so_then[0] === so_then[1];

	function someSpecificCalc(sum)
	{
		var rest = sum % 11;
		var the_digit = 0
		if (rest >= 2)
		{
			the_digit = 11 - rest;
		}
		return the_digit;
	}

	function reduceBySum(array)
	{
		return array.reduce
		(
			function (accumulator, value)
			{
				return accumulator + value;
			}
		);
	}

	function fillInInteger(string, pack, times, init)
	{
		for (var i = 0 ; i < string.length ; i++)
		{
			pack.push
			(
				parseInt(string[i]) * times[init++]
			);
		}
		return pack;
	}
}
