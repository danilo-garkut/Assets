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

