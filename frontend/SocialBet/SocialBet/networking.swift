//
//  networking.swift
//  SocialBet
//

// This file contains helper functions for sending GET and POST requests

import Foundation
import Alamofire

/* ALAMOFIRE COPYRIGHT INFORMATION
 
 Copyright (c) 2014-2018 Alamofire Software Foundation (http://alamofire.org/)
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
*/

// container for HTTP responses from GET and POST requests
struct HTTPResponse {
    var data: Data? = nil           // the JSONified response
    var success: Bool? = nil        // True if network success
    var failure: Bool? = nil        // True if network failure
    var HTTPsuccess: Bool? = nil    // True if HTTP success (i.e., 2xx)
}

// send a GET request
// arguments:   uri for the endpoint (including query string)
//              callback function of your design
func sendGET(uri: String, callback: @escaping (HTTPResponse) -> Void){
    // form the request url
    let initialURL = "http://" + common.domain + ":" + common.port + uri
    let encoded = initialURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
    
    guard let url = URL(string: encoded!) else {
        callback(HTTPResponse())
        return
    }
    // Instantiate a return variable
    var httpresponse = HTTPResponse()
    
    // Populate the return variable with the contents of the request
    Alamofire.request(url, method:.get, encoding: JSONEncoding.default)
        .responseJSON { response in
        switch response.result {
        case .success(let JSON):
            //let jsonData = JSON as! NSDictionary
            //let errorString = jsonData["errors"]
            //httpresponse.error = response.error
            let jsonData = JSON as! NSDictionary
            httpresponse.HTTPsuccess = (jsonData["success_status"] as! String == "successful")
            httpresponse.data = response.data
            httpresponse.success = true
            callback(httpresponse)
        case .failure(let JSON):
            let jsonData = JSON as! NSDictionary
            httpresponse.HTTPsuccess = (jsonData["success_status"] as! String == "successful")
            httpresponse.data = response.data
            httpresponse.success = false
            callback(httpresponse)
        }
    }
}

// send a POST request
// arguments:   uri for the endpoint (including query string)
//              dictionary of parameters to pass to the server
//              callback function of your design
func sendPOST(uri: String, parameters: Dictionary<String, Any>, callback: @escaping ([String: Any]) -> Void){
    // form the request url
    let initial_url = "http://" + common.domain + ":" + common.port + uri
    let encoded = initial_url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
    
    guard let url = URL(string: encoded!) else {
        
        let errorJson = ["success_status": "error", "errors": ["bad url"]] as [String : Any]
        callback(errorJson)
        return
    }
    
    // Populate the return variable with the contents of the request
    Alamofire.request(url, method:.post, parameters:parameters, encoding: JSONEncoding.default)
        .responseJSON { response in
        switch response.result {
        case .success(let JSON):
            let jsonData = JSON as! NSDictionary
            let jsonDict = jsonData.swiftDictionary
            print(jsonDict)
            callback(jsonDict)
        case .failure(let error):
            let errorJson = ["success_status": "error", "errors": [error]] as [String : Any]
            callback(errorJson)
        }
    }
}
