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
        performRequestWithURLPath(path, parameters: ["q": queryString], acceptJSONResponse: true, completion: { (data, errorString) -> Void in
            self.processJSONData(data, errorString: errorString, completion: completion)
        })
    }
    
    private func processJSONData(data: NSData?, errorString: String?, completion: (responseDic: NSDictionary?, errorString: String?) -> Void) {
        
        var newErrorString = errorString
        if data != nil {
            var error: NSError?
            if let retValDic = NSJSONSerialization.JSONObjectWithData(data!, options: nil, error: &error) as? NSDictionary {
                if errorString != nil {
                    println("Error from Github:")
                    println(retValDic)
                    completion(responseDic: nil, errorString: newErrorString)
                    return
                }
                
                completion(responseDic: retValDic, errorString: nil)
                return
            }
            
            if let errorJSON = error {
                newErrorString = errorJSON.localizedDescription
                completion(responseDic: nil, errorString: "Error parsing JSON response: \(newErrorString)")
            }
        }
        else {
            completion(responseDic: nil, errorString: newErrorString)
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
    
    func getCurrentUser(completion: (responseDic: NSDictionary?, errorString: String?) -> Void) {
        performRequestWithURLPath("/user", acceptJSONResponse: true, completion: { (data, errorString) -> Void in
            self.processJSONData(data, errorString: errorString, completion: completion)
        })
    }
    
    func newRepoWithName(name: String, description: String!, generateReadme: Bool, allowDownloads: Bool, completion:(responseDic: NSDictionary?, errorString: String?) -> Void) {
        var parameters = [NSString: AnyObject]()
        parameters["name"] = name
        if description != nil {
            parameters["description"] = description
        }
        
        parameters["auto_init"] = generateReadme
        parameters["has_downloads"] = allowDownloads
        
        performRequestWithURLPath("/user/repos", method: "POST", parameters: parameters, acceptJSONResponse: true, sendBodyAsJSON: true) { (data, errorString) -> Void in
            self.processJSONData(data, errorString: errorString, completion: { (responseDic, errorString) -> Void in
                if errorString != nil {
                    completion(responseDic: nil, errorString: errorString)
                    return
                }
                
                completion(responseDic: responseDic, errorString: nil)
            })
        }
    }
    
    func updateUserBio(newBio: String, completion:(responseDic: NSDictionary?, errorString: String?) -> Void) {
        performRequestWithURLPath("/user", method: "PATCH", parameters: ["bio": newBio], acceptJSONResponse: true, sendBodyAsJSON: true) { (data, errorString) -> Void in
            self.processJSONData(data, errorString: errorString, completion:completion)
        }
    }
    
    // MARK: Authorization stuff
    
    func setAccessToken(accessToken: String) {
        var configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        configuration.HTTPAdditionalHeaders = [NSObject : AnyObject]()
        configuration.HTTPAdditionalHeaders![NSString(string: "Authorization")] = "token " + accessToken
        println(configuration.HTTPAdditionalHeaders)
        
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
                
                println(NSString(data: data, encoding: NSUTF8StringEncoding))
                
                UIAlertView(title: "Error", message: "Couldn't parse JSON data while receiving access token", delegate: nil, cancelButtonTitle: "OK").show()
                return
                
                
            })
        }
    }
}