function sprint(body, fill_data_collection)
{
	return body.replace(/\$(\d+|\w+)/g, function(a, b, c)
	{
		return fill_data_collection[a.substring(1)];
	});
}

//
//
function fillTo( pack, config, modifiers )
{
	for (var i = 0 ; i < pack.length ; i++)
	{
		var item = getReceiver( pack[ i ][ 0 ], config.receiver_left_tree );
		item = passThroughModifiers( pack[ i ][ 1 ] );
	}


	function getReceiver ( receiver, tree )
	{
		if ( !! tree === true )
		{
			var key = Object.keys(tree)[0];
			return getReceiver( receiver[ key ], tree[ key ] );
		}

		return receiver;
	}

	function passThroughModifiers( last_key )
	{
		var hold = config.set_right_tree[ last_key ]
		for ( var r = 0 ; r < modifiers.length ; r++ )
		{
			var modified = modifiers[ r ]( hold );
		}
		return modified;
	}
}


function applyFilter( input_list )
{
	for (var i = 0 ; i < input_list.length ; i++)
	{
		var input = input_list[ i ];
		var name = sprint( "filter$0", [ input.getAttribute("filter") ] );
		if 
		(   
			window &&
			!! window[ name ] === true
		)
		{
			input.addEventListener
			(
				"keydown",
				window[ name ].bind( input, new InputRegexes() )
			);
			/*
			input.addEventListener
			(
				"keyup",
				window[ name ]
			);
			*/
		}
	}
}

function InputRegexes()
{
	var vars = 
	{
		single:

			/^.$/,

		at_least_2:

			/^.{2,}$/,

		single_integer:

			/^[0-9]$/,

		integer:

			/^[0-9]+$/,

		single_dot:

			/^\.$/,

		has_a_dot:
			
			/\./,

		rational:

			/\^d+(\.\d+)?$/
	}

	var functions = 
	{
		machine: machine
	}

	if ( InputRegexes.prototype.vars === undefined)
	{
		InputRegexes.prototype.vars = vars ;
		InputRegexes.prototype.functions = functions ;
	}

	function machine( matter, cherry_picked )
	{
		for ( var i = 0 ; i < cherry_picked.length ; i++ )
		{
			if ( matter.match( this.vars[ cherry_picked[i] ] ) === null )
			{
				return {
					upto: i,
					completed: ( cherry_picked.length === ( i + 1 ) )
				};
			}
		}

		return {
			upto: i,
			completed:( cherry_picked.length === ( i + 1 ) )
		};
	}

}

function filterInteger( regexes, ev )
{
	return rightOffTheBatMatchingBasic.call( null, ev, regexes, carryOn.bind( this ) );

	function carryOn()
	{
		var value = this.value;
		var key = ev.key;
		ev.preventDefault();
	}
}

function IntegerValueOf( matter )
{
	return parseInt( matter );
}

function filterRational ( regexes, ev )
{
	return rightOffTheBatMatchingBasic.call( null, ev, regexes, carryOn.bind( this ) );

	function carryOn()
	{
		var value = this.value;
		var key = ev.key;
		
		if 
		(
			value.match( regexes.vars.has_a_dot ) === null &&
			key.match( regexes.vars.single_dot ) === null
		)
		{
			return;
		}
		
		ev.preventDefault();
	}
}

//Otherwise it could be a combination that we should let pass
function rightOffTheBatMatchingBasic( ev, regexes, callback )
{
	var key = ev.key;
	if 
	(
		key.match( regexes.vars.single ) === null ||
		key.match( regexes.vars.integer ) !== null
	)
	{
		//It is trustable, so return
		return;
	}

	callback();
}

function roundWithPrecision( number, precision )
{
	var technique = number + ( precision / 2 );
	return (
		technique - ( technique % precision )
	);
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


