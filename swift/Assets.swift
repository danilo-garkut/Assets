import UIKit
import WebKit

func getControllers()
{
	let app_delegate = UIApplication.shared.delegate as? AppDelegate
	log(app_delegate?.window?.rootViewController?.presentedViewController, "presentedViewController")
	log(app_delegate?.window?.rootViewController?.childViewControllers, "childViewControllers")
}

func removeView(_ controller: UIViewController)
{
	if controller.view.superview != nil
	{
		controller.view.removeFromSuperview()
	}
}

func mergeViews(container: UIViewController, contained: UIViewController)
{
	container.view.addSubview(contained.view)
	contained.didMove(toParentViewController: container)
}

func unwrapper(_ to_unwrap: [String:Any]?) -> [String:Any]
{
	if to_unwrap != nil
	{
		return to_unwrap!
	}
	return [String:Any]()
}

func showView(
		presenting: UIViewController & UIViewControllerTransitioningDelegate, 
		presented: UIViewController
	)
{
	presented.modalPresentationStyle = UIModalPresentationStyle.custom
	presented.transitioningDelegate = presenting
	presenting.show(presented, sender: nil)
}


func loader
	(
		presenting controller: UIViewController, 
		callback:  (() -> Void)? = {}
	) 
		-> Void 
{
	log(controller.childViewControllers, "childViewControllers loader")
	if controller.presentedViewController == nil
	{
		/*
		let alert = UIAlertController (
				title: nil, message: nil, 
				preferredStyle: .alert
			)	
		*/
		let alert = UIViewController()
		log(alert.view.bounds, "alert view bounds")
		let status_height = UIApplication.shared.statusBarFrame.height
		let mirror = UIView(frame: CGRect(x:0, y:0, width:controller.view.frame.width, height:status_height))
		mirror.backgroundColor = .white
		alert.view.backgroundColor = .black
		alert.view.alpha = 0.7
		let indicator = UIActivityIndicatorView(frame: alert.view.bounds)
		alert.view.addSubview(mirror)
		alert.view.addSubview(indicator)
//		indicator.autoresizingMask = [ .flexibleWidth, .flexibleHeight ]
		indicator.isUserInteractionEnabled = false
		indicator.startAnimating()
		DispatchQueue.main.async
		{
			controller.present(alert, animated:false, 
				completion:
				{
					callback?()
				}
			)
		}
	}
	else
	{
		log(controller.presentedViewController, "presentedViewController else loader")
		controller.dismiss(
			animated: false, completion:
			{
				callback?()
			}
		)
	}
}

func statController(controller: UIViewController, _ extra_comment: String?)
{
		var safe_are_layout_guide: Any? 
		if #available(iOS 11.0, *)
		{
			safe_are_layout_guide = controller.view.safeAreaLayoutGuide
		}

		log(controller, "STATController, \(extra_comment ?? "No extra comment")")
		log(controller.view.bounds, "ViewBounds")
		log(controller.view.frame, "ViewFrames")
		log(safe_are_layout_guide, "View safeAreaLayoutGuide")
}

func alert(_ title: String? = nil, message: String, controller: UIViewController?)
{
	let alert_controller = UIAlertController(title: title, message: message, preferredStyle: .alert)
	alert_controller.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
	controller?.present(alert_controller, animated: true)
}

func getCurrentUnixtime() -> Double
{
	let time_interval = Date().timeIntervalSince1970
	return time_interval 
}

func jsonStringify(_ dict: [[String:Any]]) -> String?
{
	do
	{
		let json_data = try JSONSerialization.data(withJSONObject: dict, options:[])
		let encoded = String(data: json_data, encoding: .utf8)
		return encoded
	}
	catch
	{
		log(error.localizedDescription)
		return nil
	}
}
func jsonStringify(_ dict: [String:Any]) -> String?
{
	do
	{
		let json_data = try JSONSerialization.data(withJSONObject: dict, options:[])
		let encoded = String(data: json_data, encoding: .utf8)
		return encoded
	}
	catch
	{
		log(error.localizedDescription)
		return nil
	}

}

func jsonParse(_ json_string:String?) -> [String: Any]?
{
	if let data = json_string?.data(using: .utf8)
	{
		return jsonParse(data)
	}
	return nil
}

func jsonParse(_ data: Data?) -> [String:Any]?
{
	do
	{
		if let unwrapped_data = data
		{
			return try JSONSerialization.jsonObject(with: unwrapped_data, options:[]) as? [String: Any]
		}
	}
	catch
	{
		log("\(error.localizedDescription), \(data)", "jsonParse error")
	}

	return nil
}

func injectJSToWkWebview(webview: WKWebView, function: String, params: String? = nil)
{
	var callback = "\(function)()"
	if let params = params
	{
		callback = "\(function)(\(params))"
	}
	log(callback, "This is being injected")
	webview.evaluateJavaScript(
		callback
	) 
	{ 
		(any:Any, error) in
		if error != nil
		{
			print("An error has occurred when injecting JS to WK, \(error)")
		}
	}
	
}

func makeHttp
		(
			url: String, 
			data: [String:Any],
			callback:(([String:Any]?, Any?) -> Void)?,
			loader_controller: UIViewController? = nil
		) 
			-> Void
{
	let incoming_url = url	
	guard 
		let url = URL(string:url)
	else
	{
		log(incoming_url, "URL assertion did not pass")
		return
	}

	var loaderCallback:(() -> Void)?
	if let loader_controller = loader_controller
	{
		loader(presenting: loader_controller)
		loaderCallback = {  loader(presenting: loader_controller) }
	}

	log((url, data, callback, loader_controller), "makeHttp, url, data, callback, loader_controller")

	var request = URLRequest(url: url)
	request.httpMethod = "POST"
	request.setValue("Application/json", forHTTPHeaderField:"Content-Type")
	let data = jsonStringify(data);
	let task = 
		URLSession.shared.uploadTask(with: request, from: data?.data(using: .utf8))
		{
			data, response, error in
			log((data, response, error), "makeHttp")
			loaderCallback?()
			if let error = error 
			{
				callback?(nil, error)
				return
			}

			guard 
				let http_response = response as? HTTPURLResponse 
			else
			{
				callback?(nil, "as? HTTPURLResponse failed")
				return
			}
			
			guard 
				let data = data,
				let data_string = String(data: data, encoding: .utf8)
			else
			{
				callback?(nil, "data response came nil")
				return
			}
			log(data_string, "Data String from data, makeHttp")
			callback?(
				jsonParse(data_string), nil
			)
		}
	task.resume()
}

func booleanCoercion(_ true_or_false: Any?) -> Bool
{
	if let a = true_or_false as? Bool
	{
		return a
	}
	if let a = true_or_false as? Int
	{
		if a == 0
		{
			return false
		}
		return true
	}

	if let a = true_or_false as? String
	{
		if a == "false"
		{
			return false
		}
		return true
	}
	log(
		"Neither is it a String, nor an Int or Boolean, returning false, \(true_or_false)", 
		"booleanCoercion"
	)
	return false
}

func log(_ matter: Any?, _ label: String)
{
	print("\(label)<-label:unixtime->\(getCurrentUnixtime())")
	print(matter ?? "<EmptyMatter>")
	print("------")
}

func log(_ matter: Any?)
{
	log(matter, "UNLABELED")
}






