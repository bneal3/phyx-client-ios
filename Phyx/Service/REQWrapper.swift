//
//  REQWrapper.swift
//  Phyx
//
//  Created by Benjamin Neal on 12/1/17.
//  Copyright © 2017 Benjamin Neal. All rights reserved.
//

import Foundation
import Alamofire

let STATUS = "_status"
let MESSAGE = "_message"
let RESPONSE = "_response"
let HEADERS = "_headers"
let CODE = "_code"

// USAGE: Pass into REQWrapper methods for Alamofire requests
struct HTTPRequest {
    var method: HTTPMethod!
    var path: String!
    var parameters: Parameters? = nil
    var headers: HTTPHeaders? = nil
}

// FUNCTION: Wrapper class that handles sending Alamofire requests
class REQWrapper {
    
    private init() {}
    static let shared = REQWrapper()
    
    func invokeAlert(title: String, message: String) {
        print(message)
        // TODO: Tie error report to alerts
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
            switch action.style{
            case .default:
                print("default")
            case .cancel:
                print("cancel")
            case .destructive:
                print("destructive")
            }
        }))
        
        let appDelegate: AppDelegate? = UIApplication.shared.delegate as? AppDelegate
        if let unwrappedAppdelegate = appDelegate {
            unwrappedAppdelegate.window!.rootViewController!.present(alert, animated: true, completion: nil)
        }
    }
    
    // USAGE: General wrapper for sending alamofire requests
    func send(request: HTTPRequest, onSuccess success: @escaping (_ json: Response) -> Void, onError error: @escaping (_ json: DataResponse<Any>) -> Void) {
        // FLOW: Header modification tasks
        var headers: HTTPHeaders = [:]
        // FLOW: Add previous headers
        if let reqHeaders = request.headers {
            for header in reqHeaders {
                headers[header.key] = header.value
            }
        }
        // FLOW: Add x-version header
        headers["x-version"] = "1"
        // FLOW: Add x-auth header if there
        if let token = UserData.shared().getToken() {
            headers["x-auth"] = token
        }
        
        // FLOW: Send request
        Alamofire.request(
            API_URL + request.path,
            method: request.method,
            parameters: request.parameters,
            encoding: JSONEncoding.default,
            headers: headers
        ).responseJSON { response in
            // FLOW: Check for server errors and logic errors
            guard response.error == nil else {
                // FLOW: Couldn't retrieve data from server
                print(response.error!)
                print(response.data?.toString() ?? "No Response")
                
                self.invokeAlert(title: "Connection Issue", message: "Problem connecting to server. Check your internet connection and try again.")
                
                error(response)
                return
            }
            
            // FLOW: Check to make sure we received JSON
            guard (response.data?.base64EncodedString()) != nil else {
                // FLOW: Error in response format
                print("Error: \(String(describing: response.error))")

                self.invokeAlert(title: "Connection Issue", message: "Problem connecting to server. Check your internet connection and try again.")
                
                error(response)
                return
            }
            
            // FLOW: Make sure we have received the response object
            if let json = response.result.value as? [String: Any] {
                // FLOW: Connection reached server but still might not be successful
                
                // FLOW: Handle a backend breaking error
                guard response.response?.statusCode != 500 else {
                    // FLOW: 500 Internal Server error means server is broken
                    self.invokeAlert(title: "Server Issue", message: "Internal server error. Please try again later.")
     
                    error(response)
                    return
                }
                
                // FLOW: Handle an authorization error
                guard response.response?.statusCode != 401 else {
                    // FLOW: Log person out in client
                    self.invokeAlert(title: "Authentication Issue", message: "Please sign in again")
                    
                    UserData.shared().logout()
                    
                    let appDelegate = UIApplication.shared.delegate as? AppDelegate
                    appDelegate!.window!.rootViewController?.dismiss(animated: false) {}
                    appDelegate?.setLoginScreen()
                    
                    error(response)
                    return
                }
                
                // FLOW: Check if response conforms to format
                if var responseJSON = json["response"] as? [String: Any] {
                    // FLOW: Set request headers to HEADER field
                    responseJSON[HEADERS] = response.response?.allHeaderFields
                    // FLOW: Set status code to CODE field
                    responseJSON[CODE] = response.response?.statusCode
                    // FLOW: Initialize Response object
                    let object = Response(responseData: responseJSON)
                    
                    // DEV: Catch all server errors with alert
                    if object.status != 200 {
                        self.invokeAlert(title: "Problem With Request", message: object.message)
                    }
                    
                    // FLOW: Send response object to completion block
                    success(object)
                } else {
                    // FLOW: Does not conform to response format
                    self.invokeAlert(title: "Client Issue", message: "Client handling issue. Please update to latest version.")
                    
                    error(response)
                    return
                }
            } else {
                // FLOW: A response value was not receieved
                self.invokeAlert(title: "Connection Issue", message: "Problem connecting to server. Check your internet connection and try again.")
                
                error(response)
                return
            }
        }
    }
    
    // USAGE: Use to send many alamofire requests at a time. Helpful with many GET requests.
    func sendMany(_ requests: [HTTPRequest], onSuccess success: @escaping (_ responses: [Response]) -> Void, onFailure failure: @escaping (_ result: Any) -> Void) {
        DispatchQueue.global(qos: .background).async {
            let group = DispatchGroup()
            
            var responses: [Response] = []
            
            for request in requests {
                group.enter()
                
                self.send(request: request, onSuccess: { (json) in
                    responses.append(json)
                    group.leave()
                }, onError: failure)
            }
            
            // NOTE: DispatchGroup wait method makes sure to wait until all requests in a group have completed before executing
            group.wait()
            
            success(responses)
        }
    }
}
