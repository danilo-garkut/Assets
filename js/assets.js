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


function restartAnin(el, className, callback, callback_max_control)
{
	if (callback !== undefined)
	{
		var callcallback = function (ev)
		{
			ev.stopPropagation();
			classManager(this, [className], "remove");
			this.removeEventListener("animationend", callcallback);
			if (callback !== null)
			{
				callback.bind(this, ev)();
			}
		};		
		el.addEventListener("animationend", callcallback);
	}
	if (callback_max_control !== undefined)
	{
		var callcallback = function (ev)
		{
			callback_max_control(this, ev, callcallback);
		};
		el.custom_anin_callback = callcallback;
		el.addEventListener("animationend", callcallback);
		
	}
	if (el.className.indexOf(className) === -1 && className !== undefined)
	{
		classManager(el, [className]);
	}
	else if (className !== undefined)
	{
		el.classList.remove(className);
		void el.offsetWidth; //Reflowing
		el.classList.add(className);
	}
	return el;
}


function classManager(el, classes_names_array, action)
{	
	if(el === undefined)
		return;
	var classes_names = el.className;
	if (el.tagName.toLowerCase() === "svg")
	{
		classes_names = el.className.baseVal;
	}
	var classes = classes_names.split(" ");
	if (action === "add" || action === undefined)
	{
		var has_added = false;
		for (var w = 0 ; w < classes_names_array.length ; w++)
		{
			if (classes.indexOf(classes_names_array[w]) === -1)
			{
				classes.push(classes_names_array[w]);
				has_added = true;
			}
		}
		var classes_joined = classes.join(" ");
		if (el.tagName.toLowerCase() === "svg")
		{
			el.className.baseVal = classes_joined;
			return has_added;
		}
		el.className = classes_joined;
		return has_added;
	}
	for (var w = 0 ; w < classes_names_array.length ; w++)
	{
		var index = classes.indexOf(classes_names_array[w]);		
		if (index !== -1)
		{
			classes.splice(index, 1);
		}
	}
	if (el.tagName.toLowerCase() === "svg")
	{
		el.className.baseVal = classes.join(" ");
		return;
	}
	el.className = classes.join(" ");
}


function enableDisableInputs(form, action)
{
	for (var i = 0 ; i < form.elements.length ; i++)
	{
		var el = form.elements[i];
		if (action === "enable")
		{
			el.disabled = false;
		}
		else
		{
			el.disabled = true;
		}
	}
	if (action === "enable")
	{
		form.reset();
	}
	return form.elements;
}

