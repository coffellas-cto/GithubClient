//
//  GithubNetworkController.swift
//  GithubClient
//
//  Created by Alex G on 21.10.14.
//  Copyright (c) 2014 Alexey Gordiyenko. All rights reserved.
//

import UIKit

let kGithubOAuthURLString = "https://github.com/login/oauth/authorize"
let kGithubAccessTokenURLString = "https://github.com/login/oauth/access_token"
let kGithubScope = "user,repo"
let kGithubAPIURL = "https://api.github.com"

class GithubNetworking: NetworkController {
    // MARK: Class Properties
    override class var controller: GithubNetworking {
        struct Struct {
            static var token: dispatch_once_t = 0
            static var instance: GithubNetworking! = nil
        }
        dispatch_once(&Struct.token, { () -> Void in
            Struct.instance = GithubNetworking()
        })
        return Struct.instance
    }
    
    // MARK: Private Methods
    private func URLStringFromPathComponent(pathComponent: String) -> String {
        return kGithubAPIURL.stringByAppendingPathComponent(pathComponent)
    }
    
    private func searchForPath(path: String, containing queryString: String, completion: (responseDic: NSDictionary?, errorString: String?) -> Void) {
        performRequestWithURLPath(path, parameters: ["q": queryString], acceptJSONResponse: true) { (data, errorString) -> Void in
            
            var newErrorString = errorString
            if errorString == nil {
                var error: NSError?
                if let retValDic = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: &error) as? NSDictionary {
                    completion(responseDic: retValDic, errorString: nil)
                    return
                }
                
                if let errorJSON = error {
                    newErrorString = errorJSON.localizedDescription
                }
            }
            
            completion(responseDic: nil, errorString: "Error parsing JSON response: \(newErrorString)")
        }
    }
    
    // MARK: Life Cycle
    override init() {
        super.init()
        baseURL = kGithubAPIURL
    }
    
    // MARK: Using API
    func searchForReposContaining(#queryString: String, completion: (responseDic: NSDictionary?, errorString: String?) -> Void) {
        searchForPath("/search/repositories", containing: queryString, completion: completion)
    }
    
    func searchForUsersContaining(#queryString: String, completion: (responseDic: NSDictionary?, errorString: String?) -> Void) {
        searchForPath("/search/users", containing: queryString, completion: completion)
    }
    
    // MARK: Authorization stuff
    
    func setAccessToken(accessToken: String) {
        var configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        if var headers = configuration.HTTPAdditionalHeaders {
            headers[NSString(string: "Authorization")] = accessToken
        }
        
        session = NSURLSession(configuration: configuration)
    }
    
    func requestOAuthAccess() {
        let urlString = kGithubOAuthURLString + "?" + "client_id=" + kGithubClientID + "&scope=" + kGithubScope + "&redirect_uri=" + kGithubRedirectURL
        UIApplication.sharedApplication().openURL(NSURL(string: urlString)!)
        
    }
    
    func processOAuthCallbackURL(callbackURL: NSURL) {
        let paramsDictionary = callbackURL.dictionaryFromURL()
        if let code = paramsDictionary["code"] as? String {
            performRequestWithURLString(kGithubAccessTokenURLString, method: "POST", parameters: ["client_id": kGithubClientID, "client_secret": kGithubClientSecret, "code": code], acceptJSONResponse: true, completion: { (data, errorString) -> Void in
                if errorString != nil {
                    UIAlertView(title: "Error", message: errorString, delegate: nil, cancelButtonTitle: "OK").show()
                    return
                }
                
                if let data = data {
                    var error: NSError?
                    if let responseDictionary = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: &error) as? NSDictionary {
                        if error == nil {
                            println(responseDictionary)
                            if let accessToken = responseDictionary["access_token"] as? String {
                                NSUserDefaults.standardUserDefaults().setObject(accessToken, forKey: "accessToken")
                                self.setAccessToken(accessToken)
                                return
                            }
                        }
                    }
                }
                
                UIAlertView(title: "Error", message: "Couldn't parse JSON data while receiving access token", delegate: nil, cancelButtonTitle: "OK").show()
                return
                
                
            })
        }
    }
}