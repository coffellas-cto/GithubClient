//
//  NetworkController.swift
//  GithubClient
//
//  Created by Alex G on 20.10.14.
//  Copyright (c) 2014 Alexey Gordiyenko. All rights reserved.
//

import Foundation

var kGithubClientDefaultTimeout: NSTimeInterval = 10

extension Dictionary {
    func encodeDictionaryForHTTPBody() -> NSData? {
        var retVal: NSData? = nil
        var partsArray = NSMutableArray()
        for (key, value) in self {
            if let nsStringKey = key as? NSString {
                if let nsStringValue = value as? NSString {
                    partsArray.addObject(NSString(format: "%@=%@", nsStringKey.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!, nsStringValue.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!))
                }
                else {
                    return nil
                }
            }
            else {
                return nil
            }
        }
        
        let encodedDictionary = partsArray.componentsJoinedByString("&")
        return encodedDictionary.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
    }
}

class NetworkController {
    
    // MARK: Private Properties
    private var sharedSession = NSURLSession.sharedSession()
    
    // MARK: Class Properties
    class var controller: NetworkController {
    struct Struct {
        static var token: dispatch_once_t = 0
        static var instance: NetworkController! = nil
        }
        dispatch_once(&Struct.token, { () -> Void in
            Struct.instance = NetworkController()
        })
        return Struct.instance
    }
    
    // MARK: Life Cycle
    init() {
        
    }
    
    func performRequestWithURLString(URLString: String, method: String = "GET", parameters: [NSString: NSString]? = nil, completion: (data: NSData!, errorString: String!) -> Void) {
        let URL = NSURL(string: URLString)!
        let request = NSMutableURLRequest(URL: URL, cachePolicy: .UseProtocolCachePolicy, timeoutInterval: kGithubClientDefaultTimeout)
        request.HTTPMethod = method
        if parameters != nil {
            if let bodyData = parameters!.encodeDictionaryForHTTPBody() {
                request.HTTPBody = bodyData
                request.setValue("\(bodyData.length)", forHTTPHeaderField: "Content-Length")
                request.setValue("application/x-www-form-urlencoded charset=utf-8", forHTTPHeaderField: "Content-Type")
            }
        }
        
        sharedSession.dataTaskWithRequest(request, completionHandler: { (data: NSData!, response: NSURLResponse!, error: NSError!) -> Void in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                if error != nil {
                    completion(data: nil, errorString: error.localizedDescription)
                    return
                }
                
                let HTTPResponse = response as NSHTTPURLResponse
                var errorString: String?
                switch HTTPResponse.statusCode {
                case 200...299:
                    break
                case 400...499:
                    errorString = "Client error"
                case 500...599:
                    errorString = "Server error"
                default:
                    errorString = "Unknown error"
                }
                
                if let errorString = errorString {
                    completion(data: nil, errorString: "\(errorString): \(HTTPResponse.statusCode)")
                    return
                }
                
                if data == nil {
                    completion(data: nil, errorString: "Fatal error! Request succeed, but data is nil!")
                    return
                }
                
                completion(data: data, errorString: nil)
            })
        }).resume()
    }
}


