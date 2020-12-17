"use-strict";

//Both to NodeJS and Web
//console.log( module, exports );

var module = module || {};


(

	function ( nodejsModule, DgvFramework )
	{

		var functions = 
		{
			isDOMLoaded: function ( callback )
			{
				if ( document.readyState === "complete" )
				{
					callback(  );
				}
				else
				{
					document.addEventListener
					(
						"DOMContentLoaded",
						function ( ev )
						{
							callback( ev );	
						}
					);
				}
			},
			loadHTML: function ( content, target, callback )
			{
				var htmlInPlace = content.trim().match( /^<.+?>/ );

				!!! htmlInPlace 
										&&
				this.Ajax
				(
					content,
					{}, createWith, 
					"GET", true
				) 
										||
				createWith( content )


				function createWith( html )
				{
					var	loader = document.createElement( null );
					target.appendChild( loader );
					loader.outerHTML = html;
					( callback || function(){} )( loader );
				}

			},
			sprint: function ( body, fillDataCollection )
			{
					return body.replace
					(
						/\$(\d+|\w+)/g, 
						function(a, b, c)
						{
							return fillDataCollection[ a.substring(1) ];
						}
					);
			},
			Ajax: function Ajax( url, request, callback, method, returnThis )
			{
				var prepare_send = "";

				for ( var rv in request )
				{
					prepare_send += this.sprint( "$0=$1&", [ rv, encodeURIComponent( request[ rv ] ) ] );
				}

				var send = "";
				( prepare_send.length > 0 ) && ( send = prepare_send.match(/.+(?=.$)/)[0] );

				var xml_http_request = new XMLHttpRequest();

				xml_http_request.onreadystatechange =  
					function (ev)
					{
						if ( this.readyState === 4 && this.status === 200 )				
						{
							callback( this.responseText, this );
						}
						else if ( this.readyState === 4 )
						{
							callback( null, this );
						}
					}

				xml_http_request.open( method || "POST", url, true );
				xml_http_request.send( send );

				return returnThis;
			},
			loadFirebase: function 
					( 
						workload, 
						callback,
						configPack
					)
			{
					var _this = this;
					workload.unshift("app");
					var configPack = configPack || {};
					var version = configPack.version || "7.19.0";
					var counter = 0;
					var initHostingURL = this.sprint( "/__/firebase/$0/", [ version ] );
					var initCDN = this.sprint( "https://www.gstatic.com/firebasejs/$0/", [ version ] );
					var isCDN = false;

					makeLoad( initHostingURL, onSuccess, onError );
				//
				//	makeLoad( initCDN, onSuccess );
				//	var isCDN = true;
				//

					function onError( ev )
					{
						commonErrorSuccess
						(
							function (ev)
							{
								counter = 0;
								isCDN = true;
								makeLoad( initCDN, onSuccess );
							}
						)
					}

					function onSuccess( module, ev )
					{
						console.log("onSuccess: " + module );
						commonErrorSuccess
						(
							function (ev)
							{
								counter = 0;
								makeLoadInit();
							}
						)
					}

					function commonErrorSuccess( callback )
					{
						counter++;

						if ( counter >= workload.length )
						{
							callback();
						}
					}

					function makeLoadInit()
					{
						if ( isCDN === true )
						{
							console.log("isCDN");
							_this.makeAndAppendScript
							( 
								configPack.CDNInit || "../../localhost.only/init.js",
								function ( )
								{
									callback()
								}
							)
						}
						else
						{
							_this.makeAndAppendScript
							( 
								"/__/firebase/init.js",
								function ( )
								{
									callback()
								}
							)
						}
					}

					function makeLoad( url, onSuccess, onError )
					{
						var functions = [];
						var counter = 0;
						for (var i = 0 ; i < workload.length ; i++)
						{
							( 
								function ( holdI ) 
								{
									var completedWorkload = _this.sprint("firebase-$0.js", [ workload[ holdI ] ]);
									functions.push
									(
										function()
										{
											_this.makeAndAppendScript
											( 
												_this.sprint("$0$1", [ url, completedWorkload ]), 
												function (ev)
												{
													onSuccess.bind( null, completedWorkload )()
													next();
												},
												function (ev)
												{
													onError();
													next();
												}
											);
										}
									)
								}
							)( i );

						}

						functions[ counter ]();

						function next()
						{
							if ( functions[ counter + 1 ] !== undefined )
							{
								functions[ ++counter ]();
							}
						}

					}

				},
				roundWithPrecision: function ( number, precision )
				{
					var technique = number + ( precision / 2 );
					return (
						technique - ( technique % precision )
					);
				},
				makeAndAppendScript: function( src, onSuccess, onError )
				{
					var script = document.createElement("script");
					script.src = src;
					script.addEventListener 
					( 
						"load", 
						onSuccess || 
						function()
						{ 
							var message = this.sprint("No onSuccess to $0", [ src ]);
							console.log( message );
						} 
					);
					script.addEventListener 
					( 
						"error", 
						onError || 
						function()
						{
							var message = this.sprint("No onError to $0", [ src ]);
							console.log( message );
						} 
					);
					document.head.appendChild( script );
					return script;
				},

				detectFirebaseAuthState: function ( signedIn, signedOut )
				{
					DgvFramework.firebase.auth().onAuthStateChanged
					(
						function ( user )
						{
							if ( !! user === true )
							{
								signedIn( user );
							}
							else
							{
								signedOut();
							}
						}
					)
				},

				extractUserAndCompany: function ( userAtCompany )
				{
					return {
						user: userAtCompany.match( /^.+?(?=@)/ )[0],
						company: userAtCompany.match( /(?<=@).+?((?=\.)|$)/ )[0]
					}
				},

				emptyFunction: function ( )
				{
					console.log( "Empty function has been called", arguments );
				}


		};

		////////////

		DgvFramework.lowCohesion = {};

		if ( nodejsModule.loaded !== undefined )
		{
			nodejsModule.exports = functions;
		}
		else
		{
			for ( var i in functions )
			{
				DgvFramework.lowCohesion[ i ] = functions[ i ];
			}

			for ( var i in app )
			{
				app[ i ].app = app;
			}

			app.main.initialize.apply( DgvFramework, [ app ] );
			app = {};

		}

	}

)
( 
	module, 
	{
		context:{}
	} 
);





